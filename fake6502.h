#ifndef _FAKE6502_H
#define _FAKE6502_H

#include <stdint.h>

#define FLAG_CARRY     0x01
#define FLAG_ZERO      0x02
#define FLAG_INTERRUPT 0x04
#define FLAG_DECIMAL   0x08
#define FLAG_BREAK     0x10
#define FLAG_CONSTANT  0x20
#define FLAG_OVERFLOW  0x40
#define FLAG_SIGN      0x80

extern uint16_t pc;
extern uint8_t sp, a, x, y, status;

extern void reset6502();
void exec6502(uint32_t tickcount);
void step6502();

#endif
