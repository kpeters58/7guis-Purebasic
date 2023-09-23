; PUREBASIC: This results in a ?? KB executable on WIN64 (didn't check sizes on MacOS & Linux)

EnableExplicit

Enumeration Gadgets 
  #MainWin
EndEnumeration


Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 320, 200, "7GUI - Timer task in Purebasic", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DPIAware