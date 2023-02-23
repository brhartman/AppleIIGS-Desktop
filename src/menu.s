; ------------------------------------------------------------------------------
; menu.s
; ------------------------------------------------------------------------------
              mx        %00


QuitRequest   dw        $0000


; CreateMenu
; ------------------------------------------------------------------------------
CreateMenu

              PushLong  #$0
              PushLong  #MenuEdit
              _NewMenu
              PushWord  #$0
              _InsertMenu

              PushLong  #$0
              PushLong  #MenuFile
              _NewMenu
              PushWord  #$0
              _InsertMenu

              PushLong  #$0
              PushLong  #MenuApple
              _NewMenu
              PushWord  #$0
              _InsertMenu

              PushWord  #1
              _FixAppleMenu

              pha
              _FixMenuBar
              pla

              _DrawMenuBar

              rts


; HandleMenu
; ------------------------------------------------------------------------------
HandleMenu
              lda       TaskData
              and       #$00ff
              asl       a
              tax
              jsr       (MenuTable,x)
              PushWord  #$0000
              PushWord  TaskData+2
              _HiliteMenu
              rts


; MenuAbout
; ------------------------------------------------------------------------------
MenuAbout
              PushLong  #$0
              PushLong  #AboutDlgRec
              _GetNewModalDialog
              jsr       CheckError
              PullLong  AboutDlgPtr

]loop
              PushWord  #$0000
              PushLong  #$0000
              _ModalDialog
              pla
              cmp       #$0001
              bne       ]loop

              PushLong  AboutDlgPtr
              _CloseDialog

              rts


; MenuExmpl
; ------------------------------------------------------------------------------
MenuExmpl

; Create the icon
              PushLong  #ExmplIconSz
              PushWord  #MemAttrUI
              jsr       NewAlloc
              PullLong  ExmplIconH

              PushLong  ExmplIconH
              _HLock

              PushLong  ExmplIconH
              jsr       DerefHandle
              sta       0
              stx       2

              ldy       #0
]iconCopy     lda       ExmplIcon,y
              sta       [0],y
              iny
              iny
              cpy       #ExmplIconSz
              bne       ]iconCopy

              PushLong  ExmplIconH
              _HUnlock

; Create the dialog
              PushLong  #$0000
              PushLong  #ExmplDlgRect
              PushWord  #$0001
              PushLong  #$0000
              _NewModalDialog
              jsr       CheckError
              PullLong  ExmplDlgPtr

; Add items to the dialog
              PushLong  ExmplDlgPtr
              PushWord  #$0001
              PushLong  #ExmplBtnRect
              PushWord  #$000a         ; buttonItem
              PushLong  #ExmplBtnTxt
              PushWord  #$0000
              PushWord  #$0000
              PushLong  #$0000
              _NewDItem

              PushLong  ExmplDlgPtr
              PushWord  #$0002
              PushLong  #ExmplTxtRect
              PushWord  #$800f         ; itemDisable + statText
              PushLong  #ExmplTxt
              PushWord  #$0000
              PushWord  #$0000
              PushLong  #$0000
              _NewDItem

              PushLong  ExmplDlgPtr
              PushWord  #$0003
              PushLong  #ExmplIcnRect
              PushWord  #$8012         ; itemDisable + iconItem
              PushLong  ExmplIconH
              PushWord  #$0000
              PushWord  #$0000
              PushLong  #$0000
              _NewDItem

; Show and handle the dialog
]loop
              PushWord  #$0000
              PushLong  #$0000
              _ModalDialog
              pla
              cmp       #$0001
              bne       ]loop

              PushLong  ExmplDlgPtr
              _CloseDialog

; Clean up
              PushLong  ExmplIconH
              _DisposeHandle

              rts


; MenuQuit
; ------------------------------------------------------------------------------
MenuQuit
              dec       QuitRequest
              rts


; Menu structure
; ------------------------------------------------------------------------------

MenuApple     asc       '>>@\N1X'
              db        $00
              asc       '--About This Program...\N256'
              db        $00
              asc       '---\D'
              db        $00
              asc       '.'
              db        $00

MenuFile      asc       '>> File \N2'
              db        $00
              asc       '--Example...\N257'
              db        $00
              asc       '---\D'
              db        $00
              asc       '--Quit...\N258*Qq'
              db        $00
              asc       '.'
              db        $00

