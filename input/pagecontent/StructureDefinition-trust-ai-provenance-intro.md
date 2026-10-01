### Regulatory Requirements

This profile is part of the **AI Output Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-10](requirements.html#req-sys-10) | AI Act Art. 12 / EHDS ANNEX II (3) | Audit Trail & Access Logging | Dynamic |
| [USE-04](requirements.html#req-use-04) | GDPR Art. 5(1) | Case-Specific Indication | Dynamic |
| [LAW-01a](requirements.html#req-law-01a) | GDPR Art. 6(1) | Legal Basis (General) | Dynamic |
| [LAW-01b](requirements.html#req-law-01b) | GDPR Art. 9(2) | Health Data Exception | Dynamic |
| [LAW-02](requirements.html#req-law-02) | GDPR Art. 22 | Automated Decision Flag | Dynamic |
| [LAW-03](requirements.html#req-law-03) | EHDS Art. 51 / 52 | Data Provenance (Primary/Secondary) | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-10.1](requirements.html#sys-101) | Execution Period (Start/End) | 1..1 | [`Provenance.occurredPeriod`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.occurredPeriod) | ✅ Covered | Also: [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html), [Trust_AIObservation](StructureDefinition-trust-ai-observation.html). |
| [SYS-10.2](requirements.html#sys-102) | Input Data Reference | 1..* | [`Provenance.entity`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.entity) | ✅ Covered | `entity.role` = source. |
| [USE-04](requirements.html#use-04) | Case-Specific Indication | 1..* | [`Provenance.extension:caseIndication`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.extension:caseIndication) | ✅ Covered | Extension `case-specific-indication`. |
| [LAW-01a](requirements.html#law-01a) | Legal Basis Code | 1..1 | [`Provenance.authorization:gdprArt6Basis`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.authorization:gdprArt6Basis) | ✅ Covered | GDPRArt6LegalBasisVS. |
| [LAW-01b](requirements.html#law-01b) | Special Category Exception Code | 1..1 | [`Provenance.authorization:gdprArt9Condition`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.authorization:gdprArt9Condition) | ✅ Covered | GDPRArt9ConditionVS. |
| [LAW-02](requirements.html#law-02) | Automated Decision Flag | 1..1 | [`Provenance.extension:automatedDecision`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.extension:automatedDecision) | ✅ Covered | Extension `automated-decision-flag`. |
| [LAW-03.1](requirements.html#law-031) | Provenance Category | 1..1 | [`Provenance.extension:usageCategory`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.extension:usageCategory) | ✅ Covered | UsageCategoryVS. |
| [LAW-03.2](requirements.html#law-032) | Data Permit Reference | 0..1 | [`Provenance.extension:dataPermit`](StructureDefinition-trust-ai-provenance-definitions.html#Provenance.extension:dataPermit) | ✅ Covered | Complemented by `secondaryUsePurpose`. |
{: .grid}
