Profile: EU_AIPractitionerRole
Parent: PractitionerRole
Id: eu-ai-practitionerrole
Title: "EU AI Act Human Overseer (PractitionerRole)"
Description: "Defines the qualifications, specialty, and AI-specific training of the human responsible for oversight of the AI system, as required by the AI Act (HL-02)."

// =======================================================
// 1. CORE ROLE INFORMATION (HL-01)
// =======================================================
* practitioner 1..1 MS
* practitioner only Reference(Practitioner)
* practitioner ^short = "Reference to the specific human (Practitioner)"

* organization 1..1 MS
* organization only Reference(EU_AIOrganization)
* organization ^short = "Organization responsible for the oversight process"

// =======================================================
// 2. CLINICAL SPECIALTY (HL-02.1)
// =======================================================
* specialty 1..* MS
* specialty ^short = "Clinical specialty required for oversight"

// =======================================================
// 3. EXTENSIONS: AI TRAINING STATUS (HL-02.2)
// =======================================================
// LAW-07/HL-02.2: Ensuring the human has specific training for the AI tool
* extension contains AISystemTrainingStatus named trainingFlag 1..1 MS
* extension[trainingFlag] ^short = "Flag indicating system-specific training completed"

// =======================================================
// 4. ROLE CODES & ADMINISTRATIVE (Competence Verification)
// =======================================================
* code 1..* MS
* code ^short = "Specific role or seniority (e.g., Senior Physician, Medical Lead)"