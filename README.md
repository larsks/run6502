# run6502

## What's all this, then?

Have you ever wanted to write Linux utilities in 6502 assembly
language? Then this project is for you. This consists of a set of
tools that allow you to build 6502 binaries that can interact with
your system, and then run them directly from the command line just
like any other command.

- `run6502` is the binary interpreter for 6502 binaries. This is based
  on the [fake6502][] emulator.

- A custom header format that identifies compiled 6502 binaries and
  provides some useful metadata (load address and start address).

- Configuration files for [ca65][] that will generate output using the 
  custom header.

- A [`binfmt_misc`][binfmt_misc] configuration that instructs the
  kernel to use `run6502` when you attempt to run a 6502 binary that
  uses the custom header.

[fake6502]: http://rubbermallet.org/fake6502.c
[binfmt_misc]: https://www.kernel.org/doc/html/latest/admin-guide/binfmt-misc.html
[ca65]: https://www.cc65.org/doc/ca65.html

## Special opcodes

I have modified [fake6502][] to use the  65816 [`STP`][stp]
instruction to call [`exit(3)`][exit]. Additionally, I have added
support for the 65816 `phx/phy/plx/ply` opcodes.

[stp]: https://undisbeliever.net/snesdev/65816-opcodes.html#stp-stop-the-processor
[exit]: https://man7.org/linux/man-pages/man3/exit.3.html

## Memory mapped IO locations

- `ADDR_EXIT` (`0xf000`)

  Write a byte here to trigger a program exit with that byte as the
  exit code.

- `ADDR_STDIO` (`0xf001`)

  Write a byte here to output it to `stdout`.

  Read a byte from here to read a character from `stdin`.

- `ADDR_ARGC` (`0xf002`)

  Read a byte from here to find the number of available command
  line arguments.

- `ADDR_ARGV` (`0xf003`)

  Write a byte here to have the value of that argument written to
  `STRING_BASE` (`0xf900`).

- `ADDR_DIROPT` (`0xf004`)

  Write a byte here to request a directory operation. In general,
  write a directory name to `STRING_BASE` before requesting a
  directory operation.

  Currently supported operations:

  - `L` -- request a directory listing.

## Binary format

```
+--------------------+--------------+---------------+----...
| signature ("RN65") | load address | start address | data
| 4 bytes            | 2 bytes      | 2 bytes       |
+--------------------+--------------+---------------+----...
```
