##
## see also: https://ianmorrish.wordpress.com/2017/05/20/automating-obs-from-powershell-script/
##
## $obs|get-member

#Add-Type -path ‘obs-websocket-dotnet.dll’
#$obs = new-object OBSWebsocketDotNet.OBSWebsocket
#$obs.Connect(“ws://127.0.0.1:4444”, “HalloWelt!”)
#$scenes = $obs.ListScenes()
#$scenes
#$obs.SetCurrentScene(“OnAir”)
#Loop through each scene
#$loop = $true; $i =1
#Do{
#$obs.SetCurrentScene($scenes[$i].Name)
#if($i -eq $scenes.Count){$i=1}
#   else{$i++}
#Start-Sleep 5
#}While($loop)
#Other commands
#$obs.ToggleStreaming()
#$obs.ToggleRecording()


##init of speech engine
##Variable Index: 010
try {
	get-variable RUNMODEINIT_010 -erroraction 'stop'
	}
catch {
	$RUNMODEINIT_010 = 0
	}

IF ($RUNMODEINIT_010 -ne 1) {
	write-host "Initializing OBS Interface"
	Add-Type -path ‘functions\obs-websocket-dotnet.dll’
	$obs = new-object OBSWebsocketDotNet.OBSWebsocket
	$obs.WSTimeout = 9000
	try {
		$obs.Connect(“ws://127.0.0.1:4444”, “HalloWelt!”)
		}
		catch {
		write-host "loaded"
		}
	$THISSYSTEM_010 = @(
				'UHRZEIT:"Es ist jetzt " + $(get-date -format "%H")+" uhr "+ $(get-date -format "%m")';
				'DUMMY:"Nichts zu tun"';
				'Milch:"Milch ist ausreichend vorhanden. Bitte sehr."'
				)
	$RUNMODEINIT_010 = 1
	}
	
function OBSCONTROL {
	param (
		[string]$THISCONTEXT="speak",
		[string]$THISCOMMAND="Ich habe nicht verstanden."
		)
	write-host "obscontrol triggered"
	write-host '$THISCONTEXT:'$THISCONTEXT
	write-host '$THISCOMMAND:'$THISCOMMAND
	switch($THISCONTEXT) {
		{$_ -eq "OBS"} {$obs.setcurrentscene($THISCOMMAND);write-host "obsSwitch.0.0";break;}
		{$_ -eq "SPEAK"} {speakthis $(encodeb64($THISCOMMAND));write-host "obsSwitch.1.0";break;}
		{$_ -eq "SYSTEM"} {
			foreach ( $THISCOMMAND_010 in $THISSYSTEM_010) {
				write-host '$THISCOMMAND_010:'$THISCOMMAND
				write-host '$THISCOMMAND_010[0]:'$($THISCOMMAND_010.split(":"))[0]
				write-host '$THISCOMMAND_010[1]:'$($THISCOMMAND_010.split(":"))[1]
				if ( $THISCOMMAND -eq $($THISCOMMAND_010.split(":"))[0] ) {
					speakthis $(encodeb64($(invoke-expression $($THISCOMMAND_010.split(":"))[1])))
					}
				}
			write-host "obsSwitch.2.0";
			break;
			}
		default {speakthis $(encodeb64("Ich habe nicht verstanden."));write-host "obsSwitch.default"; break;}
		}
	}