Profile: EU_AIOrganization
Parent: Organization
Id: eu-ai-organization
Title: "EU AI Responsible Organization"
Description: "An Organization profile representing an organization involved in manufacturing, providing, deploying, or operating an AI system, including relevant accountability and contact information."

// =======================================================
// ORGANIZATION IDENTIFICATION
// =======================================================

* name 1..1 MS
* name ^short = "Name of the legal entity"

// =======================================================
// SLICING FÜR KONTAKTPERSONEN (SYS-08, SYS-12)
// =======================================================

* contact ^slicing.discriminator.type = #value  
* contact ^slicing.discriminator.path = "purpose" 
* contact ^slicing.rules = #open

* contact contains
    officialContact 1..1 MS and
    dpo 0..1 MS and
    incident 0..1 MS

* contact[officialContact].purpose 1..1
* contact[officialContact].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#ADMIN
* contact[officialContact].telecom 1..* MS
* contact[officialContact] ^short = "Official contact details of the legal entity"

// SYS-08: Data Protection Officer (DSGVO)
* contact[dpo].purpose 1..1
* contact[dpo].purpose = EUAIContactPurposeCodeSystem#dpo "Data Protection Officer"
* contact[dpo].name 0..1 MS
* contact[dpo].telecom 1..* MS
* contact[dpo] ^short = "Data Protection Officer"

// SYS-12: Additional operational governance: AI Incident Reporting Contact
* contact[incident].purpose 1..1
* contact[incident].purpose = EUAIContactPurposeCodeSystem#ai-incident-reporting "AI Incident Reporting Contact"
* contact[incident].name 0..1 MS
* contact[incident].telecom 1..* MS
* contact[incident] ^short = "AI Incident Reporting Contact"