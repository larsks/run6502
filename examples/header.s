                mac             stp
                dc.b            $db
                endm

                ifnconst        STARTADDR
STARTADDR       =               $200
                endif

                ifnconst        NOHEADER

                                                ;  This describes the run6502 header, which is used both
                                                ;  to embed the start and load address into the final
                                                ;  binary and also allows the kernel to recognize run6502
                                                ;  files.

                seg             header
                org             $0

                subroutine                      ;  declare scope for local labels
.start:         dc              "RN65"          ;  run6502 signature
                dc.w            .end-.start     ;  load address
                dc.w            STARTADDR       ;  start address
.end:
                endif
