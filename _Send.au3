#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------
#AutoIt3Wrapper_Run_AU3Check=n

#include "Libs\libs.au3"
#include "Libs\head.au3"

;Local $ipdetails=_IPDetail()

;$broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
;$Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")

;SendMagicPacket($Client_MAC, $broadcast)
DirCreate(@ProgramsCommonDir & "\" & $ScriptName)
FileCreateShortcut($ScriptFolder & "\" & $WakeInstall, @ProgramsCommonDir & "\" & $ScriptName & "\WakeInstall.lnk", $ScriptFolder)
DirRemove(@ProgramsCommonDir & "\" & $ScriptName,1)
;MsgBox(0,@StartMenuCommonDir,@ProgramsCommonDir)


#include "Libs\foot.au3"