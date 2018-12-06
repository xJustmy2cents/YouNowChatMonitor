##built current chat from wget to compare
##Variable index 007

function builtcurrentchat {
	param (
		[array]$MYINPUT = ""
		)
	
	$MYLINE_007=""
	$MYOUTPUT_007=""
	$MYINPUT_007=""
	if ( $MYINPUT -ne "" ) {
		#$MYINPUT_007 = $MYINPUT.split()
		write-host 'builtcurrentchat:$MYINPUT: ' $MYINPUT
		foreach ( $MYLINE_007 in $MYINPUT ) {
			write-host 'builtcurrentchat:$MYLINE_007: ' $MYLINE_007
			$MYOUTPUT_007 += $(encodeb64($MYLINE_007.name + " " + $MYLINE_007.comment))
			}
		}
	return $MYOUTPUT_007
	}