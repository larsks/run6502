                .import         ARGC
                .import         strerror

                .segment        "CODE"
                .p816

                lda             ARGC            ; use ARGC (number of command line
                                                ; arguments) as the error code.
                jsr             strerror
                stp                             ; exit the program
