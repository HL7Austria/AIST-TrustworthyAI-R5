### Regulatory Requirements

This profile is part of the **Clinical Decision Context (Human-in-the-Loop)** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [LAW-01a](requirements.html#req-law-01a) | GDPR Art. 6(1) | Legal Basis (General) | Dynamic |
| [LAW-01b](requirements.html#req-law-01b) | GDPR Art. 9(2) | Health Data Exception | Dynamic |
| [LAW-07](requirements.html#req-law-07) | AI Act Art. 86 | Right to Explanation | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [LAW-01c](requirements.html#law-01c) | Patient Info Provided Flag | 1..1 | [`Communication.extension:aifInfoProvided`](StructureDefinition-trust-ai-patient-explanation-definitions.html#Communication.extension:aifInfoProvided) | ✅ Covered | Extension `patient-ai-info-provided-flag`. |
| [LAW-07.1](requirements.html#law-071) | Explanation Requested Flag | 1..1 | [`Communication.about`](StructureDefinition-trust-ai-patient-explanation-definitions.html#Communication.about) | ⚠️ Partial | `about` identifies the decision to be explained; an explicit "explanation requested" flag is not modelled. |
| [LAW-07.2](requirements.html#law-072) | Explanation Provided Ref. | 0..1 | [`Communication.payload`](StructureDefinition-trust-ai-patient-explanation-definitions.html#Communication.payload) | ✅ Covered |  |
| [LAW-07.3](requirements.html#law-073) | Date of Explanation | 0..1 | [`Communication.sent`](StructureDefinition-trust-ai-patient-explanation-definitions.html#Communication.sent) | ✅ Covered |  |
{: .grid}
