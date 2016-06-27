Function create-functionalmailbox
{
    <#
    .SYNOPSIS 
    creeren of aanpassen van een shared mailbox op Office 365

    .DESCRIPTION
    Wanneer een opgegeven mailbox niet bestaat wordt deze aangemaakt. Een array van medewerkers kan worden opgegeven die rechten moeten krijgen, of waarvan de rechten moeten worden verwijderd.
    De medewerkers moeten opgegeven met een comma als seperator

    .PARAMETER Sharedaddress
    E-mail adresvan de shared mailbox

    .PARAMETER Shareddisplay
    Displayname van de shared mailbox

    .PARAMETER Addrights
    E-mail adressen van medewerker(s) die rechten moet krijgen

    .PARAMETER Removerights
    E-mail adressen van medewerker(s) waarvan de rechten worden verwijderd

    .LINK
    None

    .INPUTS


    .OUTPUTS 
    Geen

    .EXAMPLE
    PS C:\> create-216shared.ps1 -sharedaddress info@216.nl -shareddisplay "Info - 216" -addrights be.heerder@216.nl, Alex.van.buren@216.nl

    .EXAMPLE
    PS C:\> create-216shared.ps1 -sharedaddress info@216.nl -shareddisplay "Info - 216" -removerights be.heerder@216.nl.EXAMPLE
    .EXAMPLE
    PS C:\> create-216shared.ps1 -sharedaddress info@216.nl -shareddisplay "Info - 216" -addrights be.heerder@216.nl, Alex.van.buren@216.nl



    #>	


    [CmdletBinding( 
        SupportsShouldProcess=$True, 
        SupportsTransactions=$False, 
        ConfirmImpact="None", 
        DefaultParameterSetName="")] 


    param( 
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)] 
    [string]$sharedaddress,
    [Parameter(Position=1, Mandatory=$false, ValueFromPipeline=$false)] 
    [string]$shareddisplay,
    [Parameter(Position=2, Mandatory=$false, ValueFromPipeline=$false)] 
    [array]$addrights,
    [Parameter(Position=3, Mandatory=$false, ValueFromPipeline=$false)] 
    [array]$removerights
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
            New-distributiongroup -name "MBX_$($shareddisplay)_Read" -samaccountname "$($sam)-r" -organizationalunit  $dudokpath -type security
            New-distributiongroup -name "MBX_$($shareddisplay)_Sendas" -samaccountname "$($sam)-s" -organizationalunit $dudokpath -type security
        }
    }
}