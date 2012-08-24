#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1); Change to OnEvent mode
$debugwindow = GUICreate("Process Info", 200, 100)

$inputMainDisplay = GUICtrlCreateInput("", 10, 10, 180, 80)
GUICtrlSetState($inputMainDisplay, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

$count = 1

While 1
  Sleep(1000); Idle around
  GUICtrlSetData($inputMainDisplay, GUICtrlRead($inputMainDisplay) & $count & @CRLF)
  $count = $count + 1
WEnd

Func CLOSEClicked()
  Exit
EndFunc