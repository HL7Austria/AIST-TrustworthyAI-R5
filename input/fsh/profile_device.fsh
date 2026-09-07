Profile: EU_AIDevice
Parent: Device 
Id: eu-ai-device
Title: "EU AI System Device"
Description: "A Device profile representing an AI system or software component, including system identification, versioning, intended purpose, and selected regulatory documentation metadata."
// =======================================================
// 1. SYSTEM METADATA (SYS-01 (AI Act Annex IV | System Name & Version), SYS-02 (AI Act / GDPR | Manufacturer / Provider))
// =======================================================
* name 1..* MS
* name.value 1..1
* name.value ^short = "System Name"

* version 1..* MS
* version.value 1..1
* version.value ^short = "System Version"

// SYS-11 (AI Act Art. 49 | EU Database Registration)
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open

* identifier contains euDatabaseId 1..1 MS
* identifier[euDatabaseId].type 1..1
* identifier[euDatabaseId].type = EUAIIdentifierTypeCodeSystem#eu-ai-registration-number
* identifier[euDatabaseId].system 1..1
* identifier[euDatabaseId].value 1..1
* identifier[euDatabaseId] ^short = "EU AI database registration number"

* identifier[euDatabaseId] ^definition = "The unique registration number assigned to the high-risk AI system in the official EU AI database."

// =======================================================
// SYS-02.1 SYS-02.2 (AI Act / GDPR | Manufacturer / Provider)
// =======================================================
* manufacturer 1..1 MS
* manufacturer ^short = "Name of the AI manufacturer"

// Only an Organization can be the owner
* owner only Reference(EU_AIOrganization)
* owner 1..1 MS
* owner ^short = "Organization responsible for the AI system"

// =======================================================
// CONFORMITY, STANDARDS AND CERTIFICATIONS (SYS-12 (AI Act Art. 17 | QMS Certification), SYS-07.2 (AI Act Art. 13 | Operational Context & Maintenance))
// =======================================================
* conformsTo 0..* MS
* conformsTo ^short = "Applicable standards and certifications"
* conformsTo.specification 1..1 MS
* conformsTo.specification ^short = "Standard, specification, or certification"


// =======================================================
// STATIC SYSTEM CHARACTERISTICS (SYS-03b (AI Act Art. 48 | CE Marking), SYS-07.1 (AI Act Art. 13 | Operational Context & Maintenance))
// =======================================================
* property ^slicing.discriminator.type = #value
* property ^slicing.discriminator.path = "type"
* property ^slicing.rules = #open

* property contains 
    ceMark 1..1 MS and 
    notifiedBody 0..1 MS and
    expectedLifetime 1..1 MS and
    intendedPurpose 1..1 MS and
    targetPopulation 1..* MS

* property[ceMark].type =
    EUAISystemPropertyCodeSystem#ce-mark

* property[notifiedBody].type =
    EUAISystemPropertyCodeSystem#notified-body-id

* property[expectedLifetime].type =
    EUAISystemPropertyCodeSystem#expected-lifetime

* property[intendedPurpose].type =
    EUAISystemPropertyCodeSystem#intended-purpose

* property[targetPopulation].type =
    EUAISystemPropertyCodeSystem#target-population


* property[ceMark] ^short = "CE marking status"
* property[intendedPurpose] ^short = "Intended purpose"
* property[targetPopulation] ^short = "Target population"
* property[expectedLifetime] ^short = "Expected system lifetime"
* property[notifiedBody] ^short = "Notified body identification number"

// =======================================================
// DATA (LAW-04 (GDPR Art. 44 | Third-Country Transfer))
// =======================================================
* extension contains ThirdCountryDataTransfer named dataTransfer 1..1 MS
* extension[dataTransfer] ^short = "Third-Country Transfer Data"

* extension contains EU_AIModelCardLink named modelCard 1..1 MS
* extension[modelCard] ^short = "Reference to the AI model card"

// =======================================================
// SYS-03a (AI Act Art. 47 | EU Conformity Declaration): Reference on the EU Conformity Declaration
// =======================================================
* extension contains EUConformityDeclarationReference named conformityDeclaration 1..1 MS
* extension[conformityDeclaration] ^short = "Reference to the EU Conformity Declaration"