MenuEdit      asc       '>> Edit \N3D'
              db        $00
              asc       '--Undo...\N250V*Zz'
              db        $00
              asc       '--Cut...\N251*Xx'
              db        $00
              asc       '--Copy...\N252*Cc'
              db        $00
              asc       '--Paste...\N253V*Vv'
              db        $00
              asc       '--Clear...\N254'
              db        $00
              asc       '.'
              db        $00


; Menu event dispatch table
; ------------------------------------------------------------------------------

MenuTable     da        MenuAbout
              da        MenuExmpl
              da        MenuQuit
              da        $0000
              da        $0000
              da        $0000
              da        $0000
              da        $0000


; About dialog
; ------------------------------------------------------------------------------

AboutDlgPtr   ds        4

AboutDlgRec   dw        70             ; (200 - 60) / 2
              dw        120            ; (640 - 400) / 2
              dw        130            ; (200 - 60) / 2 + 60
              dw        520            ; (640 - 400) / 2 + 400
              dw        1
              adrl      0
              adrl      AboutBtnRec
              adrl      AboutTxtRec
              adrl      0

AboutBtnRec   dw        $0001
              dw        40
              dw        180
              dw        0
              dw        0
              dw        $000a          ; buttonItem
              adrl      AboutBtnTxt
              dw        0
              dw        0
              adrl      0

AboutBtnTxt   str       'OK'

AboutTxtRec   dw        $0002
              dw        10
              dw        80
              dw        40
              dw        380
              dw        $8000+$000f    ; itemDisable + statText
              adrl      AboutTxt
              dw        0
              dw        0
              adrl      0

AboutTxt      str       'This program is an example desktop'$0d'application framework.'


; Example dialog
; ------------------------------------------------------------------------------

ExmplDlgPtr   ds        4

ExmplDlgRect  dw        70             ; (200 - 60) / 2
              dw        120            ; (640 - 400) / 2
              dw        130            ; (200 - 60) / 2 + 60
              dw        520            ; (640 - 400) / 2 + 400

ExmplBtnRect  dw        40
              dw        180
              dw        0
              dw        0

ExmplBtnTxt   str       'OK'

ExmplTxtRect  dw        10
              dw        120
              dw        40
              dw        380

ExmplTxt      str       'This an example dialog created from'$0d'dialog items on the stack.'

ExmplIcnRect  dw        12
              dw        24
              dw        0
              dw        0

ExmplIconH    ds        4

ExmplIconSz   equ       520            ; 8 + 32 * 64/4

ExmplIcon     dw        0
              dw        0
              dw        32
              dw        64
              hex       00000000000000000000000000000000
              hex       00000000000000000000000000000000
              hex       00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              hex       00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              hex       00FF888888888888888888888888FF00
              hex       00FF888888888888888888888888FF00
              hex       00FF888888888888888888888888FF00
              hex       00FF888888888888888888888888FF00
              hex       00FFEEEEEEEEEEEEEEEEEEEEEEEEFF00
              hex       00FFEEEEEEEEEEEEEEEEEEEEEEEEFF00
              hex       00FFEEEEEEEEEEEEEEEEEEEEEEEEFF00
              hex       00FFEEEEEEEEEEEEEEEEEEEEEEEEFF00
              hex       00FF666666666666666666666666FF00
              hex       00FF666666666666666666666666FF00
              hex       00FF666666666666666666666666FF00
              hex       00FF666666666666666666666666FF00
              hex       00FF444444444444444444444444FF00
              hex       00FF444444444444444444444444FF00
              hex       00FF444444444444444444444444FF00
              hex       00FF444444444444444444444444FF00
              hex       00FF555555555555555555555555FF00
              hex       00FF555555555555555555555555FF00
              hex       00FF555555555555555555555555FF00
              hex       00FF555555555555555555555555FF00
              hex       00FF111111111111111111111111FF00
              hex       00FF111111111111111111111111FF00
              hex       00FF111111111111111111111111FF00
              hex       00FF111111111111111111111111FF00
              hex       00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              hex       00FFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              hex       00000000000000000000000000000000
              hex       00000000000000000000000000000000
