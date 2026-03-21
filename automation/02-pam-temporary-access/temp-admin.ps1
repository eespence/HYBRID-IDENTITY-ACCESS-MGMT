param(
    [string]$Username = "bcarter",
    [string]$GroupName = "PAM-Server-Admins",
    [int]$DurationHours = 4,
    [switch]$WhatIfMode
)

Import-Module ActiveDirectory -ErrorAction Stop
$ErrorActionPreference = "Stop"

Write-Host "[INFO] Processing $Username"

try {
    # Validate user
    $user = Get-ADUser -Identity $Username -ErrorAction Stop

    # Validate group
    $group = Get-ADGroup -Identity $GroupName -ErrorAction Stop

    # Check membership
    $isMember = Get-ADGroupMember $GroupName | Where-Object { $_.SamAccountName -eq $Username }

    if ($isMember) {
        Write-Host "[WARNING] $Username already in $GroupName - skipping"
        return
    }

    if ($WhatIfMode) {
        Write-Host "[WHATIF] Would add $Username to $GroupName"
        return
    }

    # Add user to group
    Add-ADGroupMember -Identity $GroupName -Members $Username

    $grantedTime = Get-Date
    $expiryTime = $grantedTime.AddHours($DurationHours)

    Write-Host "[SUCCESS] Added $Username to $GroupName" -ForegroundColor Green
    Write-Host "[SUCCESS] Access granted at: $grantedTime"
    Write-Host "[SUCCESS] Access expires at: $expiryTime"

}
catch {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
