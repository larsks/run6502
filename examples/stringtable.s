EXIT  = $f000
STDIO = $f001
ARGC  = $f002

.ZEROPAGE

addrlo:         .byte 0
addrhi:         .byte 0

.CODE

                lda ARGC
                jsr strerror
                lda #0
                sta EXIT

strerror:       asl a
                tax
                lda error_table,x
                sta addrlo
                inx
                lda error_table, x
                sta addrhi

                ldy #0
loop:           lda ($0),y
                sta STDIO
                beq end
                iny
                jmp loop
               
end:            lda #$0d
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
