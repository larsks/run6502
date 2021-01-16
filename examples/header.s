                mac             stp
                dc.b            $db
                endm

                ifnconst        NOHEADER
                seg             header          
                org             $0              

                subroutine                      ; declare scope for local labels
.start:         dc              "RN65"          ; run6502 signature
                dc.w            .end-.start     ; load address
                dc.w            $200            ; start address
.end:                                           
                endif
