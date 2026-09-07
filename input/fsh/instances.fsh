// =======================================================
// PoC Instances: Scenarios 1-4
// NEWS2-inspired AI risk output scenarios
// =======================================================
// sc-01-ai-only: core AI execution and traceability only
// sc-02-validation: AI output accepted by human reviewer
// sc-03-override: AI output overridden by human reviewer
// sc-04-correction-exp: AI output corrected and explained to patient
// =======================================================

// =======================================================
// 1. SHARED BASE ACTORS (Patient, Practitioner, Organizations)
// =======================================================

Instance: patient-001
InstanceOf: Patient
Usage: #example
Title: "Patient: Synthetic Patient 001"
Description: "A fictional female patient used in the NEWS2-inspired PoC scenarios."
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

* contact[officialContact].telecom[0].system = #email
* contact[officialContact].telecom[0].value = "contact@examplehospital.example"
* contact[officialContact].telecom[0].use = #work

* contact[dpo].name.text = "Data Protection Officer"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "dpo@examplehospital.example"
* contact[dpo].telecom[0].use = #work

* contact[incident].name.text = "AI Incident Reporting Contact"
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

* contact[officialContact].telecom[0].system = #email
* contact[officialContact].telecom[0].value = "contact@examplemed.example"
* contact[officialContact].telecom[0].use = #work

* contact[dpo].name.text = "Data Protection Officer"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "dpo@examplemed.example"
* contact[dpo].telecom[0].use = #work

* contact[incident].name.text = "AI Incident Reporting Contact"
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
// 2. SHARED AI SYSTEM AND MODEL CARD
// =======================================================

Instance: device-riskassist-ai
InstanceOf: EU_AIDevice
Usage: #example
Title: "Device: RiskAssist AI"
Description: "Synthetic AI system for NEWS2-inspired early-warning risk assessment."
* identifier[euDatabaseId].system = "http://example.org/fhir/sid/eu-ai-database"
* identifier[euDatabaseId].value = "EU-AI-000123"
* status = #active
* name[0].value = "RiskAssist AI"
* name[0].type = #registered-name
* name[0].display = true
* version[0].value = "1.0.0"
* manufacturer = "ExampleMed AI GmbH"
* owner = Reference(organization-examplehospital)

* conformsTo[0].category.text = "quality-management-system"
* conformsTo[0].specification.text = "Synthetic QMS certification reference for PoC purposes."
* note[0].text = "Synthetic maintenance information for PoC purposes."
* note[1].text = "AI-assisted early warning risk assessment based on synthetic NEWS2-inspired vital parameters."
* extension[dataTransfer].extension[transferFlag].valueBoolean = false
* extension[modelCard].valueReference = Reference(modelcard-riskassist-ai)
* extension[conformityDeclaration].valueReference = Reference(eu-conformity-declaration)
* property[ceMark].valueBoolean = true
* property[notifiedBody].valueString = "NB-0000"
* property[expectedLifetime].valueQuantity = 5 'a' "years"
* property[intendedPurpose].valueString = "Supportive risk stratification in acute care settings"
* property[targetPopulation][0].valueCodeableConcept.text = "Adult patients with suspected infection in an acute care setting"

Instance: eu-conformity-declaration
InstanceOf: DocumentReference
Usage: #example
Title: "EU Conformity Declaration"
* status = #current
* content.attachment = conformity-declaration-attachment

Instance: conformity-declaration-attachment
InstanceOf: Attachment
Usage: #inline
Title: "Conformity Declaration Attachment"
Description: "The document attachment for the conformity declaration."
* title = "Conformity Declaration Attachment"

