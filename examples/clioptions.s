                processor       6502

EXIT            =               $f000
STDIO           =               $f001
ARGC            =               $f002
ARGV            =               $f003
ARGV_BASE       =               $f900

                include         "header.s"

                seg             text
                org             $200

                ldx             #0              ; start with argument 0

loop:           cpx             ARGC            ; check if there are any more arguments
                beq             end
                stx             ARGV            ; request the next argument
                ldy             #0

print:          lda             ARGV_BASE,y     ; read chars from argument
                beq             next            ; break at end of string
                sta             STDIO
                iny                             ; increment string index
                jmp             print

next:           lda             #$0d            ; write cr/lf
                sta             STDIO
                lda             #$0a
                sta             STDIO
                inx                             ; increment argument counter
                jmp             loop

end:            stp
