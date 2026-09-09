// =======================================================
// Standalone scenario: AI-generated DiagnosticReport
//
// Use Case: DiagnosticAssist AI analyzes a patient's lab
// result (C-reactive protein) and generates a draft
// diagnostic report. A human reviewer (practitioner/
// practitioner role) validates the AI output before it is
// shared with the patient. The chain of resources below
// links patient -> input observation -> AI device/model
// card -> AI-generated DiagnosticReport -> provenance and
// audit trail -> human oversight assessment -> patient
// explanation communication, all tied to the organization
// responsible for the AI system.
// =======================================================
Instance: dr-patient
InstanceOf: Patient
Usage: #example
Title: "Patient: Diagnostic Report Scenario"
Description: "The patient who is the subject of the AI-generated diagnostic report."
* gender = #female
* birthDate = "1965-06-15"

Instance: dr-practitioner
InstanceOf: Practitioner
Usage: #example
Title: "Practitioner: Diagnostic Reviewer"
Description: "The clinician who performs human oversight and validates the AI-generated diagnostic report."
* name[0].family = "Reviewer"
* name[0].given[0] = "Dana"
* name[0].prefix[0] = "Dr."

Instance: dr-organization
InstanceOf: Trust_AIOrganization
Usage: #example
Title: "Organization: Example Diagnostic Center"
Description: "The diagnostic center that owns and operates the AI system used to generate the diagnostic report."
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
InstanceOf: Trust_AIPractitionerRole
Usage: #example
Title: "PractitionerRole: Diagnostic Reviewer"
Description: "The role held by the practitioner when reviewing AI-generated diagnostic reports at the organization."
* practitioner = Reference(dr-practitioner)
* organization = Reference(dr-organization)
* code[0].text = "Human AI reviewer"
* specialty[0].text = "Internal Medicine"
* extension[trainingStatus].valueBoolean = true

Instance: dr-ai-device
InstanceOf: Trust_AIDevice
Usage: #example
Title: "Device: DiagnosticAssist AI"
Description: "The AI system that generates the diagnostic report from the patient's clinical findings."
* identifier[euDatabaseId].system = "http://example.org/fhir/sid/trust-ai-database"
* identifier[euDatabaseId].value = "trust-ai-DIAG-001"
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
Description: "The conformity declaration document for the AI device used in this diagnostic report scenario."
* status = #current
* content.attachment = conformity-declaration-attachment

Instance: conformity-declaration-attachment-2
InstanceOf: Attachment
Usage: #inline
Title: "Conformity Declaration Attachment"
Description: "The document attachment for the conformity declaration."
* title = "Conformity Declaration Attachment"


Instance: dr-model-card
InstanceOf: Trust_AIModelCard
Usage: #example
Title: "Model Card: DiagnosticAssist AI"
Description: "The model card describing the AI system's performance, training data, and privacy characteristics."
* status = #current
* date = "2026-03-01T10:00:00Z"
* description = "Synthetic model card for an AI system generating diagnostic reports from structured clinical input."
* content[0].attachment.contentType = #text/html
* content[0].attachment.url = "https://example.org/model-card/diagnostic-assist"
* content[0].attachment.title = "DiagnosticAssist AI Model Card"
* extension[clinicalValidationStatus].valueCodeableConcept =
    TrustAIClinicalValidationStatusCodeSystem#not-clinically-validated "Not Clinically Validated"
* extension[performance].extension[metric][0].extension[type].valueCodeableConcept =
    TrustAIPerformanceMetricCodeSystem#accuracy "Accuracy"
* extension[performance].extension[metric][0].extension[value].valueQuantity = 0.86 '1' "1"
* extension[performance].extension[biasDisclosure][0].valueString =
    "No subgroup performance claim is made for this synthetic example."
* extension[training].extension[provenance].valueString =
    "Synthetic training-data description for demonstration purposes."
* extension[training].extension[Category][0].valueCodeableConcept =
    DataCategoryCodeSystem#ehr
