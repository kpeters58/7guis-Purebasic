; PUREBASIC: This results in a 63 KB executable on Win64 (didn't check sizes on MacOS & Linux)

EnableExplicit

Enumeration Gadgets 
  #MainWin
  #Editbox
  #Button
EndEnumeration

Procedure UpdateCounter()
  Static counter
  counter + 1
  SetGadgetText(#Editbox, Str(counter))
EndProcedure

Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 175, 40, "Counter", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    StringGadget(#Editbox,  5, 5, 80, 25, "0", #PB_String_Numeric | #PB_String_ReadOnly)
    ButtonGadget(#Button , 90, 5, 80, 25, "Count")
    BindGadgetEvent(#Button, @UpdateCounter())
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   


; even shorter version below

; Procedure UpdateCounter()
;   Static counter
;   counter + 1
;   SetGadgetText(2, Str(counter))
; EndProcedure
; 
; Procedure ShowMainWindow() 
;   If OpenWindow(1, #PB_Ignore, #PB_Ignore, 175, 40, "Counter", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
;     StringGadget(2,  5, 5, 80, 25, "0", #PB_String_Numeric | #PB_String_ReadOnly)
;     ButtonGadget(3 , 90, 5, 80, 25, "Count")
;     BindGadgetEvent(3, @UpdateCounter())
;   EndIf
; EndProcedure
; 
; ShowMainWindow() ; a window must be open for the eventloop to run
; Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; Folding = -
; Optimizer
; EnableXP
; DPIAware
; Executable = Counter.exe
; DisableDebugger