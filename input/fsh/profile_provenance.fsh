Profile: EU_AIProvenance
Parent: Provenance
Id: eu-ai-provenance
Title: "EU AI Provenance"
Description: "A Provenance profile linking an AI-generated output to the contributing AI system, source data, and relevant processing or governance context."
// =======================================================
// 1. ZIEL & ZEIT (SYS-10.1)
// =======================================================
* target 1..* MS
* target only Reference(EU_AIObservation)
* target ^short = "Link to the generated AI clinical result"

* occurred[x] only Period
* occurredPeriod 1..1 MS
* occurredPeriod ^short = "Exact execution period (Start/End) of the AI model"

// =======================================================
// 2. GDPR (LAW-01a & LAW-01b)
// =======================================================
* authorization 1..* MS
* authorization ^slicing.discriminator.type = #value
* authorization ^slicing.discriminator.path = "concept.coding.system"
* authorization ^slicing.rules = #open

* authorization contains 
    gdprBasis 1..1 MS and 
    gdprException 1..1 MS

* authorization[gdprBasis].concept.coding.system = "http://example.org/fhir/eu-ai-transparency/CodeSystem/gdpr-art6-codesystem"
* authorization[gdprException].concept.coding.system = "http://example.org/fhir/eu-ai-transparency/CodeSystem/gdpr-art9-codesystem"

* authorization[gdprBasis] from GDPR_Art6_LegalBasisVS (required)
* authorization[gdprException] from GDPR_Art9_ExceptionVS (required)

* authorization[gdprBasis].concept 1..1
* authorization[gdprException].concept 1..1
// =======================================================
// 3. DER AKTEUR 
// =======================================================
* agent 1..* MS
* agent.who only Reference(EU_AIDevice)
* agent.who ^short = "Link to the AI Device that executed the action"

// =======================================================
// 4. INPUT DATEN TRACEABILITY (SYS-10.2)
// =======================================================
* entity 1..* MS
* entity.role = #source 
* entity.what
* entity.what only Reference(Observation or ImagingStudy or DocumentReference)
* entity.what ^short = "Source data processed by the AI"

// =======================================================
// 5. EHDS EXTENSIONS (LAW-03.1 & LAW-03.2)
// =======================================================
* extension contains
    EHDSUsageCategory named usageCategory 1..1 MS and
    EHDSSecondaryUsePurpose named secondaryUsePurpose 0..* MS and
    EHDSDataPermit named dataPermit 0..1 MS

* extension[usageCategory] ^short = "Primary vs. Secondary Use Category"
* extension[secondaryUsePurpose] ^short = "Permitted purpose for secondary use"
* extension[dataPermit] ^short = "Reference to the EHDS Data Access Permit"