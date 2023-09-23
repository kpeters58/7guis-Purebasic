; PUREBASIC: This results in a 77 KB executable on WIN64 (didn't check sizes on MacOS & Linux)

EnableExplicit

Enumeration Gadgets 
  #MainWin
  #DropdownFlightType
  #EditboxFirstDate  
  #EditboxSecondDate
  #ButtonBook
EndEnumeration  

Procedure BookFlights()
  ; if the [Book] button is active, all is well in the GUI logic - just show the proper booking message
  If GetGadgetState(#DropdownFlightType) = 0 
    MessageRequester("Information", "You have booked a one-way flight on " + Trim(GetGadgetText(#EditboxFirstDate)), #PB_MessageRequester_Ok | #PB_MessageRequester_Info)
  Else 
    MessageRequester("Information", "You have booked a return flight leaving on " + Trim(GetGadgetText(#EditboxFirstDate)) + 
                                    " and returning on " + Trim(GetGadgetText(#EditboxSecondDate)), #PB_MessageRequester_Ok | #PB_MessageRequester_Info)
  EndIf  
EndProcedure


Procedure.b IsValidDate(DateStr.s)
  ProcedureReturn Bool(ParseDate("%yyyy-%mm-%dd", Datestr) <> -1)
EndProcedure


Procedure.b ValidateFormatAndLogic()
  Protected dateedit = EventGadget(), 
            valid.b  = IsValidDate(Trim(GetGadgetText(dateedit))), 
            color    = #PB_Default,
            sdate.s  = Trim(GetGadgetText(#EditboxFirstDate)),
            edate.s  = Trim(GetGadgetText(#EditboxSecondDate))              
  
  If Not Valid: color = #Red: EndIf
  ; color editbox containing invalid date format in red  
  SetGadgetColor(dateedit, #PB_Gadget_BackColor, color)
  ; now check the logic
  If GetGadgetState(#DropdownFlightType) = 0 ; single flight
    ProcedureReturn IsValidDate(sdate)
  Else ; type is 1 = return flight   
    ProcedureReturn Bool(IsValidDate(sdate) And IsValidDate(edate) And edate >= sdate)
  EndIf  
EndProcedure  

Procedure SetBookButtonState()
  DisableGadget(#ButtonBook, Bool(Not ValidateFormatAndLogic()))
EndProcedure  

Procedure FlightTypeChange()
  ; always disable return date editbox if one-way flight selected
  DisableGadget(#EditboxSecondDate, Bool(GetGadgetState(#DropdownFlightType) = 0)) 
  ; disable [Book] button if logic check fails
  SetBookbuttonState()
EndProcedure


Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 260, 130, "7GUI - Flight Booker task in Purebasic", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    ComboBoxGadget(#DropdownFlightType, 5,  5, 190, 25) 
    AddGadgetItem(#DropdownFlightType, -1, "one-way flight")  
    AddGadgetItem(#DropdownFlightType, -1, "return flight") 
    SetGadgetText(#DropdownFlightType, GetGadgetItemText(#DropdownFlightType, 0))
    StringGadget(#EditboxFirstDate,    5, 35, 190, 25, "2020-02-14") ; arbitray date as per rules - we use RFC3339/ISO8601 date format as everyone should
    StringGadget(#EditboxSecondDate,   5, 65, 190, 25, "2020-02-14"): DisableGadget(#EditboxSecondDate, #True) ; initially off as per rules 
    ButtonGadget(#ButtonBook,          5, 95, 190, 25, "Book")       ; button is initially enabled as the defaults are all valid  
    ;    
    BindGadgetEvent(#DropdownFlightType, @FlightTypeChange())
    BindGadgetEvent(#ButtonBook,         @Bookflights())
    BindGadgetEvent(#EditboxFirstDate,   @SetBookButtonState(), #PB_EventType_Change)
    BindGadgetEvent(#EditboxSecondDate,  @SetBookButtonState(), #PB_EventType_Change)
  EndIf
EndProcedure


ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow  
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 58
; FirstLine = 6
; Folding = --
; Optimizer
; EnableXP
; Executable = FlightBooker.exe
; Compiler = PureBasic 6.00 Beta 6 (Windows - x64)