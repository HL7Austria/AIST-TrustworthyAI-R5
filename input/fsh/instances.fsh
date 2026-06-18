// =======================================================
// PoC Scenario sc-02-validation
// NEWS2-inspired AI risk output with human validation
// =======================================================

// =======================================================
// 1. BASE ACTORS (Patient, Practitioner, Organizations)
// =======================================================

Instance: patient-001
InstanceOf: Patient
Usage: #example
Title: "Patient: Synthetic Patient 001"
Description: "A fictional female patient used in the NEWS2-inspired PoC scenario."
* gender = #female
* birthDate = "1959-04-12"

Instance: practitioner-001
InstanceOf: Practitioner
Usage: #example
Title: "Practitioner: Human Reviewer"
Description: "The fictional clinician responsible for reviewing the AI-generated output."
* name[0].family = "Reviewer"
* name[0].given[0] = "Clinical"
* name[0].prefix[0] = "Dr."

Instance: organization-examplehospital
InstanceOf: EU_AIOrganization
Usage: #example
Title: "Operator Organization: Example Hospital"
Description: "The fictional healthcare organization operating the AI system."
* active = true
* type[0].text = "healthcare-provider"
* name = "Example Hospital"
* contact[dpo].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#ADMIN "Administrative"
* contact[dpo].purpose.text = "Data Protection Officer"
* contact[dpo].name[0].text = "Data Protection Officer"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "dpo@examplehospital.example"
* contact[dpo].telecom[0].use = #work
* contact[incident].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#PATINF "Patient"
* contact[incident].purpose.text = "AI Incident Reporting Contact"
* contact[incident].name[0].text = "AI Incident Reporting Contact"
* contact[incident].telecom[0].system = #email
* contact[incident].telecom[0].value = "incidents@examplehospital.example"
* contact[incident].telecom[0].use = #work

Instance: organization-examplemed
InstanceOf: EU_AIOrganization
Usage: #example
Title: "Manufacturer Organization: ExampleMed AI GmbH"
Description: "The fictional manufacturer/provider of the RiskAssist AI system."
* active = true
* type[0].text = "manufacturer"
* name = "ExampleMed AI GmbH"
* contact[dpo].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#ADMIN "Administrative"
* contact[dpo].purpose.text = "Data Protection Officer"
* contact[dpo].name[0].text = "Data Protection Officer"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "dpo@examplemed.example"
* contact[dpo].telecom[0].use = #work
* contact[incident].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#PATINF "Patient"
* contact[incident].purpose.text = "AI Incident Reporting Contact"
* contact[incident].name[0].text = "AI Incident Reporting Contact"
* contact[incident].telecom[0].system = #email
* contact[incident].telecom[0].value = "incidents@examplemed.example"
* contact[incident].telecom[0].use = #work

Instance: encounter-001
InstanceOf: Encounter
Usage: #example
Title: "Encounter: Acute Care Assessment"
Description: "Synthetic encounter for suspected infection and early-warning risk assessment."
* status = #completed
* class[0] = http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* subject = Reference(patient-001)
* actualPeriod.start = "2026-03-01T10:00:00Z"
* actualPeriod.end = "2026-03-01T10:30:00Z"
* reason[0].value[0].concept.text = "suspected-infection-early-warning-risk-assessment"

// =======================================================
// 2. PATIENT INFORMATION AND PROCESSING PERMISSION
// =======================================================

Instance: sc-02-validation-consent-ai-use-001
InstanceOf: EU_AIConsent
Usage: #example
Title: "Consent: AI Use for PoC Scenario sc-02-validation"
Description: "Patient-facing information was provided and AI-related processing is permitted in this synthetic scenario."
* status = #active
* decision = #permit
* category[0] = http://terminology.hl7.org/CodeSystem/consentcategorycodes#npp "Notice of Privacy Practices"
* category[0].text = "Notice of Privacy Practices"
* subject = Reference(patient-001)
* date = "2026-03-01"
* provision[0].purpose[0] = http://terminology.hl7.org/CodeSystem/v3-ActReason#RESCH "research"
* extension[aiInfoProvided].valueBoolean = true


