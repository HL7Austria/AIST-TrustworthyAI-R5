// =======================================================
// EXTENSIONS DEVICE
// =======================================================

// SYS 05: Model Card Link
Extension: EU_AIModelCardLink
Id: ext-model-card
Title: "Model Card Reference"
Description: "A reference to the DocumentReference resource that acts as the Model Card, containing detailed documentation, intended purpose, and risk assessments."
Context: Device
* value[x] only Reference(EU_AIModelCard)
* value[x] 1..1

// LAW-04: Third-Country Data Transfer (Device Level)
Extension: ThirdCountryDataTransfer
Id: third-country-data-transfer
Title: "Third-Country Data Transfer"
Description: "Captures if patient data is transferred outside the EU by this device."
Context: Device
* value[x] 0..0
* extension contains
    transferFlag 1..1 MS and
    destinationCountry 0..* MS
* extension[transferFlag].value[x] only boolean
* extension[transferFlag].value[x] 1..1
* extension[destinationCountry].value[x] only code
* extension[destinationCountry].value[x] 1..1


// =======================================================
// EXTENSIONS MODEL CARD (DocumentReference)
// =======================================================

Extension: AIPerformanceMetrics
Id: ai-performance-metrics
Title: "AI Performance Metrics"
Description: "Captures quantitative metrics and bias disclosures."
Context: DocumentReference
* value[x] 0..0
* extension contains
    metric 1..* MS and
    biasDisclosure 0..* MS

* extension[metric].value[x] 0..0
* extension[metric].extension contains
    type 1..1 and
    value 1..1

* extension[metric].extension[type].value[x] only CodeableConcept
* extension[metric].extension[type].value[x] 1..1
* extension[metric].extension[type].valueCodeableConcept from EU_AI_PerformanceMetricVS (extensible)
* extension[metric].extension[value].value[x] only Quantity
* extension[metric].extension[value].value[x] 1..1
* extension[biasDisclosure].value[x] only string
* extension[biasDisclosure].value[x] 1..1


Extension: AIClinicalValidationStatus
Id: ai-clinical-validation-status
Title: "AI Clinical Validation Status"
Description: "Documents whether the AI system is clinically validated, not clinically validated, under validation, or only technically validated."
Context: DocumentReference
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EU_AI_ClinicalValidationStatusVS (required)

Extension: AITrainingData
Id: ai-training-data
Title: "AI Training Data Metadata"
Description: "Details regarding provenance, EHDS categories, and data quality."
Context: DocumentReference
* value[x] 0..0
* extension contains
    provenance 1..1 MS and
    ehdsCategory 0..* MS and
    ehdsSecondaryUsePurpose 0..* MS and
    ehdsPermit 0..* MS and
    dataQuality 0..* MS

* extension[provenance].value[x] only string
* extension[provenance].value[x] 1..1

* extension[ehdsPermit].value[x] only Identifier
* extension[ehdsPermit].value[x] 1..1

* extension[ehdsCategory].value[x] only CodeableConcept
* extension[ehdsCategory].value[x] 1..1
* extension[ehdsCategory].valueCodeableConcept from EHDS_DataCategoryVS (extensible)

* extension[dataQuality].value[x] only CodeableConcept
* extension[dataQuality].value[x] 1..1
* extension[dataQuality].valueCodeableConcept from EU_AI_DataQualityVS (extensible)

* extension[ehdsSecondaryUsePurpose].value[x] only CodeableConcept
* extension[ehdsSecondaryUsePurpose].value[x] 1..1
* extension[ehdsSecondaryUsePurpose].valueCodeableConcept from EHDS_SecondaryUsePurposeVS (extensible)


//  LAW-06
Extension: AIPrivacyMetadata
Id: ai-privacy-metadata
Title: "AI Privacy Metadata"
Description: "Captures the documented retention period for AI-related data, outputs, or documentation"
Context: DocumentReference
* value[x] 0..0
* extension contains
    retention 1..1 MS


* extension[retention].value[x] only Duration
* extension[retention].value[x] 1..1

// =======================================================
// EXTENSIONS EHDS / PROVENANCE (Machine Event Layer)
// =======================================================

// LAW-03.1 & LAW-03.2: EHDS Usage Category and Data Permit
Extension: EHDSUsageCategory
Id: ehds-usage-category
Title: "EHDS Usage Category"
Description: "Categorizes the data processing as Primary Care or Secondary Use according to the EHDS."
Context: Provenance
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EHDS_UsageCategoryVS (required)

Extension: EHDSDataPermit
Id: ehds-data-permit
Title: "EHDS Data Permit"
Description: "The unique ID of the Health Data Access Body permit (required if secondary use)."
Context: Provenance
* value[x] only Identifier
* value[x] 1..1

Extension: EHDSSecondaryUsePurpose
Id: ehds-secondary-use-purpose
Title: "EHDS Secondary Use Purpose"
Description: "Documents the permitted purpose for secondary use of electronic health data under the EHDS."
Context: Provenance
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EHDS_SecondaryUsePurposeVS (required)

// =======================================================
// EXTENSIONS OBSERVATION & CONSENT (Legal/Transparency)
// =======================================================
// USE-04, LAW-01c
Extension: CaseSpecificIndication
Id: case-specific-indication
Title: "Case-Specific Indication"
Description: "The clinical reason why the AI was used for this specific patient."
Context: Observation
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EUCaseSpecificIndicationVS (extensible)

Extension: AutomatedDecisionFlag
Id: automated-decision-flag
Title: "Automated Decision-Making Flag"
Description: "Indicates whether the AI-generated output was used as part of a solely automated decision-making process."
Context: Observation
* value[x] only boolean
* value[x] 1..1

Extension: PatientAIInfoProvidedFlag
Id: patient-ai-info-provided
Title: "Patient AI Info Provided Flag"
Description: "Confirmation that the patient was informed about the use of AI systems, supporting documentation of transparency requirements."
Context: Consent
* value[x] only boolean
* value[x] 1..1


// =======================================================
// EXTENSIONS HUMAN ACTION LAYER (Oversight/Training)
// =======================================================
// HL-02.2
Extension: AISystemTrainingStatus
Id: ai-system-training-status
Title: "AI System Specific Training"
Description: "Mandatory flag indicating whether the human actor has received specific training for the utilized AI tool."
Context: PractitionerRole
* value[x] only boolean
* value[x] 1..1


// =======================================================
// EXTENSIONS AUDIT EVENT (Security/Integrity)
// =======================================================

Extension: LogIntegritySignature
Id: eu-ai-log-integrity
Title: "EU AI Act Log Integrity Signature"
Description: "Cryptographic signature or verification hash supporting integrity verification and accountability of the AI execution audit log."
Context: AuditEvent
* value[x] only Signature
* value[x] 1..1
* valueSignature.type 1..*
* valueSignature.when 1..1
* valueSignature.sigFormat 1..1
* valueSignature.who only Reference(Device)
* valueSignature.data 1..1
