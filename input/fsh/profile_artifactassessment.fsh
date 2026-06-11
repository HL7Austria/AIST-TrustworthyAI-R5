Profile: EU_AIHumanOversightAssessment
Parent: ArtifactAssessment
Id: eu-ai-human-oversight
Title: "EU AI Act Human Oversight (HL)"
Description: "Documents the professional review and clinical decision-making regarding AI outputs."

// =======================================================
// 1. WORKFLOW & STATUS
// =======================================================
* workflowStatus 1..1 MS
* workflowStatus ^short = "draft | active | retired | unknown"

// =======================================================
// 2. TARGET ARTIFACT (The AI Output: Observation)
// =======================================================
* artifactReference 1..1 MS
* artifactReference only Reference(Observation)
* artifact[x] ^short = "Reference to the AI-generated Observation"

// =======================================================
// 3. HUMAN ACTOR & COMPETENCE (HL-01, HL-02)
// =======================================================
* content.author 1..1 MS
* content.author only Reference(EU_AIPractitionerRole)
* content.author ^short = "Reference to the qualified human overseer"

* content.author.extension contains AISystemTrainingStatus named aiTraining 1..1 MS
* content.author.extension[aiTraining] ^short = "Did this specific human receive training for this AI?"

// =======================================================
// 4. INTERVENTION & RATIONALE (HL-03)
// =======================================================
* content.classifier 1..1 MS 
* content.classifier from EU_AI_Intervention_ValueSet (extensible)
* content.classifier ^short = "Intervention Action (e.g., Validation, Override)"

* content.summary MS
* content.summary ^short = "Medical/Technical rationale for the decision"

// =======================================================
// 5. EVIDENCE (HL-05)
// =======================================================
* content.relatedArtifact MS
* content.relatedArtifact ^short = "Reference to heatmap or explainability tool used"