// =======================================================
// 3. AI SYSTEM AND MODEL CARD
// =======================================================

Instance: device-riskassist-ai
InstanceOf: EU_AIDevice
Usage: #example
Title: "Device: RiskAssist AI"
Description: "Synthetic AI system for NEWS2-inspired early-warning risk assessment."
* identifier[euDatabaseId].type = EUAIActCodeSystem#eu-ai-database-id "EU AI Database Identifier"
* identifier[euDatabaseId].type.text = "EU AI Database Identifier"
* identifier[0].system = "http://example.org/fhir/sid/eu-ai-database"
* identifier[euDatabaseId].value = "EU-AI-000123"
* status = #active
* name[0].value = "RiskAssist AI"
* name[0].type = #registered-name
* name[0].display = true
* version[0].value = "1.0.0"
* manufacturer = "ExampleMed AI GmbH"
* owner = Reference(organization-examplehospital)
* contact[0].system = #email
* contact[0].value = "contact@examplemed.example"
* contact[0].use = #work
* contact[1].system = #email
* contact[1].value = "dpo@examplemed.example"
* contact[1].use = #work
* conformsTo[0].category.text = "quality-management-system"
* conformsTo[0].specification.text = "Synthetic QMS certification reference for PoC purposes."
* note[0].text = "Synthetic maintenance information for PoC purposes."
* note[1].text = "AI-assisted early warning risk assessment based on synthetic NEWS2-inspired vital parameters."
* extension[dataTransfer].extension[transferFlag].valueBoolean = false
* extension[modelCard].valueReference = Reference(modelcard-riskassist-ai)
* property[ceMark].valueBoolean = true
* property[notifiedBody].valueString = "NB-0000"
* property[expectedLifetime].valueQuantity = 5 'a' "years"
* property[medicalPurpose].valueString = "Supportive risk stratification in acute care settings"
* property[targetPopulation][0].valueCodeableConcept.text = "Adult patients with suspected infection in an acute care setting"

Instance: modelcard-riskassist-ai
InstanceOf: EU_AIModelCard
Usage: #example
Title: "Model Card: RiskAssist AI v1.0.0"
Description: "Synthetic model card for the deterministic AI-output simulation component used in the PoC."
* subject = Reference(device-riskassist-ai)
* status = #current
* type = EUAIActCodeSystem#model-card "AI Model Card"
* type.text = "AI Model Card"
* description = "Synthetic model card for a deterministic AI-output simulation component used in the PoC."
* content[0].attachment.contentType = #text/html
* content[0].attachment.url = "https://fh-ooe.at/fhir/eu-ai-transparency/riskassist/model-card"
* content[0].attachment.title = "RiskAssist AI Model Card"
* content[1].attachment.contentType = #text/html
* content[1].attachment.url = "https://fh-ooe.at/fhir/eu-ai-transparency/riskassist/technical-documentation"
* content[1].attachment.title = "Technical Documentation"
* extension[clinicalValidationStatus].valueCodeableConcept = EUAIActCodeSystem#not-clinically-validated "Not Clinically Validated"
* extension[performance].extension[biasDisclosure].valueString = "No bias evaluation is claimed for this synthetic PoC model."
* extension[training].extension[provenance].valueString = "No real training data are used. The component is used only to simulate AI-like outputs for the PoC."
* extension[training].extension[ehdsCategory].valueCodeableConcept = EUAIActCodeSystem#ehr "Electronic Health Records (EHRs)"
* extension[training].extension[dataQuality].valueCodeableConcept = EUAIActCodeSystem#complete "Complete"
* extension[privacy].extension[retention].valueDuration = 10 'a' "years"
* extension[privacy].extension[transferFlag].valueBoolean = false

