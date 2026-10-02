### Regulatory Requirements

This profile is part of the **Clinical Decision Context (Human-in-the-Loop)** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [HL-01](requirements.html#req-hl-01) | AI Act Art. 14(1) | Responsible Actor (User) | Dynamic |
| [HL-02](requirements.html#req-hl-02) | AI Act Art. 14(5) | Qualification of Actor | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [HL-01](requirements.html#hl-01) | Actor Reference | 1..* | [`PractitionerRole.practitioner`](StructureDefinition-trust-ai-practitionerrole-definitions.html#PractitionerRole.practitioner) | ✅ Covered | Also: [Trust_AIHumanOversightAssessment](StructureDefinition-trust-ai-human-oversight.html). |
| [HL-02.1](requirements.html#hl-021) | Actor Specialty Code | 1..* | [`PractitionerRole.specialty`](StructureDefinition-trust-ai-practitionerrole-definitions.html#PractitionerRole.specialty) | ✅ Covered |  |
| [HL-02.2](requirements.html#hl-022) | System-Specific Training Flag | 1..1 | [`PractitionerRole.extension:trainingStatus`](StructureDefinition-trust-ai-practitionerrole-definitions.html#PractitionerRole.extension:trainingStatus) | ⚠️ Partial | Extension `ai-system-training-status` is 0..1, while the matrix requires 1..1. |
{: .grid}
