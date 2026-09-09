Profile: Trust_AIProvenance
Parent: Provenance
Id: trust-ai-provenance
Title: "Trust AI Provenance"
Description: "A Provenance profile linking an AI-generated output to the contributing AI system, source data, and relevant processing or governance context."
// =======================================================
// TARGET and TIME (SYS-10.1 (AI Act Art. 12 | Audit Trail))
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
* occurredPeriod ^requirements = "AI Act Art. 12 | Audit Trail"
* occurredPeriod.start ^short = "Start of the AI processing activity"
* occurredPeriod.end ^short = "End of the AI processing activity"

// =======================================================
// GDPR (LAW-01a (GDPR Art. 6 | Legal Basis (General)) & LAW-01b (GDPR Art. 9 | Health Data Exception))
// =======================================================
* authorization 1..* MS
* authorization ^slicing.discriminator.type = #value
* authorization ^slicing.discriminator.path = "concept.coding.system"
* authorization ^slicing.rules = #open

* authorization contains 
    gdprArt6Basis  1..1 MS and 
    gdprArt9Condition  1..1 MS

// LAW-01a (Article 6 | Legal Basis (General))
* authorization[gdprArt6Basis].reference 0..0
* authorization[gdprArt6Basis].concept 1..1
* authorization[gdprArt6Basis].concept.coding 1..*
* authorization[gdprArt6Basis].concept.coding.system = "http://example.org/fhir/trust-ai-transparency/CodeSystem/gdpr-art6-codesystem"
* authorization[gdprArt6Basis] from GDPRArt6LegalBasisVS (required)
* authorization[gdprArt6Basis] ^short = "Legal basis under GDPR Article 6"

// LAW-01b (GDPR Art. 9 | Health Data Exception)
* authorization[gdprArt9Condition].reference 0..0
* authorization[gdprArt9Condition].concept 1..1
* authorization[gdprArt9Condition].concept.coding 1..*
* authorization[gdprArt9Condition].concept.coding.system = "http://example.org/fhir/trust-ai-transparency/CodeSystem/gdpr-art9-codesystem"

* authorization[gdprArt6Basis] from GDPRArt6LegalBasisVS (required)
* authorization[gdprArt9Condition] from  GDPRArt9ConditionVS (required)

* authorization[gdprArt6Basis].reference 0..0
* authorization[gdprArt9Condition].reference 0..0

* authorization[gdprArt6Basis].concept 1..1
* authorization[gdprArt9Condition].concept 1..1

* authorization[gdprArt6Basis] ^short = "Legal basis under GDPR Article 6"
* authorization[gdprArt6Basis] ^requirements = "GDPR Art. 6 | Legal Basis (General)"
* authorization[gdprArt9Condition] ^short = "Condition under GDPR Article 9 for processing health data"
* authorization[gdprArt9Condition] ^requirements = "GDPR Art. 9 | Health Data Exception"

// =======================================================
// 3. AGENT (The Machine)
// =======================================================
* agent 1..* MS
* agent.who only Reference(Trust_AIDevice)
* agent.who ^short = "AI system that performed the processing activity"

// =======================================================
// INPUT DATEN TRACEABILITY (SYS-10.2 (AI Act Art. 12 | Audit Trail))
// =======================================================
* entity 1..* MS
* entity.role = #source 
* entity.what 1..1

* entity ^short = "Input data used to generate the AI output"
* entity.what ^short = "Source data processed by the AI system"
* entity ^requirements = "AI Act Art. 12 | Audit Trail"

// =======================================================
// EHDS EXTENSIONS 
// LAW-03.1 (EHDS Art. 51 | Data Provenance)
// LAW-03.2 (EHDS Art. 51 | Data Provenance)
// QUAL-02b (EHDS Art. 51 | Secondary Use Permit)
// =======================================================
* extension contains
    UsageCategory named usageCategory 1..1 MS and
    SecondaryUsePurpose named secondaryUsePurpose 0..* MS and
    DataPermit named dataPermit 0..1 MS

* extension[usageCategory] ^short = "Primary or secondary use category"
* extension[usageCategory] ^requirements = "EHDS Art. 51 | Data Provenance"
* extension[secondaryUsePurpose] ^short = "Purpose of secondary use, where applicable"
* extension[secondaryUsePurpose] ^requirements = "EHDS Art. 51 | Secondary Use Permit"
* extension[dataPermit] ^short = "EHDS data permit, where applicable"
* extension[dataPermit] ^requirements = "EHDS Art. 51 | Data Provenance"

// =======================================================
// 6. EXTENSIONS
// USE-04 (GDPR Art. 5 | Case-Specific Indication)
// Law-02 (GDPR Art. 22 | Automated Decision Flag)
// =======================================================

* extension contains
    CaseSpecificIndication named caseIndication 1..1 MS and
    AutomatedDecisionFlag named automatedDecision 1..1 MS

* extension[caseIndication] ^short = "Clinical reason for AI use"
* extension[caseIndication] ^requirements = "GDPR Art. 5 | Case-Specific Indication"
* extension[automatedDecision] ^short = "Automated decision flag"
* extension[automatedDecision] ^requirements = "GDPR Art. 22 | Automated Decision Flag"