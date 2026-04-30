Profile: EU_AIDevice
Parent: Device 
Id: eu-ai-device
Title: "EU AI Act Compliant Device"
Description: "A Device profile representing an AI system, fulfilling EU AI Act metadata requirements."


// =======================================================
// 1. SYSTEM METADATA (SYS-01, SYS-02)
// =======================================================
* name 1..* MS
* name.value 1..1 MS
* name.value ^short = "System Name"

* version 1..* MS
* version.value 1..1 MS
* version.value ^short = "System Version"

// SYS-11
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open

* identifier contains euDatabaseId 1..1 MS
* identifier[euDatabaseId].type 1..1 MS
* identifier[euDatabaseId].type = EUAIActCodeSystem#eu-ai-database-id "EU AI Database Identifier"
* identifier[euDatabaseId].system 1..1 MS
* identifier[euDatabaseId].value 1..1 MS
* identifier[euDatabaseId] ^short = "EU AI database registration identifier"
* identifier[euDatabaseId] ^definition = "Identifier used to document the AI system's registration entry in the EU AI database or an equivalent AI system registry."


// =======================================================
// SYS-02.1 SYS-02.2, SYS-08
// =======================================================
* manufacturer 1..1 MS
* manufacturer ^short = "Name of the AI developer/manufacturer"

// Only an Organization can be the owner (e.g., the hospital)
* owner only Reference(EU_AIOrganization)
* owner 1..1 MS
* owner ^short = "Healthcare provider responsible for the AI system"

* contact 2..* MS
* contact ^short = "Manufacturer Contact AND DPO Contact Details"

// =======================================================
// lifecycle status (SYS-12, SYS-07.2)
// =======================================================
* conformsTo 1..* MS
* conformsTo.specification ^short = "QMS Certification"

* note 1..* MS
* note ^short = "Maintenance Requirements"

// =======================================================
// dynamic features (SYS-03b, SYS-07.1, USE-01)
// =======================================================
* property ^slicing.discriminator.type = #value
* property ^slicing.discriminator.path = "type"
* property ^slicing.rules = #open

* property contains 
    ceMark 1..1 MS and 
    notifiedBody 0..1 MS and
    expectedLifetime 1..1 MS and
    medicalPurpose 1..1 MS and
    targetPopulation 1..* MS

* property[ceMark].type = EUAIActCodeSystem#ce-mark
* property[ceMark].value[x] only boolean

* property[notifiedBody].type = EUAIActCodeSystem#notified-body-id
* property[notifiedBody].value[x] only string

* property[expectedLifetime].type = EUAIActCodeSystem#expected-lifetime
* property[expectedLifetime].value[x] only Quantity

* property[medicalPurpose].type = EUAIActCodeSystem#medical-purpose
* property[medicalPurpose].value[x] only string

* property[targetPopulation].type = EUAIActCodeSystem#target-population
* property[targetPopulation].value[x] only CodeableConcept

// =======================================================
// DATA (LAW-04)
// =======================================================
* extension contains ThirdCountryDataTransfer named dataTransfer 1..1 MS
* extension[dataTransfer] ^short = "Third-Country Transfer Data"

* extension contains EU_AIModelCardLink named modelCard 1..1 MS