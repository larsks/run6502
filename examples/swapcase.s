PUTC     = $f001
EOF      = $f002
GETC     = $f004

another:
        lda EOF
        bne end

        lda GETC
        beq another

check_dot:
        cmp #$2e        ; exit on '.' at beginning of line.
        bne check_eol

        ldx #1
        cpx last_was_eol
        beq end

check_eol:
        cmp #$0d        ; check if we received <cr>
        bne not_eol
        ldx #1
        stx last_was_eol
        lda #$0a
        jmp print

not_eol:
        ldx #0
        stx last_was_eol

print:
        cmp #$40        ; don't swap chars before 'A'
        bcc noswap
        cmp #$7b        ; don't swap chars after 'z'
        bcs noswap
        eor #$20        ; swap upper and lower case as a demo

noswap:
        sta PUTC
        jmp another

end:
        brk

last_was_eol:
        .byte 0
