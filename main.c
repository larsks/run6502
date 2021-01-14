#include <errno.h>
#include <getopt.h>
#include <libgen.h>
#include <poll.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include "fake6502.h"
#include "run6502.h"

uint8_t* s_memory6502;
char *exe_path, *exe_name;

void cfmakeraw(struct termios *termios_p);

int ateof = 0;

struct termios saved_termios;
struct settings settings = {0};
struct option longopts[] = {
    {"verbose",    0, NULL, OPT_VERBOSE},
    {"load-addr",  1, NULL, OPT_LOAD_ADDR},
    {"start-addr", 1, NULL, OPT_START_ADDR},
    {0, 0, 0, 0}
};

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
    if (settings.verbose > 1)
        fprintf(stderr, "R: %x\n", address);

    switch (address) {
        case ADDR_EOF:
            return ateof;

        case ADDR_STDIN:
            return mm_getc();

        default:
            return s_memory6502[address];
    }
}

void write6502(uint16_t address, uint8_t value)
{
    if (settings.verbose > 1)
        fprintf(stderr, "W: %x %x\n", address, value);
    switch (address) {
        case ADDR_EXIT:
            exit(value);
        case ADDR_STDIN:
            mm_putc(value);
            break;

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

    // we still want CTRL-C to work
    new_termios.c_lflag |= ISIG;

    tcsetattr(STDIN_FILENO, TCSANOW, &new_termios);
}

void usage(FILE *out) {
    fprintf(out, "%s: usage: %s [-v] [-l load_addr] [-s start_addr] <image>\n", exe_name, exe_name);
}

int parse_args(int argc, const char *argv[]) {
    int ch;

    while (
            -1 != (ch = getopt_long(argc, (char * const *)argv, shortopts,
                    (const struct option *)&longopts, NULL))
          ) {
        
        switch (ch) {
            case OPT_VERBOSE:
                settings.verbose++;
                break;

            case OPT_LOAD_ADDR:
                settings.load_addr_set = 1;
                settings.load_addr = strtol(optarg, NULL, 0);
                break;

            case OPT_START_ADDR:
                settings.start_addr_set = 1;
                settings.start_addr = strtol(optarg, NULL, 0);
                break;

            case '?':
                usage(stderr);
                exit(2);
        }
    }
}

int main(int argc, const char* argv[])
{
    FILE* f;
    int size;

    uint16_t start_addr = 0;
    int start_addr_set = 0;
    uint16_t load_addr = 0;

    exe_path = strdup(argv[0]);
    exe_name = basename(exe_path);

    parse_args(argc, argv);

    s_memory6502 = malloc(65536);
    memset(s_memory6502, 0, 65536);

    if ((argc-optind) < 1)
    {
        fprintf(stderr, "%s: usage: %s image.bin\n", exe_name, exe_name);
        return 2;
    }

    if ((f = fopen(argv[optind], "rb")) == 0)
    {
        fprintf(stderr, "%s: unable to open %s: %s\n",
                exe_name, argv[optind], strerror(errno));
        return 1;
    }

    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (size >= 65535) {
        fprintf(stderr, "%s: image too large (max. size 65k)\n", exe_name);
        return 1;
    }

    if (size >= sizeof(struct header)) {
        struct header hdr;

        fread(&hdr, sizeof(struct header), 1, f);
        if (memcmp(hdr.signature, RUN6502_MAGIC, 4) != 0) {
            fseek(f, 0, SEEK_SET);
        } else {
            start_addr = hdr.start_addr;
            start_addr_set = 1;
            load_addr = hdr.load_addr;
        }
    }

    if (settings.start_addr_set) {
        start_addr = settings.start_addr;
        start_addr_set = 1;
    }

    if (settings.load_addr_set)
        load_addr = settings.load_addr;

    fread(s_memory6502 + load_addr, 1, size, f);
    fclose(f);

    setup_term();
    reset6502();

    if (start_addr_set)
        pc = start_addr;

    for (;;)    
    {
        exec6502(1);
    }

    return 0;
}
