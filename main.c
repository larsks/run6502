#include <errno.h>
#include <libgen.h>
#include <poll.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include "flags.h"

uint8_t* s_memory6502;
char *exe_path, *exe_name;

extern void reset6502();
extern void execute6502();
extern uint16_t pc, status;

void cfmakeraw(struct termios *termios_p);
void exec6502(uint32_t tickcount);
void step6502();

#define RUN6502_MAGIC "RN65"
#define ADDR_PUTC 0xf001
#define ADDR_GETC 0xf004
#define ADDR_EOF  0xf002

#ifndef STARTADDR
#define STARTADDR 0x100
#endif

int ateof = 0;

struct termios saved_termios;

uint8_t mm_getc() {
    unsigned int ch = getchar();

    if (ch == EOF) {
        ateof = 1;
        ch = 0;
    } else {
        ateof = 0;
    }

    return ch;
}

void mm_putc(uint8_t value) {
    putchar(value);
}

uint8_t read6502(uint16_t address)
{
    switch (address) {
        case ADDR_EOF:
            return ateof;

        case ADDR_GETC:
            return mm_getc();

        default:
            return s_memory6502[address];
    }
}

void write6502(uint16_t address, uint8_t value)
{
    switch (address) {
        case ADDR_PUTC:
            mm_putc(value);

        default:
            s_memory6502[address] = value;
    }
}

void reset_term() {
    tcsetattr(STDIN_FILENO, TCSANOW, &saved_termios);
}

void setup_term() {
    struct termios new_termios;

    tcgetattr(STDIN_FILENO, &saved_termios);
    atexit(reset_term);

    memcpy(&new_termios, &saved_termios, sizeof(struct termios));
    cfmakeraw(&new_termios);
    tcsetattr(STDIN_FILENO, TCSANOW, &new_termios);
}

int main(int argc, const char* argv[])
{
    FILE* f;
    int size;

    exe_path = strdup(argv[0]);
    exe_name = basename(exe_path);

    s_memory6502 = malloc(65536);
    memset(s_memory6502, 0, 65536);

    if (argc < 2)
    {
        fprintf(stderr, "%s: usage: %s image.bin\n", exe_name, exe_name);
        return 2;
    }

    if ((f = fopen(argv[1], "rb")) == 0)
    {
        fprintf(stderr, "%s: unable to open %s: %s\n",
                exe_name, argv[1], strerror(errno));
        return 1;
    }

    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (size >= 65535) {
        fprintf(stderr, "%s: image too large (max. size 65k)\n", exe_name);
        return 1;
    }

    if (size >= 4) {
        char sig[4];
        fread(&sig, 4, 1, f);
        if (memcmp(&sig, RUN6502_MAGIC, 4) != 0) {
            fseek(f, 0, SEEK_SET);
        }
    }

    fread(s_memory6502, 1, size, f);
    fclose(f);

    setup_term();
    reset6502();
    pc = STARTADDR;

    for (;;)    
    {
        exec6502(1);

        if (status & FLAG_INTERRUPT) break;
    }

    return 0;
}
