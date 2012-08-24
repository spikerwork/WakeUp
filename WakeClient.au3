#include "Libs\libs.au3"
#include "Libs\head.au3"


;;;;;;;   $ipdetails=_IPDetail()
;;;;;;;   _ArrayDisplay($ipdetails, "$avArray as a 2D array")
Local $lastrun=0

$ipdetails=_IPDetail()


; Load vars from ini
$firstrun=IniRead($resultini, "Runs", "First Run", 1)
$runs_all=IniRead($inifile, "Client", "TestRepeat", 5)+1
$runs_left=IniRead($resultini, "Runs", "Left", "")
$run=$runs_all-$runs_left
$current_run="Current run #" & $run
If $runs_left==1 Then $lastrun=1
$test_halt=IniRead($resultini, "Client", "Off",  1)
$test_sleep=IniRead($resultini, "Client", "Sleep",  1)
$test_hiber=IniRead($resultini, "Client", "Hibernate",  1)
Local $test_options=$test_halt & $test_sleep & $test_hiber ; OSH (Off, Sleep, Hibernate)



If $firstrun==1 Then 
   ToolTip("Идет подготовка к запуску теста " & $ScriptName,2000,0 , "Первый запуск", 1,4)
   PauseTime($ClientPause)
   SendData($ServerIP, "Test", $TCPport)
   PauseTime($ClientPause)
   $socket = StartTCPServer($Client_IP,$TCPport+1)
   RecieveData ($socket)
   
   If $Ready==1 Then
	  
	  history ("###Connection to server established###")
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|StoreValues", $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|MAC" & "|" & $ipdetails[2][0], $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|TestRuns" & "|" & $runs_all-1, $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|OptionsOSH" & "|" & $test_options, $TCPport) ; Halt, Reboot, Hibernate 111 or 000
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|StoreValuesFinish", $TCPport)
	  PauseTime($ClientPause)
	  $socket = StartTCPServer($Client_IP,$TCPport+1)
	  RecieveData ($socket)
	  
		 if $Done==1 Then
		 history ("###Vars stored on server###")
	  
		 IniWrite($resultini, "Runs", "First Run", 0)
		 IniWrite($resultini, "Runs", "Left", $run-1)
		 PauseTime($ClientPause)
		 halt("reboot")
		 
		 EndIf
   EndIf
   
Else
   
   If $test_sleep==1 Then
	     
	  $test_sleep_time=IniRead($resultini, $current_run, "Sleep", 0) 
	  
	  If $test_sleep_time==0 Then
		 
		 PauseTime(5)
		 
		 SendData($ServerIP, "ToServer|Sleep|" & $run, $TCPport)
		 
		 PauseTime($ClientPause)
		 
		 Run($ScriptFolder & "\" & $WakeDaemon & " Sleep", $ScriptFolder)
		 halt("sleep")
		 
	  Else
		 
		 
	  EndIf
	  
   EndIf

	  
   ;IniWrite($resultini, $current_run, "Reboot", 1)
   ;IniWrite($resultini, $current_run, "Hibernate", 1)
   ;IniWrite($resultini, $current_run, "Halt", 1)
   
   
   
   
   If $lastrun==1 Then
	  
   ToolTip("Последний прогон. Вывод результатов...",2000,0 , $ScriptName, 1,4)
   
   
   ; Last script messages
   $excel_need=IniRead($inifile, "Client", "Excel", 0)
   
   If $excel_need==0 then
	  
	  MsgBox(0,"","Script Done. Open BTResult.ini for results")
   
   Else
   
	  resulttoxls ()
	  MsgBox(0,"","Script Done. Results stored in BTresults.xls")
   
   EndIf
   
   
   EndIf

EndIf


#include "Libs\foot.au3"

