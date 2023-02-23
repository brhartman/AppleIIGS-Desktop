; ------------------------------------------------------------------------------
; desktop.s
; ------------------------------------------------------------------------------
              mx        %00


; DeskStartUp
; ------------------------------------------------------------------------------
DeskStartUp

; Load the Tools
              PushLong  #ToolList
              _LoadTools
              jsr       CheckError

; Start Apple Desktop Bus
              _ADBStartUp

; Start QuickDraw II
              lda       ZPBasePtr
              clc
              adc       #DPQuickDrawII
              pha
              PushWord  #$0080          ; #$0080 for 640, #$0000 for 320
              PushWord  #$00a0          ; #$00a0 for 640, #$0050 for 320
              PushWord  UserId
              _QDStartUp
              jsr       CheckError

; Start the Event Manager
              lda       ZPBasePtr
              clc
              adc       #DPEventMngr
              pha
              PushWord  #20
              PushWord  #0
              PushWord  #640            ; #640 for 640, #320 for 320
              PushWord  #0
              PushWord  #200
              PushWord  UserId
              _EMStartUp
              jsr       CheckError

; Start the Window Manager
              PushWord  UserId
              _WindStartUp
              jsr       CheckError

; Start the Control Manager
              PushWord  UserId
              lda       ZPBasePtr
              clc
              adc       #DPControlMngr
              pha
              _CtlStartUp
              jsr       CheckError

; Start the Menu Manager
              PushWord  UserId
              lda       ZPBasePtr
              clc
              adc       #DPMenuMngr
              pha
              _MenuStartUp
              jsr       CheckError

; Start the Line Editor
              PushWord  UserId
              lda       ZPBasePtr
              clc
              adc       #DPLineEdit
              pha
              _LEStartUp
              jsr       CheckError

; Start the Dialog Manager
              PushWord  UserId
              _DialogStartUp
              jsr       CheckError

; Start the Scrap Manager
              _ScrapStartUp
              jsr       CheckError

; Start the Desk Manager
              _DeskStartUp
              jsr       CheckError

; Redraw the screen
              PushLong  #$0
              _RefreshDesktop
              _InitCursor

; Add the menu
              jsr       CreateMenu

              rts


ToolList      dw        13              ; Count
              dw        1,0             ; Tool Locator
              dw        2,0             ; Memory Manager
              dw        3,0             ; Misc Tools
              dw        4,0             ; QuickDraw II
              dw        5,0             ; Desk Manager
              dw        6,0             ; Event Manager
              dw        9,0             ; Apple Desktop Bus
              dw        14,0            ; Window Manager
              dw        15,0            ; Menu Manager
              dw        16,0            ; Control Manager
              dw        20,0            ; LineEdit Tool
              dw        21,0            ; Dialog Manager
              dw        22,0            ; Scrap Manager


; DeskShutdown
; ------------------------------------------------------------------------------
DeskShutdown

              _DeskShutDown
              _ScrapShutDown
              _MenuShutDown
              _WindShutDown
              _DialogShutDown
              _CtlShutDown
              _EMShutDown
              _LEShutDown
              _QDShutDown
              _ADBShutDown
              rts


; HandleDesk
; ------------------------------------------------------------------------------
HandleDesk

              PushWord  #$0
              PushWord  #$ffff
              PushLong  #EventRecord
              _TaskMaster
              pla

              beq       :Continue       ; No event

              cmp       #$0011          ; Menu event
              beq       :EventMenu

              jmp       :Continue

:EventMenu
              jsr       HandleMenu
              jmp       :Continue

:Continue
              rts

EventRecord
EventWhat     ds        2
EventMsg      ds        4
EventWhen     ds        4
EventWhere    ds        4
EventMods     ds        2
TaskData      ds        4
TaskMask      dw        $1fff,$0000
