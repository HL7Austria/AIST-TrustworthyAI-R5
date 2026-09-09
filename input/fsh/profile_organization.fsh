Profile: Trust_AIOrganization
Parent: Organization
Id: trust-ai-organization
Title: "Trust AI Responsible Organization"
Description: "An Organization profile representing an organization involved in manufacturing, providing, deploying, or operating an AI system, including relevant accountability and contact information."

// =======================================================
// ORGANIZATION IDENTIFICATION
// =======================================================

* name 1..1 MS
* name ^short = "Name of the legal entity"

// =======================================================
// SLICING FÜR KONTAKTPERSONEN
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

// SYS-08 (GDPR Art. 13 | DPO Contact Details): Data Protection Officer (DSGVO)
* contact[dpo].purpose 1..1
* contact[dpo].purpose = TrustAIContactPurposeCodeSystem#dpo "Data Protection Officer"
* contact[dpo].name 0..1 MS
* contact[dpo].telecom 1..* MS
* contact[dpo] ^short = "Data Protection Officer"
* contact[dpo] ^requirements = "GDPR Art. 13 | DPO Contact Details"

// SYS-12 (AI Act Art. 17 | QMS Certification): Additional operational governance: AI Incident Reporting Contact
* contact[incident].purpose 1..1
* contact[incident].purpose = TrustAIContactPurposeCodeSystem#ai-incident-reporting "AI Incident Reporting Contact"
* contact[incident].name 0..1 MS
* contact[incident].telecom 1..* MS
* contact[incident] ^short = "AI Incident Reporting Contact"
* contact[incident] ^requirements = "AI Act Art. 17 | QMS Certification"

// SYS-09 (GDPR Art. 35 | DPIA Reference): Reference on the DPIA Document: Privacy risk management, GDPR accountability.
* extension contains DPIAReference named DPIAReference 0..1 MS
* extension[DPIAReference] ^short = "Reference to the DPIA Document"
* extension[DPIAReference] ^requirements = "GDPR Art. 35 | DPIA Reference"