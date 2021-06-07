##hier wird die Analyse des Chat gestartet und ggfls. die TTS getriggert
function newtalk {
##variable index 003
param (
	[string]$TALKTHIS="",
	[switch]$SAYIT = $FALSE,
	[switch]$WRITELOG = $FALSE
	)
	$MYTMP_003 = @()
	$MYSOUND = ""
	if ( $TALKTHIS -ne "" ) {
		$MYTMP_003 = $(decodeb64($TALKTHIS)).split(" ")
		# write-host $MYTMP_003
		$MYNAME = $MYTMP_003[0]
		$MYCOMMENT = $($MYTMP_003[1..$MYTMP_003.length] -join " ")
		}
	# write-host 'newtalk:$TALKTHIS:' $TALKTHIS
	# write-host 'newtalk:$MYNAME:' $MYNAME
	# write-host 'newtalk:$MYCOMMENT:"'$MYCOMMENT'"'
	$MYERR_003 = 1
	$MYNAME=removeem -MYINPUT $MYNAME -RMSPACE $TRUE
	$MYCOMMENT=removeem -MYINPUT $MYCOMMENT 
	if ($MYNAME -ne "" -and $MYCOMMENT -ne "") {
		$MYERR_003 = 0
		$MYTALK_003 = ""
		#write-host "before switch"
		switch ($MYCOMMENT) {
			{$MYNAME.trim() -eq "younow voyeur"} {
				$MYTALK_003 = "";
				break;
				}
			{ $_ -like "*schaut gerade zu" -or $_ -like "*is watching" } {
				$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm dir nen Keks."));
				$MYSOUND = "welcome" + $($(get-random)%3+1);  ##integer random modulo 3 + 1
				switch ($MYNAME.trim()){
					{ $_ -eq "SinglePringle1991"} {$MYSOUND += ",SinglePringle1991"; break;}
					{ $_ -eq "Shadow 21"} {$MYSOUND += ",Shadow21"; break;}
				}
				break;
			}
			{$_.contains("ist Fan geworden!") -or $_.contains("I became a fan!")} {$MYTALK_003 = $(encodeb64("Danke für's Fan werden, " + $MYNAME)); $MYSOUND = "tada"; break;}
			"Hallo" {$MYTALK_003 = $(encodeb64("Hallo " + $MYNAME + ".")); break;}
			{$_.contains("Fans zu diesem Broadcast eingeladen") -or $_.contains("fans to this broadcast")} {$MYTALK_003 = $(encodeb64("Danke für's Einladen Deiner " + $($($MYCOMMENT -match '([0-9]{1,})') >$null;$matches[1]) + " Fans, " + $MYNAME)); $MYSOUND = "tada"; break;}
			default {
				if (-not $SAYIT) {$MYTALK_003 = ""} else {$MYTALK_003 = $(encodeb64("$MYNAME sagt $MYCOMMENT"))}
				}
			}
		#write-host "after switch"
		if ( $MYTALK_003 -ne "" ) {
			speakthis $MYTALK_003 $MYSOUND
			}
		if ( $WRITELOG ) {
			write-host $MYNAME": "$MYCOMMENT
			}
		}
	#return $MYERR_003
	}