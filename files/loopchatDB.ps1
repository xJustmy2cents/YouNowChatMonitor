param (
[string]$YNUSER = "younow_voyeur",
[string]$PROFILE = "newtalk",
[switch]$READALL = $FALSE,
[switch]$NOTALK = $FALSE,
[switch]$WRITELOG = $FALSE,
[switch]$SAYALL = $FALSE,
[switch]$DEBUG = $FALSE,
[switch]$WAIT4STREAM = $FALSE,
[switch]$OBSON = $FALSE,
[switch]$SNDON = $FALSE
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
	$PRIVATE:MYSPACER=" "
	SET-LOCATION $MYPATH

	## initial function load
	$PRIVATE:LOADFUNCTIONS = @("encodeb64", "decodeb64", "builtlastchat")
	if ( -not $NOTALK ) {
		$LOADFUNCTIONS += "removeem"
		$LOADFUNCTIONS += "..\profiles\$PROFILE"
		$LOADFUNCTIONS += "speakthis"
		}
	if ( $SNDON ) { $LOADFUNCTIONS += "PlaySounds"} ##Event Sounds
	if ( $OBSON ) { $LOADFUNCTIONS += "obswebsocket" } ##OBS Websocket needs to be loaded as last modul
	
	foreach ( $LOADFUNCTION in $LOADFUNCTIONS ) {
		write-host "loading $LOADFUNCTION"
		try {. .\functions\$LOADFUNCTION.ps1}
		catch {$MYERRORCODE = 999;$MYERRORFUNCTION=$LOADFUNCTION; break;}
		#start-sleep 0.6
		}


	while ($MYERRORCODE -eq 0) {
		$CURRENTCHAT20B64 = @()
		$MYCONTENT=$($(wget https://api.younow.com/php/api/broadcast/info/user=$($YNUSER.replace(".","%2e"))).content|ConvertFrom-Json)
		$MYERRORCODE=$($MYCONTENT|select -expand errorcode)
		if ( $MYERRORCODE -eq 0 ) {	
			#####################################
			##
			## Work stanza
			##
			#####################################
			
			if (!$THIS_BROADCASTID) {
				##load broadcastid and check, if a log exists
				$THIS_BROADCASTID = $MYCONTENT.broadcastid
				$THIS_LOGFILE = "./outfiles/$THIS_BROADCASTID.log"
				if ( test-path $THIS_LOGFILE ) {
					try {
						$THIS_SERVERTIME_OLD=$( $(get-content $THIS_LOGFILE|select -last 1).split(":"))[0]
						} catch {
						##file is empty, just skip
						}
				} else {
					$null > $THIS_LOGFILE
				}
			}
				
			##Load current servertime and set old reference for first time
			$THIS_SERVERTIME_NEW=$MYCONTENT.servertime
			if (!$THIS_SERVERTIME_OLD) {$THIS_SERVERTIME_OLD=$THIS_SERVERTIME_NEW}


			##Load the Comments in an array
			$MYNEWCOMMENTS=$MYCONTENT|select -expand comments
			
			##Loop thought the comments and check by timestamp
			foreach ($MYNEWCOMMENT in $MYNEWCOMMENTS) {
				if ($MYNEWCOMMENT.timestamp -ge $THIS_SERVERTIME_OLD) {
					## encrypt the comment to base64 and send it to the filter
					$MYNEWCOMMENT.comment=$(removeem($MYNEWCOMMENT.comment))
					$THIS_COMMENT_USERID=$MYNEWCOMMENT.userid
					
					##because of issues with the out-file, we need to resolve all objects to a simple variable
					$THIS_COMMENT_USERID_INFO=$($(wget https://cdn.younow.com/php/api/channel/getInfo/channelId=$THIS_COMMENT_USERID).content|convertfrom-json)
					$COL01=$THIS_SERVERTIME_OLD
					$COL02=$MYNEWCOMMENT.timestamp
					$COL03= -join($MYNEWCOMMENT.name,$(if ($THIS_COMMENT_USERID_INFO.datecreated -like "2020-08-10*") {$("(BOT)")}))
					$COL04=$MYNEWCOMMENT.comment
					$COL05=$THIS_COMMENT_USERID_INFO.userid
					$COL06=$THIS_COMMENT_USERID_INFO.datecreated
					$COL07=$THIS_COMMENT_USERID_INFO.propslevel
					$COL08=""
					$COL09=""
					
					
					write-host $COL01":"$COL02":"$COL03":"$COL04":"$COL05":"$COL06":"$COL07
					write $COL01":"$COL02":"$COL03":"$COL04":"$COL05":"$COL06":"$COL07|out-file $THIS_LOGFILE -append
					
					}
				}
			
			##roll servertime reference
			$THIS_SERVERTIME_OLD = $THIS_SERVERTIME_NEW

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
				sleep 0.6
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

if ( $obs ) {$obs.disconnect()}