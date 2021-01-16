                processor       6502

EXIT            =               $f000
STDIO           =               $f001
ARGC            =               $f002
ARGV            =               $f003
DIROPT          =               $f004

STRING_BASE     =               $f900
DTYPE           =               $f800

                seg.u           zeropage
                org             $0

addrlo:         ds.b            1
addrhi:         ds.b            1

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

.lbody:         lda             #<STRING_BASE   ; load name into addrlo + addrhi
                sta             addrlo
                lda             #>STRING_BASE
                sta             addrhi
                jsr             println
                jsr             listdir
                inx
                jmp             .loop           ; process next argument

.end:           stp                             ; exit program

; @name listdir
;
; Print out the type and name of items in a directory.
;
; @param STRING_BASE contains name of directory
listdir:        subroutine
                lda             #'L
                sta             DIROPT          ; request directory listing
                lda             DTYPE           ; read d_type of next entry
                                                ; (places d_name into STRING_BASE)
                beq             .end            ; exit if we have read last dir entry
                sta             STDIO           ; write dtype to stdout
                lda             #'
                sta             STDIO

                lda             #<STRING_BASE   ; load name into addrlo + addrhi
                sta             addrlo
                lda             #>STRING_BASE
                sta             addrhi
                jsr             println         ; print name + eol
                jmp             listdir

.end:           rts

; @name println
;
; Print a string, terminiating it with <cr><lf>.
;
; @param addrlo zero page location of low byte of string address
; @param addrhi zero page location of high byte of string address
; @return none
println:
                subroutine
                ldy             #0              ; loop over string pointed to by
.loop:          lda             (addrlo),y      ; addrlo + addrhi
                beq             .end            ; exit on termintal 0
                sta             STDIO
                iny
                jmp             .loop

.end:           lda             #$0d            ; send <cr>
                sta             STDIO
                lda             #$0a            ; send <lf>
                sta             STDIO
                lda             #0
                rts
