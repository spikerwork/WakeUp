; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_GetSystemPowerStatus
; Description....: Retrieves the power status of the system.
; Syntax.........: _WinAPI_GetSystemPowerStatus ( )
; Parameters.....: None
; Return values..: Success - The array containing the following parameters:
;
;                            [0] - The AC power status. This parameter can be one of the following values.
;                                    0 - Offline
;                                    1 - Online
;                                  255 - Unknown status
;                            [1] - The battery charge status. This parameter can be a combination of the following values.
;                                    0 - The battery is not being charged and its capacity is between low and high
;                                    1 - High - the battery capacity is at more than 66 percent
;                                    2 - Low - the battery capacity is at less than 33 percent
;                                    4 - Critical - the battery capacity is at less than 5 percent
;                                    8 - Charging
;                                  128 - No system battery
;                                  255 - Unknown status - unable to read the battery flag information
;                            [2] - The percentage of full battery charge remaining. This member can be a value in the range 0 to 100, or 255 if status is unknown.
;                            [3] - The number of seconds of battery life remaining, or (Ц1) if remaining seconds are unknown.
;                            [4] - The number of seconds of battery life when at full charge, or (Ц1) if full battery lifetime is unknown.
;
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........: @@MsdnLink@@ GetSystemPowerStatus
; Example........: Yes
; ===============================================================================================================================

Func _WinAPI_GetSystemPowerStatus()

	Local $tSYSTEM_POWER_STATUS = DllStructCreate('byte;byte;byte;byte;dword;dword')
	Local $Ret = DllCall('kernel32.dll', 'int', 'GetSystemPowerStatus', 'ptr', DllStructGetPtr($tSYSTEM_POWER_STATUS))

	If (@error) Or (Not $Ret[0]) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $Result[5]

	$Result[0] = DllStructGetData($tSYSTEM_POWER_STATUS, 1)
	$Result[1] = DllStructGetData($tSYSTEM_POWER_STATUS, 2)
	$Result[2] = DllStructGetData($tSYSTEM_POWER_STATUS, 3)
	$Result[3] = DllStructGetData($tSYSTEM_POWER_STATUS, 5)
	$Result[4] = DllStructGetData($tSYSTEM_POWER_STATUS, 6)

	For $i = 3 To 4
		If $Result[$i] = 4294967295 Then
			$Result[$i] = -1
		EndIf
	Next
	Return $Result
EndFunc   ;==>_WinAPI_GetSystemPowerStatus

$Notebook="Notebook.pow"
$Desktop="Desktop.pow"

Local $Data = _WinAPI_GetSystemPowerStatus()

   If $Data[1]=128 Then
   
	  $Battery_Status="Ѕатаре€ отсутствует"
	  $powerplan=$Desktop
	  
   Else
	  
	  $Battery_Status="Ѕатаре€ присутствует"
	  $powerplan=$Notebook
	  
   EndIf
   
;MsgBox(0,"","|" & $Battery_Status & "|")
$ScriptName = "StartWakeUp" ; Name
$ScriptFolder=@HomeDrive & "\" & $ScriptName ; Destination 


$tempfile=@HomeDrive & "\powercfg.txt"

ShellExecuteWait('cmd.exe', '/c powercfg GETACTIVESCHEME | find /I ":" > ' & $tempfile)

$file=FileOpen($tempfile, 0)
$line = FileReadLine($file)
$result = StringInStr($line, ":")
$GUID=StringTrimLeft($line,$result+1)
$result = StringInStr($GUID, " ")
$GUID=StringLeft($GUID,$result-1)

MsgBox (0, "", "|" & $GUID & "|")

