# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A FHIR **R5** Implementation Guide (IG `fhir.ig.trust.aitransparency`, canonical `http://example.org/fhir/trust-ai-transparency`) written in FSH. It models transparency, traceability and human-oversight requirements from the EU AI Act, GDPR and EHDS for clinical AI. It comes out of a Master's thesis at FH Hagenberg. There is also a Python proof of concept in `poc/` that generates synthetic scenarios, maps them to FHIR resources that conform to this IG and validates them.

The profiles (named `Trust_AI*`, with ids `trust-ai-*`) form three traceability layers:
1. **Static system context**: `Trust_AIDevice`, `Trust_AIOrganization`, `Trust_AIModelCard` (a DocumentReference)
2. **AI output context**: `Trust_AIObservation`, `Trust_AIProvenance`, `Trust_AIAuditEvent` (id `trust-ai-machine-execution-audit-event`). There is no longer a Consent profile.
3. **Clinical decision context**: `Trust_AIHumanOversightAssessment` (an ArtifactAssessment), `Trust_AIPractitionerRole`, `Trust_AIPatientExplanation` (a Communication)

`tagging.fsh` defines `TrustAIData`, a generic profile on `Resource` used to tag any AI-generated output. Profiles live one per file in `input/fsh/profile_*.fsh`. Extensions are in `extensions.fsh`, CodeSystems and ValueSets are in `valuesets.fsh`, and the IG pages are in `input/pagecontent/*.md`. `doc/` holds the architecture diagrams (`architecture-*.pdf`/`.txt`) and `documentation_matrices.xlsx`, which maps legal requirements to the profiles.

## Building the IG

```bash
./_updatePublisher.sh     # downloads publisher.jar into input-cache/ (needed once)
sushi .                   # compile FSH only → fsh-generated/ (fast check for FSH errors)
./_genonce.sh             # full IG Publisher run (it also runs SUSHI) → output/
./_gencontinuous.sh       # same, but in watch mode
```

- The `.sh` scripts aren't executable in git, so run them with `bash _genonce.sh`. `ig.ini` points to `fsh-generated/resources/ImplementationGuide-fhir.ig.trust.aitransparency.json`. `_genonce.sh` uses `-tx n/a` when it can't reach tx.fhir.org.
- The outputs you'll check are `output/qa.html` (QA report) and `output/package.tgz` (the IG package the PoC validates against).
- `fsh-generated/`, `input-cache/`, `output/`, `temp/` and `template/` are all generated and gitignored.
- CI (`.github/workflows/deploy.yml`) builds on every push and PR to `main` and publishes to `HL7Austria/hl7austria.github.io` under `r5-aist-trustworthyai-<branch>`.

## PoC pipeline (`poc/`)

The data flows one way, and each stage reads the previous stage's files from disk:

```
poc/input/base_case.json + poc/config/scenario_*.json
  → simulate_ai_output.py   → poc/output/metadata/<scenarioOutputId>.json
  → mapper.py               → poc/output/fhir/<scenarioOutputId>/*.json
  → validate-scenario.ps1   → poc/validation/results/<scenarioOutputId>/
```

- **Run the Python scripts from the repo root.** They use hardcoded relative paths such as `Path("poc/output/metadata")`. The sibling imports (`from fhir_utils import ...`) work because the scripts are run directly. On this Linux machine use `python3`:
  ```bash
  python3 poc/src/simulate_ai_output.py
  python3 poc/src/mapper.py
  ```
- `simulate_ai_output.py` holds all the simulation and decision logic: NEWS2-inspired scoring via `news2_scoring.py`, AI output, audit, provenance, oversight, corrections and patient explanations. Each scenario config (`aiOutputConfig`, `humanOversightConfig` with modes such as validation, override and correction, and `patientExplanationConfig`) is merged over `base_case.json`. The `fhirMapping` section of `base_case.json` supplies the coded values the mapper uses.
- `mapper.py` is only a transformation step and must not infer clinical, legal or workflow decisions. It has one `map_*` function per resource type, and `map_scenario()` assembles them. The profile, extension and CodeSystem URLs are constants at the top of the file and **must stay in sync with the `Id:` values in the FSH files**.
- Resource IDs are prefixed with the scenario (`make_scenario_resource_id`), for example `sc-02-validation-...`.
- The pipeline and validation scripts are PowerShell (`poc/run-pipeline-poc.ps1`). It accepts `-BuildIG`, `-Clean`, `-SkipValidation` and `-ScenarioName <id>`. pwsh isn't installed here, so on Linux run the Python steps directly.
- To validate a single scenario, run `.\validate-scenario.ps1 -ScenarioName sc-02-validation` from `poc/validation/`. It expects `validator_cli.jar` in `poc/validation/` (the jar isn't committed, and you can get it from https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar) and `output/package.tgz` from an IG build. On Linux you can call the validator directly:
  ```bash
  java -jar validator_cli.jar poc/output/fhir/sc-02-validation/*.json -version 5.0.0 -ig output/package.tgz
  ```
- You only need to rebuild the IG (`-BuildIG` / `./_genonce.sh`) after changing FSH, `sushi-config.yaml` or the example instances. Changes to the Python code or the scenario JSON can reuse the existing `package.tgz`.
- There are no unit tests. The FHIR Validator results are the test.

## Coupling between the IG examples and the PoC

`input/fsh/instances.fsh` hand-writes the **sc-02-validation** PoC scenario as IG examples, and `sushi-config.yaml` → `resources:` lists descriptions for those instance IDs. `instance_2.fsh` holds a separate example (an AI-generated DiagnosticReport) that isn't part of the PoC. If you change the mapper output shape, the base case or a profile, update all three so they stay consistent. All data is synthetic, and the NEWS2 scoring is deliberately simplified and not clinically valid.
