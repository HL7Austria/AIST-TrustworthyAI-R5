# Extensions

The IG defines custom extensions where the FHIR core specification does not sufficiently represent AI transparency, legal context, or regulatory metadata. The *Requirement* column links to the logical attribute on the [Requirements Traceability](requirements.html) page that the extension implements.

## Static System Context

| Extension | Used in | Value | Requirement |
|---|---|---|---|
| [Model Card Reference](StructureDefinition-ext-model-card.html) | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) | Reference to the [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | – |
| [EU Conformity Declaration Reference](StructureDefinition-trust-ai-conformity-reference.html) | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) | Reference to the EU Declaration of Conformity (DocumentReference) | [SYS-03a](requirements.html#sys-03a) |
| [Third-Country Data Transfer](StructureDefinition-third-country-data-transfer.html) | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) | `transferFlag` (boolean), `destinationCountry` (ISO 3166 code) | [LAW-04.1](requirements.html#law-041), [LAW-04.2](requirements.html#law-042) |
| [Trust AI DPIA Reference](StructureDefinition-trust-ai-dpia-reference.html) | [Trust_AIOrganization](StructureDefinition-trust-ai-organization.html) | Reference to the DPIA document (DocumentReference) | [SYS-09](requirements.html#sys-09) |
| [AI Performance Metrics](StructureDefinition-ai-performance-metrics.html) | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | `metric` (`type`, `value`), `biasDisclosure` | [QUAL-01.1](requirements.html#qual-011), [QUAL-01.2](requirements.html#qual-012), [QUAL-04](requirements.html#qual-04) |
| [AI Training Data Metadata](StructureDefinition-ai-training-data.html) | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | `provenance`, `Category`, `SecondaryUsePurpose`, `Permit`, `dataQuality` | [QUAL-02a](requirements.html#qual-02a), [QUAL-02b](requirements.html#qual-02b), [QUAL-02c](requirements.html#qual-02c), [QUAL-03](requirements.html#qual-03) |
| [AI Retention Information](StructureDefinition-ai-retention-information.html) | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | `retention` (Duration) | [LAW-06](requirements.html#law-06) |
| [AI Clinical Validation Status](StructureDefinition-ai-clinical-validation-status.html) | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) | CodeableConcept | – |
{: .grid}

## AI Output Context

| Extension | Used in | Value | Requirement |
|---|---|---|---|
| [Usage Category](StructureDefinition-usage-category.html) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | CodeableConcept (primary or secondary use) | [LAW-03.1](requirements.html#law-031) |
| [Secondary Use Purpose](StructureDefinition-secondary-use-purpose.html) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | CodeableConcept | [LAW-03.2](requirements.html#law-032) |
| [Data Permit](StructureDefinition-data-permit.html) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | Identifier | [LAW-03.2](requirements.html#law-032) |
| [Case-Specific Indication](StructureDefinition-case-specific-indication.html) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | CodeableConcept | [USE-04](requirements.html#use-04) |
| [Automated Decision-Making Flag](StructureDefinition-automated-decision-flag.html) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) | boolean | [LAW-02](requirements.html#law-02) |
| [Trust AI Log Integrity Signature](StructureDefinition-trust-ai-log-integrity.html) | [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html) | Signature | [LAW-08](requirements.html#law-08) |
{: .grid}

## Clinical Decision Context

| Extension | Used in | Value | Requirement |
|---|---|---|---|
| [AI System-Specific Training Status](StructureDefinition-ai-system-training-status.html) | [Trust_AIPractitionerRole](StructureDefinition-trust-ai-practitionerrole.html) | boolean | [HL-02.2](requirements.html#hl-022) |
| [Patient AI Info Provided Flag](StructureDefinition-patient-ai-info-provided-flag.html) | [Trust_AIPatientExplanation](StructureDefinition-trust-ai-patient-explanation.html) | boolean | [LAW-01c](requirements.html#law-01c) |
{: .grid}
