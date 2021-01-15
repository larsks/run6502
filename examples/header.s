; This file describes the header used by run6502 to correctly
; load and execute compiled 6502 binaries.

.segment "SIGNATURE"

        .byte "RN65"            ; embed signature into generated output

.segment "LOADADDR"

        .word *+4               ; embed load address

.segment "STARTADDR"

        .word *+2               ; embed start address
