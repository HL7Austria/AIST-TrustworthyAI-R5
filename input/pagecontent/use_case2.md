## Overview

| **Element** | **Description** |
|---|---|
| **Actor** | [Example Diagnostic Center](Organization-dr-organization.html), the simulated [DiagnosticAssist AI](Device-dr-ai-device.html) diagnostic support system and a [human reviewer](PractitionerRole-dr-practitioner-role.html) |
| **Description** | DiagnosticAssist AI analyses a patient's laboratory result (C-reactive protein) and generates a draft diagnostic report. The AI output is represented as a standard FHIR DiagnosticReport that is marked as AI-generated, instead of a dedicated Trust AI output profile. A human reviewer validates the report before the patient is informed about the AI involvement. |
| **Trigger** | A laboratory result for the patient is available and submitted to DiagnosticAssist AI for diagnostic assessment. |
| **Preconditions** | The patient and the input observation are available as structured clinical data, the DiagnosticAssist AI system is registered with its model card and conformity declaration, and the responsible organization and human reviewer are configured. |
| **Result** | An AI-generated DiagnosticReport is linked to its input observation, AI system, provenance and audit information, a documented human validation and a patient-facing explanation. |
{: .grid}

## Description

Use Case 2 demonstrates the **generalized AI output** approach of this IG. Not every AI output fits a dedicated profile such as [Trust_AIObservation](StructureDefinition-trust-ai-observation.html). This use case shows how any FHIR resource, here a DiagnosticReport, can be documented as an AI output using the generic transparency pattern of the IG.

The AI involvement is recorded directly on the output resource: the DiagnosticReport carries a `meta.security` tag with the code `ai-generated` from the [Trust AI Involvement Code System](CodeSystem-trust-ai-involvement-cs.html), the resource-independent marking defined by the [TrustAIData](StructureDefinition-trust-ai-data.html) profile. All further transparency information is attached through the same profiles as in the specialized use case:

1. **Static System Context:** the AI system ([Trust_AIDevice](StructureDefinition-trust-ai-device.html)) is owned by the responsible organization and references its model card and EU conformity declaration.
2. **AI Output Context:** the provenance record documents the input observation, the AI system as agent, the GDPR legal basis (Art. 6(1)(d) and Art. 9(2)(h)), primary use, the case-specific indication "diagnostic support" and that no automated decision was made. The audit event records the generation of the report.
3. **Clinical Decision Context:** a human reviewer validates the AI-generated report, and a patient-facing communication informs the patient that the report was generated with AI support and reviewed by a clinician.

In contrast to [Use Case 1](use_case1.html), this scenario is a single standalone example and is not part of the PoC pipeline.

## Related FHIR Resources

The following resources represent Use Case 2 in this IG. All of them belong to the [Generalized AI Output Scenario](artifacts.html#1) example set.

| Context | Resource | Profile | Example |
|---|---|---|---|
| Clinical context | Patient | – | [dr-patient](Patient-dr-patient.html) |
| Clinical context | Input Observation | – | [dr-input-observation](Observation-dr-input-observation.html) |
| Static System Context | AI System | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) | [dr-ai-device](Device-dr-ai-device.html) |
| Static System Context | Model Card | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | [dr-model-card](DocumentReference-dr-model-card.html) |
| Static System Context | EU Conformity Declaration | – | [eu-conformity-declaration-2](DocumentReference-eu-conformity-declaration-2.html) |
| Static System Context | Responsible Organization | [Trust_AIOrganization](StructureDefinition-trust-ai-organization.html) | [dr-organization](Organization-dr-organization.html) |
| AI Output Context | AI Output | DiagnosticReport, tagged as described by [TrustAIData](StructureDefinition-trust-ai-data.html) | [dr-ai-diagnostic-report](DiagnosticReport-dr-ai-diagnostic-report.html) |
| AI Output Context | Execution Trace | [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html) | [dr-ai-audit-event](AuditEvent-dr-ai-audit-event.html) |
| AI Output Context | Provenance | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | [dr-ai-provenance](Provenance-dr-ai-provenance.html) |
| Clinical Decision Context | Human Reviewer | [Trust_AIPractitionerRole](StructureDefinition-trust-ai-practitionerrole.html) | [dr-practitioner-role](PractitionerRole-dr-practitioner-role.html), [dr-practitioner](Practitioner-dr-practitioner.html) |
| Clinical Decision Context | Human Oversight | [Trust_AIHumanOversightAssessment](StructureDefinition-trust-ai-human-oversight.html) | [dr-human-assessment](ArtifactAssessment-dr-human-assessment.html) |
| Clinical Decision Context | Patient Explanation | [Trust_AIPatientExplanation](StructureDefinition-trust-ai-patient-explanation.html) | [dr-patient-communication](Communication-dr-patient-communication.html) |
{: .grid}
