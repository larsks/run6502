                processor       6502

EXIT            =               $f000
STDIO           =               $f001
ARGC            =               $f002
ARGV            =               $f003
DIROPT          =               $f004

STRING_BASE     =               $f900
DTYPE           =               $f800

                include         "zeropage.s"
                include         "header.s"

                seg             text
                org             $200

main:           subroutine
                ldx             #0
                cpx             ARGC            ; check if there are any arguments
                bne             .loop           ; .loop over arguments if available

                lda             #'.             ; default to listing '.' if no args
                sta             STRING_BASE
                dex                             ; inx at bottom of .loop will set x=0
                jmp             .lbody

.loop:          cpx             ARGC            ; check if there are any more arguments
                beq             .end
                stx             ARGV            ; request the next argument

.lbody:         lda             #<STRING_BASE   ; load name into strptr
                sta             strptr
                lda             #>STRING_BASE
                sta             strptr + 1
                jsr             println
                jsr             listdir
                inx
                jmp             .loop           ; process next argument

.end:           stp                             ; exit program

                include         "println.s"
                include         "listdir.s"
