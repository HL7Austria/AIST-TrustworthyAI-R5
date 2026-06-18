Profile: EU_AIConsent
Parent: Consent
Id: eu-ai-consent
Title: "EU AI Consent and Processing Context"
Description: "A Consent profile documenting patient-facing information, permission status, and opt-out preferences for AI-supported processing where applicable."

* status = #active
* category = http://terminology.hl7.org/CodeSystem/consentcategorycodes#npp "Notice of Privacy Practices"

* subject 1..1 MS 
* subject only Reference(Patient)

// =======================================================
// 1. INFORMATION (LAW-01c)
// =======================================================
* extension contains PatientAIInfoProvidedFlag named aiInfoProvided 1..1 MS

// =======================================================
// 2. EHDS OPT-OUT (LAW-05)
// =======================================================
* decision 1..1 MS
* decision ^short = "deny (Opt-out) | permit (Consent)"

* provision 1..1 MS
* provision.purpose 0..*