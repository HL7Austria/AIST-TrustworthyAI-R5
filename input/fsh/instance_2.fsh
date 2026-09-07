// =======================================================
// Standalone scenario: AI-generated DiagnosticReport
// =======================================================
Instance: dr-patient
InstanceOf: Patient
Usage: #example
Title: "Patient: Diagnostic Report Scenario"
* gender = #female
* birthDate = "1965-06-15"

Instance: dr-practitioner
InstanceOf: Practitioner
Usage: #example
Title: "Practitioner: Diagnostic Reviewer"
* name[0].family = "Reviewer"
* name[0].given[0] = "Dana"
* name[0].prefix[0] = "Dr."

Instance: dr-organization
InstanceOf: EU_AIOrganization
Usage: #example
Title: "Organization: Example Diagnostic Center"
* active = true
* name = "Example Diagnostic Center"
* contact[officialContact].telecom[0].system = #email
* contact[officialContact].telecom[0].value = "contact@diagnostic-center.example"
* contact[dpo].name.text = "Data Protection Officer"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "dpo@diagnostic-center.example"
* contact[incident].name.text = "AI Incident Reporting Contact"
* contact[incident].telecom[0].system = #email
* contact[incident].telecom[0].value = "ai-incidents@diagnostic-center.example"

Instance: dr-practitioner-role
InstanceOf: EU_AIPractitionerRole
Usage: #example
Title: "PractitionerRole: Diagnostic Reviewer"
* practitioner = Reference(dr-practitioner)
* organization = Reference(dr-organization)
* code[0].text = "Human AI reviewer"
* specialty[0].text = "Internal Medicine"
* extension[trainingStatus].valueBoolean = true

Instance: dr-ai-device
InstanceOf: EU_AIDevice
Usage: #example
Title: "Device: DiagnosticAssist AI"
* identifier[euDatabaseId].system = "http://example.org/fhir/sid/eu-ai-database"
* identifier[euDatabaseId].value = "EU-AI-DIAG-001"
* status = #active
* name[0].value = "DiagnosticAssist AI"
* name[0].type = #registered-name
* version[0].value = "1.0.0"
* manufacturer = "Example AI Medical GmbH"
* owner = Reference(dr-organization)
* contact[0].system = #email
* contact[0].value = "manufacturer@example-ai-medical.example"
* contact[1].system = #email
* contact[1].value = "dpo@example-ai-medical.example"
* conformsTo[0].specification.text = "Synthetic quality management certification"
* note[0].text = "Annual maintenance and validation required."
* property[ceMark].valueBoolean = true
* property[expectedLifetime].valueQuantity = 5 'a' "years"
* property[intendedPurpose].valueString = "Support diagnostic assessment from clinical findings"
* property[targetPopulation][0].valueCodeableConcept.text = "Adult patients"
* extension[dataTransfer].extension[transferFlag].valueBoolean = false
* extension[modelCard].valueReference = Reference(dr-model-card)
* extension[conformityDeclaration].valueReference = Reference(eu-conformity-declaration-2)

Instance: eu-conformity-declaration-2
InstanceOf: DocumentReference
Usage: #example
Title: "EU Conformity Declaration"
* status = #current
* content.attachment = conformity-declaration-attachment

Instance: conformity-declaration-attachment-2
InstanceOf: Attachment
Usage: #inline
Title: "Conformity Declaration Attachment"
Description: "The document attachment for the conformity declaration."
* title = "Conformity Declaration Attachment"


Instance: dr-model-card
InstanceOf: EU_AIModelCard
Usage: #example
Title: "Model Card: DiagnosticAssist AI"
* subject = Reference(dr-ai-device)
* status = #current
* date = "2026-03-01T10:00:00Z"
* description = "Synthetic model card for an AI system generating diagnostic reports from structured clinical input."
* content[0].attachment.contentType = #text/html
* content[0].attachment.url = "https://example.org/model-card/diagnostic-assist"
* content[0].attachment.title = "DiagnosticAssist AI Model Card"
* extension[clinicalValidationStatus].valueCodeableConcept =
    EUAIClinicalValidationStatusCodeSystem#not-clinically-validated "Not Clinically Validated"
* extension[performance].extension[metric][0].extension[type].valueCodeableConcept =
    EUAIPerformanceMetricCodeSystem#accuracy "Accuracy"
* extension[performance].extension[metric][0].extension[value].valueQuantity = 0.86 '1' "1"
* extension[performance].extension[biasDisclosure][0].valueString =
    "No subgroup performance claim is made for this synthetic example."
