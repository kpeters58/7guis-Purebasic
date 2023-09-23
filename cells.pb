; PUREBASIC: This results in a 71 KB executable on WIN (didn't check sizes on MacOS & Linux)

EnableExplicit

Enumeration Gadgets 
  #MainWin
  #Filterlabel
  #Firstnamelabel
  #Lastnamelabel
  #FilterEditbox
  #FirstnameEditbox
  #LastnameEditbox
  #NamesListview
  #CreateButton
  #UpdateButton
  #DeleteButton
EndEnumeration


Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 320, 200, "Cells", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#FilterLabel,         10,  13,  60,  22, "Filter prefix")
    StringGadget(#FilterEditbox,     80,  10,  50,  22, "")
    ListViewGadget(#NamesListview,   10,  45, 140,  110) ; defaults to single select, which is what we want here
    TextGadget(#FirstnameLabel,     160,  53,  60,  22, "First name")
    StringGadget(#FirstnameEditbox, 230,  50,  80,  22, "")
    TextGadget(#LastnameLabel,      160,  93,  60,  22, "Last name") 
    StringGadget(#LastnameEditbox,  230,  90,  80,  22, "")
    ;
    ButtonGadget(#CreateButton,  10, 170, 60, 25, "Create")
    ButtonGadget(#UpdateButton,  80, 170, 60, 25, "Update")
    ButtonGadget(#DeleteButton, 150, 170, 60, 25, "Delete")
    ;
;     BindGadgetEvent(#CreateButton,  @CreateRecord())
;     BindGadgetEvent(#UpdateButton,  @UpdateRecord())
;     BindGadgetEvent(#DeleteButton,  @DeleteRecord())
;     BindGadgetEvent(#NamesListview, @SelectRecord())
;     BindGadgetEvent(#FilterEditbox, @Filterrecords(), #PB_EventType_Change)
;     ;
;     AddSampleRecords()
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 39
; Folding = -
; Markers = 19
; EnableXP
; DPIAware
; Executable = CRUD.exe