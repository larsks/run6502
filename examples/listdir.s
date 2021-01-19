                .import         DIROPT,DTYPE,STDIO,STRING_BASE
                .import         println
                .importzp       strptr

                .export         listdir

                .segment        "CODE"
; @name listdir
;
; Print out the type and name of items in a directory.
;
; @param STRING_BASE contains name of directory
listdir:        .scope
                lda             #'L'
                sta             DIROPT          ; request directory listing
                lda             DTYPE           ; read d_type of next entry
                                                ; (places d_name into STRING_BASE)
                beq             end             ; exit if we have read last dir entry
                sta             STDIO           ; write dtype to stdout
                lda             #' '
                sta             STDIO

                lda             #<STRING_BASE   ; load name into strptr
                sta             strptr
                lda             #>STRING_BASE
                sta             strptr + 1
                jsr             println         ; print name + eol
                jmp             listdir

end:            rts
                .endscope
