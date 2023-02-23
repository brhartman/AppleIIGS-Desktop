            rel
            dsk   main.l

            mx    %00


; Macros
; ------------------------------------------------------------------------------

            use   Adb.Macs
            use   Ctl.Macs
            use   Desk.Macs
            use   Dialog.Macs
            use   Dos.16.Macs
            use   Event.Macs
            use   Line.Macs
            use   Locator.Macs
            use   Mem.Macs
            use   Menu.Macs
            use   Misc.Macs
            use   Qd.Macs
            use   Util.Macs
            use   Scrap.Macs
            use   Window.Macs

            use   memory.macs
            use   utilities.macs


; Main
; ------------------------------------------------------------------------------

            phk
            plb
            tdc
            sta   InitialZP

            jsr   Set16Bit
            jsr   StartUp
            jsr   EventLoop
            jsr   Shutdown
            jsr   Quit


; StartUp
; ------------------------------------------------------------------------------
StartUp

            _TLStartUp

            jsr   MemStartUp

            _MTStartUp
            jsr   CheckError

            jsr   DeskStartUp

            rts


; EventLoop
; ------------------------------------------------------------------------------
EventLoop

            jsr   HandleDesk
            bit   QuitRequest
            bpl   EventLoop

            rts


; Shutdown
; ------------------------------------------------------------------------------
Shutdown

            jsr   DeskShutdown

            _MTShutDown

            jsr   MemShutdown

            _TLShutDown

            rts


; Includes Begin
; ------------------------------------------------------------------------------

            use   equates
            use   desktop
            use   memory
            use   menu
            use   utilities

; Includes End
; ------------------------------------------------------------------------------
