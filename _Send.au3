#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------
#RequireAdmin
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Client"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.4.9
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.3.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"


#include <GUIConstantsEx.au3>
#include <EventLog.au3>

Global $iMemo

_Main()

Func _Main()
    Local $hEventLog, $aEvent

    ; Create GUI
    GUICreate("EventLog", 400, 300)
    $iMemo = GUICtrlCreateEdit("", 2, 2, 396, 300, 0)
    GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")
    GUISetState()

    ; Read most current event record
    $hEventLog = _EventLog__Open("", "Application")
    $aEvent = _EventLog__Read($hEventLog, True, False) ; read last event
;~  $hEventLog = _EventLog__Open("", "System")
;~  $aEvent = _EventLog__Read($hEventLog)
;~  $aEvent = _EventLog__Read($hEventLog, True, False)
    MemoWrite("Result ............: " & $aEvent[0])
    MemoWrite("Record number .....: " & $aEvent[1])
    MemoWrite("Submitted .........: " & $aEvent[2] & " " & $aEvent[3])
    MemoWrite("Generated .........: " & $aEvent[4] & " " & $aEvent[5])
    MemoWrite("Event ID ..........: " & $aEvent[6])
    MemoWrite("Type ..............: " & $aEvent[8])
    MemoWrite("Category ..........: " & $aEvent[9])
    MemoWrite("Source ............: " & $aEvent[10])
    MemoWrite("Computer ..........: " & $aEvent[11])
    MemoWrite("Username ..........: " & $aEvent[12])
    MemoWrite("Description .......: " & $aEvent[13])
    _EventLog__Close($hEventLog)


    ; Loop until user exits
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE

EndFunc   ;==>_Main

; Write a line to the memo control
Func MemoWrite($sMessage)
    GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite







;$lol=GetUnixTimeStamp()
;MsgBox(0,"",$lol)

;$lol=UnixTimeStampToTime($lol)
;MsgBox(0,"", $lol[0] & " " & $lol[1] & " " & $lol[2] & " " & $lol[3] & " " & $lol[4] & " " & $lol[5])
;ActivityDaemon()


;Local $ipdetails=_IPDetail()

;$broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
;$Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")

;SendMagicPacket($Client_MAC, $broadcast)
;DirCreate(@ProgramsCommonDir & "\" & $ScriptName)
;FileCreateShortcut($ScriptFolder & "\" & $WakeInstall, @ProgramsCommonDir & "\" & $ScriptName & "\WakeInstall.lnk", $ScriptFolder)
;DirRemove(@ProgramsCommonDir & "\" & $ScriptName,1)
;MsgBox(0,@StartMenuCommonDir,@ProgramsCommonDir)


#cs

; http://technet.microsoft.com/en-us/library/dd835564%28WS.10%29.aspx

Global $b_ScriptIsRunningWithAdminRights, $b_UAC_IsEnabled, $s_UAC_BehaviorAdmin, $s_UAC_BehaviorUser, $s_UAC_EnableInstallerDetection

Switch IsAdmin()
    Case 0
        $b_ScriptIsRunningWithAdminRights = False
    Case Else
        $b_ScriptIsRunningWithAdminRights = True
EndSwitch

Switch RegRead("HKEY_LOCAL_MACHINESoftwareMicrosoftWindowsCurrentVersionPoliciesSystem", "EnableLUA")
    Case 0
        $b_UAC_IsEnabled = "UAC (formally known as LUA) is disabled."
    Case 1
        $b_UAC_IsEnabled = "UAC (formally known as LUA) is enabled."
EndSwitch

Switch RegRead("HKEY_LOCAL_MACHINESoftwareMicrosoftWindowsCurrentVersionPoliciesSystem", "ConsentPromptBehaviorAdmin")
    Case 0
        $s_UAC_BehaviorAdmin = "Elevate without prompting (Use this option only in the most constrained environments)"
    Case 1
        $s_UAC_BehaviorAdmin = "Prompt for credentials on the secure desktop"
    Case 2
        $s_UAC_BehaviorAdmin = "Prompt for consent on the secure desktop"
    Case 3
        $s_UAC_BehaviorAdmin = "Prompt for credentials"
    Case 4
        $s_UAC_BehaviorAdmin = "Prompt for consent"
    Case 5
        $s_UAC_BehaviorAdmin = "Prompt for consent for non-Windows binaries (default)"
EndSwitch


Switch RegRead("HKEY_LOCAL_MACHINESoftwareMicrosoftWindowsCurrentVersionPoliciesSystem", "ConsentPromptBehaviorUser")
    Case 0
        $s_UAC_BehaviorUser = "Automatically deny elevation requests"
    Case 1
        $s_UAC_BehaviorUser = "Prompt for credentials on the secure desktop (default)"
    Case 3
        $s_UAC_BehaviorUser = "Prompt for credentials"
EndSwitch

Switch RegRead("HKEY_LOCAL_MACHINESoftwareMicrosoftWindowsCurrentVersionPoliciesSystem", "EnableInstallerDetection")
    Case 0
        $s_UAC_EnableInstallerDetection = "Disabled (default for enterprise)"
    Case 1
        $s_UAC_EnableInstallerDetection = "Enabled (default for home)"
EndSwitch

MsgBox(64 + 262144, "Script Info - " & @UserName, "Script is started by user with Admin rights = " & _IsAdministrator() & @CRLF & _
        "Script is started with Admin access = " & $b_ScriptIsRunningWithAdminRights & @CRLF & @CRLF & _
        "EnableLUA:" & @CRLF & $b_UAC_IsEnabled & @CRLF & @CRLF & _
        "ConsentPromptBehaviorAdmin:" & @CRLF & $s_UAC_BehaviorAdmin & @CRLF & @CRLF & _
        "ConsentPromptBehaviorUser:" & @CRLF & $s_UAC_BehaviorUser & @CRLF & @CRLF & _
        "EnableInstallerDetection:" & @CRLF & $s_UAC_EnableInstallerDetection)

; trancexx
; http://www.autoitscript.com/forum/topic/113611-if-isadmin-not-detected-as-admin/page__view__findpost__p__795036
Func _IsAdministrator($sUser = @UserName, $sCompName = ".")
    Local $aCall = DllCall("netapi32.dll", "long", "NetUserGetInfo", "wstr", $sCompName, "wstr", $sUser, "dword", 1, "ptr*", 0)
    If @error Or $aCall[0] Then Return SetError(1, 0, False)
    Local $fPrivAdmin = DllStructGetData(DllStructCreate("ptr;ptr;dword;dword;ptr;ptr;dword;ptr", $aCall[4]), 4) = 2
    DllCall("netapi32.dll", "long", "NetApiBufferFree", "ptr", $aCall[4])
    Return $fPrivAdmin
EndFunc   ;==>_IsAdministrator


#ce

#include "Libs\foot.au3"