// =======================================================
// 4. NEWS2-INSPIRED CLINICAL INPUT DATA
// =======================================================

Instance: sc-02-validation-observation-temperature-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Body Temperature"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Body temperature"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 38.6 'Cel' "°C"
* performer = Reference(Practitioner/practitioner-001)

Instance: sc-02-validation-observation-heart-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Heart Rate"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 112 '/min' "beats/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(Practitioner/practitioner-001)

Instance: sc-02-validation-observation-respiratory-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Respiratory Rate"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#9279-1 "Respiratory rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 23 '/min' "breaths/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(Practitioner/practitioner-001)

Instance: sc-02-validation-observation-blood-pressure-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Systolic Blood Pressure"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Systolic blood pressure"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 96 'mm[Hg]' "mmHg"
* performer = Reference(Practitioner/practitioner-001)

Instance: sc-02-validation-observation-oxygen-saturation-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Oxygen Saturation"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 92 '%' "%"
* code.coding = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(Practitioner/practitioner-001)

Instance: sc-02-validation-observation-consciousness-status-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Consciousness Status"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Consciousness status"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueCodeableConcept.text = "Alert"
* performer = Reference(Practitioner/practitioner-001)

// =======================================================
// 5. AI OUTPUT AND TRACEABILITY
// =======================================================

Instance: sc-02-validation-ai-observation-risk-001
InstanceOf: EU_AIObservation
Usage: #example
Title: "AI Output: Early Warning Risk Assessment"
Description: "Synthetic AI-generated high-risk output derived from NEWS2-inspired input parameters."
* status = #final
* code.text = "AI-assisted early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:15:03Z"
* device = Reference(device-riskassist-ai)
* interpretation[aiGeneratedFlag] = EUAIActCodeSystem#ai-generated "AI Generated Result"
* interpretation[aiGeneratedFlag].text = "AI Generated Result"
* valueCodeableConcept.text = "high-risk"
* component[0].code.text = "Confidence"
* component[0].valueQuantity = 0.86 '1' "1"
* component[1].code.text = "Simplified score"
* component[1].valueInteger = 9
* note[0].text = "Urgent clinical review recommended"
* extension[caseIndication].valueCodeableConcept = EUAIActCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false
* performer = Reference(organization-examplehospital)

Instance: sc-02-validation-audit-event-ai-execution-001
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace"
Description: "Synthetic audit event documenting the AI execution for PoC traceability."
* extension[logIntegrity].valueSignature.type[0] = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.5 "Verification Signature"
* extension[logIntegrity].valueSignature.when = "2026-03-01T10:15:04Z"
* extension[logIntegrity].valueSignature.who = Reference(device-riskassist-ai)
* extension[logIntegrity].valueSignature.sigFormat = #text/plain
* extension[logIntegrity].valueSignature.data = "c2hhMjU2LTIzNGY0MmQxMzQyN2YyMzRiOWU3YTg5NTJjMGU1ZjA1MmRkZDNiNTBkMWMxMGZjY2Q0OWNjN2EwMWM5OWQ0NjA="
* code = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
* code.text = "RESTful Operation"
* action = #C
* recorded = "2026-03-01T10:15:04Z"
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* authorization[0].text = "Document simulated AI execution for PoC traceability."
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* agent[0].who = Reference(device-riskassist-ai)
* agent[0].requestor = false
* source.observer = Reference(device-riskassist-ai)
* entity[inputData][0].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][0].role.text = "Domain Resource"
* entity[inputData][0].what = Reference(sc-02-validation-observation-temperature-001)
* entity[inputData][1].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][1].role.text = "Domain Resource"
* entity[inputData][1].what = Reference(sc-02-validation-observation-heart-rate-001)
* entity[inputData][2].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][2].role.text = "Domain Resource"
* entity[inputData][2].what = Reference(sc-02-validation-observation-respiratory-rate-001)
* entity[inputData][3].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][3].role.text = "Domain Resource"
* entity[inputData][3].what = Reference(sc-02-validation-observation-blood-pressure-001)
* entity[inputData][4].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][4].role.text = "Domain Resource"
* entity[inputData][4].what = Reference(sc-02-validation-observation-oxygen-saturation-001)
* entity[inputData][5].role = http://terminology.hl7.org/CodeSystem/object-role#4 "Domain Resource"
* entity[inputData][5].role.text = "Domain Resource"
* entity[inputData][5].what = Reference(sc-02-validation-observation-consciousness-status-001)
* entity[outputData][0].role = http://terminology.hl7.org/CodeSystem/object-role#3 "Report"
* entity[outputData][0].role.text = "Report"
* entity[outputData][0].what = Reference(sc-02-validation-ai-observation-risk-001)