Instance: modelcard-riskassist-ai
InstanceOf: EU_AIModelCard
Usage: #example
Title: "Model Card: RiskAssist AI v1.0.0"
Description: "Synthetic model card for the deterministic AI-output simulation component used in the PoC."
* subject = Reference(device-riskassist-ai)
* status = #current
* date = "2026-03-01T10:00:00Z"
* description = "Synthetic model card for a deterministic AI-output simulation component used in the PoC."
* content[0].attachment.contentType = #text/html
* content[0].attachment.url = "https://fh-ooe.at/fhir/eu-ai-transparency/riskassist/model-card"
* content[0].attachment.title = "RiskAssist AI Model Card"
* content[1].attachment.contentType = #text/html
* content[1].attachment.url = "https://fh-ooe.at/fhir/eu-ai-transparency/riskassist/technical-documentation"
* content[1].attachment.title = "Technical Documentation"
* extension[clinicalValidationStatus].valueCodeableConcept = EUAIClinicalValidationStatusCodeSystem#not-clinically-validated "Not Clinically Validated"
* extension[performance].extension[metric][0].extension[type].valueCodeableConcept = EUAIPerformanceMetricCodeSystem#accuracy "Accuracy"
* extension[performance].extension[metric][0].extension[value].valueQuantity = 0.86 '1' "1"
* extension[performance].extension[biasDisclosure][0].valueString = "No bias evaluation is claimed for this synthetic PoC model."
* extension[training].extension[provenance].valueString = "No real training data are used. The component is used only to simulate AI-like outputs for the PoC."
* extension[training].extension[ehdsCategory][0].valueCodeableConcept = EHDSDataCategoryCodeSystem#ehr
* extension[training].extension[dataQuality][0].valueCodeableConcept = EUAIDataQualityCodeSystem#complete "Complete"
* extension[privacy].extension[retention].valueDuration = 10 'a' "years"

Instance: practitionerrole-reviewer-001
InstanceOf: EU_AIPractitionerRole
Usage: #example
Title: "PractitionerRole: Human Reviewer"
Description: "Synthetic practitioner role representing a trained internal medicine reviewer."
* practitioner = Reference(practitioner-001)
* organization = Reference(organization-examplehospital)
* code[0].text = "human-overseer"
* specialty[0].text = "Internal Medicine"
* extension[trainingStatus].valueBoolean = true


// =======================================================
// Scenario 1: AI-only execution
// =======================================================

// NEWS2-inspired clinical input data for sc-01-ai-only

