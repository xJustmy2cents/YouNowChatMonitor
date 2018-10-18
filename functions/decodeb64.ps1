function decodeb64 {
##variable index 004
param (
[string]$THISTEXTB64
)
$THISTEXT_004=""
if ($THISTEXTB64 -ne "") {
$THISTEXT_004 = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($THISTEXTB64))

}
return $THISTEXT_004
}