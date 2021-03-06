#ifndef _RUN6502_H
#define _RUN6502_H

#include <stdint.h>
#include <dirent.h>

#define RUN6502_MAGIC "RN65"

#define ADDR_EXIT   0xf000
#define ADDR_STDIO  0xf001
#define ADDR_ARGC   0xf002  // number of command line arguments
#define ADDR_ARGV   0xf003  // retrieve arguments
#define ADDR_DIROPT 0xf004

#define ADDR_DIRENT_TYPE 0xf800
#define ADDR_STRING_BASE 0xf900

#define OPT_VERBOSE    'v'
#define OPT_LOAD_ADDR  'l'
#define OPT_START_ADDR 's'
#define shortopts "+vl:s:"

#define MAX_STRING_LENGTH 0xFF

struct header {
    char    signature[4];
    uint16_t load_addr;
    uint16_t start_addr;
};

struct settings {
    int verbose;
    int load_addr_set;
    uint16_t load_addr;
    int start_addr_set;
    uint16_t start_addr;
};

struct context {
    DIR *dir;
    char dirop;
    struct dirent *cur_dirent;
};

#endif
