### Regulatory Requirements

This profile is part of the **Clinical Decision Context (Human-in-the-Loop)** layer. It implements the following documentation requirements from the [Requirements Traceability](requirements.html) analysis.

| Requirement | Law / Source | Metadata Field | Static / Dynamic |
|---|---|---|---|
| [HL-01](requirements.html#req-hl-01) | AI Act Art. 14(1) | Responsible Actor (User) | Dynamic |
| [HL-03](requirements.html#req-hl-03) | AI Act Art. 14(4) | Type of Intervention | Dynamic |
| [HL-05](requirements.html#req-hl-05) | AI Act Art. 14(4)(c) | Specific Evidence Shown | Dynamic |
{: .grid}

#### Element Mapping

| Attribute | Logical Attribute | Card. (matrix) | Element(s) in this profile | Status | Notes |
|---|---|---|---|---|---|
| [HL-01](requirements.html#hl-01) | Actor Reference | 1..* | [`ArtifactAssessment.content.author`](StructureDefinition-trust-ai-human-oversight-definitions.html#ArtifactAssessment.content.author) | ✅ Covered | Also: [Trust_AIPractitionerRole](StructureDefinition-trust-ai-practitionerrole.html). |
| [HL-03.1](requirements.html#hl-031) | Intervention Action Code | 1..1 | [`ArtifactAssessment.content.classifier`](StructureDefinition-trust-ai-human-oversight-definitions.html#ArtifactAssessment.content.classifier) | ✅ Covered | TrustAIHumanOversightActionVS. |
| [HL-03.2](requirements.html#hl-032) | Intervention Rationale | 0..1* | [`ArtifactAssessment.content.summary`](StructureDefinition-trust-ai-human-oversight-definitions.html#ArtifactAssessment.content.summary) | ⚠️ Partial | The conditional 1..1 (for override) is not yet enforced by an invariant. |
| [HL-05](requirements.html#hl-05) | Specific Evidence Shown | 0..* | [`ArtifactAssessment.content.relatedArtifact`](StructureDefinition-trust-ai-human-oversight-definitions.html#ArtifactAssessment.content.relatedArtifact) | ✅ Covered |  |
{: .grid}
