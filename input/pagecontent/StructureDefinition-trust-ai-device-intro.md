### Regulatory Requirements

This profile is part of the **Static System Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-01](requirements.html#req-sys-01) | AI Act Annex IV 1 | System Name & Version | Static |
| [SYS-02](requirements.html#req-sys-02) | GDPR Art. 13 / AI Act Annex IV 1 | Manufacturer / Provider | Static |
| [SYS-03a](requirements.html#req-sys-03a) | AI Act Art. 47 | EU Declaration of Conformity | Static |
| [SYS-03b](requirements.html#req-sys-03b) | AI Act Art. 48 | Digital CE Marking & Notified Body ID | Static |
| [SYS-03c](requirements.html#req-sys-03c) | AI Act Art. 15 | Cybersecurity Status | Static |
| [SYS-07](requirements.html#req-sys-07) | AI Act Art. 13(3) | Expected Lifetime & Maintenance | Static |
| [SYS-11](requirements.html#req-sys-11) | AI Act Art. 49 | EU Database Registration ID | Static |
| [SYS-12](requirements.html#req-sys-12) | AI Act Art. 17 | QMS Certification | Static |
| [USE-01](requirements.html#req-use-01) | AI Act Art. 13 (3) / GDPR Art. 5 | Intended Purpose | Static |
| [LAW-04](requirements.html#req-law-04) | GDPR Art. 13(1)(f) / Art. 44 | Third-Country Data Transfer | Static |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-01.1](requirements.html#sys-011) | System Name | 1..1 | [`Device.name`](StructureDefinition-trust-ai-device-definitions.html#Device.name) | ✅ Covered |  |
| [SYS-01.2](requirements.html#sys-012) | System Version | 1..1 | [`Device.version`](StructureDefinition-trust-ai-device-definitions.html#Device.version) | ✅ Covered |  |
| [SYS-02.1](requirements.html#sys-021) | Manufacturer Name | 1..1 | [`Device.manufacturer`](StructureDefinition-trust-ai-device-definitions.html#Device.manufacturer), [`Device.owner`](StructureDefinition-trust-ai-device-definitions.html#Device.owner) | ✅ Covered | `owner` references the responsible Trust_AIOrganization. |
| [SYS-03a](requirements.html#sys-03a) | EU Declaration of Conformity | 1..1 | [`Device.extension:conformityDeclaration`](StructureDefinition-trust-ai-device-definitions.html#Device.extension:conformityDeclaration) | ✅ Covered | Extension `trust-ai-conformity-reference` → DocumentReference of the declaration. |
| [SYS-03b.1](requirements.html#sys-03b1) | CE Marking Flag | 1..1 | [`Device.property:ceMark`](StructureDefinition-trust-ai-device-definitions.html#Device.property:ceMark) | ✅ Covered |  |
| [SYS-03b.2](requirements.html#sys-03b2) | Notified Body ID | 0..1 | [`Device.property:notifiedBody`](StructureDefinition-trust-ai-device-definitions.html#Device.property:notifiedBody) | ✅ Covered |  |
| [SYS-03c](requirements.html#sys-03c) | Cybersecurity Status | 1..1 | [`Device.conformsTo`](StructureDefinition-trust-ai-device-definitions.html#Device.conformsTo) | ⚠️ Partial | No dedicated element; applied security standards can be listed in `conformsTo`, but a reference to the cybersecurity test report is not modelled. |
| [SYS-07.1](requirements.html#sys-071) | Expected Lifetime | 1..1 | [`Device.property:expectedLifetime`](StructureDefinition-trust-ai-device-definitions.html#Device.property:expectedLifetime) | ✅ Covered |  |
| [SYS-07.2](requirements.html#sys-072) | Maintenance Requirements | 1..1 | [`Device.conformsTo`](StructureDefinition-trust-ai-device-definitions.html#Device.conformsTo) | ✅ Covered | Maintenance and update requirements are part of the technical documentation. Also: [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html). |
| [SYS-11](requirements.html#sys-11) | EU Database Registration ID | 1..1 | [`Device.identifier:euDatabaseId`](StructureDefinition-trust-ai-device-definitions.html#Device.identifier:euDatabaseId) | ✅ Covered |  |
| [SYS-12](requirements.html#sys-12) | QMS Certification | 1..1 | [`Device.conformsTo`](StructureDefinition-trust-ai-device-definitions.html#Device.conformsTo) | ✅ Covered | QMS certification in `conformsTo`; the AI incident reporting contact supports the QMS. Also: [Trust_AIOrganization](StructureDefinition-trust-ai-organization.html). |
| [USE-01.1](requirements.html#use-011) | Medical Purpose Description | 1..1 | [`Device.property:intendedPurpose`](StructureDefinition-trust-ai-device-definitions.html#Device.property:intendedPurpose) | ✅ Covered |  |
| [USE-01.2](requirements.html#use-012) | Intended Target Population | 1..* | [`Device.property:targetPopulation`](StructureDefinition-trust-ai-device-definitions.html#Device.property:targetPopulation) | ✅ Covered |  |
| [LAW-04.1](requirements.html#law-041) | Third-Country Transfer Flag | 1..1 | [`Device.extension:dataTransfer`](StructureDefinition-trust-ai-device-definitions.html#Device.extension:dataTransfer) | ✅ Covered | Sub-extension `transferFlag`. |
| [LAW-04.2](requirements.html#law-042) | Destination Country | 0..* | [`Device.extension:dataTransfer`](StructureDefinition-trust-ai-device-definitions.html#Device.extension:dataTransfer) | ✅ Covered | Sub-extension `destinationCountry` (ISO 3166). |
{: .grid}
