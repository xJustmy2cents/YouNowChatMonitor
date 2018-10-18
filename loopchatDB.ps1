param (
[string]$YNUSER = "",
[string]$PROFILE = "newtalk",
[switch]$READALL = $FALSE,
[switch]$NOTALK = $FALSE,
[switch]$WRITELOG = $FALSE,
[switch]$SAYALL = $FALSE,
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
	$PRIVATE:CURRENTCHAT20=""
	$PRIVATE:CURRENTCHATB64=""
	$PRIVATE:LASTCHAT20=""
	$PRIVATE:MYPATH=$PSScriptRoot
	$PRIVATE:MYLOGPATH="$MYPATH\..\"
	SET-LOCATION $MYPATH

	## initial function load
	$PRIVATE:LOADFUNCTIONS = @("encodeb64", "decodeb64")
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
		$MYCONTENT=$($(wget https://api.younow.com/php/api/broadcast/info/user=$YNUSER).content|ConvertFrom-Json)
		$MYERRORCODE=$($MYCONTENT|select -expand errorcode)
		if ( $MYERRORCODE -eq 0 ) {	
			if ( $RUNLOOPINIT -eq 0 ) {
				$BROADCASTID = $($MYCONTENT.broadcastID)
				$USERID=$($MYCONTENT.username)
				$CURRENTFILE="$MYLOGPATH\$USERID-$BROADCASTID.log"
				if ( -not (test-path $CURRENTFILE)) {
					""|out-file $CURRENTFILE
					} 
				}
			$CURRENTCHAT20=$($MYCONTENT|select -expand comments|select name, comment)
			try {
				$LASTCHAT20=$(Get-Content -last ($CURRENTCHAT20.length + 1) $CURRENTFILE)
				} catch {
				$LASTCHAT20=$(Get-Content -last 1 $CURRENTFILE)
				}
			#write-host '$CURRENTCHAT20.length:' $CURRENTCHAT20.length
			#write-host '$LASTCHAT20.length:' $LASTCHAT20.length
			foreach ($CURRENTCHAT in $CURRENTCHAT20) {
				#write-host '$CURRENTCHAT: ' $CURRENTCHAT
				$CURRENTCHATB64 = $(encodeb64($CURRENTCHAT.name + " " + $CURRENTCHAT.comment))
				if ( $LASTCHAT20 -like "*$CURRENTCHATB64" ) {
					#donothing
					} else {
					if ($READALL -or $RUNLOOPINIT -eq 1) {
						if ( $WRITELOG ) {write-host $CURRENTCHAT.name": "$CURRENTCHAT.comment} 
						if ( -not $NOTALK ) {newtalk -MYNAME $CURRENTCHAT.name -MYCOMMENT $CURRENTCHAT.comment -SAYALL $SAYALL}
						}
					"$(get-date -format yyyMMddHHmmss);;$CURRENTCHATB64"|out-file -append $CURRENTFILE
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

