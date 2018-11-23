##built lastchat from log to compare
##Variable index 006

function BUILTLASTCHAT {

	param (
		[string]$MYINPUT = ""
		)

	if ( $MYINPUT -ne "" ) {
		$MYOUTPUT_006 = @()
		$MYINPUT_006 = @()
		$MYLINE_006 = ""
		$MYINPUT_006 = $MYINPUT.split()
#		write-host 'BUILTLASTCHAT:$MYINPUT_006: ' $MYINPUT_006
		foreach ($MYLINE_006 in $MYINPUT_006) {
#			write-host 'BUILTLASTCHAT:$MYLINE_006: ' $MYLINE_006
			$MYCOMMENT_006 = $($MYLINE_006.split(";;"))[2]
#			write-host 'BUILTLASTCHAT:$MYCOMMENT_006: ' $MYCOMMENT_006 
			$MYOUTPUT_006 += "$MYCOMMENT_006"
			}
		}
	return $MYOUTPUT_006
	write-host '$MYOUTPUT = ' $MYOUTPUT_006
	}