Instance: sc-02-validation-provenance-ai-output-001
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Output Generation"
Description: "Synthetic provenance resource linking the AI output to the AI system, input data, and legal processing context."
* target = Reference(sc-02-validation-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprBasis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprException].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* activity.text = "ai-output-generation"
* agent[0].who = Reference(device-riskassist-ai)
* entity[0].role = #source
* entity[0].what = Reference(sc-02-validation-observation-temperature-001)
* entity[1].role = #source
* entity[1].what = Reference(sc-02-validation-observation-heart-rate-001)
* entity[2].role = #source
* entity[2].what = Reference(sc-02-validation-observation-respiratory-rate-001)
* entity[3].role = #source
* entity[3].what = Reference(sc-02-validation-observation-blood-pressure-001)
* entity[4].role = #source
* entity[4].what = Reference(sc-02-validation-observation-oxygen-saturation-001)
* entity[5].role = #source
* entity[5].what = Reference(sc-02-validation-observation-consciousness-status-001)
* extension[usageCategory].valueCodeableConcept = EUAIActCodeSystem#primary-use "Primary Use"
* extension[dataPermit].valueIdentifier.value = "EHDS-PERMIT-001"

// =======================================================
// 6. HUMAN OVERSIGHT: VALIDATION BY CLINICIAN
// =======================================================

Instance: practitionerrole-reviewer-001
InstanceOf: EU_AIPractitionerRole
Usage: #example
Title: "PractitionerRole: Human Reviewer"
Description: "Synthetic practitioner role representing a trained internal medicine reviewer."
* practitioner = Reference(practitioner-001)
* organization = Reference(organization-examplehospital)
* code[0].text = "human-overseer"
* specialty[0].text = "Internal Medicine"
* extension[trainingFlag].valueBoolean = true

Instance: sc-02-validation-human-oversight-001
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "Assessment: Human Validation of AI Output"
Description: "The simulated AI output is reviewed and accepted by the human reviewer."
* workflowStatus = #published
* artifactReference = Reference(sc-02-validation-ai-observation-risk-001)
* date = "2026-03-01T10:20:00Z"
* content[0].author = Reference(practitionerrole-reviewer-001)
* content[0].author.extension[ai-system-training-status].valueBoolean = true
* content[0].classifier = EUAIActCodeSystem#human-validation "Human Validation"
* content[0].summary = "The simulated AI output was reviewed and accepted."

Instance: Communication-sc-02-patient-explanation-001
InstanceOf: EU_AIPatientExplanation
Usage: #example
Title: "Communication: Patient-Facing AI Explanation"
Description: "Synthetic patient-facing explanation about AI-supported processing."
* status = #completed
* extension[explanationRequested].valueBoolean = true
* subject = Reference(patient-001)
* sender = Reference(practitionerrole-reviewer-001)
* about[0] = Reference(sc-02-validation-human-oversight-001)
* sent = "2026-03-01T10:30:00Z"
* payload[0].contentCodeableConcept.text = "The patient received an explanation that AI supported the assessment and that the result was reviewed by a clinician."