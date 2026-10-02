### Regulatory Requirements

This profile is part of the **AI Output Context** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [SYS-10](requirements.html#req-sys-10) | AI Act Art. 12 / EHDS ANNEX II (3) | Audit Trail & Access Logging | Dynamic |
| [LAW-08](requirements.html#req-law-08) | AI Act Art. 12(3) | Log Integrity | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [SYS-10.1](requirements.html#sys-101) | Execution Period (Start/End) | 1..1 | [`AuditEvent.occurredPeriod`](StructureDefinition-trust-ai-machine-execution-audit-event-definitions.html#AuditEvent.occurredPeriod) | ✅ Covered | Also: [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html), [Trust_AIObservation](StructureDefinition-trust-ai-observation.html). |
| [SYS-10.3](requirements.html#sys-103) | Reference Database | 0..* | [`AuditEvent.entity:referenceDb`](StructureDefinition-trust-ai-machine-execution-audit-event-definitions.html#AuditEvent.entity:referenceDb) | ✅ Covered |  |
| [LAW-08](requirements.html#law-08) | Log Integrity | 1..1 | [`AuditEvent.extension:logIntegrity`](StructureDefinition-trust-ai-machine-execution-audit-event-definitions.html#AuditEvent.extension:logIntegrity) | ⚠️ Partial | Extension `trust-ai-log-integrity` is 0..1, while the matrix requires 1..1. |
{: .grid}
