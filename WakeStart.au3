#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Start Script for Server and Client.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Start"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.0.27
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.2.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

;;; Local Vars ;;;

Local $pausetime=5

;;; Forms dimensions

Local $FirstFormWidth=300
Local $FirstFormHigh=200

Local $ClientFormWidth=400
Local $ClientFormHigh=400

Local $ServerFormWidth=400
Local $ServerFormHigh=400

;;; Empty vars

Local $Button_1
Local $Button_2
Local $Button_3
Local $Button_5
Local $Button_6
Local $Button_9
Local $combo
Local $adapterList
Local $MainAdapter_ip
Local $MainAdapter
Local $MainAdapter_netmask
Local $MainAdapter_MAC
Local $INI_MAC
Local $INI_Broadcast
Local $INI_IP
Local $INI_TCP
Local $INI_UDP
Local $INI_excel
Local $INI_TestRepeat
Local $INI_cpu_time
Local $INI_sleep
Local $INI_halt
Local $INI_hiber
Local $INI_cpu_activity
Local $INI_hdd_activity
Local $broadcast_input
Local $ip_input
Local $TCP_input
Local $UDP_input
Local $S_input
Local $S_TCP_input
Local $Adapter_GUID

;;; Vars filled with values
Local $t=0
Local $adapters=0
Local $PhysicAdapters=0
Local $ipdetails=_IPDetail() ; Gather information of network adapters

