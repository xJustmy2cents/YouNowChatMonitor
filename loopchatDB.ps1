param (
[string]$YNUSER = "",
[switch]$READALL = $FALSE,
[switch]$NOTALK = $FALSE,
[switch]$WAIT4STREAM = $FALSE

)
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

##hier wird ein gegebener String base64 kodiert
function encodeb64 {
param (
[string]$THISTEXT
)
$THISTEXTB64=""
if ($THISTEXT -ne "") {
$THISTEXTB64 = [Convert]::ToBase64String( [System.Text.Encoding]::Unicode.GetBytes($THISTEXT) )
}
return $THISTEXTB64
}

##hier wird die Analyse des Chat gestartet und ggfls. die TTS getriggert
function newtalk {
param (
	[string]$MYNAME="",
	[string]$MYCOMMENT=""
	)
	#write-host '$MYSPEAK:' $MYSPEAK
	#write-host '$MYNAME:' $MYNAME
	#write-host '$MYCOMMENT:' $MYCOMMENT
	$MYERR = 1
	if ($MYNAME -ne "" -and $MYCOMMENT -ne "") {
		$MYERR = 0
		$MYTALK = ""
		switch ($MYCOMMENT) {
			{$_ -like "*schaut gerade zu"} {$MYTALK = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm dir nen Keks."))}
			{$_ -like "*is watching"} {$MYTALK = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm dir nen Keks."))}
			# " is here" {$MYTALK = $(encodeb64("Hallo " + $MYNAME + ". Setz Dich, nimm dir nen Keks."))}
			{$_ -like "*ist Fan geworden!"} {$MYTALK = $(encodeb64("Danke für's Fan werden, " + $MYNAME))}
			"Hallo" {$MYTALK = $(encodeb64("Hallo " + $MYNAME + "."))}
			{$_ -like "*zu diesem Broadcast eingeladen."} {$MYTALK = $(encodeb64("Danke für's Einladen Deiner Fans, " + $MYNAME))}
			default {$MYTALK = $(encodeb64($MYCOMMENT))}
			}
		$speak = $MYSPEAK + "'" + $MYTALK + "'"
		write-host $speak
		start-process powershell -wait -windowstyle hidden -argumentlist $speak				
		}
	#return $MYERR
	}


if ($YNUSER -ne "") {

	$LASTCHAT20=
	$MYPATH=$PSScriptRoot
	$MYLOGPATH="$MYPATH\..\"
	$MYSPEAK="$MYPATH\speakthis.ps1 -talkthis "

	$MYERRORCODE=0
	$RUNLOOPINIT=0
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
				$LASTCHAT20=$(Get-Content -last $CURRENTCHAT20.length $CURRENTFILE)
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
						if ( $NOTALK ) {write-host $CURRENTCHAT.comment} else {newtalk -MYNAME $CURRENTCHAT.name -MYCOMMENT $CURRENTCHAT.comment}
						}
					"$(get-date -format yyyMMddHHmmss);;$CURRENTCHATB64"|out-file -append $CURRENTFILE
					}
			
				}
			$RUNLOOPINIT = 1
			start-sleep 0.6
			}
			if ( $WAIT4STREAM -and $MYERRORCODE -ne 0 ) {
				$MYERRORCODE = 0
				$speak = $MYSPEAK + "'" + $(encodeb64("User $YNUSER is offline, warte auf Stream!")) + "'"
				if ( !$NOTALK ) {start-process powershell -wait -windowstyle hidden -argumentlist $speak}
				Write-host "User $YNUSER is offline, warte auf Stream!"
				start-sleep 5
				}
		}
	
	$speak = $MYSPEAK + "'" + $(encodeb64("User $YNUSER is offline!")) + "'"
	if ( !$NOTALK ) {start-process powershell -wait -windowstyle hidden -argumentlist $speak}
	Write-host "User $YNUSER is offline!"
	} else {
	write-host "USAGE:"
	write-host ".\loopchat.ps1 -ynuser [junau user name]"
	}

