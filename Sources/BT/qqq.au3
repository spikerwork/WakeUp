#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <array.au3>

$asset = "192.11.11.1"

GUICreate("Tasks on " & $asset, 275, 500)
GUISetState(@SW_SHOW)
$test = GUICtrlCreateButton("Refresh Tasks", 45, 470, 80, 20)
$test2 = GUICtrlCreateButton("End Task", 150, 470, 80, 20)
Global $in1 = GUICtrlCreateListView("Task|CPU|Memory", 2, 2, 272, 460, BitOr($LVS_SORTASCENDING,$LVS_SINGLESEL))

_GUICtrlListView_SetColumnWidth($in1, 0, 130)
_GUICtrlListView_SetColumnWidth($in1, 1, 40)
_GUICtrlListView_SetColumnWidth($in1, 2, 60)

$procs = _ProcessListProperties()
_ArrayDisplay($procs)

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            Exit
        Case $msg = $test
            _ProcessListProperties()
        Case $msg = $test2
            exit1()
    EndSelect
WEnd

Func exit1($asset = $asset)
    $arselect = _GUICtrlListView_GetSelectedIndices($in1, "True")
    If $arselect[0] = "" Then
        MsgBox(0, "Error", "No Selection")
    Else
        $process = _GUICtrlListView_GetItemText($in1, $arselect[1])
        RunWait('taskkill /s ' & $asset & ' /IM "' & $process & '"')
        _ProcessListProperties()
    EndIf
EndFunc   ;==>exit1

;===============================================================================
; Function Name:    _ProcessListProperties()
; Description:   Get various properties of a process, or all processes
; Call With:       _ProcessListProperties( [$Process [, $asset]] )
; Parameter(s):  (optional) $Process - PID or name of a process, default is "" (all)
;          (optional) $asset - remote computer to get list from, default is local
; Requirement(s):   AutoIt v3.2.4.9+
; Return Value(s):  On Success - Returns a 2D array of processes, as in ProcessList()
;            with additional columns added:
;            [0][0] - Number of processes listed (can be 0 if no matches found)
;            [1][0] - 1st process name
;            [1][1] - 1st process PID
;            [1][2] - 1st process Parent PID
;            [1][3] - 1st process owner
;            [1][4] - 1st process priority (0 = low, 31 = high)
;            [1][5] - 1st process executable path
;            [1][6] - 1st process CPU usage
;            [1][7] - 1st process memory usage
;            [1][8] - 1st process creation date/time = "MM/DD/YYY hh:mm:ss" (hh = 00 to 23)
;            [1][9] - 1st process command line string
;            ...
;            [n][0] thru [n][9] - last process properties
; On Failure:      Returns array with [0][0] = 0 and sets @Error to non-zero (see code below)
; Author(s):        PsaltyDS at http://www.autoitscript.com/forum
; Date/Version:   12/01/2009  --  v2.0.4
; Notes:            If an integer PID or string process name is provided and no match is found,
;            then [0][0] = 0 and @error = 0 (not treated as an error, same as ProcessList)
;          This function requires admin permissions to the target computer.
;          All properties come from the Win32_Process class in WMI.
;            To get time-base properties (CPU and Memory usage), a 100ms SWbemRefresher is used.
;===============================================================================
Func _ProcessListProperties($Process = "")

    Local $sUserName, $sMsg, $sUserDomain, $avProcs, $dtmDate
    Local $avProcs[1][2] = [[0, ""]], $n = 1

    ; Convert PID if passed as string
    If StringIsInt($Process) Then $Process = Int($Process)

    _GUICtrlListView_DeleteAllItems($in1)

    ; Connect to WMI and get process objects
    $oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate,authenticationLevel=pktPrivacy, (Debug)}!\\" & $asset & "\root\cimv2")
    If IsObj($oWMI) Then
        ; Get collection processes from Win32_Process
        If $Process == "" Then
            ; Get all
            $colProcs = $oWMI.ExecQuery("select * from win32_process")
        ElseIf IsInt($Process) Then
            ; Get by PID
            $colProcs = $oWMI.ExecQuery("select * from win32_process where ProcessId = " & $Process)
        Else
            ; Get by Name
            $colProcs = $oWMI.ExecQuery("select * from win32_process where Name = '" & $Process & "'")
        EndIf

        If IsObj($colProcs) Then
            ; Return for no matches
            If $colProcs.count = 0 Then Return $avProcs

            ; Size the array
            ReDim $avProcs[$colProcs.count + 1][10]
            $avProcs[0][0] = UBound($avProcs) - 1

            ; For each process...
            For $oProc In $colProcs
                ; [n][0] = Process name
                $avProcs[$n][0] = $oProc.name
                ; [n][1] = Process PID
                $avProcs[$n][1] = $oProc.ProcessId
                ; [n][2] = Parent PID
                $avProcs[$n][2] = $oProc.ParentProcessId
                ; [n][3] = Owner
                If $oProc.GetOwner($sUserName, $sUserDomain) = 0 Then $avProcs[$n][3] = $sUserDomain & "\" & $sUserName
                ; [n][4] = Priority
                $avProcs[$n][4] = $oProc.Priority
                ; [n][5] = Executable path
                $avProcs[$n][5] = $oProc.ExecutablePath
                ; [n][8] = Creation date/time
                $dtmDate = $oProc.CreationDate
                If $dtmDate <> "" Then
                    ; Back referencing RegExp pattern from weaponx
                    Local $sRegExpPatt = "\A(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(?:.*)"
                    $dtmDate = StringRegExpReplace($dtmDate, $sRegExpPatt, "$2/$3/$1 $4:$5:$6")
                EndIf
                $avProcs[$n][8] = $dtmDate
                ; [n][9] = Command line string
                $avProcs[$n][9] = $oProc.CommandLine

                ; increment index
                $n += 1
            Next
        Else
            SetError(2); Error getting process collection from WMI
        EndIf
        ; release the collection object
        $colProcs = 0

        ; Get collection of all processes from Win32_PerfFormattedData_PerfProc_Process
        ; Have to use an SWbemRefresher to pull the collection, or all Perf data will be zeros
        Local $oRefresher = ObjCreate("WbemScripting.SWbemRefresher")
        $colProcs = $oRefresher.AddEnum($oWMI, "Win32_PerfFormattedData_PerfProc_Process" ).objectSet
        $oRefresher.Refresh

        ; Time delay before calling refresher
        Local $iTime = TimerInit()
        Do
            Sleep(20)
        Until TimerDiff($iTime) >= 100
        $oRefresher.Refresh

        ; Get PerfProc data
        For $oProc In $colProcs
            ; Find it in the array
            For $n = 1 To $avProcs[0][0]
                If $avProcs[$n][1] = $oProc.IDProcess Then
                    ; [n][6] = CPU usage
                    $avProcs[$n][6] = $oProc.PercentProcessorTime
                    ; [n][7] = memory usage
                    $avProcs[$n][7] = $oProc.WorkingSet
                    ExitLoop
                EndIf
            Next
        Next
    Else
        SetError(1); Error connecting to WMI
    EndIf

for $n=1 to UBound($avProcs)-1
    GUICtrlCreateListViewItem($avProcs[$n][0] & "|" & $avProcs[$n][6] & "|" & $avProcs[$n][7], $in1)
Next

    ; Return array
;~     Return $avProcs
EndFunc  ;==>_ProcessListProperties