Function Connect-Microsoft
{
    <#
    .SYNOPSIS 
    Creeate a connection to Office 365 and Azure Active Directory

    .DESCRIPTION
    Connect to a Microsoft Office 365 tenant with DAP credentials 

    .PARAMETER Credential
    DAP Microsoft Credentials

    .PARAMETER Tenant
    Primaire domein naam zoals de Office 365 tenant is aan gemaakt

    .LINK
    None

    .INPUTS


    .OUTPUTS 
    Geen

    .EXAMPLE
    PS C:\> Connect-Microsoft -credential $cred -tenant dudokbeheer.onmicrosoft.com
    #>	


    [CmdletBinding( 
        SupportsTransactions=$False, 
        DefaultParameterSetName="")] 


    param( 
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] 
    [System.Management.Automation.PSCredential]$credential,
    [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$false)] 
    [string]$tenant
    ) 
    Begin
    {
        if (!(get-module msonline -listavailable))
        {
            "Msonline module niet geinstalleerd!"
            start-process "https://technet.microsoft.com/nl-nl/library/jj151805.aspx"
        }
        $connect = $false
    }
    Process
    {
        
        Try
        {
            Connect-msolservice -credential $credential -ea stop
            $connect=$true
        }
        Catch
        {
            "Connect not succeeded, $error[0]"
            Break
        }
        if ($connect)
        {
            if ($tenant)
            {
                try 
                {
                    $global:tenantid = Get-MsolPartnerContract -DomainName $tenant
                }
                Catch
                {
                    "Can not connect to $tenant, $error[0]"
                    Break
                }
            }
            else 
            {
                $i = 0
                $choicearr = @()
                $tenants = get-msolpartnercontract #|select tenantid, defaultdomainname
                $global:Tentantid = $tenants |select name, defaultdomainname, tenantid |out-gridview -PassThru
                Return $tenantid
            }
        }
    }
}

Function Get-tenantparameters
{
    if (!($tenantid))
    {
        "Please start with Connect-microsoft"
        Break
    }
    else 
    {
        $tenantinfo = import-csv -Delimiter ";" -Path |where  
    }
}

Function set-onzin
{
    "fdfd"
}
Function Set-mailbox
{

}

Function new-functionalmailbox
{
    <#
    .SYNOPSIS 
    Create a shared mailbox on Office 365

    .DESCRIPTION
    Wanneer een opgegeven mailbox niet bestaat wordt deze aangemaakt. Een array van medewerkers kan worden opgegeven die rechten moeten krijgen, of waarvan de rechten moeten worden verwijderd.
    De medewerkers moeten opgegeven met een comma als seperator

    .PARAMETER Sharedaddress
    E-mail adres van de shared mailbox

    .PARAMETER Shareddisplay
    Displayname van de shared mailbox

    .LINK
    None

    .INPUTS


    .OUTPUTS 
    Geen

    .EXAMPLE
    PS C:\> create-216shared.ps1 -sharedaddress info@216.nl -shareddisplay "Info - 216" -addrights be.heerder@216.nl, Alex.van.buren@216.nl
    #>	


    [CmdletBinding( 
        SupportsTransactions=$False, 
        DefaultParameterSetName="")] 


    param( 
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] 
    [string]$sharedaddress,
    [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$false)] 
    [string]$shareddisplay
    ) 
    Process
    {
        $dudokpath = "DUDOK.local/DUDOKBEHEER/Security Groups/Maguise/Mailboxen"
        $dudokmbpath = "DUDOK.local/DUDOKBEHEER/Shared Mailboxes/Maguise"
        $pw = "Welkom2016!" |convertto-securestring -asplaintext -force
        $mb = get-remotemailbox $sharedaddress -erroraction silentlycontinue
        if (!($shareddisplay))
        {
            $shareddisplay = ($sharedaddress.split('@'))[0]
        }
        if (!($MB))
        {
            New-remoteMailbox -name $sharedaddress -primarysmtpaddress $sharedaddress -displayname $shareddisplay -onpremisesorganizationalunit $dudokmbpath -userprincipalname $sharedaddress -password $pw
            $sam = ($sharedaddress.split('@'))[0]
            New-ormdistributiongroup -name "MBX_$($shareddisplay)_Read" -samaccountname "$($sam)-r" -organizationalunit  $dudokpath -type security
            New-ormdistributiongroup -name "MBX_$($shareddisplay)_Sendas" -samaccountname "$($sam)-s" -organizationalunit $dudokpath -type security
        }
    }
}

enable-ormdistributiongroup
{
    [CmdletBinding( 
    SupportsTransactions=$False, 
    DefaultParameterSetName="")] 


    param( 
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] 
    [Microsoft.ActiveDirectory.Management.ADGroup]$group
    ) 
    Process
    {

    $msExchRecipientDisplayType = "1073741833"
    $smtp = "SMTP:$($grp.samaccountname)"
    }
}
Export-ModuleMember "new-fuctionalmailbox", "connect-microsoft", $tenantid, $tenants