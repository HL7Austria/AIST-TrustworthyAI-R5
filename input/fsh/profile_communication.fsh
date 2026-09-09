Profile: Trust_AIPatientExplanation
Parent: Communication
Id: trust-ai-patient-explanation
Title: "Trust AI Patient Explanation Communication"
Description: "A Communication profile documenting that an explanation regarding an AI-supported clinical decision was provided to a patient. The explanation may describe the role of the AI system, the related human oversight, and the key elements of the resulting clinical decision in accordance with Article 86 of the Trust AI Act."

// =======================================================
// SUBJECT & SENDER (The Actors)
// =======================================================
* subject 1..1 MS
* subject only Reference(Patient)
* subject ^short = "The patient who received the explanation"

* sender 1..1 MS
* sender only Reference(PractitionerRole)
* sender ^short = "The human-in-the-loop providing the explanation"

// =======================================================
// CONTEXT & DECISION (LAW-07.1 (AI Act Art. 86 | Patient-Facing Transparency Information))
// =======================================================
// LAW-07.1 request information about the specific decision the patient wants to have explained
* about 1..* MS
* about ^definition = "References the AI-generated or AI-supported clinical output, related human oversight assessment, provenance record, or other resource representing the decision or workflow addressed by the patient-facing explanation."
* about ^short = "The specific decision the patient wants to have explained"
* about ^requirements = "AI Act Art. 86 | Patient-Facing Transparency Information"

// =======================================================
// PAYLOAD & CONTENT (LAW-07.2 AI Act Art. 86 | Patient-Facing Transparency Information))
// =======================================================
* payload 1..* MS
* payload.content[x] only Attachment or Reference(DocumentReference)
* payload ^short = "Patient-facing explanation or reference to an explanation document"
* payload ^requirements = "AI Act Art. 86 | Patient-Facing Transparency Information"

// =======================================================
// TIMING (LAW-07.3 AI Act Art. 86 | Patient-Facing Transparency Information))
// =======================================================
* sent 1..1 MS
* sent ^short = "Date and time the explanation was provided"

// LAW-01c (GDPR Art. 13): Patient Info Provided Flag 
* extension contains PatientAIInfoProvidedFlag named aifInfoProvided 1..1 MS
* extension[aifInfoProvided] ^short = "Flag if the patient was informed about the use of AI."
* extension[aifInfoProvided] ^requirements = "GDPR Art. 13 | Patient Information Provided Flag & AI Act Art. 86 | Patient-Facing Transparency Information"
