Profile: EU_AIPatientExplanation
Parent: Communication
Id: eu-ai-patient-explanation
Title: "EU AI Act Patient Right to Explanation"
Description: "Documents the fulfillment of the patient's right to a clear and meaningful explanation regarding the AI's role and the clinical decision (LAW-07)."

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
// LAW-07.1: (Request-Tracking)
* extension contains EU_AI_ExplanationRequested named explanationRequested 1..1 MS
* extension[explanationRequested] ^short = "Flag: Did the patient/data subject actively request this explanation?"


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

