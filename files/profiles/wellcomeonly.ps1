##hier wird die Analyse des Chat gestartet und ggfls. die TTS getriggert
function newtalk {
##variable index 003
param (
	[string]$TALKTHIS="",
	[switch]$SAYIT = $FALSE,
	[switch]$WRITELOG = $FALSE
	)

	$MYTMP_003 = @()
	if ( $TALKTHIS -ne "" ) {
		$MYTMP_003 = $(decodeb64($TALKTHIS)).split(" ")
		write-host $MYTMP_003
		$MYNAME = $MYTMP_003[0]
		$MYCOMMENT = $($MYTMP_003[1..$MYTMP_003.length] -join " ")
		}
	
	$MYERR_003 = 1
	$MYNAME=removeem($MYNAME)
	$MYCOMMENT=$(removeem($MYCOMMENT)).trim()
	write-host '$MYNAME:'$MYNAME
	write-host '$MYCOMMENT:'$MYCOMMENT
	if ($MYNAME -ne "" -and $MYCOMMENT -ne "") {
		$MYERR_003 = 0
		$MYTALK_003 = ""
		switch ($MYCOMMENT) {
			{$MYNAME.trim() -eq "Younow Voyeur"} {
				if ( ($MYCOMMENT -split "!")[1] -eq "Cortana" ) {
					obscontrol -THISCONTEXT $(($MYCOMMENT -split "!")[2] -split ":")[0] -THISCOMMAND $(($MYCOMMENT -split "!")[2] -split ":")[1]
					write-host "switch0.A"
					} else {
					$MYTALK_003 = "";write-host "switch0.B"; break;
					}
				break;
				}
			{$_ -like "*schaut gerade zu" -or $_ -like "*is watching"} {
				if ( $MYNAME.trim() -eq "InspectorPrada" ) {
					$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm Dir 'nen Keks. Ich hoffe der kleine Einspieler gefällt Dir."));
					obscontrol -THISCONTEXT "OBS" -THISCOMMAND "Frankreich";
					speakthis $MYTALK_003;
					obscontrol -THISCONTEXT "OBS" -THISCOMMAND "OnAir";
					write-host "switch1.A"
				} else {
					$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm Dir 'nen Keks."));
					write-host "switch1.B";
				}
				break;
				}
			{$_ -like "*ist Fan geworden!" -or $_ -like "I became a fan!"} {$MYTALK_003 = $(encodeb64("Danke für's Fan werden, " + $MYNAME + ".")); write-host "switch3"; break}
			{$_ -like "*zu diesem Broadcast eingeladen." -or $_ -like "*fans to this broadcast."} {$MYTALK_003 = $(encodeb64("Danke für's Einladen Deiner " + $($($MYCOMMENT -match '([0-9]{1,})') >$null;$matches[1]) + " Fans, " + $MYNAME));write-host "switch4"; break}
			default {
				$MYTALK_003 = "";write-host "switchdefault"; break; 
				}
			}
		if ( $MYTALK_003 -ne "" ) {
			speakthis $MYTALK_003
			}
		}
	#return $MYERR_003
	}