* extension[training].extension[dataQuality][0].valueCodeableConcept =
    TrustAIDataQualityCodeSystem#complete "Complete"
* extension[privacy].extension[retention].valueDuration = 10 'a' "years"

Instance: dr-input-observation
InstanceOf: Observation
Usage: #example
Title: "Input Observation: C-Reactive Protein"
Description: "The clinical finding used as input to the AI system when generating the diagnostic report."
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
Description: "The diagnostic report generated by the AI system from the patient's input observation."
* meta.security = TrustAIInvolvementCodeSystem#ai-generated "AI Generated"
* status = #final
* code.text = "AI-generated diagnostic assessment"
* subject = Reference(dr-patient)
* effectiveDateTime = "2026-03-10T09:05:00Z"
* issued = "2026-03-10T09:05:04Z"
* result[0] = Reference(dr-input-observation)
* conclusion = "The findings indicate an increased probability of an acute infectious process."

Instance: dr-ai-provenance
InstanceOf: Trust_AIProvenance
Usage: #example
Title: "Provenance: AI Diagnostic Report"
Description: "The provenance record describing how and under what legal basis the AI-generated diagnostic report was produced."
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
    UsageCategoryCodeSystem#primary-use "Primary Use"
* extension[caseIndication].valueCodeableConcept =
    TrustAICaseSpecificIndicationCodeSystem#diagnostic-support "Diagnostic Support"
* extension[automatedDecision].valueBoolean = false

Instance: dr-ai-audit-event
InstanceOf: Trust_AIAuditEvent
Usage: #example
Title: "AuditEvent: AI Diagnostic Report Generation"
Description: "The audit trail entry recording the AI system's generation of the diagnostic report."
* code.text = "AI diagnostic report generation"
* action = #C
* recorded = "2026-03-10T09:05:04Z"
* occurredPeriod.start = "2026-03-10T09:05:00Z"
* occurredPeriod.end = "2026-03-10T09:05:03Z"
* agent[0].who = Reference(dr-ai-device)
* agent[0].requestor = false
* source.observer = Reference(dr-ai-device)
* entity[outputData][0].role = TrustAIAuditEntityRoleCodeSystem#ai-output
* entity[outputData][0].what = Reference(dr-ai-diagnostic-report)

Instance: dr-human-assessment
InstanceOf: Trust_AIHumanOversightAssessment
Usage: #example
Title: "ArtifactAssessment: Human Validation"
Description: "The human oversight assessment recording the clinician's review and validation of the AI-generated diagnostic report."
* workflowStatus = #published
* artifactReference = Reference(dr-ai-diagnostic-report)
* date = "2026-03-10T09:10:00Z"
* content[0].author = Reference(dr-practitioner-role)
* content[0].classifier =
    TrustAIHumanOversightCodeSystem#human-validation "Human Validation"
* content[0].summary =
    "The clinician reviewed the AI-generated diagnostic report and accepted its conclusion."

Instance: dr-patient-communication
InstanceOf: Trust_AIPatientExplanation
Usage: #example
Title: "Communication: Patient Explanation"
Description: "The communication informing the patient about the AI's involvement in generating the diagnostic report and its subsequent human review."
* status = #completed
* subject = Reference(dr-patient)
* sender = Reference(dr-practitioner-role)
* about[0] = Reference(dr-human-assessment)
* sent = "2026-03-10T09:15:00Z"
* payload[0].contentAttachment.contentType = #text/plain
* payload[0].contentAttachment.title = "Patient-facing AI explanation"
* payload[0].contentAttachment.data = "VGhlIGRpYWdub3N0aWMgcmVwb3J0IHdhcyBnZW5lcmF0ZWQgd2l0aCBBSSBzdXBwb3J0IGFuZCBzdWJzZXF1ZW50bHkgcmV2aWV3ZWQgYnkgYSBxdWFsaWZpZWQgY2xpbmljaWFuLg=="
* extension[aifInfoProvided].valueBoolean = true
