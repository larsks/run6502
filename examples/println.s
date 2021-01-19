                .import         STDIO
                .importzp       strptr

                .export         println

                .segment        "CODE"
; @name println
;
; Print a string, terminiating it with <cr><lf>.
;
; @param strptr zero page location of low byte of string address
; @return none
println:        .scope
                ldy             #0              ; loop over string pointed to by
loop:           lda             (strptr),y
                beq             end             ; exit on termintal 0
                sta             STDIO
                iny
                jmp             loop

end:            lda             #$0d            ; send <cr>
                sta             STDIO
                lda             #$0a            ; send <lf>
                sta             STDIO
                lda             #0
                rts
                .endscope
