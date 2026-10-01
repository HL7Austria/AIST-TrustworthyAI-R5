### Regulatory Requirements

This profile is part of the **Static System Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-02](requirements.html#req-sys-02) | GDPR Art. 13 / AI Act Annex IV 1 | Manufacturer / Provider | Static |
| [SYS-08](requirements.html#req-sys-08) | GDPR Art. 13(1) | DPO Contact Details | Static |
| [SYS-09](requirements.html#req-sys-09) | GDPR Art. 35 | DPIA (Data Protection Impact Assessment) | Static |
| [SYS-12](requirements.html#req-sys-12) | AI Act Art. 17 | QMS Certification | Static |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-02.2](requirements.html#sys-022) | Manufacturer Contact Details | 1..* | [`Organization.contact:officialContact`](StructureDefinition-trust-ai-organization-definitions.html#Organization.contact:officialContact) | ✅ Covered | Reached from the Device via `Device.owner`. |
| [SYS-08](requirements.html#sys-08) | DPO Contact Details | 1..1 | [`Organization.contact:dpo`](StructureDefinition-trust-ai-organization-definitions.html#Organization.contact:dpo) | ✅ Covered |  |
| [SYS-09](requirements.html#sys-09) | DPIA Reference | 0..1 | [`Organization.extension:DPIAReference`](StructureDefinition-trust-ai-organization-definitions.html#Organization.extension:DPIAReference) | ✅ Covered | Extension `trust-ai-dpia-reference`. |
| [SYS-12](requirements.html#sys-12) | QMS Certification | 1..1 | [`Organization.contact:incident`](StructureDefinition-trust-ai-organization-definitions.html#Organization.contact:incident) | ✅ Covered | QMS certification in `conformsTo`; the AI incident reporting contact supports the QMS. Also: [Trust_AIDevice](StructureDefinition-trust-ai-device.html). |
{: .grid}
