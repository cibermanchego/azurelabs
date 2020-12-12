$GPOs = 'Windows Event Forwarding Server', 'Custom Event Channel Permissions'
foreach ($GPOName in $GPOs) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing the GPO $GPOName"
    Import-GPO -BackupGpoName $GPOName -Path "c:\resources\GPO\wef_configuration" -TargetName $GPOName -CreateIfNeeded
    $OUs = "OU=Servers,dc=itisfine,dc=lab", "ou=Workstations,dc=itisfine,dc=lab", "ou=Domain Controllers,dc=itisfine,dc=lab"
    foreach ($OU in $OUs) {
        $gpLinks = $null
        $gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
        $GPO = Get-GPO -Name $GPOName
        If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
        {
            New-GPLink -Name $GPOName -Target $OU -Enforced yes
        } else {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) GpLink $GPOName already linked on $OU. Moving On."
        }
    }
}
#Update policies
gpupdate /force