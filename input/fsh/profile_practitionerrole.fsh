Profile: EU_AIPractitionerRole
Parent: PractitionerRole
Id: eu-ai-practitionerrole
Title: "EU AI Practitioner Role"
Description: "A PractitionerRole profile representing the role, qualification context, specialty, and AI-related training information of the human reviewer involved in oversight of an AI-supported workflow."

// =======================================================
// 1. CORE ROLE INFORMATION (HL-01 (AI Act Art. 14 | Responsible Actor))
// =======================================================
* practitioner 1..1 MS
* practitioner only Reference(Practitioner)
* practitioner ^short = "Reference to the specific human (Practitioner)"

* organization 1..1 MS
* organization only Reference(EU_AIOrganization)
* organization ^short = "Organization in which the practitioner performs the oversight role"

// =======================================================
// 2. CLINICAL SPECIALTY (HL-02.1 (AI Act Art. 14 | Qualification of Actor))
// =======================================================
* specialty 1..* MS
* specialty ^short = "Clinical specialty supporting competence for human oversight"

// =======================================================
// 3. EXTENSIONS: AI TRAINING STATUS (HL-02.2 (AI Act Art. 14 | Qualification of Actor))
// =======================================================
// HL-02.2:  Documentation of AI-related training relevant to human oversight
* extension contains AISystemTrainingStatus named trainingStatus 0..1 MS
* extension[trainingStatus] ^short = "Whether relevant AI training has been documented"

// =======================================================
// 4. ROLE CODES & ADMINISTRATIVE (Competence Verification)
// =======================================================
* code 1..* MS
* code ^short = "Professional role relevant to the human oversight activity"