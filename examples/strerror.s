                .import         println
                .importzp       strptr

                .export         strerror

                .segment        "CODE"
; @name strerror
;
; Returns the address of a string describing a numeric error code.
;
; @param a -- error code
; @return none
strerror:       .scope
                asl                             ; multiply error code by two because
                                                ; error_table consists of two-byte
                                                ; entries

                cmp             #(error_max-error_table)
                                                ; make sure error code is one
                                                ; we know about
                bcc             print
                lda             #(error_max-error_table)
                                                ; load last error message, which
                                                ; should be the "invalid error
                                                ; code" message

print:          tax                             ; move value to x register for indexing
                lda             error_table,x   ; load low byte of string address
                sta             strptr
                inx
                lda             error_table,x   ; load high byte of string address
                sta             strptr + 1
                jsr             println         ; print the error message
                rts

error_table:    .word           error_0
                .word           error_1
                .word           error_2
error_max:      .word           err_invalid_errno

error_0:        .asciiz         "This is error 0"
error_1:        .asciiz         "This is error 1"
error_2:        .asciiz         "This is error 2"
err_invalid_errno:
                .asciiz         "Invalid error code."

                .endscope
