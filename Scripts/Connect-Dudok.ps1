$opcred = get-credential
$OpSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://exchange.dudok.nl/powershell/ -Authentication basic -cred $opcred
Import-PSSession $OPSession
