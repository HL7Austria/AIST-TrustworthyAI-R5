# Use Cases & Examples

## Use Cases

| Use Case | Title |
|---|---|
| [Use Case 1](use_case1.html) | AI-supported Risk evaluation |
| [Use Case 2](use_case2.html) | AI-generated Diagnostic Report |
{: .grid}

## Examples

The example instances of this IG are grouped into two example sets. All example resources are listed on the [Artifacts](artifacts.html) page.

| Example Set | AI System | AI Output | Related Use Case |
|---|---|---|---|
| [Specialized AI Output Scenario](artifacts.html#2) | [RiskAssist AI](Device-device-riskassist-ai.html) | [Trust_AIObservation](StructureDefinition-trust-ai-observation.html) | [Use Case 1](use_case1.html) |
| [Generalized AI Output Scenario](artifacts.html#1) | [DiagnosticAssist AI](Device-dr-ai-device.html) | [DiagnosticReport](DiagnosticReport-dr-ai-diagnostic-report.html) | [Use Case 2](use_case2.html) |
{: .grid}

### Specialized AI Output Scenario

The specialized example set contains four scenarios based on the same synthetic patient and AI system:

| Scenario | Description | AI Output |
|---|---|---|
| `sc-01-ai-only` | Core AI execution and traceability only | [sc-01-ai-only-ai-observation-risk-001](Observation-sc-01-ai-only-ai-observation-risk-001.html) |
| `sc-02-validation` | AI output accepted by human reviewer | [sc-02-validation-ai-observation-risk-001](Observation-sc-02-validation-ai-observation-risk-001.html) |
| `sc-03-override` | AI output overridden by human reviewer | [sc-03-override-ai-observation-risk-001](Observation-sc-03-override-ai-observation-risk-001.html) |
| `sc-04-correction-exp` | AI output corrected and explained to patient | [sc-04-correction-exp-ai-observation-risk-001](Observation-sc-04-correction-exp-ai-observation-risk-001.html) |
{: .grid}

### Generalized AI Output Scenario

The generalized example set shows how the IG can be used for AI outputs without a dedicated profile. DiagnosticAssist AI generates a draft [DiagnosticReport](DiagnosticReport-dr-ai-diagnostic-report.html) from a lab result, which is validated by a human reviewer before it is shared with the patient. See [Use Case 2](use_case2.html).
