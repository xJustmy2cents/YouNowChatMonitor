param (
[string]$YNUSER = "younow_voyeur",
[string]$PROFILE = "newtalk",
[switch]$READALL = $FALSE,
[switch]$NOTALK = $FALSE,
[switch]$WRITELOG = $FALSE,
[switch]$SAYALL = $FALSE,
[switch]$DEBUG = $FALSE,
[switch]$WAIT4STREAM = $FALSE,
[switch]$OBSON = $FALSE
)
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

if ($YNUSER -ne "") {

	$PRIVATE:MYERRORCODE=0
	$PRIVATE:RUNLOOPINIT=0
	$PRIVATE:MYCONTENT=""
	$PRIVATE:BROADCASTID=""
	$PRIVATE:USERID=""
	$PRIVATE:SPEAK=""
	$PRIVATE:CURRENTFILE=""
	$PRIVATE:DEBUGFILE=""
	$PRIVATE:CURRENTCHAT20=""
	$PRIVATE:CURRENTCHATB64=""
	$PRIVATE:CURRENTCHAT20B64 = @()
	$PRIVATE:LASTCHAT20B64 = @()
	$PRIVATE:LASTCHAT20=""
	$PRIVATE:MYPATH=$PSScriptRoot
	$PRIVATE:MYLOGPATH="$MYPATH\..\"
	SET-LOCATION $MYPATH

	## initial function load
	$PRIVATE:LOADFUNCTIONS = @("encodeb64", "decodeb64", "builtlastchat")
	if ( -not $NOTALK ) {
		$LOADFUNCTIONS += "removeem"
		$LOADFUNCTIONS += "..\profiles\$PROFILE"
		$LOADFUNCTIONS += "speakthis"
		}
	if ( $OBSON ) { $LOADFUNCTIONS += "obswebsocket" } ##OBS Websocket needs to be loaded as last modul
	
	foreach ( $LOADFUNCTION in $LOADFUNCTIONS ) {
		write-host "loading $LOADFUNCTION"
		try {. .\functions\$LOADFUNCTION.ps1}
		catch {$MYERRORCODE = 999;$MYERRORFUNCTION=$LOADFUNCTION; break;}
		#start-sleep 0.6
		}


	while ($MYERRORCODE -eq 0) {
		$CURRENTCHAT20B64 = @()
		$MYCONTENT=$($(wget https://api.younow.com/php/api/broadcast/info/user=$YNUSER).content|ConvertFrom-Json)
		$MYERRORCODE=$($MYCONTENT|select -expand errorcode)
		if ( $MYERRORCODE -eq 0 ) {	
			## RUNLOOPINIT START
			if ( $RUNLOOPINIT -eq 0 ) {
				$BROADCASTID = $($MYCONTENT.broadcastID)
				$USERID=$($MYCONTENT.username)
				$CURRENTFILE="$MYLOGPATH\$USERID-$BROADCASTID.log"
				if ( $DEBUG ) {$DEBUGFILE="$MYLOGPATH\$USERID-$BROADCASTID.dbg"}
				if ( -not (test-path $CURRENTFILE)) {
					new-item $CURRENTFILE -ItemType file
					} 
				}
			## RUNLOOPINIT END
			
			##Einlesen des aktuellen Chats
			$CURRENTCHAT20=$($MYCONTENT|select -expand comments|select name, comment)
			
			## Kodieren des aktuellen Chat (BASE64)
			foreach ($CURRENTCHAT in $CURRENTCHAT20) {
				$CURRENTCHAT20B64 += "$(encodeb64($CURRENTCHAT.name + " " + $CURRENTCHAT.comment))"
				}
			
			## holen des letzen gespeicherten Chat im Logfile (Dynamischer Block)
			try {
				$LASTCHAT20=$(Get-Content -last ($CURRENTCHAT20B64.length) $CURRENTFILE)
				} catch {
				$LASTCHAT20=$(Get-Content $CURRENTFILE)
				}
			#write-host 'loopchat: before BUILTCHAT: $LASTCHAT20.lenght=' $LASTCHAT20.length
			## zerlegen des letzen Chat -> Zeitstempel abschneiden
			$LASTCHAT20B64 = BUILTLASTCHAT -MYINPUT $LASTCHAT20
			#write-host 'loopchat: after BUILTCHAT: $LASTCHAT20B64.lenght=' $LASTCHAT20B64.length
			
			## Ausgabe es letzten Chatblocks für Debugging
			if ( $DEBUG ) {
				$(get-date -format yyyMMddHHmmss)|out-file -append $DEBUGFILE
				"`$CURRENTCHAT20B64`:"|out-file -append $DEBUGFILE
				$CURRENTCHAT20B64|out-file -append $DEBUGFILE
				"`$LASTCHAT20B64`:"|out-file -append $DEBUGFILE
				$LASTCHAT20B64|out-file -append $DEBUGFILE
				'================================'|out-file -append $DEBUGFILE
				}
			$CURRENTCHAT20B64_MAXINDEX=$CURRENTCHAT20B64.length -1
			$LASTCHAT20B64_MAXINDEX=$LASTCHAT20B64.length -1
			## ausgabe der Anzahl der Chat Zeilen im Vergleich
			#write-host 'loopchat:$CURRENTCHAT20B64:' $CURRENTCHAT20B64
			#write-host 'loopchat:$LASTCHAT20B64:' $LASTCHAT20B64
			
			
			$CHATREFERENCE=$CURRENTCHAT20B64_MAXINDEX  ##lines to send to engine
			for ( $i=0; $i -le $LASTCHAT20B64_MAXINDEX; $i++ ) {
				if ( -not (compare-object $LASTCHAT20B64[$(0+$i)..$LASTCHAT20B64_MAXINDEX] $CURRENTCHAT20B64[0..$($CURRENTCHAT20B64_MAXINDEX - $i)]) ) {
					$CHATREFERENCE=$i-1
					break
				}
				if ( $DEBUG ) {
					"`$LASTCHAT20B64[$(0+$i)..$LASTCHAT20B64_MAXINDEX]`:"|out-file -append $DEBUGFILE
					$LASTCHAT20B64[$(0+$i)..$LASTCHAT20B64_MAXINDEX]|out-file -append $DEBUGFILE
					"`$CURRENTCHAT20B64[0..$($CURRENTCHAT20B64_MAXINDEX - $i)]`:"|out-file -append $DEBUGFILE
					$CURRENTCHAT20B64[0..$($CURRENTCHAT20B64_MAXINDEX - $i)]|out-file -append $DEBUGFILE
				}
			}
			#### Logik Problem abfangen
			#if ($CHATREFERENCE -gt $LASTCHAT20B64_MAXINDEX) {$CHATREFERENCE = -1}
			##
			if ($CHATREFERENCE -gt -1) {
				write-host 'loopchat:$CURRENTCHAT20B64.length:' $CURRENTCHAT20B64_MAXINDEX
				write-host 'loopchat:$LASTCHAT20B64.length:' $LASTCHAT20B64_MAXINDEX
				write-host 'loopchat:$CHATREFERENCE: ' $CHATREFERENCE;
				for ( $i=$CURRENTCHAT20B64_MAXINDEX - $CHATREFERENCE; $i -le $CURRENTCHAT20B64_MAXINDEX; $i++ ) {
					write-host '$CURRENTCHAT20B64['$i']: ' $CURRENTCHAT20B64[$i]
					if ( $LASTCHAT20B64 -contains "$CURRENTCHAT20B64[$i]" -or $CURRENTCHAT20B64[0..$($i-1)] -contains "$CURRENTCHAT20B64[$i]" ) {
						##do nothing
						} else {
						if ($READALL -or $RUNLOOPINIT -eq 1) {
							if ( -not $NOTALK ) {newtalk -TALKTHIS $CURRENTCHAT20B64[$i] -SAYIT $SAYALL -WRITELOG $WRITELOG}
							}
						}
					$(get-date -format yyyMMddHHmmss) + ";;" + $CURRENTCHAT20B64[$i] | out-file -append $CURRENTFILE
					}
			}
			
			
			
			
			
			


			$RUNLOOPINIT = 1
			start-sleep 0.6
			}
			switch ($MYERRORCODE) {
				"206"  {
					if ( $WAIT4STREAM ) {
						$MYERRORCODE = 0
						if ( !$NOTALK ) {speakthis $(encodeb64("User $YNUSER ist offline, warte auf Stream!"))}
						Write-host "User $YNUSER ist offline, warte auf Stream!"
						start-sleep 5
						}
					}
				}
		}
	
	switch ($MYERRORCODE) {
		"206" {
			$SPEAK = $(encodeb64("User $YNUSER is offline!"))
			if ( !$NOTALK ) {speakthis $SPEAK}
			Write-host "User $YNUSER is offline!"
			}
		"101" {
			$SPEAK = $(encodeb64("User $YNUSER nicht gefunden!"))
			if ( !$NOTALK ) {speakthis $SPEAK}
			Write-host "User $YNUSER nicht gefunden!"
			}
		"999" {
			$SPEAK = $(encodeb64("FEHLER: Laden der Funktionen nicht beendet!"))
			if ( !$NOTALK ) {speakthis $SPEAK}
			Write-host "Funktion $MYERRORFUNCTION konnte nicht geladen werden"
			
			}
		}
			
	} else {
	write-host "USAGE:"
	write-host ".\loopchat.ps1 -YNUSER [junau user name] [-WAIT4STREAM] [-NOTALK] [-WRITELOG] [-READALL] [-SAYALL]"
	}

if ( $OBSON ) {$obs.disconnect()}