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

Global NewList Records.s()

Procedure DisplayRecords()
  ClearGadgetItems(#NamesListview)    
  ForEach Records()
    AddGadgetItem(#NamesListview, -1, Records())
  Next  
EndProcedure

Procedure AddSampleRecords()
  ; note the spaces after the separating commas
  AddElement(Records()): Records() = "Binder, Almut"    
  AddElement(Records()): Records() = "Bielstein, Andrea"
  AddElement(Records()): Records() = "Dammeyer, Susanne"
  AddElement(Records()): Records() = "Bringer, Anke"
  AddElement(Records()): Records() = "Schiak, Rolf"
  ;
  DisplayRecords()
EndProcedure

Procedure UpdateButtons()
  DisableGadget(#UpdateButton, Bool(CountGadgetItems(#NamesListview) = 0))
  DisableGadget(#DeleteButton, Bool(CountGadgetItems(#NamesListview) = 0))
EndProcedure  

Procedure FilterRecords()
  Protected filter.s = LCase(Trim(GetGadgetText(#FilterEditbox))), left.s
  
  ClearGadgetItems(#NamesListview)    
  ForEach Records()
    left = LCase(Left(Records(), Len(filter)))
    If filter = "" Or Bool(filter > "" And left = filter)
      AddGadgetItem(#NamesListview, -1, Records())
    EndIf  
  Next  
EndProcedure

Procedure ClearFilter()
  ; with an active filter we may get an incorrect picture of the current data
  UnbindGadgetEvent(#FilterEditbox, @Filterrecords(), #PB_EventType_Change)
  SetGadgetText(#FilterEditbox, "")
  BindGadgetEvent(#FilterEditbox, @Filterrecords(), #PB_EventType_Change)
EndProcedure

Procedure CreateRecord()
  Protected firstname.s = Trim(GetGadgetText(#FirstnameEditbox)), 
            lastname.s  = Trim(GetGadgetText(#LastnameEditbox)), 
            record.s    = lastname + ", " + firstname
  
  If (firstname = "") Or (lastname = "") 
    MessageRequester("Information", "Both first- & last name are required.", #PB_MessageRequester_Info)
    ProcedureReturn
  EndIf
  ; prevent duplicate entries
  ForEach Records()
    If LCase(Records()) = LCase(record)
      MessageRequester("Error", "This record already exists.", #PB_MessageRequester_Error)
      ProcedureReturn
    EndIf  
  Next
  ; display list with the added record
  ClearFilter()
  AddElement(Records()): Records() = record
  DisplayRecords()
  UpdateButtons()
EndProcedure

Procedure UpdateRecord()
  Protected index       = GetGadgetState(#NamesListview),
            firstname.s = Trim(GetGadgetText(#FirstnameEditbox)), 
            lastname.s  = Trim(GetGadgetText(#LastnameEditbox))
  
  If index = -1 ; no record is currently selected
    MessageRequester("Information", "Select a record to be updated first", #PB_MessageRequester_Info)
    ProcedureReturn
  Else  
    If (firstname = "") Or (lastname = "") 
      MessageRequester("Information", "Both first- & last name are required.", #PB_MessageRequester_Info)
      ProcedureReturn
    EndIf
    Records() = lastname + ", " + firstname
  EndIf
  ClearFilter()
  ; display list with the updated record
  DisplayRecords()
  ; no UpdateButtons() call required for updates
EndProcedure

Procedure DeleteRecord()
  If GetGadgetState(#NamesListview) = -1 ; no record is currently selected
    MessageRequester("Information", "Select a record to be deleted first", #PB_MessageRequester_Info)
    ProcedureReturn
  Else  
    DeleteElement(Records(), 1)
    SetGadgetText(#FirstnameEditbox, "")
    SetGadgetText(#LastnameEditbox, "")
  EndIf
  ClearFilter()
  ; display list without the deleted record
  DisplayRecords()
  UpdateButtons()
EndProcedure

Procedure SelectRecord()
  Protected index       = GetGadgetState(#NamesListview),
            record.s    = GetGadgetItemText(#NamesListview, index),
            lastname.s  = StringField(record, 1, ","),
            firstname.s = Trim(StringField(record, 2, ",")) ; lose leading space
  
  SetGadgetText(#LastnameEditbox,  lastname)
  SetGadgetText(#FirstnameEditbox, firstname)
  SelectElement(Records(), index)
EndProcedure

Procedure ShowMainWindow() 
  Protected gheight = 22
  
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 320, 200, "7GUI - CRUD task in Purebasic", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#FilterLabel,         10,  13,  60, gheight, "Filter")
    StringGadget(#FilterEditbox,     50,  10,  50, gheight, ""): GadgetToolTip(#FilterEditbox, "Lastname starts with")
    ListViewGadget(#NamesListview,   10,  45, 140, 110) ; defaults to single select, which is what we want here
    TextGadget(#FirstnameLabel,     160,  53,  60, gheight, "First name")
    StringGadget(#FirstnameEditbox, 230,  50,  80, gheight, "")
    TextGadget(#LastnameLabel,      160,  93,  60, gheight, "Last name") 
    StringGadget(#LastnameEditbox,  230,  90,  80, gheight, "")
    ;
    ButtonGadget(#CreateButton,  10, 170, 60, gheight, "Create")
    ButtonGadget(#UpdateButton,  80, 170, 60, gheight, "Update")
    ButtonGadget(#DeleteButton, 150, 170, 60, gheight, "Delete")
    ;
    BindGadgetEvent(#CreateButton,  @CreateRecord())
    BindGadgetEvent(#UpdateButton,  @UpdateRecord())
    BindGadgetEvent(#DeleteButton,  @DeleteRecord())
    BindGadgetEvent(#NamesListview, @SelectRecord())
    BindGadgetEvent(#FilterEditbox, @Filterrecords(), #PB_EventType_Change)
    ;
    AddSampleRecords()
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 113
; FirstLine = 99
; Folding = --
; Markers = 86
; EnableXP
; DPIAware
; Executable = CRUD.exe