<#
.SYNOPSIS
    Runs the complete PoC pipeline from inside the poc folder.

.DESCRIPTION
    Expected layout:
      project-root/
        sushi-config.yaml
        input-cache/publisher.jar
        output/package.tgz
        poc/
          run-pipeline.ps1
          input/base_case.json
          config/scenario_*.json
          src/simulate_ai_output.py
          src/mapper.py
          src/fhir_utils.py
          src/news2_scoring.py
          validation/validate-scenario.ps1

    Optional full pipeline:
      1. Build the Implementation Guide with SUSHI and the IG Publisher
      2. Generate scenario metadata with src/simulate_ai_output.py
      3. Map metadata to FHIR JSON resources with src/mapper.py
      4. Validate generated scenario resources with validation/validate-scenario.ps1

.EXAMPLE
    .\run-pipeline.ps1
    Runs metadata generation, FHIR mapping and validation using the existing IG package.

.EXAMPLE
    .\run-pipeline.ps1 -BuildIG
    Builds the IG first, then regenerates metadata/FHIR resources and validates all scenarios.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\run-pipeline.ps1 -BuildIG
    Same as above, but bypasses local PowerShell script blocking for this single run.
#>

param(
    [switch]$BuildIG,
    [switch]$Clean,
    [switch]$SkipValidation,
    [string]$ScenarioName,

    # Defaults assume this script is placed in project-root/poc and started from there.
    [string]$PocDir = ".",
    [string]$SourceDir = ".\src",
    [string]$IgRootDir = "..",
    [string]$PublisherJar = ".\input-cache\publisher.jar",
    [string]$ValidatorScript = ".\validation\validate-scenario.ps1",
    [string]$IgPackage = "..\output\package.tgz",
    [string]$PythonCommand = "python"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Assert-PathExists {
    param(
        [string]$Path,
        [string]$Description
    )

    if (-not (Test-Path $Path)) {
        throw "$Description not found: $Path"
    }
}

function Invoke-CheckedCommand {
    param(
        [string]$DisplayName,
        [scriptblock]$Command
    )

    Write-Host "Running: $DisplayName" -ForegroundColor Yellow
    & $Command

    if ($LASTEXITCODE -ne 0) {
        throw "$DisplayName failed with exit code $LASTEXITCODE"
    }
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $ScriptDir

try {
    $PocDir = (Resolve-Path $PocDir).Path
    $SourceDir = (Resolve-Path $SourceDir).Path
    $IgRootDir = (Resolve-Path $IgRootDir).Path

    $MetadataOutputDir = Join-Path $PocDir "output\metadata"
    $FhirOutputDir = Join-Path $PocDir "output\fhir"
    $ValidationResultsDir = Join-Path $PocDir "validation\results"

    if ($Clean) {
        Write-Step "Cleaning generated PoC output"
        foreach ($Dir in @($MetadataOutputDir, $FhirOutputDir, $ValidationResultsDir)) {
            if (Test-Path $Dir) {
                Write-Host "Removing $Dir"
                Remove-Item -Recurse -Force $Dir
            }
        }
    }

    if ($BuildIG) {
        Write-Step "Building Implementation Guide"

        Push-Location $IgRootDir
        try {
            Assert-PathExists ".\sushi-config.yaml" "SUSHI config"
            Assert-PathExists $PublisherJar "IG Publisher JAR"

            Invoke-CheckedCommand "SUSHI" {
                sushi .
            }

            Invoke-CheckedCommand "IG Publisher" {
                java -jar $PublisherJar -ig .
            }
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Step "Skipping IG build"
        Write-Host "Using existing IG package. Re-run with -BuildIG after changes to FSH profiles, extensions, CodeSystems or ValueSets."
    }

    Write-Step "Checking required files"
    Assert-PathExists (Join-Path $PocDir "input\base_case.json") "Base case JSON"
    Assert-PathExists (Join-Path $PocDir "config") "Scenario config directory"
    Assert-PathExists (Join-Path $SourceDir "simulate_ai_output.py") "Scenario metadata generator"
    Assert-PathExists (Join-Path $SourceDir "mapper.py") "FHIR mapper"
    Assert-PathExists (Join-Path $SourceDir "fhir_utils.py") "FHIR utility module"
    Assert-PathExists (Join-Path $SourceDir "news2_scoring.py") "NEWS2 scoring module"

    if (-not $SkipValidation) {
        Assert-PathExists $IgPackage "IG package"
        Assert-PathExists $ValidatorScript "Validation script"
    }

    # Important:
    # The Python scripts use paths such as poc/input/base_case.json.
    # Therefore, they are executed from the project root, not from poc.
    Write-Step "Generating scenario metadata"
    Push-Location $IgRootDir
    try {
        Invoke-CheckedCommand "simulate_ai_output.py" {
            & $PythonCommand ".\poc\src\simulate_ai_output.py"
        }
    }
    finally {
        Pop-Location
    }

    Write-Step "Mapping metadata to FHIR JSON resources"
    Push-Location $IgRootDir
    try {
        Invoke-CheckedCommand "mapper.py" {
            & $PythonCommand ".\poc\src\mapper.py"
        }
    }
    finally {
        Pop-Location
    }

    if ($SkipValidation) {
        Write-Step "Skipping validation"
    }
    else {
        Write-Step "Validating generated FHIR resources"

        $ScenarioDirs = @()
        if ([string]::IsNullOrWhiteSpace($ScenarioName)) {
            Assert-PathExists $FhirOutputDir "FHIR output directory"
            $ScenarioDirs = Get-ChildItem -Path $FhirOutputDir -Directory | Sort-Object Name
        }
        else {
            $ScenarioPath = Join-Path $FhirOutputDir $ScenarioName
            Assert-PathExists $ScenarioPath "Requested scenario output directory"
            $ScenarioDirs = @(Get-Item $ScenarioPath)
        }

        if ($ScenarioDirs.Count -eq 0) {
            throw "No generated scenario folders found in $FhirOutputDir"
        }

        $ValidatorScriptPath = (Resolve-Path $ValidatorScript).Path
        $ValidatorScriptDir = Split-Path -Parent $ValidatorScriptPath
        $ValidatorScriptFile = Split-Path -Leaf $ValidatorScriptPath

        $FailedScenarios = @()

        foreach ($ScenarioDir in $ScenarioDirs) {
            Write-Host ""
            Write-Host "Validating scenario: $($ScenarioDir.Name)" -ForegroundColor Yellow

            $ScenarioExitCode = 0

            Push-Location $ValidatorScriptDir
            try {
                & ".\$ValidatorScriptFile" -ScenarioName $ScenarioDir.Name
                $ScenarioExitCode = $LASTEXITCODE
            }
            catch {
                $ScenarioExitCode = 1

                Write-Host `
                    "Validation script failed for $($ScenarioDir.Name): $($_.Exception.Message)" `
                    -ForegroundColor Red
            }
            finally {
                Pop-Location
            }

            if ($ScenarioExitCode -ne 0) {
                $FailedScenarios += $ScenarioDir.Name

                Write-Host `
                    "Scenario $($ScenarioDir.Name) contains validation failures. Continuing with the next scenario." `
                    -ForegroundColor Red
            }
            else {
                Write-Host `
                    "Scenario $($ScenarioDir.Name) passed validation." `
                    -ForegroundColor Green
            }
        }

        if ($FailedScenarios.Count -gt 0) {
            Write-Host ""
            Write-Host "Scenarios with validation failures:" -ForegroundColor Red

            foreach ($FailedScenario in $FailedScenarios) {
                Write-Host " - $FailedScenario" -ForegroundColor Red
            }

            throw "$($FailedScenarios.Count) scenario(s) contain validation failures."
        }
    }

    Write-Step "Pipeline finished"
    Write-Host "Metadata output:   $MetadataOutputDir"
    Write-Host "FHIR output:       $FhirOutputDir"
    if (-not $SkipValidation) {
        Write-Host "Validation output: $ValidationResultsDir"
    }
    if ($BuildIG) {
        Write-Host "IG QA report:      $(Join-Path $IgRootDir 'output\qa.html')"
        Write-Host "IG package:        $(Join-Path $IgRootDir 'output\package.tgz')"
    }
}
catch {
    Write-Host ""
    Write-Host "Pipeline failed:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location
}