$import = import-csv -Path $env:USERPROFILE\documents\blokweg-mb.csv -del ";"
foreach ($mb in $import)
{
    #get-mailbox $($mb.'primary smtp address') |select -expand emailaddresses
    new-mailbox -shared -displayname $mb.displaynaam1 -primarysmtpaddress $mb.alias1 -name $mb.displaynaam1
}

foreach ($mb in $import)
{
    if ($mb.displaynaam4){new-mailbox -shared -displayname $mb.displaynaam4 -primarysmtpaddress $mb.alias4 -name $mb.displaynaam4}
}

foreach ($mb in $import)
{
    if (get-mailbox $mb.displaynaam3){"$($mb.displaynaam3),$($MB.alias3)"}
}

foreach ($mb in $import)
{
    get-aduser -filter {emailaddress -like "$($mb.'primary smtp address')"}
}

foreach ($mb in $import)
{
    "$($mb.'primary smtp address')"
}

foreach ($mb in $import)
{
    $prim = $mb.'primary smtp address'
    [string]$id = ($prim -split "@")[0]
    [string]$company = ($prim -split "@")[1]
    if ($id.length -gt 20){$id = $id.substring(0,20)}
    Get-aduser $id |set-aduser -replace @{proxyaddresses ="SMTP:$($mb.'primary smtp address')"} -emailaddress $prim -userprincipalname $prim -company $company
}

foreach ($mb in $import)
{
    $prim = $mb.'primary smtp address'
    [string]$id = ($prim -split "@")[0]
    [string]$company = ($prim -split "@")[1]
    if ($id.length -gt 20){$id = $id.substring(0,20)}
    #alias = $mb.'alias2'
    $alias = $mb.'alias4'
    
    [string]$aliasid = ($alias -split "@")[0]
    [string]$aliascompany = ($alias -split "@")[1]
    if ($aliascompany -eq $company)
    {
        $user = Get-aduser $id -prop *
        $prox = "$($user.proxyaddresses);smtp:$($alias)"
        $user|set-aduser -replace @{proxyaddresses ="$prox"}
    }  
}

foreach ($mb in $import)
{
    if ($mb.alias4)
    {
        $prim = $mb.'alias4'
        [string]$id = ($prim -split "@")[0]
        [string]$company = ($prim -split "@")[1]
        if ($id.length -gt 20){$id = $id.substring(0,20)}
        $alias = $mb.'alias5'
        #$alias = $mb.'alias3'
        
        [string]$aliasid = ($alias -split "@")[0]
        [string]$aliascompany = ($alias -split "@")[1]
        
        if ($aliascompany -eq $company)
        {
            $user = Get-mailbox $prim
            #$prox = "$($user.proxyaddresses);smtp:$($alias)"
            
            $user|set-mailbox -emailaddress @{add=$alias}
        }
    }
}

Add-RecipientPermission <identity> -AccessRights SendAs -Trustee <user> 

foreach ($mb in $import)
{
    if ($mb.alias4)
    {
        $prim = $mb.'alias4'
        $user = Get-mailbox $prim
       #$prox = "$($user.proxyaddresses);smtp:$($alias)"
        $user |Add-RecipientPermission -AccessRights SendAs -Trustee $mb.'primary smtp address' -confirm:$false
        $user|set-mailbox -forwardingsmtpaddress $mb.'primary smtp address'
    }
}
