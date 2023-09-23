; PUREBASIC: This results in a 62 KB executable on Win64 (didn't check sizes on MacOS & Linux)
; the reference code in SCALA also rounds ...

EnableExplicit

Enumeration Gadgets 
  #MainWin
  #EditboxCelsius
  #EditboxFahrenheit
EndEnumeration  

Procedure ConvertTemp(Temp.s, C2F.b)
  If C2F: ProcedureReturn Round((Val(Temp) * 1.0) * (9/5) + 32, #PB_Round_Nearest): EndIf
  ;  
  ProcedureReturn Round(((Val(Temp) * 1.0) - 32) * (5/9), #PB_Round_Nearest)
EndProcedure  

Procedure UpdateWindow()
  Protected entry.s  = Trim(GetGadgetText(EventGadget())),
            otherbox = #EditboxFahrenheit ; the other editbox that did NOT trigger this event
  
  If EventGadget() = #EditboxFahrenheit: otherbox = #EditboxCelsius: EndIf 
  ; we need to unhook the event for the other edit box so we don't trigger an endless update loop 
  UnbindGadgetEvent(otherbox, @UpdateWindow(), #PB_EventType_Change) 
  If entry = ""
    SetGadgetText(otherbox, "") ; rules are ambiguous here - this seems cleaner to me - otherwise remove this line
  Else  
    SetGadgetText(otherbox, Str(ConvertTemp(entry, Bool(otherbox = #EditboxFahrenheit))))
  EndIf  
  BindGadgetEvent(otherbox, @UpdateWindow(), #PB_EventType_Change) ; edit box is updated - safe to hook event back up
EndProcedure

Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 330, 40, "Temperature Converter", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    StringGadget(#EditboxCelsius,      5, 5, 80, 25, "", #PB_String_Numeric) 
    TextGadget(#PB_Any,              100, 8, 60, 25, "Celsius =")
    StringGadget(#EditboxFahrenheit, 165, 5, 80, 25, "", #PB_String_Numeric) 
    TextGadget(#PB_Any,              255, 8, 80, 25, "Fahrenheit")
    ;    
    BindGadgetEvent(#EditboxCelsius,    @UpdateWindow(), #PB_EventType_Change)
    BindGadgetEvent(#EditboxFahrenheit, @UpdateWindow(), #PB_EventType_Change)
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow  
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 37
; Folding = -
; Optimizer
; EnableXP
; Executable = TemperatureConverter.exe
; DisableDebugger
; Compiler = PureBasic 6.00 Beta 6 (Windows - x64)