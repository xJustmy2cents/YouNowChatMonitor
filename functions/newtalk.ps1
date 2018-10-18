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
			{$_ -like "*schaut gerade zu" -or $_ -like "*is watching"} {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm dir nen Keks."))}
			{$_ -like "*ist Fan geworden!" -or $_ -like "I became a fan!"} {$MYTALK_003 = $(encodeb64("Danke für's Fan werden, " + $MYNAME))}
			"Hallo" {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + "."))}
			{$_ -like "*zu diesem Broadcast eingeladen." -or $_ -like "*fans to this broadcast."} {$MYTALK_003 = $(encodeb64("Danke für's Einladen Deiner " + $($($MYCOMMENT -match '([0-9]{1,})') >$null;$matches[1]) + " Fans, " + $MYNAME))}
			default {
				if (-not $SAYIT) {$MYTALK_003 = $(encodeb64("$MYNAME sagt $MYCOMMENT"))} else {$MYTALK_003 = ""}
				}
			}
		if ( $MYTALK_003 -ne "" ) {
			speakthis $MYTALK_003
			}
		}
	#return $MYERR_003
	}