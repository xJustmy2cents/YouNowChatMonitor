param (
[string]$YNUSER = "",
[string]$PROFILE = "newtalk",
[switch]$READALL = $FALSE,
[switch]$NOTALK = $FALSE,
[switch]$WRITELOG = $FALSE,
[switch]$SAYALL = $FALSE,
[switch]$DEBUG = $FALSE,
[switch]$WAIT4STREAM = $FALSE
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
	foreach ( $LOADFUNCTION in $LOADFUNCTIONS ) {
		write-host "loading $LOADFUNCTION"
		try {. .\functions\$LOADFUNCTION.ps1}
		catch {$MYERRORCODE = 999}
		#start-sleep 0.6
		}


	while ($MYERRORCODE -eq 0) {
		$CURRENTCHAT20B64 = @()
		$MYCONTENT=$($(wget https://api.younow.com/php/api/broadcast/info/user=$YNUSER).content|ConvertFrom-Json)
		$MYERRORCODE=$($MYCONTENT|select -expand errorcode)
		if ( $MYERRORCODE -eq 0 ) {	
			if ( $RUNLOOPINIT -eq 0 ) {
				$BROADCASTID = $($MYCONTENT.broadcastID)
				$USERID=$($MYCONTENT.username)
				$CURRENTFILE="$MYLOGPATH\$USERID-$BROADCASTID.log"
				if ( $DEBUG ) {$DEBUGFILE="$MYLOGPATH\$USERID-$BROADCASTID.dbg"}
				if ( -not (test-path $CURRENTFILE)) {
					new-item $CURRENTFILE -ItemType file
					} 
				}
			$CURRENTCHAT20=$($MYCONTENT|select -expand comments|select name, comment)
			foreach ($CURRENTCHAT in $CURRENTCHAT20) {
				$CURRENTCHAT20B64 += "$(encodeb64($CURRENTCHAT.name + " " + $CURRENTCHAT.comment))"
				}
			try {
				$LASTCHAT20=$(Get-Content -last ($CURRENTCHAT20B64.length + 1) $CURRENTFILE)
				} catch {
				$LASTCHAT20=$(Get-Content -last 1 $CURRENTFILE)
				}
			$LASTCHAT20B64 = BUILTLASTCHAT -MYINPUT $LASTCHAT20
			if ( $DEBUG ) {
				$(get-date -format yyyMMddHHmmss)|out-file -append $DEBUGFILE
				"`$CURRENTCHAT20B64`:"|out-file -append $DEBUGFILE
				$CURRENTCHAT20B64|out-file -append $DEBUGFILE
				"`$LASTCHAT20B64`:"|out-file -append $DEBUGFILE
				$LASTCHAT20B64|out-file -append $DEBUGFILE
				'================================'|out-file -append $DEBUGFILE
				}
			write-host 'loopchat:$CURRENTCHAT20B64.length:' $CURRENTCHAT20B64.length
			write-host 'loopchat:$LASTCHAT20B64.length:' $LASTCHAT20B64.length
			#write-host 'loopchat:$CURRENTCHAT20B64:' $CURRENTCHAT20B64
			#write-host 'loopchat:$LASTCHAT20B64:' $LASTCHAT20B64
			if ( $CURRENTCHAT20B64 -ne $LASTCHAT20B64 ) {
				##We know s/t is different, so we need to find the start of the new item
				##we take the first item of last chat as reference,
				##and search in current chat
				##having this reference, we know, how many new items we received.
				##This is a workaround, because we get no index from the URL
				$CHATREFERENCE = -1
				foreach ($LASTCHAT in $LASTCHAT20B64) {
					$CHATREFERENCE = [array]::indexof($CURRENTCHAT20B64,$LASTCHAT)
					if ( $CHATREFERENCE -ne -1 ) {break}
					}
				if ( $CHATREFERENCE -eq -1 ) {$CHATREFERENCE = $CURRENTCHAT20B64.length}
				write-host 'loopchat:$CHATREFERENCE: ' $CHATREFERENCE;
				for ( $i=$CURRENTCHAT20B64.length - $CHATREFERENCE; $i -le $CURRENTCHAT20B64.length -1; $i++ ) {
					write-host '$CURRENTCHAT20B64['$i']: ' $CURRENTCHAT20B64[$i]
					if ( $LASTCHAT20B64 -like "*$CURRENTCHAT20B64[$i]" ) {
						##do nothing
						} else {
						if ($READALL -or $RUNLOOPINIT -eq 1) {
							if ( -not $NOTALK ) {newtalk -TALKTHIS $CURRENTCHAT20B64[$i] -SAYIT $SAYALL -WRITELOG $WRITELOG}
							}
						}
					"$(get-date -format yyyMMddHHmmss);;$CURRENTCHAT20B64[$i]"|out-file -append $CURRENTFILE
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
			$SPEAK = $(encodeb64("Regel Profil $PROFILE nicht gefunden!"))
			if ( !$NOTALK ) {speakthis $SPEAK}
			Write-host "Regel Profil $PROFILE nicht gefunden!"
			
			}
		}
			
	} else {
	write-host "USAGE:"
	write-host ".\loopchat.ps1 -YNUSER [junau user name] [-WAIT4STREAM] [-NOTALK] [-WRITELOG] [-READALL] [-SAYALL]"
	}