Instance: sc-01-ai-only-observation-temperature-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Body Temperature (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8310-5 "Body temperature"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 38.6 'Cel' "°C"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-01-ai-only-observation-heart-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Heart Rate (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 112 '/min' "beats/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-01-ai-only-observation-respiratory-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Respiratory Rate (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#9279-1 "Respiratory rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 23 '/min' "breaths/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-01-ai-only-observation-blood-pressure-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Blood Pressure (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* component[0].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[0].valueQuantity = 96 'mm[Hg]' "mmHg"
* component[1].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[1].valueQuantity = 62 'mm[Hg]' "mmHg"
* performer = Reference(practitioner-001)

Instance: sc-01-ai-only-observation-oxygen-saturation-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Oxygen Saturation (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.coding[0] = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* code.coding[1] = http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* code.text = "Oxygen saturation in Arterial blood by Pulse oximetry"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 92 '%' "%"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* note[0].text = "NEWS2 SpO2 scale: scale-1; supplemental oxygen: false"
* performer = Reference(practitioner-001)

Instance: sc-01-ai-only-observation-consciousness-status-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Consciousness Status (1)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Consciousness status"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueCodeableConcept.text = "Alert"
* performer = Reference(practitioner-001)

// AI output and traceability for sc-01-ai-only

Instance: sc-01-ai-only-ai-observation-risk-001
InstanceOf: Observation
Usage: #example
Title: "AI Output: Early Warning Risk Assessment (1)"
Description: "Synthetic AI-generated high-risk output derived from NEWS2-inspired input parameters."
* status = #final
* code.text = "AI-assisted early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:15:03Z"
* device = Reference(device-riskassist-ai)
* meta.security = EUAIInvolvementCodeSystem#ai-generated "AI Generated"
* valueCodeableConcept.text = "high-risk"
* component[0].code.text = "Confidence"
* component[0].valueQuantity = 0.86 '1' "1"
* component[1].code.text = "Simplified score"
* component[1].valueInteger = 9
* note[0].text = "Urgent clinical review recommended"
* performer = Reference(organization-examplehospital)

Instance: sc-01-ai-only-audit-event-ai-execution-001
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace (1)"
Description: "Synthetic audit event documenting the AI execution for PoC traceability."
* extension[logIntegrity].valueSignature.type[0] = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.5 "Verification Signature"
* extension[logIntegrity].valueSignature.when = "2026-03-01T10:15:04Z"
* extension[logIntegrity].valueSignature.who = Reference(device-riskassist-ai)
* extension[logIntegrity].valueSignature.sigFormat = #text/plain
* extension[logIntegrity].valueSignature.data = "c2hhMjU2LTFmNzg5N2U0ZWVmNDNlM2ZiYmY1M2U3MDgxYzEwYTA1ZTEyZjhhNDEzZGI5NDQxMzI0NDYzZGRhZDAzNDdlMjk="
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
* entity[outputData][0].role = EUAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].role.text = "AI Output"
* entity[outputData][0].what = Reference(sc-01-ai-only-ai-observation-risk-001)

Instance: sc-01-ai-only-provenance-ai-output-001
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Output Generation (1)"
Description: "Synthetic provenance resource linking the AI output to the AI system, input data, and legal processing context."
* target = Reference(sc-01-ai-only-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprArt6Basis].concept.coding =
    GDPRArt6CodeSystem#gdpr-art-6-1-d
    "Vital Interests (Art. 6(1)(d))"
* authorization[gdprArt9Condition].concept.coding =
    GDPRArt9CodeSystem#gdpr-art-9-2-h
    "Health or Social Care (Art. 9(2)(h))"
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* activity.text = "ai-output-generation"
* agent[0].who = Reference(device-riskassist-ai)
* entity[0].role = #source
* entity[0].what = Reference(sc-01-ai-only-observation-temperature-001)
* entity[1].role = #source
* entity[1].what = Reference(sc-01-ai-only-observation-heart-rate-001)
* entity[2].role = #source
* entity[2].what = Reference(sc-01-ai-only-observation-respiratory-rate-001)
* entity[3].role = #source
* entity[3].what = Reference(sc-01-ai-only-observation-blood-pressure-001)
* entity[4].role = #source
* entity[4].what = Reference(sc-01-ai-only-observation-oxygen-saturation-001)
* entity[5].role = #source
* entity[5].what = Reference(sc-01-ai-only-observation-consciousness-status-001)
* extension[usageCategory].valueCodeableConcept = EHDSUsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept = EUAICaseSpecificIndicationCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false


// =======================================================
// Scenario 2: Validated AI output
// =======================================================

// NEWS2-inspired clinical input data for sc-02-validation

Instance: sc-02-validation-observation-temperature-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Body Temperature (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8310-5 "Body temperature"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 38.6 'Cel' "°C"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-02-validation-observation-heart-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Heart Rate (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 112 '/min' "beats/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-02-validation-observation-respiratory-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Respiratory Rate (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#9279-1 "Respiratory rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 23 '/min' "breaths/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-02-validation-observation-blood-pressure-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Blood Pressure (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* component[0].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[0].valueQuantity = 96 'mm[Hg]' "mmHg"
* component[1].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[1].valueQuantity = 62 'mm[Hg]' "mmHg"
* performer = Reference(practitioner-001)

Instance: sc-02-validation-observation-oxygen-saturation-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Oxygen Saturation (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.coding[0] = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* code.coding[1] = http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* code.text = "Oxygen saturation in Arterial blood by Pulse oximetry"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 92 '%' "%"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* note[0].text = "NEWS2 SpO2 scale: scale-1; supplemental oxygen: false"
* performer = Reference(practitioner-001)

Instance: sc-02-validation-observation-consciousness-status-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Consciousness Status (2)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Consciousness status"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueCodeableConcept.text = "Alert"
* performer = Reference(practitioner-001)

// AI output and traceability for sc-02-validation

Instance: sc-02-validation-ai-observation-risk-001
InstanceOf: Observation
Usage: #example
Title: "AI Output: Early Warning Risk Assessment (2)"
Description: "Synthetic AI-generated high-risk output derived from NEWS2-inspired input parameters."
* status = #final
* code.text = "AI-assisted early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:15:03Z"
* device = Reference(device-riskassist-ai)
* meta.security = EUAIInvolvementCodeSystem#ai-generated "AI Generated"
* valueCodeableConcept.text = "high-risk"
* component[0].code.text = "Confidence"
* component[0].valueQuantity = 0.86 '1' "1"
* component[1].code.text = "Simplified score"
* component[1].valueInteger = 9
* note[0].text = "Urgent clinical review recommended"
* performer = Reference(organization-examplehospital)

Instance: sc-02-validation-audit-event-ai-execution-001
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace (2)"
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
* entity[outputData][0].role =  EUAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].role.text = "Report"
* entity[outputData][0].what = Reference(sc-02-validation-ai-observation-risk-001)

Instance: sc-02-validation-provenance-ai-output-001
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Output Generation (2)"
Description: "Synthetic provenance resource linking the AI output to the AI system, input data, and legal processing context."
* target = Reference(sc-02-validation-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprArt6Basis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprArt9Condition].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h
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
* extension[usageCategory].valueCodeableConcept = EHDSUsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept = EUAICaseSpecificIndicationCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false

// Human oversight for sc-02-validation

Instance: sc-02-validation-human-oversight-001
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "Assessment: Human Validation of AI Output (2)"
Description: "Synthetic human oversight assessment documenting the clinician's review of the AI output."
* workflowStatus = #published
* artifactReference = Reference(sc-02-validation-ai-observation-risk-001)
* date = "2026-03-01T10:20:00Z"
* content[0].author = Reference(practitionerrole-reviewer-001)
* content[0].classifier = EUAIHumanOversightCodeSystem#human-validation "Human Validation"
* content[0].summary = "The simulated AI output was reviewed and accepted."


// =======================================================
// Scenario 3: Human override
// =======================================================

// NEWS2-inspired clinical input data for sc-03-override

Instance: sc-03-override-observation-temperature-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Body Temperature (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8310-5 "Body temperature"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 38.6 'Cel' "°C"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-03-override-observation-heart-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Heart Rate (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 112 '/min' "beats/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-03-override-observation-respiratory-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Respiratory Rate (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#9279-1 "Respiratory rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 23 '/min' "breaths/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-03-override-observation-blood-pressure-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Blood Pressure (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* component[0].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[0].valueQuantity = 96 'mm[Hg]' "mmHg"
* component[1].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[1].valueQuantity = 62 'mm[Hg]' "mmHg"
* performer = Reference(practitioner-001)

Instance: sc-03-override-observation-oxygen-saturation-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Oxygen Saturation (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.coding[0] = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* code.coding[1] = http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* code.text = "Oxygen saturation in Arterial blood by Pulse oximetry"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 92 '%' "%"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* note[0].text = "NEWS2 SpO2 scale: scale-1; supplemental oxygen: false"
* performer = Reference(practitioner-001)

Instance: sc-03-override-observation-consciousness-status-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Consciousness Status (3)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Consciousness status"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueCodeableConcept.text = "Alert"
* performer = Reference(practitioner-001)

// AI output and traceability for sc-03-override

Instance: sc-03-override-ai-observation-risk-001
InstanceOf: Observation
Usage: #example
Title: "AI Output: Early Warning Risk Assessment (3)"
Description: "Synthetic AI-generated low-risk output derived from NEWS2-inspired input parameters."
* status = #final
* code.text = "AI-assisted early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:15:03Z"
* device = Reference(device-riskassist-ai)
* meta.security = EUAIInvolvementCodeSystem#ai-generated "AI Generated"
* valueCodeableConcept.text = "low-risk"
* component[0].code.text = "Confidence"
* component[0].valueQuantity = 0.68 '1' "1"
* component[1].code.text = "Simplified score"
* component[1].valueInteger = 9
* note[0].text = "No immediate escalation suggested"
* performer = Reference(organization-examplehospital)

Instance: sc-03-override-audit-event-ai-execution-001
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace (3)"
Description: "Synthetic audit event documenting the AI execution for PoC traceability."
* extension[logIntegrity].valueSignature.type[0] = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.5 "Verification Signature"
* extension[logIntegrity].valueSignature.when = "2026-03-01T10:15:04Z"
* extension[logIntegrity].valueSignature.who = Reference(device-riskassist-ai)
* extension[logIntegrity].valueSignature.sigFormat = #text/plain
* extension[logIntegrity].valueSignature.data = "c2hhMjU2LWJiMDBlZjdhYzRjZjZiNGQxNjY2MjNkZTE5ZTgyOGVjNzJkOTIzZjRjYzg5MWI1MDEzODg4NzgwNjFmNmViYzQ="
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
* entity[outputData][0].role =  EUAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].role.text = "Report"
* entity[outputData][0].what = Reference(sc-03-override-ai-observation-risk-001)

Instance: sc-03-override-provenance-ai-output-001
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Output Generation (3)"
Description: "Synthetic provenance resource linking the AI output to the AI system, input data, and legal processing context."
* target = Reference(sc-03-override-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprArt6Basis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprArt9Condition].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* activity.text = "ai-output-generation"
* agent[0].who = Reference(device-riskassist-ai)
* entity[0].role = #source
* entity[0].what = Reference(sc-03-override-observation-temperature-001)
* entity[1].role = #source
* entity[1].what = Reference(sc-03-override-observation-heart-rate-001)
* entity[2].role = #source
* entity[2].what = Reference(sc-03-override-observation-respiratory-rate-001)
* entity[3].role = #source
* entity[3].what = Reference(sc-03-override-observation-blood-pressure-001)
* entity[4].role = #source
* entity[4].what = Reference(sc-03-override-observation-oxygen-saturation-001)
* entity[5].role = #source
* entity[5].what = Reference(sc-03-override-observation-consciousness-status-001)
* extension[usageCategory].valueCodeableConcept = EHDSUsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept = EUAICaseSpecificIndicationCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false

// Human oversight for sc-03-override

Instance: sc-03-override-human-oversight-001
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "Assessment: Human Override of AI Output (3)"
Description: "Synthetic human oversight assessment documenting the clinician's review of the AI output."
* workflowStatus = #published
* artifactReference = Reference(sc-03-override-ai-observation-risk-001)
* date = "2026-03-01T10:20:00Z"
* content[0].author = Reference(practitionerrole-reviewer-001)
* content[0].classifier = EUAIHumanOversightCodeSystem#human-override "Human Override"
* content[0].summary = "The clinician overrode the simulated low-risk AI output due to additional synthetic clinical concerns."


// =======================================================
// Scenario 4: Human correction with patient-facing explanation
// =======================================================
// NEWS2-inspired clinical input data for sc-04-correction-exp

Instance: sc-04-correction-exp-observation-temperature-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Body Temperature (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8310-5 "Body temperature"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 38.6 'Cel' "°C"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-observation-heart-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Heart Rate (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 112 '/min' "beats/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-observation-respiratory-rate-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Respiratory Rate (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#9279-1 "Respiratory rate"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 23 '/min' "breaths/min"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-observation-blood-pressure-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Blood Pressure (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* component[0].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[0].valueQuantity = 96 'mm[Hg]' "mmHg"
* component[1].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[1].valueQuantity = 62 'mm[Hg]' "mmHg"
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-observation-oxygen-saturation-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Oxygen Saturation (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.coding[0] = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* code.coding[1] = http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* code.text = "Oxygen saturation in Arterial blood by Pulse oximetry"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueQuantity = 92 '%' "%"
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* note[0].text = "NEWS2 SpO2 scale: scale-1; supplemental oxygen: false"
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-observation-consciousness-status-001
InstanceOf: Observation
Usage: #example
Title: "Input Observation: Consciousness Status (4)"
Description: "Synthetic NEWS2-inspired input parameter."
* status = #final
* code.text = "Consciousness status"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:10:00Z"
* valueCodeableConcept.text = "Alert"
* performer = Reference(practitioner-001)

// AI output and traceability for sc-04-correction-exp

Instance: sc-04-correction-exp-ai-observation-risk-001
InstanceOf: Observation
Usage: #example
Title: "AI Output: Early Warning Risk Assessment (4)"
Description: "Synthetic AI-generated low-risk output derived from NEWS2-inspired input parameters."
* status = #final
* code.text = "AI-assisted early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:15:03Z"
* device = Reference(device-riskassist-ai)
* meta.security = EUAIInvolvementCodeSystem#ai-generated "AI Generated"
* valueCodeableConcept.text = "low-risk"
* component[0].code.text = "Confidence"
* component[0].valueQuantity = 0.68 '1' "1"
* component[1].code.text = "Simplified score"
* component[1].valueInteger = 9
* note[0].text = "No immediate escalation suggested"
* performer = Reference(organization-examplehospital)

Instance: sc-04-correction-exp-audit-event-ai-execution-001
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace (4)"
Description: "Synthetic audit event documenting the AI execution for PoC traceability."
* extension[logIntegrity].valueSignature.type[0] = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.5 "Verification Signature"
* extension[logIntegrity].valueSignature.when = "2026-03-01T10:15:04Z"
* extension[logIntegrity].valueSignature.who = Reference(device-riskassist-ai)
* extension[logIntegrity].valueSignature.sigFormat = #text/plain
* extension[logIntegrity].valueSignature.data = "c2hhMjU2LWUwNTFjNDEzNmNhZWEwMmIyOTA5OWEyOWZhNzQ4Yzc3ZDgyNDNmNmEyYTRkMzllOTg3ODQ4ZDhlYzg3NGQ1MTA="
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
* entity[outputData][0].role =   EUAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].role.text = "Report"
* entity[outputData][0].what = Reference(sc-04-correction-exp-ai-observation-risk-001)

Instance: sc-04-correction-exp-provenance-ai-output-001
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Output Generation (4)"
Description: "Synthetic provenance resource linking the AI output to the AI system, input data, and legal processing context."
* target = Reference(sc-04-correction-exp-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprArt6Basis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprArt9Condition].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* activity.text = "ai-output-generation"
* agent[0].who = Reference(device-riskassist-ai)
* entity[0].role = #source
* entity[0].what = Reference(sc-04-correction-exp-observation-temperature-001)
* entity[1].role = #source
* entity[1].what = Reference(sc-04-correction-exp-observation-heart-rate-001)
* entity[2].role = #source
* entity[2].what = Reference(sc-04-correction-exp-observation-respiratory-rate-001)
* entity[3].role = #source
* entity[3].what = Reference(sc-04-correction-exp-observation-blood-pressure-001)
* entity[4].role = #source
* entity[4].what = Reference(sc-04-correction-exp-observation-oxygen-saturation-001)
* entity[5].role = #source
* entity[5].what = Reference(sc-04-correction-exp-observation-consciousness-status-001)
* extension[usageCategory].valueCodeableConcept = EHDSUsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept = EUAICaseSpecificIndicationCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false

// Human oversight for sc-04-correction-exp

Instance: sc-04-correction-exp-human-oversight-001
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "Assessment: Human Correction of AI Output (4)"
Description: "Synthetic human oversight assessment documenting the clinician's review of the AI output."
* workflowStatus = #published
* artifactReference = Reference(sc-04-correction-exp-ai-observation-risk-001)
* date = "2026-03-01T10:20:00Z"
* content[0].author = Reference(practitionerrole-reviewer-001)
* content[0].classifier = EUAIHumanOversightCodeSystem#human-correction "Human Correction"
* content[0].summary = "The simulated AI output was intentionally configured as inconsistent and corrected by the human reviewer."

Instance: sc-04-correction-exp-corrected-clinical-observation-001
InstanceOf: Observation
Usage: #example
Title: "Corrected Clinical Observation: Early Warning Risk Assessment (4)"
Description: "Human-corrected clinical result preserving traceability to the original AI-generated output."
* status = #final
* code.text = "Human-corrected early warning risk assessment"
* subject = Reference(patient-001)
* encounter = Reference(encounter-001)
* effectiveDateTime = "2026-03-01T10:20:00Z"
* derivedFrom[0] = Reference(sc-04-correction-exp-ai-observation-risk-001)
* valueCodeableConcept.text = "high-risk"
* note[0].text = "Urgent clinical review recommended"
* note[1].text = "The simulated AI output was intentionally configured as inconsistent and corrected by the human reviewer."
* note[2].text = "Corrected clinical result created for PoC traceability demonstration."
* performer = Reference(practitioner-001)

Instance: sc-04-correction-exp-patient-explanation-001
InstanceOf: EU_AIPatientExplanation
Usage: #example
Title: "Communication: Patient-Facing AI Explanation (4)"
Description: "Synthetic patient-facing explanation about AI-supported processing and human review."
* status = #completed
* subject = Reference(patient-001)
* sender = Reference(practitionerrole-reviewer-001)
* about[0] = Reference(sc-04-correction-exp-human-oversight-001)
* sent = "2026-03-01T10:30:00Z"
* payload[0].contentAttachment.contentType = #text/plain
* payload[0].contentAttachment.title = "Patient-facing AI explanation"
* payload[0].contentAttachment.data = "VGhlIEFJLXN1cHBvcnRlZCBhc3Nlc3NtZW50IHdhcyByZXZpZXdlZCBieSBhIHF1YWxpZmllZCBjbGluaWNpYW4uIFRoZSBpbml0aWFsIEFJIHJlY29tbWVuZGF0aW9uIHdhcyBjb3JyZWN0ZWQgYmVmb3JlIHRoZSBmaW5hbCBjbGluaWNhbCBkZWNpc2lvbiB3YXMgbWFkZS4="
* extension[aifInfoProvided].valueBoolean = true

// =======================================================
// Secondary Use Example
// =======================================================

Instance: example-secondary-use-provenance
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: Secondary Use Example"
Description: "Example showing EHDS secondary use purpose and data permit."

* target = Reference(sc-01-ai-only-ai-observation-risk-001)
* occurredPeriod.start = "2026-03-01T10:15:00Z"
* occurredPeriod.end = "2026-03-01T10:15:03Z"
* recorded = "2026-03-01T10:15:04Z"
* authorization[gdprArt6Basis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprArt9Condition].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h
* patient = Reference(patient-001)
* encounter = Reference(encounter-001)
* activity.text = "secondary-use-ai-validation"
* agent[0].who = Reference(device-riskassist-ai)
* entity[0].role = #source
* entity[0].what = Reference(sc-04-correction-exp-observation-temperature-001)
* extension[usageCategory].valueCodeableConcept = EHDSUsageCategoryCodeSystem#secondary-use "Secondary Use"
* extension[caseIndication].valueCodeableConcept = EUAICaseSpecificIndicationCodeSystem#prognosis "Prognostic Prediction"
* extension[automatedDecision].valueBoolean = false
* extension[secondaryUsePurpose].valueCodeableConcept = EHDSSecondaryUsePurposeCodeSystem#scientific-research "Scientific Research"
* extension[dataPermit].valueIdentifier.system = "http://example.org/fhir/sid/ehds-data-permit"
* extension[dataPermit].valueIdentifier.value = "EHDS-PERMIT-2026-0001"