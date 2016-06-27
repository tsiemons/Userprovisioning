$result = @()
$distgroups = get-distributiongroup
foreach ($grp in $distgroups)
{
    $name = $grp.name
    $members = $grp |get-distributiongroupmember |select name
    $members |add-member -membertype noteproperty -name Group -value $name
    $members = $members |sort Group |select group, name 
    $result += $members
 
}
$result|export-csv -path ".\export.csv" -NoTypeInformation -Delimiter ";"