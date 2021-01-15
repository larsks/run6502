STDIO = $f001
ARGC  = $f002

; run6502 supports the 65816 stp instruction
; to cause the simulator to exit
.DEFINE stp .byte $DB

.ZEROPAGE

; Define some zeropage address locations. These aren't included in the
; assembled binary, but it allows us to refer to the locations by name
; in the CODE segment.

addrlo:         .byte 0
addrhi:         .byte 0

.CODE
                lda ARGC                ; use ARGC (number of command line
                                        ; arguments) as the error code.
                jsr strerror
                stp                     ; exit the program

; @name strerror
;
; Returns the address of a string describing a numeric error code.
;
; @param a -- error code
; @return none
strerror:       asl a                   ; multiply error code by two because
                                        ; error_table consists of two-byte
                                        ; entries

                cmp #(error_max-error_table)
                                        ; make sure error code is one
                                        ; we know about
                bcc continue
                lda #(error_max-error_table)
                                        ; load last error message, which
                                        ; should be the "invalid error
                                        ; code" message

continue:       tax                     ; move value to x register for indexing
                lda error_table,x       ; load low byte of string address
                sta addrlo
                inx
                lda error_table, x      ; load high byte of string address
                sta addrhi
                jsr println             ; print the error message
                rts

; @name println
;
; Print a string, terminiating it with <cr><lf>.
;
; @param addrlo zero page location of low byte of string address
; @param addrhi zero page location of high byte of string address
; @return none
println:        ldy #0
@loop:          lda (addrlo),y
                beq @end                ; exit on termintal 0 
                sta STDIO
                iny
                jmp @loop
               
@end:           lda #$0d                ; send <cr>
                sta STDIO
                lda #$0a                ; send <lf>
                sta STDIO
                lda #0
                rts

error_table:    .addr error_0
                .addr error_1
                .addr error_2
error_max:      .addr err_invalid_errno

error_0:        .asciiz "This is error 0"
error_1:        .asciiz "This is error 1"
error_2:        .asciiz "This is error 2"
err_invalid_errno:
                .asciiz "Invalid error code."
