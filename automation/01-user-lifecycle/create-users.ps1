<#
.SYNOPSIS
    Bulk creates Active Directory users from a CSV file, places them in the correct OU,
    and assigns one or more security groups.

.DESCRIPTION
    This script is designed for the HYBRID-IDENTITY-ACCESS-MGMT automation module
    "01-user-lifecycle". It reads user records from users.csv, validates required fields,
    confirms OU and group existence, creates the account if it does not already exist,
    and then adds the user to one or more groups.

    If AAD-Sync-Users is included in the Groups column, the account is also scoped for hybrid
    synchronization through the existing Entra Connect group-based filtering design.

.NOTES
    Author: Edward E. Spence
    Repo: HYBRID-IDENTITY-ACCESS-MGMT
    Module: 01-user-lifecycle
#>

param(
    [string]$CsvPath = ".\users.csv",
    [switch]$WhatIfMode
)

Import-Module ActiveDirectory -ErrorAction Stop
$ErrorActionPreference = "Stop"

$createdCount = 0
$skippedCount = 0
$errorCount   = 0
$rowNumber    = 0

function Test-RequiredField {
    param(
        [string]$Value,
        [string]$FieldName,
        [int]$RowNumber
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "Row ${RowNumber}: Required field '${FieldName}' is missing or blank."
    }
}

foreach ($user in (Import-Csv -Path $CsvPath)) {
    $rowNumber++

    try {
        Test-RequiredField $user.FirstName "FirstName" $rowNumber
        Test-RequiredField $user.LastName  "LastName"  $rowNumber
        Test-RequiredField $user.Username  "Username"  $rowNumber
        Test-RequiredField $user.Password  "Password"  $rowNumber
        Test-RequiredField $user.OU        "OU"        $rowNumber
        Test-RequiredField $user.Groups    "Groups"    $rowNumber

        $firstName = $user.FirstName.Trim()
        $lastName  = $user.LastName.Trim()
        $username  = $user.Username.Trim()
        $password  = $user.Password.Trim()
        $ou        = $user.OU.Trim()
        $groupsRaw = $user.Groups.Trim()

        Write-Host "[INFO] Processing ${username}"

        if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
            Write-Host "[WARNING] ${username} already exists - skipping"
            $skippedCount++
            continue
        }

        Get-ADOrganizationalUnit -Identity $ou -ErrorAction Stop | Out-Null

        $groups = $groupsRaw -split ";" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

        foreach ($g in $groups) {
            Get-ADGroup -Identity $g -ErrorAction Stop | Out-Null
        }

        if ($WhatIfMode) {
            Write-Host "[WHATIF] Would create ${username}"
            foreach ($g in $groups) {
                Write-Host "[WHATIF] Would add ${username} to ${g}"
            }
            continue
        }

        New-ADUser `
            -Name "$firstName $lastName" `
            -SamAccountName $username `
            -UserPrincipalName "${username}@iampam.lab" `
            -Path $ou `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true

        Write-Host "[SUCCESS] Created ${username}" -ForegroundColor Green

        foreach ($g in $groups) {
            Add-ADGroupMember -Identity $g -Members $username -ErrorAction Stop
            Write-Host "[SUCCESS] Added ${username} to ${g}" -ForegroundColor Green
        }

        $createdCount++
    }
    catch {
        Write-Host "[ERROR] Row ${rowNumber} failed: $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }

    Write-Host ""
}

Write-Host "==== SUMMARY ====" -ForegroundColor Cyan
Write-Host "Processed: $rowNumber"
Write-Host "Created  : $createdCount"
Write-Host "Skipped  : $skippedCount"
Write-Host "Errors   : $errorCount"