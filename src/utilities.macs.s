; ------------------------------------------------------------------------------
; utilities.macs.s
; ------------------------------------------------------------------------------
            mx        %00


; IncrementX
; ]1 = Amount to increment X by
; ------------------------------------------------------------------------------
IncrementX  mac
            txa
            clc
            adc       ]1
            tax
            <<<


; DecrementX
; ]1 = Amount to decrement X by
; ------------------------------------------------------------------------------
DecrementX  mac
            txa
            sec
            sbc       ]1
            tax
            <<<


; IncrementY
; ]1 = Amount to increment Y by
; ------------------------------------------------------------------------------
IncrementY  mac
            tya
            clc
            adc       ]1
            tay
            <<<


; DecrementY
; ]1 = Amount to decrement Y by
; ------------------------------------------------------------------------------
DecrementY  mac
            tya
            sec
            sbc       ]1
            tay
            <<<


; SetColor
;   ]1 = palette color entry
;   ]2 = XRGB color
; ------------------------------------------------------------------------------
SetColor    mac
            lda       ]1
            asl
            tax
            lda       ]2
            stal      $e19e00,x
            <<<


; DbgMsg
;   ]1 = x position
;   ]2 = y position
;   ]3 = single quoted message
; Example: DbgMsg #40;#40;'Text'
; ------------------------------------------------------------------------------
DbgMsg      mac
            jmp       DbgMsgJmp
Msg         asc       ]3
            hex       00
DbgMsgJmp   PushWord  #$0000
            _SetBackColor
            PushWord  #$ffff
            _SetForeColor
            PushWord  ]1
            PushWord  ]2
            _MoveTo
            PushLong  #Msg
            _DrawCString
            <<<


; DbgBrk
; ------------------------------------------------------------------------------
DbgBrk      mac
            pha
            phx
            phy
            _GrafOff
            ply
            plx
            pla
            brk
            <<<
