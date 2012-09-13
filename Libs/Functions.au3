#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	The main library for WakeUp Script Time Checker (WSTC)
	Contains main functions

#ce --------------------------------------------------------------------

   ; ===================================================================
   ; 							Functions
   ; ===================================================================

   ;
   ; General Functions
   ;

   ;  Set Pause for $time (in seconds)
   Func PauseTime($time)
   history ("Pause func triggered. Pause time - " & $time)
	ProgressOn("Progress", "Pause for " & $time & " seconds", "0 seconds")
	Local $i
	For $i = 1 to $time step 1
		Sleep(1000)
		Local $p=(100/$time)*$i
		ProgressSet( $p, $i & " seconds")
    Next
	ProgressSet(100 , "Done", "Complete")
	Sleep(500)
	ProgressOff()
	history ("Pause ended.")

   EndFunc

   ; Shutdown functions with Force (+4) option
   Func halt($halt_option)
      history ("The system is halting. Reason - " & $halt_option)
	  Switch $halt_option
	  Case "reboot"
   		 Shutdown(6)
	  Case "sleep"
		 Shutdown(32) ; 32+4 not working
	  Case "hibernate"
		 Shutdown(64) ; 64+4 not working
	  Case "halt"
		 Shutdown(5)
	  Case Else
		 MsgBox(0, "", "Wrong shutdown option")
		 Exit
	  EndSwitch

   EndFunc

   ; Get time function
   Func currenttime ()
	  $currentdate=@HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC
	  Return $currentdate
   EndFunc

   ; Logging function
   Func history ($post)

	  If $log == 1 Then

	  Local $time=currenttime ()
	  Local $file = FileOpen($logfile, 9) ; which is similar to 1 + 8 (append to file + create dir)

	  If $file = -1 Then
		  MsgBox(0, "Error", "Unable to create or open log file.")
		  Exit
	   EndIf
	  If $linedebug==1 Then ToolTip("Time - " & $time & @CRLF & $post & @CRLF, 2000, 0, @ScriptName, 2,4)
	  FileWrite($file, $time & " Script (" & @ScriptName & ") — - — " & $post & @CRLF)
	  FileClose($file)

	  EndIf

   EndFunc

   ; Open log file of current script when doubleclicked on tray icon
   Func OpenLog()

	  If $log == 1 Then
	  history ("Log file " & $logfile & " opened")
	  ShellExecute($logfile)
	  EndIf

   EndFunc

   ;
   ; Other Functions
   ;

   ; Computer activity gatherer Daemon
   Func ActivityDaemon()

   history ("Start WMI daemon...")

	  $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}\\.\root\cimv2")

	  Local $time=0 ; Cycle timer
	  Local $worktime=0 ; All timer

	  While 1

	  $CPULoadArray[0]="0"
	  $HDDLoadArray[0]="0"

	  if $worktime==0 Then
		 $run = 1
	  Else
		 $run=$worktime/5+1
	  EndIf


	  $time=$time+0.5

		If $cpu_need==0 and $hdd_need==0 Then
		history ("Skiping WMI daemon. ")
		ExitLoop
		EndIf

	  ; Gathering CPU WMI Information
		If $cpu_need==1 Then

		 $WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",0x10+0x20)

		 For $obj In $WMIQuery
			  $Current_Clock = $obj.CurrentClockSpeed
			  $Load = $obj.LoadPercentage
		 Next

		 _ArrayAdd($CPULoadArray, $Load)

		 $CPU_Clock = "Current CPU Clock: " & $Current_Clock & " MHz"



			$CPU_Load = "Average CPU Load: " & $Load & " %"

		 Else
			$CPU_Clock = ""
			$CPU_Load = "CPULoad monitoring off"

		 EndIf

	  ; Gathering HDD WMI Information

		If $hdd_need==1 Then

		 $WMIQuery2 = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")

		 For $obj2 In $WMIQuery2
			   $hdd_activity = $obj2.PercentDiskTime
			   $hdd_bytes = $obj2.DiskBytesPerSec
		 Next

		_ArrayAdd($HDDLoadArray, $hdd_activity)

		$HDD_bytes = "HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes


		$HDD = "Average HDD Load (PercentDiskTime): " &  $hdd_activity

		 Else

			$HDD = "HDDLoad monitoring off"
			$HDD_bytes=" "

		 EndIf

		 $idle = "Elapsed Time: " & $time & " sec"

		 ToolTip("Cycle number " & $run & @CRLF & $CPU_Load & @CRLF & $CPU_Clock & @CRLF & $HDD & @CRLF & $HDD_bytes& @CRLF & $idle, 2000, 0, @ScriptName, 2,4)

		 Sleep(500)

	  if $time >= 5 Then

	  Local $i=0
	  Local $l=0
	  Local $r

			; CPU Array

			If $cpu_need==1 Then

			   $r=Ubound($CPULoadArray)
			   Do
			   $i=$i+1
			   $l=$l+$CPULoadArray[$i]
			   Until $i = $r-1
			   $CPULoadArray=0
			   Global $CPULoadArray[1]

			   $r=$r-1
			   $AverageLoadCPU=$l/$r

				$AverageLoadCPU=StringFormat ( "%d", $AverageLoadCPU)


			   ; CPU Load check
			   $cpu_percent_need=Number($cpu_percent_need)
			   $AverageLoadCPU=Number($AverageLoadCPU)

				history ("Current CPU Clock: " & $Current_Clock & " MHz")


			   If $AverageLoadCPU == "" Then $AverageLoadCPU=100

				  If $AverageLoadCPU > $cpu_percent_need Then

					 history ("Average CPU Load is too high — " & $AverageLoadCPU & "%. Default is " & $cpu_percent_need & "%")
					 $worktime=$worktime+$time
					 $time=0

				  Else

					 history ("Average CPU Load is low than — " & $cpu_percent_need & "%")

				  EndIf

			EndIf

			;--------------
			; HDD Array

			If $hdd_need==1 Then

			   $r=Ubound($HDDLoadArray)
			   $i=0
			   $l=0

			   Do
			   $i=$i+1
			   $l=$l+$HDDLoadArray[$i]
			   Until $i = $r-1
			   $HDDLoadArray=0
			   Global $HDDLoadArray[1]

			   $r=$r-1
			   $AverageLoadHDD=$l/$r
			   $AverageLoadHDD=StringFormat ( "%d", $AverageLoadHDD)

			   ; HDD Load Check
			   $hdd_percent_need=Number($hdd_percent_need)
			   $AverageLoadHDD=Number($AverageLoadHDD)

			   If $AverageLoadHDD == "" Then $AverageLoadHDD=100

			   history ("HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes)

				  If $AverageLoadHDD > $hdd_percent_need Then

					 history ("Average HDD Load is too high — " & $AverageLoadHDD & "%. Default is " & $hdd_percent_need & "%")
					 $worktime=$worktime+$time
					 $time=0

				  Else

					 history ("Average HDD Load is low than — " & $hdd_percent_need & "%")

				  EndIf

			EndIf

			if $time==0 Then history ("Next cycle initialized...")
			If $time<>0 Then ExitLoop


	  EndIf
	  WEnd

   $worktime +=5

   history ("System enter IDLE state, after " & $worktime & " seconds. " & $run & " cycles")

   Return $worktime & "|" & $run

   EndFunc


   ; Parsing results from ini file to excel
   Func resulttoxls ($ini,$xls)
   Dim $resultarray[1][2]

   Local $sections = IniReadSectionNames($ini)
   Local $i=$sections[0]

    While $i >= 1

	  Local $section = IniReadSection($ini, $sections[$i])
	  local $l=$section[0][0]

		 While $l >= 1
		 _Array2DInsert($resultarray,0, $section[$l][0] &  "|" & $section[$l][1])
		 $l = $l - 1
		 WEnd

	_Array2DInsert($resultarray,0, $sections[$i] & "| Time")
	$i = $i - 1
   WEnd

   _Array2DInsert($resultarray,0, "Parameter | Value")
   _Array2DEmptyDel($resultarray)
   _ArrayToXLS($resultarray, $xls)

   EndFunc

   ; Convert ini file to XLS file
   Func convertresults ($ini,$xls)

	  history ("Try to convert ini to XLS")
	  $oExcel = ObjCreate('Excel.Application')
	  If @error Then
	  history ("Convert to XLS disabled. Excel not found in system.")
	  Else
		 Local $file = FileOpen($ini, 0)

		 If $file = -1 Then
			history ("Unable to open " & $ini)
		 Else

			If FileGetSize($ini) < 30 Then
			history ("File " & $resultini & " to small: " & FileGetSize($ini) & " bytes")
			Else
			history ("Converting ini to XLS file " & $xls)
			resulttoxls ($ini,$xls)
			EndIf

		 EndIf

	  EndIf

   EndFunc


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
   ;                            [3] - The number of seconds of battery life remaining, or (–1) if remaining seconds are unknown.
   ;                            [4] - The number of seconds of battery life when at full charge, or (–1) if full battery lifetime is unknown.
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


   ; Add to registry PnPCapabilites record (256 - good)
   Func PnPCapabilites ($GUID)

	  $Results = _RegSearch($SearchKey, $GUID)
	  history ("Searching " & $GUID & " in " & $SearchKey)
	  $result = StringInStr($Results, "NetCfgInstanceId")
	  $result=StringTrimLeft($Results,$result-6)
	  $result=StringLeft($result,4)

	  $var=RegRead($SearchKey & "\" & $result, "PnPCapabilities")
	  history ("Found key " & $GUID & ". PnPCapabilities=" & $var)

	  if $var<>"256" Then
		RegWrite($SearchKey & "\" & $result, "PnPCapabilities", "REG_DWORD", "256")
	  EndIf

   EndFunc


    ; Add to Firewall Exception. Need admin rights
   Func AddToFirewall ($appName, $applicationFullPath)
	  RunWait ('netsh advfirewall firewall add rule name="' & $appName &'" dir=in action=allow program="' & $applicationFullPath & '" enable=yes profile=any')
  EndFunc

	; IMPORTANT MAKE A COPY OF SCRIPT BEFORE DELETION
	; Deletes the running script
	; Author MHz

	Func _SelfDelete($iDelay = 0)
		Local $sCmdFile
		FileDelete(@TempDir & "\scratch.bat")
		$sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
				& ':loop' & @CRLF _
				& 'del "' & @ScriptFullPath & '"' & @CRLF _
				& 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
				& 'del ' & @TempDir & '\scratch.bat'
		FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
		Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
	EndFunc
