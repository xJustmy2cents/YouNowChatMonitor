####
###
##
## This function is ment to play sound on events.
##
## it makes use of media player
##
##
###
####

$THISSOUND = new-object System.Media.SoundPlayer
$SOUNDPATH="C:\Users\carsten\Documents\_privatesOC\Projekte\StreamProjects\Soundfiles\"
$SOUNDFILE = @{}
$SOUNDFILE['tada'] = "c:\windows\media\tada.wav"
$SOUNDFILE['welcome1'] = $SOUNDPATH + "welcome_deep.wav"
$SOUNDFILE['welcome2'] = $SOUNDPATH + "welcome_visitor.wav"
$SOUNDFILE['welcome3'] = $SOUNDPATH + "welcome_stage.wav"
$SOUNDFILE['SinglePringle1991'] = $SOUNDPATH + "SinglePringle1991.wav"
$SOUNDFILE['shadow21'] = $SOUNDPATH + "shadow21.wav"

function playsound {
param (
	$PLAYTHIS = ""
	)
foreach ($FILE in $PLAYTHIS.split(",")) {
if ( $FILE.trim() -ne "" ) {
$THISSOUND.SoundLocation = $SOUNDFILE[$FILE]
if ( $OBSON ) {
	$PushOBSScene=$obs.GetCurrentScene().Name
	$obs.SetCurrentScene("PS_" + $FILE)
	}
$THISSOUND.PlaySync()
if ( $OBSON ) {
	$obs.SetCurrentScene($PushOBSScene)
	}

}
}
}