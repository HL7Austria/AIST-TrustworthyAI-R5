param(
    [Parameter(Mandatory = $true)]
    [string]$ScenarioName
)

Set-StrictMode -Version Latest

$Validator = (Resolve-Path ".\validator_cli.jar").Path
$IgPackage = (Resolve-Path "..\..\output\package.tgz").Path
$FhirVersion = "5.0.0"

$ScenarioDir = (Resolve-Path "..\output\fhir\$ScenarioName").Path
$ResultDir = Join-Path $PSScriptRoot "results\$ScenarioName"

New-Item -ItemType Directory -Force -Path $ResultDir | Out-Null

# @() ensures that Count also works reliably when exactly one file exists.
$Files = @(Get-ChildItem -Path $ScenarioDir -Filter "*.json" -File)

if ($Files.Count -eq 0) {
    Write-Host "No FHIR JSON files found in $ScenarioDir" -ForegroundColor Red
    exit 1
}

Write-Host "FHIR Validator: $Validator"
Write-Host "IG Package:      $IgPackage"
Write-Host "FHIR Version:    $FhirVersion"
Write-Host "Scenario:        $ScenarioName"
Write-Host "Input folder:    $ScenarioDir"
Write-Host "Files found:     $($Files.Count)"
Write-Host ""

$Summary = @()
$ScenarioFailed = $false

foreach ($File in $Files) {
    $ResourceName = $File.BaseName

    $HtmlOutput = Join-Path $ResultDir "$ResourceName-validation.html"
    $TxtOutput = Join-Path $ResultDir "$ResourceName-validation.txt"

    Write-Host "Validating $($File.Name) ..."

    # Java writes informational messages such as JAVA_TOOL_OPTIONS to stderr.
    # With ErrorActionPreference = Stop inherited from the parent script,
    # this may otherwise terminate the PowerShell script.
    $PreviousErrorActionPreference = $ErrorActionPreference

    try {
        $ErrorActionPreference = "Continue"

        $Output = @(
            & java `
                -jar $Validator `
                $File.FullName `
                -version $FhirVersion `
                -ig $IgPackage `
                -tx "https://tx.fhir.org" `
                -html-output $HtmlOutput `
                2>&1
        )

        # Must be captured immediately after the native java command.
        $JavaExitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $PreviousErrorActionPreference
    }

    # Convert every output element explicitly to text.
    $OutputText = ($Output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine

    $OutputText | Out-File `
        -FilePath $TxtOutput `
        -Encoding utf8

    $Status = "UNKNOWN"
    $ErrorCount = $null
    $WarningCount = $null
    $NoteCount = $null

    $WarningMessages = (
        $OutputText -split "`r?`n" |
        Where-Object { $_ -match "^\s*Warning @" } |
        ForEach-Object { $_.Trim() }
    ) -join " | "

    if (
        $OutputText -match
        "(?i)(success|\*success\*|\*failure\*|failure):?\s*(\d+)\s+errors?,\s*(\d+)\s+warnings?,\s*(\d+)\s+notes?"
    ) {
        $ErrorCount = [int]$Matches[2]
        $WarningCount = [int]$Matches[3]
        $NoteCount = [int]$Matches[4]
    }
    elseif (
        $OutputText -match
        "(?i)(\d+)\s+errors?,\s*(\d+)\s+warnings?,\s*(\d+)\s+notes?"
    ) {
        $ErrorCount = [int]$Matches[1]
        $WarningCount = [int]$Matches[2]
        $NoteCount = [int]$Matches[3]
    }

    if ($null -ne $ErrorCount) {
        if ($ErrorCount -gt 0) {
            $Status = "FAILURE"
        }
        elseif ($WarningCount -gt 0) {
            $Status = "SUCCESS_WITH_WARNINGS"
        }
        else {
            $Status = "SUCCESS"
        }
    }
    elseif ($JavaExitCode -ne 0) {
        $Status = "FAILURE"
    }

    if ($Status -eq "FAILURE" -or $Status -eq "UNKNOWN") {
        $ScenarioFailed = $true
    }

    $Summary += [PSCustomObject]@{
        Scenario        = $ScenarioName
        File            = $File.Name
        Status          = $Status
        ValidatorExit   = $JavaExitCode
        Errors          = $ErrorCount
        Warnings        = $WarningCount
        Notes           = $NoteCount
        WarningMessages = $WarningMessages
        Report          = $HtmlOutput
        Log             = $TxtOutput
    }

    switch ($Status) {
        "SUCCESS" {
            Write-Host "  SUCCESS" -ForegroundColor Green
        }
        "SUCCESS_WITH_WARNINGS" {
            Write-Host "  SUCCESS_WITH_WARNINGS" -ForegroundColor Yellow
        }
        "FAILURE" {
            Write-Host "  FAILURE" -ForegroundColor Red
            Write-Host "  Validator exit code: $JavaExitCode" -ForegroundColor Red
        }
        default {
            Write-Host "  UNKNOWN" -ForegroundColor Magenta
            Write-Host "  Validator exit code: $JavaExitCode" -ForegroundColor Magenta
        }
    }

    Write-Host ""
}

$SummaryPath = Join-Path $ResultDir "validation-summary.csv"

$Summary |
    Export-Csv `
        -Path $SummaryPath `
        -NoTypeInformation `
        -Encoding UTF8

Write-Host "Validation finished for scenario: $ScenarioName"
Write-Host "Summary written to: $SummaryPath"

if ($ScenarioFailed) {
    Write-Host "Scenario validation contains failures or unknown results." `
        -ForegroundColor Red
    exit 1
}

Write-Host "Scenario validation completed successfully." `
    -ForegroundColor Green

exit 0