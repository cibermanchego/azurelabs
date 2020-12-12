# Purpose: Installs the GPOs for the custom WinEventLog auditing policy.
$GPOs = 'Domain Controllers Enhanced Auditing Policy', 'Servers Enhanced Auditing Policy', 'Workstations Enhanced Auditing Policy'
$OUs = "ou=Domain Controllers,dc=itisfine,dc=lab", "ou=Servers,dc=itisfine,dc=lab", "ou=Workstations,dc=itisfine,dc=lab"
$GPOPaths = "c:\resources\GPO\Domain_Controllers_Enhanced_Auditing_Policy", "c:\resources\GPO\Servers_Enhanced_Auditing_Policy", 
            "c:\resources\GPO\Workstations_Enhanced_Auditing_Policy"
$index = 0..2
foreach ($i in $index) {
    $GPOName = $GPOs[$i]
    $OU =  $OUs[$i]
    $GPOPath = $GPOPaths[$i]
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOPath -TargetName $GPOName -CreateIfNeeded
    $gpLinks = $null
    $gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
    $GPO = Get-GPO -Name $GPOName
    If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
    {
        New-GPLink -Name $GPOName -Target $OU -Enforced yes
    }
    else
    {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) GpLink $GPOName already linked on $OU. Moving On."
    }
}
    