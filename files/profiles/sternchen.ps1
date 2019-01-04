##hier wird die Analyse des Chat gestartet und ggfls. die TTS getriggert
function newtalk {
##variable index 003
param (
	[string]$TALKTHIS="",
	[switch]$SAYIT = $FALSE,
	[switch]$WRITELOG = $FALSE
	)
	$MYNAME=removeem($MYNAME)
	$MYCOMMENT=removeem($MYCOMMENT)
	$MYTMP_003 = @()
	if ( $TALKTHIS -ne "" ) {
		$MYTMP_003 = $(decodeb64($TALKTHIS)).split(" ")
		write-host $MYTMP_003
		$MYNAME = $MYTMP_003[0]
		$MYCOMMENT = $($MYTMP_003[1..$MYTMP_003.length] -join " ")
		}
	
	$MYERR_003 = 1
	$MYNAME=removeem($MYNAME)
	$MYCOMMENT=removeem($MYCOMMENT)
	write-host '$MYNAME:' $MYNAME
	write-host '$MYCOMMENT:' $MYCOMMENT
	if ($MYNAME -ne "" -and $MYCOMMENT -ne "") {
		$MYERR_003 = 0
		$MYTALK_003 = ""
		switch ($MYCOMMENT) {
			{$MYNAME -eq "younow_voyeur"} {$MYTALK_003 = "";write-host "switch0"; break;}
			{$MYNAME -eq "sternchen-24" -and ($_ -like "*schaut gerade zu" -or $_ -like "*is watching")} {$MYTALK_003 = $(encodeb64("Hallo Sabrina. Hier werden Coins für Deine Streams gesammelt. Also nicht lange hier abhängen. Geh online unter häshtäg Weihnachten.")); write-host "switch1"; break}
			{$_ -like "*schaut gerade zu" -or $_ -like "*is watching"} {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Hier werden Coins für Sternchens Weihnachtschallenge gesammelt. Also fleißig in den Chat schreiben und bei sternchen 24 leiks rausschicken.")); write-host "switch2"; break}
			{$_ -like "*ist Fan geworden!" -or $_ -like "I became a fan!"} {$MYTALK_003 = $(encodeb64("Danke für's Fan werden, " + $MYNAME + ".")); write-host "switch3"; break}
			{$_ -like "*zu diesem Broadcast eingeladen." -or $_ -like "*fans to this broadcast."} {$MYTALK_003 = $(encodeb64("Danke für's Einladen Deiner " + $($($MYCOMMENT -match '([0-9]{1,})') >$null;$matches[1]) + " Fans, " + $MYNAME + ". Jetzt aber ab zu sternchen 24, leiks rausschicken."));write-host "switch4"; break}
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