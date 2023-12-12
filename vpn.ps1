
$Password = Read-Host "Input password, please" -MaskInput
$SecondPassword = Read-Host -MaskInput "Input second password, please"

$Server="host.com.br"
$Group="1"
$User="user"

vpn-setup  $Server $Group $User $Password $SecondPassword