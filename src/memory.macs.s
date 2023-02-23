; ------------------------------------------------------------------------------
; memory.macs.s
; ------------------------------------------------------------------------------
             mx    %00


; EnterInitZP
; Begin using the zero page that the program was initially started with
; ------------------------------------------------------------------------------
EnterInitZP  mac
             phb
             phk
             plb
             phd
             lda   InitialZP
             tcd
             <<<


; ExitInitZP
; End using the zero page that the program was initially started with
; ------------------------------------------------------------------------------
ExitInitZP   mac
             pld
             plb
             <<<