; Files check (Vars from head.au3)
If $filesinfolder<>$F_arra-1 Then
	MsgBox(0, "Warning.", "Some files not found. Reinstall Script")
	history ("Some files not found. Reinstall Script. Found only - " & $filesinfolder)
	If FileExists($ScriptFolder & "\" & $WakeInstall) Then Run($ScriptFolder & "\" & $WakeInstall, $ScriptFolder)
	Exit
EndIf


; Creating main GUI
$mainGui=GuiCreate("Start WakeScript (WSTC)", $FirstFormWidth, $FirstFormHigh)
GUISetHelp(@ComSpec & ' /C start ' & $ScriptFolder & "\" & $helpfile) ; Display Help file
Opt("GUICoordMode", 1)

GuiCtrlCreateLabel("Press F1 for help", 145, 0, 150, 15, $SS_RIGHT)

$Button_1 = GUICtrlCreateButton("Start Client", 80, 30, 150, 40)
$Button_2 = GUICtrlCreateButton("Start Server",  80, 80, 150, 40)
$Button_3 = GUICtrlCreateButton("Uninstall Script",  80, 130, 150, 40)

GUISwitch($mainGui)
GUISetState ()

; Main cycle

While 1

   $msg = GUIGetMsg()

   Select

   ;
   ;
   ; Install Client (Step 1)
   ;
   ;
   Case $msg == $Button_1
   history ("Choosed option *Install Client* " & $Button_1)

	  $InstallClientGui=GuiCreate("Install WSTC Client", $ClientFormWidth, $ClientFormHigh)

	  GUISwitch($InstallClientGui)
	  GUISetState(@SW_HIDE, $mainGui)
	  GUISetState(@SW_SHOW, $InstallClientGui)

	  $tab = GUICtrlCreateTab(20, 20, $ClientFormWidth-40, $ClientFormHigh-40)

	  ; First tab
	  $maintab = GUICtrlCreateTabItem("Main")

	  GuiCtrlCreateLabel("Test preset ", 40, 50, 150, 20)
	  GUICtrlSetFont (-1, 8.5, 800, 0, "Tahoma")
	  $timer_sleep=GUICtrlCreateCheckbox("Sleep ", 40, 80, 120, 20)
	  $timer_hiber=GUICtrlCreateCheckbox("Hibernation ", 40, 100, 120, 20)
	  $timer_halt=GUICtrlCreateCheckbox("Halt (enabled in BIOS?)", 40, 120, 160, 20)
	  GuiCtrlCreateLabel("Analyze PC load algorithm ", 40, 160, 150, 20)
	  GUICtrlSetFont (-1, 8.5, 800, 0, "Tahoma")
	  $hdd_activity=GUICtrlCreateCheckbox("Analyze HDD ", 40, 180, 120, 20)
	  $cpu_activity=GUICtrlCreateCheckbox("Analyze CPU ", 40, 200, 120, 20)
	  GuiCtrlCreateLabel("Max CPU Load, %  ", 160, 204, 120, 20, $SS_RIGHT)
	  $cpu_time = GUICtrlCreateInput (5, 320, 200, 40, 20, $SS_RIGHT)
	  GUICtrlCreateUpdown($cpu_time)
	  GUICtrlSetLimit ($cpu_time, 2 , 1)
	  GuiCtrlCreateLabel("���������� �������� �����:", 40, 234, 250, 20)
	  $TestRepeat = GUICtrlCreateInput (5, 320, 230, 40, 20, $SS_RIGHT)
	  GUICtrlCreateUpdown($TestRepeat)
	  GUICtrlSetLimit ($TestRepeat, 2 , 1)
	  GuiCtrlCreateLabel("Results ", 40, 260, 150, 20)
	  GUICtrlSetFont (-1, 8.5, 800, 0, "Tahoma")
	  $excel_enabled=GUICtrlCreateCheckbox("Export to Excel ", 40, 280, 170, 20)

	  GUICtrlSetState ($cpu_activity, $GUI_CHECKED )

			If $osversion=="WIN_8" Then
			history ("HDDLoad monitoring not effective in this OS")
			GUICtrlSetState ($hdd_activity, $GUI_UNCHECKED )
			GUICtrlSetState ($hdd_activity, $GUI_DISABLE )
			Else
			GUICtrlSetState ($hdd_activity, $GUI_CHECKED )
			EndIf

	  GUICtrlSetState ($timer_sleep, $GUI_CHECKED )
	  GUICtrlSetState ($timer_hiber, $GUI_CHECKED )
	  GUICtrlSetState ($timer_halt, $GUI_CHECKED )

	  ; Check the excel
	  $oExcel = ObjCreate('Excel.Application')
		 If @error Then
		 GUICtrlSetState ($excel_enabled, $GUI_DISABLE)
		 Else
		 GUICtrlSetState ($excel_enabled, $GUI_CHECKED)
	  EndIf

	  $Button_6 = GUICtrlCreateButton("Next", 130, 320, 150, 40)

	  GUISetState ()

	  ; Second tab
	  $secondtab=GUICtrlCreateTabItem("Network")


		While $t <= UBound($ipdetails, 2)-1

			if $ipdetails[0][$t]<>"" Then
			   $adapters+=1
			   If $ipdetails[5][$t]==1 Then

				  $PhysicAdapters +=1
				  $MainAdapter=$ipdetails[0][$t]
				  $MainAdapter_ip=$ipdetails[1][$t]
				  $MainAdapter_MAC=$ipdetails[2][$t]
				  $MainAdapter_netmask=$ipdetails[3][$t]
				  $Adapter_GUID=$ipdetails[6][$t]
				  PnPCapabilites($Adapter_GUID)

			   EndIf

			   $adapterList=$adapterList & "|" & $ipdetails[0][$t]

			EndIf
			$t+=1

		WEnd

		If $t==0 Then
			 history ("Active network adapters not found! Run script again...")
			 Exit
		EndIf

		If $PhysicAdapters==0 Then
			history ("Warning! Physical network adapters not found.")
		Else
			history ("Using main adapter � " & $MainAdapter)
		EndIf

		 $INI_IP=$ServerIP
		 $INI_CIP=$MainAdapter_ip
		 $INI_TCP=$TCPport
		 $INI_MAC=$MainAdapter_MAC


		 GUICtrlCreateLabel("Use this network adapter:", 30, 50, 320, 20)

		 $combo=GUICtrlCreateCombo("Adapters", 30, 70, 330, 20)
		 GUICtrlSetData(-1, $adapterList, $MainAdapter)

		 GUICtrlCreateLabel("Client IP address:", 30, 100, 300, 20)
		 $ip_input=GUICtrlCreateInput($INI_CIP, 30, 120, 300, 20)

		 GUICtrlCreateLabel("Server IP address:", 30, 150, 300, 20)
		 $S_input=GUICtrlCreateInput($INI_IP, 30, 170, 300, 20)

		 GUICtrlCreateLabel("Server TCP port:", 30, 200, 300, 20)
		 $S_TCP_input=GUICtrlCreateInput($TCPport, 30, 220, 300, 20)

		 GUICtrlCreateLabel("Client TCP port:", 30, 250, 300, 20)
		 $C_TCP_input=GUICtrlCreateInput($TCPport+1, 30, 270, 300, 20)
		 GUICtrlSetState($C_TCP_input, $GUI_DISABLE)

		 $Button_5 = GUICtrlCreateButton("Finish!", 130, 320, 150, 40)
		 GUISetState ()


	  GUICtrlSetState($maintab, $GUI_SHOW) ; will be display the current tab


   Case $msg == $S_input
   ; Changing Server IP

	  IF GUICtrlRead ($S_input)<>"" Then
		 $INI_IP=GUICtrlRead ($S_input)
		 history ("Server IP changed � " & $INI_IP)
	  EndIf

   Case $msg == $S_TCP_input
   ; Changing Server port

	  IF GUICtrlRead ($S_TCP_input)<>"" Then
		 $INI_TCP=GUICtrlRead ($S_TCP_input)
		 history ("Server port changed � " & $INI_TCP)
	  EndIf


   ;
   ;
   ;
   ; Install Server (Step 1)
   ;
   ;
   ;

   Case $msg == $Button_2

   ; Install Server (Step 1)
   history ("Choosed option *Install Server* " & $Button_2)

	  $InstallServerGui=GuiCreate("Install WSTC Server", $ServerFormWidth, $ServerFormHigh)
	  GUISetHelp(@ComSpec & ' /C start ' & @TempDir & "\" & $helpfile) ; Display Help file
	  Opt("GUICoordMode", 1)

		 While $t <= UBound($ipdetails, 2)-1

			if $ipdetails[0][$t]<>"" Then
			   $adapters+=1
			   If $ipdetails[5][$t]==1 Then

				  $PhysicAdapters +=1
				  $MainAdapter=$ipdetails[0][$t]
				  $MainAdapter_ip=$ipdetails[1][$t]
				  $MainAdapter_MAC=$ipdetails[2][$t]
				  $MainAdapter_netmask=$ipdetails[3][$t]

			   EndIf

			   $adapterList=$adapterList & "|" & $ipdetails[0][$t]

			EndIf
			$t+=1

		 WEnd

		 If $t==0 Then
		 history ("Active network adapters not found! Run script again...")
		 Exit
		 EndIf

		 If $PhysicAdapters==0 Then
		 history ("Warning! Physical network adapters not found.")
		 Else
		 history ("Using main adapter � " & $MainAdapter)
		 EndIf

		 $INI_Broadcast=GetBroadcast($MainAdapter_ip, $MainAdapter_netmask)
		 $INI_IP=$MainAdapter_ip
		 $INI_TCP=$TCPport
		 $INI_UDP=$UDPport
		 $INI_MAC=$MainAdapter_MAC

		 GUISwitch($InstallServerGui)
		 GUISetState(@SW_HIDE, $mainGui)
		 GUISetState(@SW_SHOW, $InstallServerGui)

		 GUICtrlCreateLabel("Use this network adapter:", 10, 20, 300, 20)

		 $combo=GUICtrlCreateCombo("Adapters", 10, 40, 350, 20)
		 GUICtrlSetData(-1, $adapterList, $MainAdapter)

		 GUICtrlCreateLabel("Server IP address:", 10, 80, 300, 20)
		 $ip_input=GUICtrlCreateInput($INI_IP, 10, 100, 300, 20)

		 GUICtrlCreateLabel("Broadcast IP address:", 10, 140, 300, 20)
		 $broadcast_input=GUICtrlCreateInput($INI_Broadcast, 10, 160, 300, 20)

		 GUICtrlCreateLabel("Server TCP port:", 10, 200, 300, 20)
		 $TCP_input=GUICtrlCreateInput($TCPport, 10, 220, 300, 20)

		 GUICtrlCreateLabel("UDP port for sending MagicPackets:", 10, 260, 300, 20)
		 $UDP_input=GUICtrlCreateInput($UDPport, 10, 280, 300, 20)
		 GUICtrlSetState($UDP_input, $GUI_DISABLE)

		 $Button_9 = GUICtrlCreateButton("Let`s Go!", 130, 340, 150, 40)
		 GUISetState ()



   Case $msg == $ip_input
   ; Changing Server IP

	  $INI_IP=GUICtrlRead ($ip_input)
	   If _IsValidIP($INI_IP) == 1 Then
	  	 history ("IP check passed. New IP � " & $INI_IP)
		 Else
		 MsgBox(0,"", $INI_IP & " is INVALID IP")
		 history ("Entered wrong IP")
	   EndIf



   Case $msg == $TCP_input
   ; Changing TCP port

	  If GUICtrlRead ($TCP_input)<>"" Then
		 $INI_TCP=GUICtrlRead ($TCP_input)
		 history ("TCP port changed � " & $INI_TCP)
	  EndIf


   Case $msg == $combo
   ; Refreshing IP and Broadcast address after combo select
   ; Use in Client and Server setup

   history ("Selected network adapter � " & GUICtrlRead ($combo))
   $t=0

   While $t <= UBound($ipdetails, 2)-1

	  If GUICtrlRead ($combo)==$ipdetails[0][$t] Then

		 $MainAdapter_ip=$ipdetails[1][$t]
		 $MainAdapter_netmask=$ipdetails[3][$t]
		 $MainAdapter_MAC=$ipdetails[2][$t]
		 $INI_MAC=$MainAdapter_MAC
		 $INI_IP=$MainAdapter_ip
		 $INI_Broadcast=GetBroadcast($MainAdapter_ip, $MainAdapter_netmask)
		 GUICtrlSetData($ip_input, $INI_IP)
		 GUICtrlSetData($broadcast_input, $INI_Broadcast)
		 $Adapter_GUID=$ipdetails[6][$t]
		 PnPCapabilites ($Adapter_GUID)
		 history ("Network settings refreshed. New � " & $INI_IP & " | " & $INI_Broadcast)

	  EndIf
	  $t +=1
   WEnd


	Case $msg == $Button_6
	; Go to next step

	  GUICtrlSetState($maintab, $GUI_HIDE)
	  GUICtrlSetState($Button_6,$GUI_DISABLE)
	  GUICtrlSetState($secondtab, $GUI_SHOW)


   Case $msg == $Button_9
   ; Install Server (Step 2)

   history ("Choosed option *Ready to start install server* " & $Button_9)

	  ; Reload all files in directory

	If FileExists($inifile)==1 Then FileDelete($inifile) ; Check if file exists
	If FileExists($resultini)==1 Then FileDelete($resultini) ; Check if file exists

	If FileExists(@StartupCommonDir & "\WakeClient.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeClient.lnk")
	If FileExists(@StartupCommonDir & "\WakeDaemon.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")

	history ("Deleted old files " & $inifile & ", " & $resultini)

	  ; Write vars to ini files
	  IniWrite($inifile, "Network", "TCPport", $INI_TCP)
	  IniWrite($inifile, "Network", "UDPport", $INI_UDP)
	  IniWrite($inifile, "Network", "IP", $INI_IP)
	  IniWrite($inifile, "Network", "Broadcast", $INI_Broadcast)
	  IniWrite($inifile, "All", "Log", $log)
	  IniWrite($inifile, "All", "LineDebug", $linedebug)
	  IniWrite($inifile, "All", "Console", 1) ; Default server option
	  IniWrite($inifile, "Time", "WakeUpPause", $WakeUpPause )
	  IniWrite($inifile, "Time", "ServerPause", $ServerPause )
	  IniWrite($inifile, "Time", "ClientPause", $ClientPause )


		GUISetState(@SW_HIDE, $InstallServerGui)
		$destr=GUIDelete($mainGui)
		history ("Main GUI destroyed � " & $destr)
		PauseTime($pausetime)

		history ("Starting process � " & $ScriptFolder & "\" & $WakePrepare & " Server")

		Run($ScriptFolder & "\" & $WakePrepare & " Server", $ScriptFolder)
		ExitLoop



   Case $msg == $Button_5
   ; Install Client last step

   history ("Choosed option *Ready to finish client setup* " & $Button_5)

	  $INI_TestRepeat=GUICtrlRead($TestRepeat)

	  If BitAnd(GUICtrlRead($cpu_activity),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_cpu_activity=1
	  $INI_cpu_time=GUICtrlRead($cpu_time)
	  ElseIf BitAnd(GUICtrlRead($cpu_activity),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
	  $INI_cpu_activity=0
	  EndIf

	  If BitAnd(GUICtrlRead($hdd_activity),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_hdd_activity=1
      ElseIf BitAnd(GUICtrlRead($hdd_activity),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
      $INI_hdd_activity=0
	  EndIf

	  If BitAnd(GUICtrlRead($excel_enabled),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_excel=1
	  ElseIf BitAnd(GUICtrlRead($excel_enabled),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
	  $INI_excel=0
	  ElseIf BitAnd(GUICtrlRead($excel_enabled),$GUI_DISABLE) = $GUI_DISABLE THEN;
	  $INI_excel=0
	  EndIf


	  If BitAnd(GUICtrlRead($timer_sleep),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_sleep=1
      ElseIf BitAnd(GUICtrlRead($timer_sleep),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
      $INI_sleep=0
	  EndIf

	  If BitAnd(GUICtrlRead($timer_halt),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_halt=1
      ElseIf BitAnd(GUICtrlRead($timer_halt),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
      $INI_halt=0
	  EndIf

	  If BitAnd(GUICtrlRead($timer_hiber),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $INI_hiber=1
      ElseIf BitAnd(GUICtrlRead($timer_hiber),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
      $INI_hiber=0
	  EndIf

		If FileExists($inifile)==1 Then FileDelete($inifile) ; Check if file exists
		If FileExists($resultini)==1 Then FileDelete($resultini) ; Check if file exists
		If FileExists(@StartupCommonDir & "\WakeClient.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeClient.lnk")
		If FileExists(@StartupCommonDir & "\WakeDaemon.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")

		IniWrite($inifile, "Network", "TCPport", $INI_TCP)
		IniWrite($inifile, "Network", "IP", $INI_IP)
		IniWrite($inifile, "Network", "Client_IP", $INI_CIP)
		IniWrite($inifile, "Network", "MAC", $INI_MAC)
		IniWrite($inifile, "All", "Log", $log)
		IniWrite($inifile, "All", "LineDebug", $linedebug)
		IniWrite($inifile, "All", "Console", 0) ; Default client option
		IniWrite($inifile, "Time", "WakeUpPause", $WakeUpPause )
		IniWrite($inifile, "Time", "ServerPause", $ServerPause )
		IniWrite($inifile, "Time", "ClientPause", $ClientPause )
		IniWrite($resultini, "Client", "TestRepeat",  $INI_TestRepeat)
		IniWrite($resultini, "Client", "Cpu_activity",  $INI_cpu_activity)
		IniWrite($resultini, "Client", "CPU_load",  $INI_cpu_time)
		IniWrite($resultini, "Client", "Hdd_activity",  $INI_hdd_activity)
		IniWrite($resultini, "Client", "Sleep",  $INI_sleep)
		IniWrite($resultini, "Client", "Halt",  $INI_halt)
		IniWrite($resultini, "Client", "Hibernate",  $INI_hiber)
		IniWrite($resultini, "Client", "Excel",  $INI_excel)

		GUISetState(@SW_HIDE, $InstallClientGui)
		$destr=GUIDelete($mainGui)
		history ("Main GUI destroyed � " & $destr)
		PauseTime($pausetime)
		history ("Starting process � " & $ScriptFolder & "\" & $WakePrepare & " Client")

		Run($ScriptFolder & "\" & $WakePrepare & " Client", $ScriptFolder)

		ExitLoop


	Case $msg == $Button_3
	; Uninstall
	history ("Choosed option *Uninstall Client* " & $Button_1)
	Run($ScriptFolder & "\" & $WakeUninstall, $ScriptFolder)
	$destr=GUIDelete($mainGui)
	ExitLoop


	Case $msg == $GUI_EVENT_CLOSE
	; Exit installer

	  $destr=GUIDelete($mainGui)
	  history ("Main GUI destroyed � " & $destr)
	  history ("Start canceled")
	  ExitLoop

	EndSelect


WEnd

#include "Libs\foot.au3"

