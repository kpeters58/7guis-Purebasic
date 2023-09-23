; PUREBASIC: This code results in a 118 KB executable on Win64 (didn't check sizes on MacOS & Linux)

EnableExplicit

Enumeration Gadgets 
  #MainWin
  #SizeWin
  #UndoButton
  #RedoButton
  #Canvas
  #Trackbar
  #SizeLabel
EndEnumeration

Structure CircleInfo
  x.i ; of center point  
  y.i ; of center point
  r.i ; radius
EndStructure

#Default_Radius = 20

Global NewRadius, OldRadius,
       NewList CircleList.CircleInfo() ; this list can only grow, as circle deletion is not required

Procedure.b PointBelongsToCircle(x, y)
  Protected distance.f
  
  ForEach CircleList()
    distance = Sqr(Pow(x - CircleList()\x, 2) + Pow(y - CircleList()\y, 2))
    If distance <= CircleList()\r
      ProcedureReturn #True
    EndIf
  Next
  ProcedureReturn #False
EndProcedure

Procedure UndobuttonClick()
  MessageRequester("Information", "Undo functionality not yet implemented.", #PB_MessageRequester_Info)
EndProcedure

Procedure RedobuttonClick()
  MessageRequester("Information", "Redo functionality not yet implemented.", #PB_MessageRequester_Info)
EndProcedure

Procedure ClearSelection() ; iterate over all circles and fill them with 'non-selected' color
  ForEach CircleList()
    If StartDrawing(CanvasOutput(#Canvas)) ; CanvasOutput() result is valid for only ONE drawing session
      FillArea(CircleList()\x, CircleList()\y, -1, #White) ; auto-select new circle as per spec?
      StopDrawing()
    EndIf  
  Next  
EndProcedure

Procedure SelectCircle(x, y) ; select the current list member circle
  If StartDrawing(CanvasOutput(#Canvas))
    FillArea(x, y, -1, #Yellow)
    StopDrawing()
  EndIf  
EndProcedure

Procedure CanvasLeftClick()
  Protected x = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX),
            y = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY)
  
  If PointBelongsToCircle(x, y)
    SelectCircle(x, y)
  Else
    ClearSelection(); as we are about to select the new circle below
    If StartDrawing(CanvasOutput(#Canvas)) ; CanvasOutput() result is valid for only ONE drawing session
      DrawingMode(#PB_2DDrawing_Outlined)
      Circle(x, y, #Default_Radius + 10, #Black)
      FillArea(x, y, -1, #Red) ; auto-select new circle as per spec?
      StopDrawing()
      ;
      AddElement(CircleList())
      CircleList()\x = x
      CircleList()\y = y
      CircleList()\r = #Default_Radius + 10
    EndIf  
  EndIf  
EndProcedure

Procedure CloseSizeAdjustmentWindow() ; event procedures cannot have parameters in PureBasic
  CloseWindow(#SizeWin)
  DisableWindow(#MainWin, #False)
  If OldRadius <> NewRadius ; apply NewRadius set by ShowSizeAdjustmentWindow() to current circle 
    Debug "Need to redraw circle with new radius"
  EndIf
EndProcedure

Procedure SliderMoved()
  NewRadius = GetGadgetState(#Trackbar)
  ;Debug NewRadius
EndProcedure

Procedure ShowSizeAdjustmentWindow(x, y, r)
  If OpenWindow(#SizeWin, #PB_Ignore, #PB_Ignore, 230, 80, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    StickyWindow(#SizeWin, #True)
    DisableWindow(#MainWin, #True)
    ;
    TextGadget(#PB_Any,       20, 10, 200, 20, "Adjust diameter of circle at " + "(" + Str(x) + ", " + Str(y) + ")")
    TrackBarGadget(#Trackbar, 20, 40, 200, 20, #Default_Radius, #Default_Radius * 3, #PB_TrackBar_Ticks)
    SetGadgetState(#Trackbar, r) ; set trackbar to the current radius value of the selected circle
    BindGadgetEvent(#Trackbar, @SliderMoved(), #PB_EventType_LeftClick);#PB_Event_Gadget)
    ; window needs its own close event - otherwise closing it terminates the application in event loop
    BindEvent(#PB_Event_CloseWindow, @CloseSizeAdjustmentWindow(), #SizeWin) ; close via system menu
  EndIf  
EndProcedure  

Procedure CanvasRightClick()
  Protected x = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseX),
            y = GetGadgetAttribute(#Canvas, #PB_Canvas_MouseY), 
            cx, cy, cr
  
  If PointBelongsToCircle(x, y)
    ; circle on which the user just right-clicked
    cx = CircleList()\x 
    cy = CircleList()\y 
    cr = CircleList()\r 
    OldRadius = cr
    ShowSizeAdjustmentWindow(cx, cy, cr) ; pass in all 3 circle values: x & y for text label; r for initial trackbar position
  EndIf 
EndProcedure

Procedure ShowMainWindow() 
  If OpenWindow(#MainWin, #PB_Ignore, #PB_Ignore, 400, 300, "7GUI - Circle Drawer task in Purebasic", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    ButtonGadget(#UndoButton,  135,  5,  60,  25, "Undo")
    ButtonGadget(#RedoButton,  205,  5,  60,  25, "Redo")
    CanvasGadget(#Canvas,        5, 35, 390, 260, #PB_Canvas_Border)
    SetGadgetAttribute(#Canvas, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    ;
    BindGadgetEvent(#UndoButton, @UndobuttonClick())
    BindGadgetEvent(#Redobutton, @RedobuttonClick())
    BindGadgetEvent(#Canvas,     @CanvasLeftClick(),  #PB_EventType_LeftClick)
    BindGadgetEvent(#Canvas,     @CanvasRightClick(), #PB_EventType_RightClick)
  EndIf
EndProcedure

ShowMainWindow() ; a window must be open for the eventloop to run
Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow   
End
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 126
; FirstLine = 77
; Folding = --
; EnableXP
; DPIAware
; Executable = CircleDrawer.exe