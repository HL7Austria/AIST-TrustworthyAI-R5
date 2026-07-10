Profile: EU_AIPatientExplanation
Parent: Communication
Id: eu-ai-patient-explanation
Title: "EU AI Patient Explanation Communication"
Description: "A Communication profile documenting patient-facing information about the AI-supported workflow, including the role of the AI system and the related clinical review where applicable."

// =======================================================
// 1. BASICS & STATUS
// =======================================================
* status 1..1 MS
* status ^short = "preparation | in-progress | completed | not-done"

* category = http://terminology.hl7.org/CodeSystem/communication-category#instruction "Instruction"

// =======================================================
// 2. SUBJECT & SENDER (The Actors)
// =======================================================
* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "The patient who received the explanation"

* sender 1..1 MS
* sender only Reference(PractitionerRole)
* sender ^short = "The human-in-the-loop providing the explanation"

// =======================================================
// 3. CONTEXT & DECISION (LAW-07.1)
// =======================================================

// LAW-07.1 request inforamtion about the specific decision the patient wants to have explained
* about 1..* MS
* about only Reference(EU_AIHumanOversightAssessment)
* about ^short = "The specific decision the patient wants to have explained"
// =======================================================
// 4. PAYLOAD & CONTENT (LAW-07.2)
// =======================================================
* payload 1..* MS
* payload.content[x] only Reference(DocumentReference) or CodeableConcept
* payload ^short = "The explanation text OR a reference to a formal explanation document"

// =======================================================
// 5. TIMING (LAW-07.3)
// =======================================================
* sent 1..1 MS
* sent ^short = "Date and time the explanation was provided"

