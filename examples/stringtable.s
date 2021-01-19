                processor       6502

STDIO           =               $f001
ARGC            =               $f002

                include         "zeropage.s"
                include         "header.s"

                seg             text
                org             $200

                lda             ARGC            ; use ARGC (number of command line
                                                ; arguments) as the error code.
                jsr             strerror
                stp                             ; exit the program

; @name strerror
;
; Returns the address of a string describing a numeric error code.
;
; @param a -- error code
; @return none
strerror:       subroutine
                asl                             ; multiply error code by two because
                                                ; error_table consists of two-byte
                                                ; entries

                cmp             #(error_max-error_table)
                                                ; make sure error code is one
                                                ; we know about
                bcc             .print
                lda             #(error_max-error_table)
                                                ; load last error message, which
                                                ; should be the "invalid error
                                                ; code" message

.print:         tax                             ; move value to x register for indexing
                lda             error_table,x   ; load low byte of string address
                sta             strptr
                inx
                lda             error_table,x   ; load high byte of string address
                sta             strptr + 1
                jsr             println         ; print the error message
                rts

                include         "println.s"

error_table:    dc.w            error_0
                dc.w            error_1
                dc.w            error_2
error_max:      dc.w            err_invalid_errno

error_0:        dc.b            "This is error 0",0
error_1:        dc.b            "This is error 1",0
error_2:        dc.b            "This is error 2",0
err_invalid_errno:
                dc.b            "Invalid error code.",0
