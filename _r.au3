$Timer = TimerInit()
$Timer = TimerDiff($Timer) / 1000

$SearchKey = "HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
$SearchString = "0AA0FECA-B1B1-496F-8122-0B79AA57A1A7"

$Results = _RegSearch($SearchKey, $SearchString)

$result = StringInStr($Results, "NetCfgInstanceId")
$result=StringTrimLeft($Results,$result-6)
$result=StringLeft($result,4)

$var=RegRead("HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" & "\" & $result, "PnPCapabilities")
if $var<>"256" Then
  RegWrite("HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" & "\" & $result, "PnPCapabilities", "REG_DWORD", "256")
EndIf
   
MsgBox(0,"",$result)

;*****************************************************
; Function _RegSearch($startkey, $searchval)
;   Performs a recursive search of the registry
;     Starting at $sStartKey, looking for $sSearchVal
; Returns a string containing a list of key names and values.
;   If a key name matches, it is listed as a reg path with trailing backslash:
;     i.e. HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\
;   If a value name matches, it is listed as a reg path without trailing backslash:
;     i.e. HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WallPaperDir
;   If the data matches, the format is path = data:
;       i.e. HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WallPaperDir = %SystemRoot%\Web\Wallpaper
;*****************************************************
Func _RegSearch($startkey, $searchval)
    Local $v, $val, $k, $key, $found = ""
    
    ; This loop checks values
    $v = 1
    While 1
        $val = RegEnumVal($startkey, $v)
        If @error = 0 Then
            ; Valid value - test it's name
            If StringInStr($val, $searchval) Then
                $found = $found & $startkey & "\" & $val & @LF
            EndIf
            ; test it's data
            $readval = RegRead($startkey, $val)
            If StringInStr($readval, $searchval) Then
                $found = $found & $startkey & "\" & $val & " = " & $readval & @LF
            EndIf
            $v += 1
        Else
            ; No more values here
            ExitLoop
        EndIf
    WEnd
    
    ; This loop checks subkeys
    $k = 1
    While 1
        $key = RegEnumKey($startkey, $k)
        If @error = 0 Then
            ; Valid key - test it's name
            If StringInStr($key, $searchval) Then
                $found = $found & $startkey & "\" & $key & "\" & @LF
            EndIf
            ; Now search it
            $found = $found & _RegSearch($startkey & "\" & $key, $searchval)
        Else
            ; No more keys here
            ExitLoop
        EndIf
        $k += 1
    WEnd
    
    ; Return results
    Return $found
EndFunc   ;==>_RegSearch