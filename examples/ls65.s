EXIT        = $f000
STDIO       = $f001
ARGC        = $f002
ARGV        = $f003
DIROPT      = $f004

STRING_BASE = $f900
DTYPE       = $f800

; run6502 supports the 65816 stp instruction
; to cause the simulator to exit
.DEFINE stp .byte $DB

.ZEROPAGE

addrlo: .byte 0
addrhi: .byte 0

.CODE

        ; TODO: only lists "."; need to add code to accept
        ; pathname on command line.
        lda #'.'
        sta STRING_BASE
loop:   lda #'L'
        sta DIROPT
        lda DTYPE
        beq end                 ; exit if we have read last dir entry
        sta STDIO               ; write dtype to stdout
        lda #' '
        sta STDIO

        lda #<STRING_BASE        ; load name into addrlo + addrhi
        sta addrlo
        lda #>STRING_BASE
        sta addrhi

        jsr println             ; print name + eol
        jmp loop

end:
        stp

println:        ldy #0
@loop:          lda (addrlo),y
                sta STDIO
                beq @end                ; exit on termintal 0 
                iny
                jmp @loop
               
@end:           lda #$0d                ; send <cr>
                sta STDIO
                lda #$0a                ; send <lf>
                sta STDIO
                lda #0
                rts
