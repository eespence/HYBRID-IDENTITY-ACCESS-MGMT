param(
    [int]$InactiveDays = 30
)

Import-Module ActiveDirectory -ErrorAction Stop
$ErrorActionPreference = "Stop"

$report = @()

$groupsToAudit = @(
    "PAM-Server-Admins",
    "IT-Admins"
)

$cutoffDate = (Get-Date).AddDays(-$InactiveDays)

Write-Host "[INFO] Starting Identity Audit..." -ForegroundColor Cyan

foreach ($group in $groupsToAudit) {

    Write-Host "[INFO] Auditing group: $group"

    try {
        $members = Get-ADGroupMember -Identity $group -ErrorAction Stop
    }
    catch {
        Write-Host "[ERROR] Failed to query group: $group" -ForegroundColor Red
        continue
    }

    foreach ($member in $members) {

        if ($member.objectClass -ne "user") {
            continue
        }

        try {
            $user = Get-ADUser $member.SamAccountName -Properties LastLogonDate

            $isInactive = $false

            if ($user.LastLogonDate -eq $null -or $user.LastLogonDate -lt $cutoffDate) {
                $isInactive = $true
            }

            $report += [PSCustomObject]@{
                Username       = $user.SamAccountName
                Group          = $group
                LastLogon      = $user.LastLogonDate
                Inactive       = $isInactive
            }

            Write-Host "[INFO] Checked $($user.SamAccountName)"

        }
        catch {
            Write-Host "[ERROR] Failed to process $($member.SamAccountName)" -ForegroundColor Red
        }
    }
}

$report | Export-Csv -Path ".\sample-report.csv" -NoTypeInformation

Write-Host ""
Write-Host "[SUCCESS] Audit complete. Report saved to sample-report.csv" -ForegroundColor Green
