Profile: EU_AIProvenance
Parent: Provenance
Id: eu-ai-provenance
Title: "EU AI Provenance"
Description: "A Provenance profile linking an AI-generated output to the contributing AI system, source data, and relevant processing or governance context."
// =======================================================
// 1. ZIEL & ZEIT (SYS-10.1)
// =======================================================
* target 1..* MS
* target ^short = "Link to the generated AI clinical result"

* recorded 1..1 MS
* recorded ^short = "Time when the provenance record was created"

* occurred[x] only Period
* occurredPeriod 1..1 MS
* occurredPeriod.start 1..1 MS
* occurredPeriod.end 1..1 MS
* occurredPeriod ^short = "Period of the activity that generated or influenced the target resource"
* occurredPeriod.start ^short = "Start of the AI processing activity"
* occurredPeriod.end ^short = "End of the AI processing activity"

// =======================================================
// 2. GDPR (LAW-01a & LAW-01b)
// =======================================================
* authorization 1..* MS
* authorization ^slicing.discriminator.type = #value
* authorization ^slicing.discriminator.path = "concept.coding.system"
* authorization ^slicing.rules = #open

* authorization contains 
    gdprArt6Basis  1..1 MS and 
    gdprArt9Condition  1..1 MS

* authorization[gdprArt6Basis].concept.coding.system = "http://example.org/fhir/eu-ai-transparency/CodeSystem/gdpr-art6-codesystem"
* authorization[gdprArt9Condition].concept.coding.system = "http://example.org/fhir/eu-ai-transparency/CodeSystem/gdpr-art9-codesystem"

* authorization[gdprArt6Basis] from GDPRArt6LegalBasisVS (required)
* authorization[gdprArt9Condition] from  GDPRArt9ConditionVS (required)

* authorization[gdprArt6Basis].reference 0..0
* authorization[gdprArt9Condition].reference 0..0

* authorization[gdprArt6Basis].concept 1..1
* authorization[gdprArt9Condition].concept 1..1

* authorization[gdprArt6Basis] ^short = "Legal basis under GDPR Article 6"
* authorization[gdprArt9Condition] ^short = "Condition under GDPR Article 9 for processing health data"

// =======================================================
// 3. AGENT (The Machine)
// =======================================================
* agent 1..* MS
* agent.who only Reference(EU_AIDevice)
* agent.who ^short = "AI system that performed the processing activity"

// =======================================================
// 4. INPUT DATEN TRACEABILITY (SYS-10.2)
// =======================================================
* entity 1..* MS
* entity.role = #source 
* entity.what 1..1

* entity ^short = "Input data used to generate the AI output"
* entity.what ^short = "Source data processed by the AI system"

// =======================================================
// 5. EHDS EXTENSIONS (LAW-03.1 & LAW-03.2)
// =======================================================
* extension contains
    EHDSUsageCategory named usageCategory 1..1 MS and
    EHDSSecondaryUsePurpose named secondaryUsePurpose 0..* MS and
    EHDSDataPermit named dataPermit 0..1 MS

* extension[usageCategory] ^short = "Primary or secondary use category"
* extension[secondaryUsePurpose] ^short = "Purpose of secondary use, where applicable"
* extension[dataPermit] ^short = "EHDS data permit, where applicable"

// =======================================================
// 6. EXTENSIONS (USE-04 & Law-02)
// =======================================================

* extension contains
    CaseSpecificIndication named caseIndication 1..1 MS and
    AutomatedDecisionFlag named automatedDecision 1..1 MS

* extension[caseIndication] ^short = "Clinical reason for AI use"
* extension[automatedDecision] ^short = "Automated decision flag"