EXIT     = $f000
STDIN    = $f001
EOF      = $f002

get_next_char:
        lda EOF                 ; check if we've reached the end of input
        bne end

        lda STDIN               ; get next character
        beq get_next_char       ; try again if no char available

check_dot:
        cmp #$2e                ; check if we read a '.'
        bne check_eol

        ldx #1                  ; check if previous char was eol
        cpx last_was_eol
        beq end                 ; exit if we see '.' at beginning of line

check_eol:
        cmp #$0d                ; check if we received <cr>
        bne not_eol
        ldx #1
        stx last_was_eol
        lda #$0a
        jmp print

not_eol:
        ldx #0
        stx last_was_eol

print:
        cmp #$40                ; don't swap chars before 'A'
        bcc noswap
        cmp #$7b                ; don't swap chars after 'z'
        bcs noswap
        eor #$20                ; swap upper and lower case as a demo

noswap:
        sta STDIN
        jmp get_next_char

end:
        lda #0
        sta EXIT

last_was_eol:
        .byte 0