* extension[training].extension[provenance].valueString =
    "Synthetic training-data description for demonstration purposes."
* extension[training].extension[ehdsCategory][0].valueCodeableConcept =
    EHDSDataCategoryCodeSystem#ehr
* extension[training].extension[dataQuality][0].valueCodeableConcept =
    EUAIDataQualityCodeSystem#complete "Complete"
* extension[privacy].extension[retention].valueDuration = 10 'a' "years"

Instance: dr-input-observation
InstanceOf: Observation
Usage: #example
Title: "Input Observation: C-Reactive Protein"

* status = #final
* code.text = "C-reactive protein concentration"
* subject = Reference(dr-patient)
* performer[0] = Reference(dr-organization)
* effectiveDateTime = "2026-03-10T09:00:00Z"
* valueQuantity.value = 148
* valueQuantity.unit = "mg/L"

Instance: dr-ai-diagnostic-report
InstanceOf: DiagnosticReport
Usage: #example
Title: "AI Output: Diagnostic Report"
* meta.security = EUAIInvolvementCodeSystem#ai-generated "AI Generated"
* status = #final
* code.text = "AI-generated diagnostic assessment"
* subject = Reference(dr-patient)
* effectiveDateTime = "2026-03-10T09:05:00Z"
* issued = "2026-03-10T09:05:04Z"
* result[0] = Reference(dr-input-observation)
* conclusion = "The findings indicate an increased probability of an acute infectious process."

Instance: dr-ai-provenance
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Provenance: AI Diagnostic Report"
* target = Reference(dr-ai-diagnostic-report)
* occurredPeriod.start = "2026-03-10T09:05:00Z"
* occurredPeriod.end = "2026-03-10T09:05:03Z"
* recorded = "2026-03-10T09:05:04Z"
* authorization[gdprArt6Basis].concept.coding =
    GDPRArt6CodeSystem#gdpr-art-6-1-d
* authorization[gdprArt9Condition].concept.coding =
    GDPRArt9CodeSystem#gdpr-art-9-2-h
* agent[0].who = Reference(dr-ai-device)
* entity[0].role = #source
* entity[0].what = Reference(dr-input-observation)
* extension[usageCategory].valueCodeableConcept =
    EHDSUsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept =
    EUAICaseSpecificIndicationCodeSystem#diagnostic-support "Diagnostic Support"
* extension[automatedDecision].valueBoolean = false

Instance: dr-ai-audit-event
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "AuditEvent: AI Diagnostic Report Generation"
* code.text = "AI diagnostic report generation"
* action = #C
* recorded = "2026-03-10T09:05:04Z"
* occurredPeriod.start = "2026-03-10T09:05:00Z"
* occurredPeriod.end = "2026-03-10T09:05:03Z"
* agent[0].who = Reference(dr-ai-device)
* agent[0].requestor = false
* source.observer = Reference(dr-ai-device)
* entity[outputData][0].role = EUAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].what = Reference(dr-ai-diagnostic-report)

Instance: dr-human-assessment
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "ArtifactAssessment: Human Validation"
* workflowStatus = #published
* artifactReference = Reference(dr-ai-diagnostic-report)
* date = "2026-03-10T09:10:00Z"
* content[0].author = Reference(dr-practitioner-role)
* content[0].classifier =
    EUAIHumanOversightCodeSystem#human-validation "Human Validation"
* content[0].summary =
    "The clinician reviewed the AI-generated diagnostic report and accepted its conclusion."

Instance: dr-patient-communication
InstanceOf: EU_AIPatientExplanation
Usage: #example
Title: "Communication: Patient Explanation"
* status = #completed
* subject = Reference(dr-patient)
* sender = Reference(dr-practitioner-role)
* about[0] = Reference(dr-human-assessment)
* sent = "2026-03-10T09:15:00Z"
* payload[0].contentAttachment.contentType = #text/plain
* payload[0].contentAttachment.title = "Patient-facing AI explanation"
* payload[0].contentAttachment.data = "VGhlIGRpYWdub3N0aWMgcmVwb3J0IHdhcyBnZW5lcmF0ZWQgd2l0aCBBSSBzdXBwb3J0IGFuZCBzdWJzZXF1ZW50bHkgcmV2aWV3ZWQgYnkgYSBxdWFsaWZpZWQgY2xpbmljaWFuLg=="
* extension[aifInfoProvided].valueBoolean = true
