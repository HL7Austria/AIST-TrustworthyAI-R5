Profile: EU_AIHumanOversightAssessment
Parent: ArtifactAssessment
Id: eu-ai-human-oversight
Title: "EU AI Human Oversight Assessment"
Description: "An ArtifactAssessment profile documenting professional review of an AI-generated output, including whether the result was accepted, corrected, modified, or overridden."

// =======================================================
// 1. WORKFLOW & STATUS
// =======================================================
* workflowStatus 1..1 MS
* workflowStatus ^short = "draft | active | retired | unknown"
* date 1..1 MS
* date ^short = "Date and time of human oversight assessment"

// =======================================================
// 2. TARGET ARTIFACT (The AI Output: Observation)
// =======================================================
* artifactReference 1..1 MS
* artifactReference only Reference(EU_AIObservation)
* artifact[x] ^short = "Reference to the AI-generated Observation"

// =======================================================
// 3. HUMAN ACTOR & COMPETENCE (HL-01, HL-02)
// =======================================================
* content.author 1..1 MS
* content.author only Reference(EU_AIPractitionerRole)
* content.author ^short = "Reference to the qualified human overseer"

// =======================================================
// 4. INTERVENTION & RATIONALE (HL-03)
// =======================================================
* content.classifier 1..1 MS 
* content.classifier from EU_AI_Intervention_ValueSet (extensible)
* content.classifier ^short = "Intervention Action (e.g., Validation, Override)"

* content.summary 0..1 MS
* content.summary ^short = "Medical/Technical rationale for the decision"

// =======================================================
// 5. EVIDENCE (HL-05)
// =======================================================
* content.relatedArtifact
* content.relatedArtifact ^short = "Reference to heatmap or explainability tool used"