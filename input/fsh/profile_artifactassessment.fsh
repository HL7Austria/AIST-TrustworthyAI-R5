Profile: EU_AIHumanOversightAssessment
Parent: ArtifactAssessment
Id: eu-ai-human-oversight
Title: "EU AI Human Oversight Assessment"
Description: "An ArtifactAssessment profile documenting professional review of an AI-generated output, including whether the result was accepted, corrected, modified, or overridden."

// =======================================================
// WORKFLOW & STATUS
// =======================================================
* date 1..1 MS
* date ^short = "Date and time of human oversight assessment"

// =======================================================
// TARGET ARTIFACT
// =======================================================
* artifactReference 1..1 MS
* artifact[x] ^short = "Reference to the AI-generated"

// =======================================================
// HUMAN ACTOR & COMPETENCE (HL-01 (AI Act Art. 14 | Responsible Actor), HL-02(AI Act Art. 14 | Qualification of Actor))
// =======================================================
* content.author 1..1 MS
* content.author only Reference(EU_AIPractitionerRole)
* content.author ^short = "Reference to the qualified human overseer"

// =======================================================
// INTERVENTION (HL-03 (AI Act Art. 14 | Type of Intervention))
// =======================================================
* content.classifier 1..1 MS 
* content.classifier from EUAIHumanOversightActionVS (extensible)
* content.classifier ^short = "Human oversight action"

* content.summary 0..1 MS
* content.summary ^short = "Clinical or technical rationale for the assessment"

// =======================================================
// EVIDENCE (HL-05 (AI Act Art. 14 | Case-Specific Interpretability Information))
// =======================================================
* content.relatedArtifact 0..*
* content.relatedArtifact ^short = "Supporting documentation or explainability evidence"
