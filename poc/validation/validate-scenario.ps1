param(
    [Parameter(Mandatory = $true)]
    [string]$ScenarioName
)

$Validator = Resolve-Path ".\validator_cli.jar"
$IgPackage = Resolve-Path "..\..\output\package.tgz"
$FhirVersion = "5.0.0"

$ScenarioDir = Resolve-Path "..\output\fhir\$ScenarioName"
$ResultDir = ".\results\$ScenarioName"

New-Item -ItemType Directory -Force -Path $ResultDir | Out-Null

$Files = Get-ChildItem $ScenarioDir -Filter "*.json"

if ($Files.Count -eq 0) {
    Write-Host "No FHIR JSON files found in $ScenarioDir"
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

foreach ($File in $Files) {
    $ResourceName = $File.BaseName

    $HtmlOutput = Join-Path $ResultDir "$ResourceName-validation.html"
    $TxtOutput = Join-Path $ResultDir "$ResourceName-validation.txt"

    Write-Host "Validating $($File.Name) ..."

    $Output = & java -jar "$Validator" "$($File.FullName)" `
        -version $FhirVersion `
        -ig "$IgPackage" `
        -html-output "$HtmlOutput" 2>&1

    $Output | Out-File -FilePath $TxtOutput -Encoding utf8

    $Status = "UNKNOWN"
    $ErrorCount = $null
    $WarningCount = $null
    $NoteCount = $null

    $OutputText = Get-Content -Path $TxtOutput -Raw

    $WarningMessages = (
        $OutputText -split "`r?`n" |
        Where-Object { $_ -match "^\s*Warning @" } |
        ForEach-Object { $_.Trim() }
    ) -join " | "

    if ($OutputText -match "(?i)(success|\*success\*|\*failure\*|failure):?\s*(\d+)\s+errors?,\s*(\d+)\s+warnings?,\s*(\d+)\s+notes?") {
        $ErrorCount = [int]$Matches[2]
        $WarningCount = [int]$Matches[3]
        $NoteCount = [int]$Matches[4]

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
    elseif ($OutputText -match "(?i)(\d+)\s+errors?,\s*(\d+)\s+warnings?,\s*(\d+)\s+notes?") {
        $ErrorCount = [int]$Matches[1]
        $WarningCount = [int]$Matches[2]
        $NoteCount = [int]$Matches[3]

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

    $Summary += [PSCustomObject]@{
        Scenario        = $ScenarioName
        File            = $File.Name
        Status          = $Status
        Errors          = $ErrorCount
        Warnings        = $WarningCount
        Notes           = $NoteCount
        WarningMessages = $WarningMessages
        Report          = $HtmlOutput
        Log             = $TxtOutput
    }

    if ($Status -eq "SUCCESS") {
        Write-Host "  SUCCESS" -ForegroundColor Green
    }
    elseif ($Status -eq "SUCCESS_WITH_WARNINGS") {
        Write-Host "  SUCCESS_WITH_WARNINGS" -ForegroundColor Green
    }
    elseif ($Status -eq "FAILURE") {
        Write-Host "  FAILURE" -ForegroundColor Red
    }
    else {
        Write-Host "  UNKNOWN" -ForegroundColor Magenta
    }

    Write-Host ""
}

$SummaryPath = Join-Path $ResultDir "validation-summary.csv"
$Summary | Export-Csv -Path $SummaryPath -NoTypeInformation -Encoding UTF8

Write-Host "Validation finished for scenario: $ScenarioName"
Write-Host "Summary written to: $SummaryPath"