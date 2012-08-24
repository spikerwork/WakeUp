#include "Libs\libs.au3"
#include "Libs\head.au3"


_FirewallException(1, @ScriptName, @ScriptFullPath)
MsgBox(0, "", @ScriptFullPath)
MsgBox(0, "", $ScriptFolder & "\" & $WakeClient)
_FirewallException(1, $WakeClient, $ScriptFolder & "\" & $WakeClient)
#include "Libs\foot.au3"
