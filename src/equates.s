; ------------------------------------------------------------------------------
; equates.s
; ------------------------------------------------------------------------------
               mx    %00

; memory
DPMem0         equ   $0010
DPMem1         equ   $0014
DPMem2         equ   $0018
DPMem3         equ   $001a

; global
DPTmp0         equ   $0080
DPTmp1         equ   $0084
DPTmp2         equ   $0088
DPTmp3         equ   $008a

; tools
DPQuickDrawII  equ   $0100       ; QuickDraw II     - 3 pages
DPEventMngr    equ   $0400       ; Event Manager    - 1 page
DPControlMngr  equ   $0500       ; Control Manager  - 1 page
DPMenuMngr     equ   $0600       ; Menu Manager     - 1 page
DPLineEdit     equ   $0700       ; LineEdit         - 1 page
DPAmount       equ   $0800
