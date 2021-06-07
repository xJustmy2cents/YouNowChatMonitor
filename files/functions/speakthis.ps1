##init of speech engine
##Variable Index: 001
try {
	get-variable RUNMODEINIT_001 -erroraction 'stop'
	}
catch {
	$RUNMODEINIT_001 = 0
	}

IF ($RUNMODEINIT_001 -ne 1) {
	write-host "Initializing speech engine"
	Add-Type -AssemblyName System.speech
	$speak_001 = New-Object System.Speech.Synthesis.SpeechSynthesizer
	$speak_001.selectvoice("Microsoft Hedda Desktop")
	$speak_001.rate = 2
	$RUNMODEINIT_001 = 1
	}

function speakthis {
	
	param (
	[string]$TALKTHISB64 = "",
	[string]$PLAYTHIS = "FALSE"
	)
	
	if ($TALKTHISB64 -ne "") {
		$TALKTHIS_001 = decodeb64($TALKTHISB64)
##		$TALKTHIS_001 = removeem($TALKTHIS_001)
		if ($PLAYTHIS -ne "FALSE") {playsound($PLAYTHIS)}
		$speak_001.Speak($TALKTHIS_001)
		}
	}

speakthis $(encodeb64("Sprach Interface geladen."))