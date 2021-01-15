## Special opcodes

I have modified [fake6502][] to use the  65816 [`STP`][stp]
instruction to call [`exit(3)`][exit]. Additionally, I have added
support for the 65816 `phx/phy/plx/ply` opcodes.

[fake6502]: http://rubbermallet.org/fake6502.c
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
