##hier wird ein gegebener String base64 kodiert
function encodeb64 {
##variable index 005
param (
[string]$THISTEXT
)
$THISTEXTB64_005=""
if ($THISTEXT -ne "") {
$THISTEXTB64_005 = [Convert]::ToBase64String( [System.Text.Encoding]::Unicode.GetBytes($THISTEXT) )
}
return $THISTEXTB64_005
}
