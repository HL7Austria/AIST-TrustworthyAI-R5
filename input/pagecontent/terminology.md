# Terminology

The Implementation Guide defines custom terminology where existing FHIR terminologies do not sufficiently represent AI transparency concepts. It contains 16 CodeSystems and 12 ValueSets.

## AI Transparency and Documentation

| Code System | Codes | Value Set (Binding) | Used in |
|---|---|---|---|
| [Trust AI Involvement](CodeSystem-trust-ai-involvement-cs.html) | `ai-generated`, `ai-assisted`, `ai-reported`, `ai-asserted` | [Trust AI Involvement](ValueSet-trust-ai-involvement-vs.html) (required) | [TrustAIData](StructureDefinition-trust-ai-data.html) `meta.security`, [Trust_AIObservation](StructureDefinition-trust-ai-observation.html) `interpretation` |
| [Trust AI Performance Metric](CodeSystem-trust-ai-performance-metric-cs.html) | `accuracy`, `sensitivity`, `specificity`, `robustness` | [Trust AI Performance Metric](ValueSet-trust-ai-performance-metric-vs.html) (extensible) | [AI Performance Metrics](StructureDefinition-ai-performance-metrics.html) |
| [Trust AI Clinical Validation Status](CodeSystem-trust-ai-clinical-validation-status-cs.html) | `clinically-validated`, `not-clinically-validated`, `validation-in-progress`, `technical-validation-only` | [Trust AI Clinical Validation Status](ValueSet-trust-ai-clinical-validation-status-vs.html) (required) | [AI Clinical Validation Status](StructureDefinition-ai-clinical-validation-status.html) |
| [Trust AI Data Quality](CodeSystem-trust-ai-data-quality-cs.html) | `representative`, `error-free`, `complete`, `relevant` | [Trust AI Data Quality](ValueSet-trust-ai-data-quality-vs.html) (extensible) | [AI Training Data Metadata](StructureDefinition-ai-training-data.html) |
| [Trust AI Case-Specific Indication](CodeSystem-trust-ai-case-specific-indication-cs.html) | `triage`, `screening`, `second-opinion`, `diagnostic-support`, `treatment-planning`, `prognosis` | [Trust AI Case-Specific Indication](ValueSet-trust-ai-case-specific-indication-vs.html) (extensible) | [Case-Specific Indication](StructureDefinition-case-specific-indication.html) |
{: .grid}

## Human Oversight

| Code System | Codes | Value Set (Binding) | Used in |
|---|---|---|---|
| [Trust AI Human Oversight](CodeSystem-trust-ai-human-oversight-cs.html) | `human-validation`, `human-override`, `human-correction` | [Trust AI Human Oversight Action](ValueSet-trust-ai-human-oversight-action-vs.html) (extensible) | [Trust_AIHumanOversightAssessment](StructureDefinition-trust-ai-human-oversight.html) `content.classifier` |
{: .grid}

## GDPR

| Code System | Codes | Value Set (Binding) | Used in |
|---|---|---|---|
| [GDPR Article 6 Legal Basis](CodeSystem-gdpr-art6-codesystem.html) | Art. 6(1)(a) to (f) | [GDPR Article 6 Legal Basis](ValueSet-gdpr-art6-legal-basis-vs.html) (required) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) `authorization` |
| [GDPR Article 9 Condition](CodeSystem-gdpr-art9-codesystem.html) | Art. 9(2)(a), (c), (g), (h), (i), (j) | [GDPR Article 9 Condition](ValueSet-gdpr-art9-condition-vs.html) (required) | [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html) `authorization` |
{: .grid}

## European Health Data Space (EHDS)

| Code System | Codes | Value Set (Binding) | Used in |
|---|---|---|---|
| [Usage Category](CodeSystem-usage-category-cs.html) | `primary-use`, `secondary-use` | [Usage Category](ValueSet-usage-category-vs.html) (required) | [Usage Category](StructureDefinition-usage-category.html) |
| [Data Category](CodeSystem-data-category-cs.html) | 17 categories of electronic health data for secondary use | [Data Category](ValueSet-data-category-vs.html) (extensible) | [AI Training Data Metadata](StructureDefinition-ai-training-data.html) |
| [Secondary-Use Purpose](CodeSystem-secondary-use-purpose-cs.html) | 8 permitted purposes of secondary use | [Secondary-Use Purpose](ValueSet-secondary-use-purpose-vs.html) (required in [Secondary Use Purpose](StructureDefinition-secondary-use-purpose.html), extensible in [AI Training Data Metadata](StructureDefinition-ai-training-data.html)) | [Secondary Use Purpose](StructureDefinition-secondary-use-purpose.html), [AI Training Data Metadata](StructureDefinition-ai-training-data.html) |
{: .grid}

## Structural Codes

These code systems provide fixed codes that identify slices and document types within the profiles.

| Code System | Codes | Value Set (Binding) | Used in |
|---|---|---|---|
| [Trust AI Contact Purpose](CodeSystem-trust-ai-contact-purpose-cs.html) | `dpo`, `ai-incident-reporting` | – | [Trust_AIOrganization](StructureDefinition-trust-ai-organization.html) `contact.purpose` |
| [Trust AI Artifact Type](CodeSystem-trust-ai-artifact-type-cs.html) | `model-card` | – | [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) `type` |
| [Trust AI Identifier Type](CodeSystem-trust-ai-identifier-type-cs.html) | `trust-ai-registration-number` | – | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) `identifier.type` |
| [Trust AI System Property](CodeSystem-trust-ai-system-property-cs.html) | `ce-mark`, `notified-body-id`, `expected-lifetime`, `intended-purpose`, `target-population` | – | [Trust_AIDevice](StructureDefinition-trust-ai-device.html) `property.type` |
| [Trust AI Audit Entity Role](CodeSystem-trust-ai-audit-entity-role.html) | `reference-database`, `ai-output` | [Trust AI Audit Entity Role](ValueSet-trust-ai-audit-entity-role-vs.html) | [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html) `entity.role` |
{: .grid}
