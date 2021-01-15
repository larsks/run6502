STDIO = $f001
ARGC  = $f002

; run6502 supports the 65816 stp instruction
; to cause the simulator to exit
.DEFINE stp .byte $DB

.ZEROPAGE

addrlo:         .byte 0
addrhi:         .byte 0

.CODE

                lda ARGC
                jsr strerror
                stp

strerror:       asl a
                cmp #(error_max-error_table)
                bcc continue
                lda #(error_max-error_table)

continue:       tax
                lda error_table,x
                sta addrlo
                inx
                lda error_table, x
                sta addrhi
                jsr println
                rts

println:        ldy #0
@loop:          lda ($0),y
                sta STDIO
                beq @end
                iny
                jmp @loop
               
@end:           lda #$0d
                sta STDIO
                lda #$0a
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
