// =======================================================
// EXTENSIONS DEVICE
// =======================================================

// SYS 05: Model Card Link
Extension: EU_AIModelCardLink
Id: ext-model-card
Title: "Model Card Reference"
Description: "A reference to the DocumentReference resource that acts as the Model Card, containing detailed
 documentation, intended purpose, and risk assessments."
 Context: Device
* ^context[+].type = #element
* ^context[=].expression = "Device" 
* value[x] only Reference(DocumentReference)

// LAW-04: Third-Country Data Transfer (Device Level)
Extension: ThirdCountryDataTransfer
Id: third-country-data-transfer
Title: "Third-Country Data Transfer"
Description: "Captures if patient data is transferred outside the EU by this device."
Context: Device
* extension contains
    transferFlag 1..1 MS and
    destinationCountry 0..* MS
* extension[transferFlag].value[x] only boolean
* extension[destinationCountry].value[x] only code


// =======================================================
// EXTENSIONS MODEL CARD (DocumentReference)
// =======================================================

Extension: AIPerformanceMetrics
Id: ai-performance-metrics
Title: "AI Performance Metrics"
Description: "Captures quantitative metrics and bias disclosures."
Context: DocumentReference
* ^context[0].type = #element
* ^context[0].expression = "DocumentReference"
* extension contains
    metric 1..* MS and
    biasDisclosure 0..1 MS
* extension[metric].extension contains
    type 1..1 MS and
    value 1..1 MS
* extension[metric].extension[type].value[x] only CodeableConcept
* extension[metric].extension[type].valueCodeableConcept from EU_AI_PerformanceMetricVS (extensible)
* extension[metric].extension[value].value[x] only Quantity
* extension[biasDisclosure].value[x] only string


Extension: AITrainingData
Id: ai-training-data
Title: "AI Training Data Metadata"
Description: "Details regarding provenance, EHDS categories, and data quality."
Context: DocumentReference
* extension contains
    provenance 1..1 MS and
    ehdsCategory 0..* MS and
    ehdsPermit 0..* MS and
    dataQuality 1..1 MS
* extension[provenance].value[x] only string
* extension[ehdsPermit].value[x] only Identifier
* extension[ehdsCategory].value[x] only CodeableConcept
* extension[ehdsCategory].valueCodeableConcept from EHDS_DataCategoryVS (extensible)
* extension[dataQuality].value[x] only CodeableConcept
* extension[dataQuality].valueCodeableConcept from EU_AI_DataQualityVS (extensible)


// LAW-04 & LAW-06
Extension: AIPrivacyMetadata
Id: ai-privacy-metadata
Title: "AI Privacy Metadata"
Description: "GDPR and AI Act privacy parameters. Third country transfer flags and data retention policies at the model level."
Context: DocumentReference
* extension contains
    retention 1..1 MS and
    transferFlag 1..1 MS and
    destination 0..* MS
* extension[retention].value[x] only Duration
* extension[transferFlag].value[x] only boolean
* extension[destination].value[x] only code

// =======================================================
// EXTENSIONS EHDS / PROVENANCE (Machine Event Layer)
// =======================================================

// LAW-03.1 & LAW-03.2: EHDS Usage Category and Data Permit
Extension: EHDSPUsageCategory
Id: ehds-usage-category
Title: "EHDS Usage Category"
Description: "Categorizes the data processing as Primary Care or Secondary Use according to the EHDS."
Context: Provenance
* value[x] only CodeableConcept
* valueCodeableConcept from EHDS_UsageCategoryVS (required)

Extension: EHDSDataPermit
Id: ehds-data-permit
Title: "EHDS Data Permit"
Description: "The unique ID of the Health Data Access Body permit (required if secondary use)."
Context: Provenance
* value[x] only Identifier


// =======================================================
// EXTENSIONS OBSERVATION & PATIENT (Legal/Transparency)
// =======================================================
// USE-04, LAW-01c
Extension: CaseSpecificIndication
Id: case-specific-indication
Title: "Case-Specific Indication"
Description: "The clinical reason why the AI was used for this specific patient."
Context: Observation
* value[x] only CodeableConcept
* valueCodeableConcept from EUCaseSpecificIndicationVS (extensible)

Extension: PatientAIInfoProvidedFlag
Id: patient-ai-info-provided
Title: "Patient AI Info Provided Flag"
Description: "Confirmation that the patient was informed about the use of AI systems according to AI Act transparency rules."
Context: Consent
* value[x] only boolean

// =======================================================
// EXTENSIONS HUMAN ACTION LAYER (Oversight/Training)
// =======================================================
// HL-02.2 
Extension: AISystemTrainingStatus
Id: ai-system-training-status
Title: "AI System Specific Training"
Description: "Mandatory flag indicating whether the human actor has received specific training for the utilized AI tool."
Context: ArtifactAssessment.content.author, PractitionerRole
* value[x] only boolean
* valueBoolean ^short = "True if training was completed"

Extension: EU_AI_ExplanationRequested
Id: eu-ai-explanation-requested
Title: "EU AI Act Explanation Requested Flag"
Description: "Flag indicating if the patient (data subject) explicitly requested a clear and meaningful explanation of the AI's role and the clinical decision."
Context: Communication
* ^context[+].type = #element
* ^context[=].expression = "Communication"
* value[x] only boolean
* valueBoolean 1..1 MS
* valueBoolean ^short = "True, if the patient actively requested an explanation."

// =======================================================
// EXTENSIONS AUDIT EVENT (Security/Integrity)
// =======================================================

Extension: LogIntegritySignature
Id: eu-ai-log-integrity
Title: "EU AI Act Log Integrity Signature"
Description: "Cryptographic signature or verification hash to ensure the integrity, accountability, and non-repudiation of the AI execution audit log."
Context: AuditEvent
* ^context[+].type = #element
* ^context[=].expression = "AuditEvent"
* value[x] only Signature
* value[x] 1..1 MS
* valueSignature.type 1..* MS
* valueSignature.when 1..1 MS
* valueSignature.who only Reference(Device)
* valueSignature.data 1..1 MS


