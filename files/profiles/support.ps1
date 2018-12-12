##hier wird die Analyse des Chat gestartet und ggfls. die TTS getriggert
function newtalk {
##variable index 003
param (
	[string]$MYNAME="",
	[string]$MYCOMMENT="",
	[switch]$SAYIT = $FALSE
	)
	#write-host '$MYNAME:' $MYNAME
	#write-host '$MYCOMMENT:' $MYCOMMENT
	$MYERR_003 = 1
	if ($MYNAME -ne "" -and $MYCOMMENT -ne "") {
		$MYERR_003 = 0
		$MYTALK_003 = ""
		switch ($MYCOMMENT) {
			{$MYNAME -eq "marus20" -or $MYNAME -eq "silentsands"} {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Hier wird keine Pause eingelegt. Los, ab in Deinen Stream, Fans zum Spenden animieren!"))}
			{$_ -like "*schaut gerade zu" -or $_ -like "*is watching"} {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Halte Dich nicht lange hier auf. Schaue bei silentsands oder marus20 vorbei. Dort kannst Du Dich an der Spendenaktion für die Deutsche Krebshilfe beteiligen."))}
			{$_ -like "*ist Fan geworden!" -or $_ -like "I became a fan!"} {$MYTALK_003 = $(encodeb64("Danke für's Fan werden, " + $MYNAME + ". Jetzt aber ab zu marus20 oder silentsands"))}
			"Hallo" {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + "."))}
			{$_ -like "*zu diesem Broadcast eingeladen." -or $_ -like "*fans to this broadcast."} {$MYTALK_003 = $(encodeb64("Danke für's Einladen Deiner " + $($($MYCOMMENT -match '([0-9]{1,})') >$null;$matches[1]) + " Fans, " + $MYNAME + ". Jetzt aber ab zu marus20 oder silentsands"))}
			default {
				if (-not $SAYIT) {$MYTALK_003 = ""} else {$MYTALK_003 = $(encodeb64("$MYNAME sagt $MYCOMMENT"))}
				}
			}
		if ( $MYTALK_003 -ne "" ) {
			speakthis $MYTALK_003
			}
		}
	#return $MYERR_003
	}