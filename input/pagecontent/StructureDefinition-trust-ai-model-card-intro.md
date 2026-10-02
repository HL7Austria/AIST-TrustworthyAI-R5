### Regulatory Requirements

This profile is part of the **Static System Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-04](requirements.html#req-sys-04) | AI Act Annex IV 1 | Hardware/Software Interfaces | Static |
| [SYS-05](requirements.html#req-sys-05) | AI Act Art. 11 / Annex IV | Full Technical Documentation Ref. | Static |
| [SYS-06](requirements.html#req-sys-06) | AI Act Art. 13(3) | Explainability / Interpretation Aids | Static |
| [SYS-07](requirements.html#req-sys-07) | AI Act Art. 13(3) | Expected Lifetime & Maintenance | Static |
| [USE-02](requirements.html#req-use-02) | AI Act Art. 13 (3) | Limitations & Contraindications | Static |
| [USE-03](requirements.html#req-use-03) | GDPR Art. 13(1) / AI Act Art. 13 (3) | Scope and Clinical Consequences | Static |
| [QUAL-01](requirements.html#req-qual-01) | AI Act Art. 13(3) | Performance Metrics | Static |
| [QUAL-02a](requirements.html#req-qual-02a) | AI Act Art. 10 | Training Data Info | Static |
| [QUAL-02b](requirements.html#req-qual-02b) | EHDS Art. 512 | Secondary Use Category & Permit | Static |
| [QUAL-03](requirements.html#req-qual-03) | EHDS Art. 78 | Data Quality Label | Static |
| [QUAL-04](requirements.html#req-qual-04) | AI Act Art. 13(3)(b)(v) | Target Group Performance | Static |
| [RISK-01](requirements.html#req-risk-01) | AI Act Art. 9(2) / Art. 13(3)(b) | Health & Fundamental Rights Risks | Static |
| [HL-04](requirements.html#req-hl-04) | AI Act Art. 14(3) | Oversight Instructions | Static |
| [LAW-06](requirements.html#req-law-06) | GDPR Art. 13(2) | Data Retention Period | Static |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-04](requirements.html#sys-04) | Hardware/Software Interfaces | 1..* | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered | Documented in the linked technical documentation. |
| [SYS-05](requirements.html#sys-05) | Full Technical Doc. Ref. | 1..1 | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered | `attachment.url` points to the full technical documentation. |
| [SYS-06](requirements.html#sys-06) | Explainability/Interpretation Aids | 0..* | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered |  |
| [SYS-07.2](requirements.html#sys-072) | Maintenance Requirements | 1..1 | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered | Maintenance and update requirements are part of the technical documentation. Also: [Trust_AIDevice](StructureDefinition-trust-ai-device.html). |
| [USE-02.1](requirements.html#use-021) | Medical Contraindications | 0..* | [`DocumentReference.description`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.description), [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ⚠️ Partial | Narrative only; no coded, repeatable contraindication element. |
| [USE-02.2](requirements.html#use-022) | Technical Limitations | 0..* | [`DocumentReference.description`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.description), [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ⚠️ Partial | Narrative only; no coded, repeatable limitation element. |
| [USE-03](requirements.html#use-03) | Scope and Clinical Consequences | 1..1 | [`DocumentReference.description`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.description) | ✅ Covered |  |
| [QUAL-01.1](requirements.html#qual-011) | Metric Type Code | 1..* | [`DocumentReference.extension:performance`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:performance) | ✅ Covered | Sub-extension `metric.type` (TrustAIPerformanceMetricVS). |
| [QUAL-01.2](requirements.html#qual-012) | Metric Value | 1..* | [`DocumentReference.extension:performance`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:performance) | ✅ Covered | Sub-extension `metric.value` (Quantity). |
| [QUAL-02a](requirements.html#qual-02a) | Data Provenance Description | 1..1 | [`DocumentReference.extension:training`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:training) | ✅ Covered | Sub-extension `provenance`. |
| [QUAL-02b](requirements.html#qual-02b) | EHDS Data Category | 0..* | [`DocumentReference.extension:training`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:training) | ✅ Covered | Sub-extension `Category` (DataCategoryVS). |
| [QUAL-02c](requirements.html#qual-02c) | Training Data Permit Ref. | 0..* | [`DocumentReference.extension:training`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:training) | ✅ Covered | Sub-extension `Permit` (Identifier). |
| [QUAL-03](requirements.html#qual-03) | Data Quality Label | 1..1 | [`DocumentReference.extension:training`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:training) | ⚠️ Partial | Sub-extension `dataQuality` is 0..*, while the matrix requires 1..1. |
| [QUAL-04](requirements.html#qual-04) | Target Group Performance | 0..* | [`DocumentReference.extension:performance`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:performance) | ✅ Covered | Sub-extension `biasDisclosure`. |
| [RISK-02.1](requirements.html#risk-021) | Health/Safety Risks | 0..* | [`DocumentReference.description`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.description) | ⚠️ Partial | Narrative summary only. |
| [RISK-02.2](requirements.html#risk-022) | Fundamental Rights Risks | 0..* | [`DocumentReference.description`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.description) | ⚠️ Partial | Narrative summary only. |
| [RISK-02.3](requirements.html#risk-023) | Residual Risk Mitigation | 1..1 | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered | Instructions for use / risk management documentation. |
| [HL-04](requirements.html#hl-04) | Oversight Instructions | 1..1 | [`DocumentReference.content.attachment`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.content.attachment) | ✅ Covered |  |
| [LAW-06](requirements.html#law-06) | Data Retention Period | 1..1 | [`DocumentReference.extension:privacy`](StructureDefinition-trust-ai-model-card-definitions.html#DocumentReference.extension:privacy) | ✅ Covered | Sub-extension `retention` (Duration). |
{: .grid}
