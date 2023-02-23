; ------------------------------------------------------------------------------
; memory.s
; ------------------------------------------------------------------------------
              mx        %00


UserId        ds        2
MemId         ds        2

MemAttrDP     equ       %11000000_00000101
MemAttrAlgn   equ       %11000000_00011100
MemAttrUI     equ       %00000000_00000000


; MemStartUp
; ------------------------------------------------------------------------------
MemStartUp    stz       MMAppId
              pha
              _MMStartUp
              pla
              bcc       :MMStarted

; _MMStartUp likely failed because we are not running from GS/OS
; Create a new id, allocate banks 0 and 1, and then try _MMStartUp again

; Create a new id
              PushWord  #$0000
              PushWord  #$1000
              _GetNewID
              jsr       CheckError
              pla
              sta       MMAppId

; Allocate all of bank0
              PushLong  #$0000
              PushLong  #$b800
              PushWord  MMAppId
              PushWord  #$c002
              PushLong  #$00000800
              _NewHandle
              jsr       CheckError
              PullLong  MMBank0

; Allocate all of bank1
              PushLong  #$0000
              PushLong  #$b800
              PushWord  MMAppId
              PushWord  #$c002
              PushLong  #$00010800
              _NewHandle
              jsr       CheckError
              PullLong  MMBank1

; Try _MMStartUp again
              pha
              _MMStartUp
              jsr       CheckError
              pla

:MMStarted    sta       UserId
              ora       #$0100
              sta       MemId

              jsr       AllocDPMem

              rts

MMAppId       ds        2

MMBank0       ds        4
MMBank1       ds        4


; MemShutdown
; ------------------------------------------------------------------------------
MemShutdown   lda       MMAppId
              beq       :MMShutdown

              PushLong  MMBank1
              _DisposeHandle
              PushLong  MMBank0
              _DisposeHandle
              PushWord  MMAppId
              _DeleteID

:MMShutdown
              PushWord  MemId
              _DisposeAll

              PushWord  UserId
              _MMShutDown
              rts


; NewAlloc
; Stack = block size (long), attribute flags (word)
; Return Stack = block handle
; ------------------------------------------------------------------------------
NewAlloc
              plx                           ; rts address
              PullWord  MemBlockAttr
              PullLong  MemBlockSize
              phx                           ; rts address

; Allocate the memory block
              PushLong  #$0000
              PushLong  MemBlockSize
              PushWord  MemId
              PushWord  MemBlockAttr
              PushLong  #$0000
              _NewHandle
              jsr       CheckError
              PullLong  DPMem1

; Push the block handle
              plx                           ; rts address
              PushLong  DPMem1
              phx                           ; rts address

              rts

MemBlockSize  ds        4
MemBlockAttr  ds        2


; DerefHandle
; Stack = block handle
; Return a,x = block pointer
; ------------------------------------------------------------------------------
DerefHandle
              plx                           ; rts address
              PullLong  0
              phx                           ; rts address

; Dereference the block handle to a,x
              ldy       #$2
              lda       [0],y
              tax
              lda       [0]

              rts


; AllocDPMem
; ------------------------------------------------------------------------------
AllocDPMem

; Allocate direct page memory
              PushLong  #$0000
              PushLong  #DPAmount
              PushWord  MemId
              PushWord  #MemAttrDP
              PushLong  #$0000
              _NewHandle
              jsr       CheckError

; Dereference the handle and store the pointer
              PullLong  0
              lda       [0]
              sta       ZPBasePtr

              rts

ZPBasePtr     ds        2                   ; Pointer to zero page memory that we allocated (high word is always 0)
InitialZP     ds        2                   ; see EnterInitZP/ExitInitZP for using this
