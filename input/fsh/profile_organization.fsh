Profile: EU_AIOrganization
Parent: Organization
Id: eu-ai-organization
Title: "EU AI Responsible Organization"
Description: "An organization acting as a manufacturer or deployer (owner) of an AI system, containing required regulatory contacts."

// =======================================================
// SLICING FÜR KONTAKTPERSONEN (SYS-08, SYS-12)
// =======================================================
* contact ^slicing.discriminator.type = #value  
* contact ^slicing.discriminator.path = "purpose" 
* contact ^slicing.rules = #open

// SYS-08: Data Protection Officer (DSGVO)
* contact contains dpo 0..1 MS
* contact[dpo].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#ADMIN
* contact[dpo].name.text MS
* contact[dpo].name.text ^short = "Data Protection Officer"
* contact[dpo].telecom 1..* MS

// SYS-12: Incident Reporting Contact (EU AI Act)
* contact contains incident 0..1 MS
* contact[incident].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#PATINF
* contact[incident].name.text MS
* contact[incident].name.text ^short = "AI Incident Reporting Contact"
* contact[incident].telecom 1..* MS