#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Main installer. Includes all nessasary files

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $pausetime=5

Local $FirstFormWidth=400
Local $FirstFormHigh=300
Local $ClientFormWidth=400
Local $ClientFormHigh=400
Local $ServerFormWidth=400
Local $ServerFormHigh=400


Local $Button_4
Local $Button_5
Local $Button_6
Local $FilesArray[1]
Local $combo
Local $t=0
Local $adapters=0
Local $PhysicAdapters=0
Local $adapterList
Local $MainAdapter_ip
Local $MainAdapter
Local $MainAdapter_netmask
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

history ("Starting install...")
If FileExists($inifile)==1 Then 
history ("Skip settings of existing ini file")
EndIf

If DirGetSize($ScriptFolder) <> -1 Then
DirRemove($ScriptFolder, 1)
history ("Old directory removed")
EndIf



; Help file install
If FileInstall("help.txt", @TempDir & "\" & $helpfile, 1)<>0 Then
history ("File " & $helpfile & " is copied successfully to " & @TempDir & "\" & $helpfile)
Else
history ("File " & $helpfile & " is not copied to" & @TempDir & "\" & $helpfile)   
EndIf

Local $ipdetails=_IPDetail()

; Creating install GUI
$mainGui=GuiCreate("Install WakeScript", $FirstFormWidth, $FirstFormHigh)
GUISetHelp(@ComSpec & ' /C start ' & @TempDir & "\" & $helpfile) ; Display Help file
Opt("GUICoordMode", 1)

GuiCtrlCreateLabel("Press F1 for help", 240, 0, 150, 15, $SS_RIGHT)

$Button_1 = GUICtrlCreateButton("Install Client", 130, 60, 150, 40)
$Button_2 = GUICtrlCreateButton("Install Server", 130, 130, 150, 40)
$Button_3 = GUICtrlCreateButton("Install BootTime", 130, 200, 150, 40)
;GUICtrlSetState ($Button_3, $GUI_DISABLE )

GUISwitch($mainGui)
GUISetState ()


While 1
   
   $msg = GUIGetMsg()
	
   Select
   
   
   ;
   ;
   ; Install Client
   ;
   ;
   Case $msg == $Button_1
   history ("Choosed option *Install Client* " & $Button_1)
	  
	  $InstallClientGui=GuiCreate("Install WakeScript client", $ClientFormWidth, $ClientFormHigh)
	  
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
	  $timer_halt=GUICtrlCreateCheckbox("Halt (not tested)", 40, 120, 120, 20)
	  GuiCtrlCreateLabel("PC load algorithm ", 40, 160, 150, 20)
	  GUICtrlSetFont (-1, 8.5, 800, 0, "Tahoma")
	  $cpu_activity=GUICtrlCreateCheckbox("Analyze HDD ", 40, 180, 120, 20)
	  $hdd_activity=GUICtrlCreateCheckbox("Analyze CPU ", 40, 200, 120, 20)
	  GuiCtrlCreateLabel("Max CPU Load, %  ", 160, 204, 120, 20, $SS_RIGHT)
	  $cpu_time = GUICtrlCreateInput ($cpu_percent_need, 320, 200, 40, 20, $SS_RIGHT)
	  GUICtrlCreateUpdown($cpu_time)
	  GUICtrlSetLimit ($cpu_time, 2 , 1)
	  GuiCtrlCreateLabel(" оличество прогонов теста:", 40, 234, 250, 20)
	  $TestRepeat = GUICtrlCreateInput ($testrepeats, 320, 230, 40, 20, $SS_RIGHT)
	  GUICtrlCreateUpdown($TestRepeat)
	  GUICtrlSetLimit ($TestRepeat, 2 , 1)
	  GuiCtrlCreateLabel("Results ", 40, 260, 150, 20)
	  GUICtrlSetFont (-1, 8.5, 800, 0, "Tahoma")
	  $excel_enabled=GUICtrlCreateCheckbox("Export to Excel ", 40, 280, 170, 20)
	  
	  GUICtrlSetState ($cpu_activity, $GUI_CHECKED )
	  GUICtrlSetState ($hdd_activity, $GUI_CHECKED )
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
				  $MainAdapter_netmask=$ipdetails[3][$t]
				  $Adapter_GUID=$ipdetails[6][$t]
				  PnPCapabilites ($Adapter_GUID)
				  
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
		 history ("Using main adapter Ч " & $MainAdapter)
		 EndIf
		 
		 $INI_IP=$ServerIP
		 $INI_CIP=$MainAdapter_ip
		 $INI_TCP=$TCPport
		 
		
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
		 history ("Server IP changed Ч " & $INI_IP)
	  EndIf
   
   Case $msg == $S_TCP_input
   ; Changing Server port 
	
	  IF GUICtrlRead ($S_TCP_input)<>"" Then 
		 $INI_TCP=GUICtrlRead ($S_TCP_input)
		 history ("Server port changed Ч " & $INI_TCP)
	  EndIf
   
   
   ;
   ;
   ;
   ; Install Server
   ;
   ;
   ;
   
   Case $msg == $Button_2
   ; Install Server first step
   history ("Choosed option *Install Server* " & $Button_2)
   
	  $InstallServerGui=GuiCreate("Install WakeScript server", $ServerFormWidth, $ServerFormHigh)
	  GUISetHelp(@ComSpec & ' /C start ' & @TempDir & "\" & $helpfile) ; Display Help file
	  Opt("GUICoordMode", 1)
		 
		 While $t <= UBound($ipdetails, 2)-1
			
			if $ipdetails[0][$t]<>"" Then
			   $adapters+=1
			   If $ipdetails[5][$t]==1 Then
				  
				  $PhysicAdapters +=1
				  $MainAdapter=$ipdetails[0][$t]
				  $MainAdapter_ip=$ipdetails[1][$t]
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
		 history ("Using main adapter Ч " & $MainAdapter)
		 EndIf
		 
		 $INI_Broadcast=GetBroadcast($MainAdapter_ip, $MainAdapter_netmask)
		 $INI_IP=$MainAdapter_ip
		 $INI_TCP=$TCPport
		 $INI_UDP=$UDPport
		 
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
		 
		 $Button_4 = GUICtrlCreateButton("Let`s Go!", 130, 340, 150, 40)
		 GUISetState ()


   
   Case $msg == $ip_input
   ; Changing Server IP
	 
	  $INI_IP=GUICtrlRead ($ip_input)
	   If _IsValidIP($INI_IP) == 1 Then
	  	 history ("IP check passed. New IP Ч " & $INI_IP)
		 Else
		 MsgBox(0,"", $INI_IP & " is INVALID IP")
		 history ("Entered wrong IP")
	   EndIf
	    
	  
   
   Case $msg == $TCP_input
   ; Changing TCP port 
	  
	  If GUICtrlRead ($TCP_input)<>"" Then
		 $INI_TCP=GUICtrlRead ($TCP_input)
		 history ("TCP port changed Ч " & $INI_TCP)
	  EndIf
	  
   
   Case $msg == $combo
   ; Refreshing IP and Broadcast address after combo select
   
   history ("Selected network adapter Ч " & GUICtrlRead ($combo))
   $t=0
  
   While $t <= UBound($ipdetails, 2)-1
	  
	  If GUICtrlRead ($combo)==$ipdetails[0][$t] Then
		 
		 $MainAdapter_ip=$ipdetails[1][$t]
		 $MainAdapter_netmask=$ipdetails[3][$t]
		 $INI_IP=$MainAdapter_ip
		 $INI_Broadcast=GetBroadcast($MainAdapter_ip, $MainAdapter_netmask)
		 GUICtrlSetData($ip_input, $INI_IP) 
		 GUICtrlSetData($broadcast_input, $INI_Broadcast) 
		 $Adapter_GUID=$ipdetails[6][$t]
		 PnPCapabilites ($Adapter_GUID)
		 history ("Network settings refreshed. New Ч " & $INI_IP & " | " & $INI_Broadcast)
		 
	  EndIf
	  $t +=1
   WEnd
	
   
   
   Case $msg == $Button_4
   ; Install Server last step
   
   history ("Choosed option *Ready to start install server* " & $Button_4)
	  
	  
	  If FileExists($ScriptFolder & "\" & $WakeServer)==1 Then FileDelete($ScriptFolder & "\" & $WakeServer) ; Check if file exists
	  If FileExists($ScriptFolder & "\" & $WakePrepare)==1 Then FileDelete($ScriptFolder & "\" & $WakePrepare) ; Check if file exists
	  If FileExists($inifile)==1 Then FileDelete($inifile) ; Check if file exists
	  If FileExists($resultini)==1 Then FileDelete($resultini) ; Check if file exists
		 
	  history ("Deleted old files " & $WakeServer & ", " & $WakePrepare & ", " & $inifile & ", " & $resultini)
	  
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
	  

	  If FileInstall("WakeServer.exe", $ScriptFolder & "\" & $WakeServer)<>0 Then
		 
		 history ("File " & $WakeServer & " is copied successfully to " & $ScriptFolder & "\" & $WakeServer)
		 
		 If FileInstall("WakePrepare.exe", $ScriptFolder & "\" & $WakePrepare)<>0 Then
			
			history ("File " & $WakePrepare & " is copied successfully to " & $ScriptFolder & "\" & $WakePrepare)
			GUISetState(@SW_HIDE, $InstallServerGui)
			$destr=GUIDelete($mainGui)
			history ("Main GUI destroyed Ч " & $destr)
			PauseTime($pausetime)
			history ("Starting process Ч " & $ScriptFolder & "\" & $WakePrepare)
			FileDelete(@TempDir & "\" & $helpfile)
			Run($ScriptFolder & "\" & $WakePrepare & " Server", $ScriptFolder)
			ExitLoop
			
		 Else
			
			history ("File " & $WakePrepare & " is not copied to " & $ScriptFolder & "\" & $WakePrepare)
			ExitLoop
			
		 EndIf
	  	 		
	  Else
				
		 ExitLoop
		 history ("File " & $WakeServer & " is not copied to " & $ScriptFolder & "\" & $WakeServer)   
		 
	  EndIf
   
   
   
   ;
   ;
   ; Install BootTime
   ;
   ;
   Case $msg == $Button_3
   ; Install BootTime
   history ("Choosed option *Install BootTime* " & $Button_2)
	  
	  If FileExists(@TempDir & "\" & $WakeBT)==1 Then FileDelete(@TempDir & "\" & $WakeBT) ; Check if file exists
	  If FileInstall("BT.exe", @TempDir & "\" & $WakeBT)<>0 Then
		 history ("File " & $WakeBT & " is copied successfully to " & @TempDir & "\" & $WakeBT)
		 GUISetState(@SW_HIDE, $mainGui)
		 $destr=GUIDelete($mainGui)
		 history ("Main GUI destroyed Ч " & $destr)
		 PauseTime($pausetime)
		 history ("Starting process Ч " & @TempDir & "\" & $WakeBT)
		 FileDelete(@TempDir & "\" & $helpfile)
		 Run(@TempDir & "\" & $WakeBT, @TempDir)
		 ExitLoop
	  Else
		 history ("File " & $WakeBT & " is not copied to " & @TempDir & "\" & $WakeBT)   
	  EndIf
   
   
   Case $msg == $GUI_EVENT_CLOSE
   ; Exit installer
   
	  $destr=GUIDelete($mainGui)
	  history ("Main GUI destroyed Ч " & $destr)
	  ; Clean temp files
	  FileDelete(@TempDir & "\" & $helpfile)
	  history ("Installation canceled")
	  ExitLoop
   Case $msg == $Button_6
   ; Go to next step
   
	  GUICtrlSetState($maintab, $GUI_HIDE)
	  GUICtrlSetState($Button_6,$GUI_DISABLE) 
	  GUICtrlSetState($secondtab, $GUI_SHOW)
	  
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
	  
	  If FileExists($ScriptFolder & "\" & $WakeClient)==1 Then FileDelete($ScriptFolder & "\" & $WakeClient) ; Check if file exists
	  If FileExists($ScriptFolder & "\" & $WakePrepare)==1 Then FileDelete($ScriptFolder & "\" & $WakePrepare) ; Check if file exists
	  If FileExists($inifile)==1 Then FileDelete($inifile) ; Check if file exists
	  If FileExists($resultini)==1 Then FileDelete($resultini) ; Check if file exists
		 
	  IniWrite($inifile, "Network", "TCPport", $INI_TCP)
	  IniWrite($inifile, "Network", "IP", $INI_IP)
	  IniWrite($inifile, "Network", "Client_IP", $INI_CIP)
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
	  
	  
	  If FileInstall("WakeClient.exe", $ScriptFolder & "\" & $WakeClient)<>0 Then
		 
		 history ("File " & $WakeClient & " is copied successfully to " & $ScriptFolder & "\" & $WakeClient)
		 
		 If FileInstall("WakePrepare.exe", $ScriptFolder & "\" & $WakePrepare)<>0 Then
			
			history ("File " & $WakePrepare & " is copied successfully to " & $ScriptFolder & "\" & $WakePrepare)
			
			If FileInstall("WakeDaemon.exe", $ScriptFolder & "\" & $WakeDaemon)<>0 Then
			
			history ("File " & $WakeDaemon & " is copied successfully to " & $ScriptFolder & "\" & $WakeDaemon)
		
			   GUISetState(@SW_HIDE, $InstallClientGui)
			   $destr=GUIDelete($mainGui)
			   history ("Main GUI destroyed Ч " & $destr)
			   PauseTime($pausetime)
			   history ("Starting process Ч " & $ScriptFolder & "\" & $WakePrepare)
			   FileDelete(@TempDir & "\" & $helpfile)
			   Run($ScriptFolder & "\" & $WakePrepare & " Client", $ScriptFolder)
			   ExitLoop
			   
			Else
			
			history ("File " & $WakeDaemon & " is not copied to " & $ScriptFolder & "\" & $WakeDaemon)
			ExitLoop
			
			EndIf
			
		 Else
			
			history ("File " & $WakePrepare & " is not copied to " & $ScriptFolder & "\" & $WakePrepare)
			ExitLoop
			
		 EndIf
	  	 		
	  Else
				
		 ExitLoop
		 history ("File " & $WakeServer & " is not copied to " & $ScriptFolder & "\" & $WakeServer)   
		 
	  EndIf
   
   
   
   EndSelect
   
   
WEnd

#include "Libs\foot.au3"
 
 