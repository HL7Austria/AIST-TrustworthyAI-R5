### Regulatory Requirements

This profile is part of the **AI Output Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-10](requirements.html#req-sys-10) | AI Act Art. 12 / EHDS ANNEX II (3) | Audit Trail & Access Logging | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-10.1](requirements.html#sys-101) | Execution Period (Start/End) | 1..1 | [`Observation.effective[x]`](StructureDefinition-trust-ai-observation-definitions.html#Observation.effective[x]) | ✅ Covered | Also: [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html), [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html). |
{: .grid}
