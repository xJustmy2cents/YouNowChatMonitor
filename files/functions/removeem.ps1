function removeem {
##Variable Index 002
param (
[STRING]$MYINPUT = "",
[BOOL]$RMSPACE = $TRUE
)
if ( $MYINPUT -ne "") {
##		$MYCHARARRAY=$MYINPUT.ToCharArray()
##		$MYHEXSTRING=""
##		foreach ($element in $MYCHARARRAY) {
##			$MYHEXSTRING = $MYHEXSTRING + ";" + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($element))
##			}
##		write-host '$MYINPUT before: ' $MYINPUT
		write-host '$RMSPACE is: ' $RMSPACE
##		write-host '$MYCHARARRAY before: ' $($MYCHARARRAY[0..$MYCHARARRAY.length] -join " ")
##		write-host '$MYHEXSTRING before: ' $MYHEXSTRING
		$EMOJICONS_002 = @(
					"[$([char]0x2700)-$([char]0x27bf)]";
					"$([char]0xd83c)[$([char]0xdde6)-$([char]0xddff)]{2}";
					"[$([char]0xd800)-$([char]0xdbff)][$([char]0xdc00)-$([char]0xdfff)]";
					"[$([char]0x0023)-$([char]0x0039)]$([char]0xfe0f)$([char]0x20e3)";
					"$([char]0x3299)";
					"$([char]0x3297)";
					"$([char]0x303d)";
					"$([char]0x3030)";
					"$([char]0x24c2)";
					"$([char]0xd83c)[$([char]0xdd70)-$([char]0xdd71)]";
					"$([char]0xd83c)[$([char]0xdd7e)-$([char]0xdd7f)]";
					"$([char]0xd83c)$([char]0xdd8e)";
					"$([char]0xd83c)[$([char]0xdd91)-$([char]0xdd9a)]";
					"$([char]0xd83c)[$([char]0xdde6)-$([char]0xddff)]";
					"[$([char]0xd83c)[$([char]0xde01)-$([char]0xde02)]";
					"$([char]0xd83c)$([char]0xde1a)";
					"$([char]0xd83c)$([char]0xde2f)";
					"[$([char]0xd83c)[$([char]0xde32)-$([char]0xde3a)]";
					"[$([char]0xd83c)[$([char]0xde50)-$([char]0xde51)]";
					"$([char]0x203c)";
					"$([char]0x2049)";
					"[$([char]0x25aa)-$([char]0x25ab)]";
					"$([char]0x25b6)";
					"$([char]0x25c0)";
					"[$([char]0x25fb)-$([char]0x25fe)]";
					"$([char]0x00a9)";
					"$([char]0x00ae)";
					"$([char]0x2122)";
					"$([char]0x2139)";
					"$([char]0xd83c)$([char]0xdc04)";
					"[$([char]0x2600)-$([char]0x26FF)]";
					"$([char]0x2b05)";
					"$([char]0x2b06)";
					"$([char]0x2b07)";
					"$([char]0x2b1b)";
					"$([char]0x2b1c)";
					"$([char]0x2b50)";
					"$([char]0x2b55)";
					"$([char]0x231a)";
					"$([char]0x231b)";
					"$([char]0x2328)";
					"$([char]0x23cf)";
					"[$([char]0x23e9)-$([char]0x23f3)]";
					"[$([char]0x23f8)-$([char]0x23fa)]";
					"$([char]0xd83c)$([char]0xdccf)";
					"$([char]0x2934)";
					"$([char]0x2935)";
					"[$([char]0x2190)-$([char]0x21ff)]";
					"[$([char]0xd83d)$([char]0xdc96)]";
					"$([char]0x200b)";
					"\^";
					"\;";"\-";"\)";"\$"
					)
		$WHITESPACES = @("_")
		$MY_STRINGARRAY=$MYINPUT.tochararray();
		foreach ($MY_LETTER in $MY_STRINGARRAY) {
			$MY_LETTER_INT=[int[]][char[]]$MY_LETTER
			write-host "$MY_LETTER -> $MY_LETTER_INT"
		}
		foreach ( $EMOJI_002 in $EMOJICONS_002 ) {
				#write-host $EMOJI_002;
				$TMP_002=$MYINPUT -replace "$EMOJI_002",""
				$MYINPUT = $TMP_002.trim()
				}
			if ($RMSPACE -eq $TRUE) {
				foreach ( $WHITESPACE in $WHITESPACES ) {
					$TMP_002=$MYINPUT -replace "$WHITESPACE"," "
					$MYINPUT = $TMP_002.trim()
					}
				}
		write-host '$MYINPUT after: ' $MYINPUT
		$MY_STRINGARRAY=$MYINPUT.tochararray();
		
		foreach ($MY_LETTER in $MY_STRINGARRAY) {
			$MY_LETTER_INT=[int[]][char[]]$MY_LETTER
			write-host "$MY_LETTER -> $MY_LETTER_INT"
		}
		
		return $MYINPUT
	}

}