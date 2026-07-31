// =============================================================================
// 1. DEVICE EXTENSIONS
// Resource: EU_AIDevice
// =============================================================================

// Used in: EU_AIDevice
// Target resource: EU_AIModelCard (DocumentReference)
// Purpose: Links the registered AI system to its associated model card or
// technical documentation.
Extension: EU_AIModelCardLink
Id: ext-model-card
Title: "Model Card Reference"
Description: "References the model card that documents the AI system's intended purpose, limitations, performance, risks, and other relevant technical information."
Context: Device
* value[x] only Reference(EU_AIModelCard)
* value[x] 1..1


// Used in: EU_AIDevice
// Target resource: Device
// Purpose: Documents whether use of the AI system involves a transfer of
// personal data to a third country or an international organisation and,
// where known, the destination country or countries.
//
// Note: The extension records transfer-related metadata. It does not by itself
// establish whether the transfer is lawful under the GDPR.
// ISO 3166 Country Codes?
Extension: ThirdCountryDataTransfer
Id: third-country-data-transfer
Title: "Third-Country Data Transfer"
Description: "Documents whether use of the AI system involves a transfer of personal data to a third country or an international organisation and identifies the destination country or countries where applicable."
Context: Device
* value[x] 0..0
* extension contains
    transferFlag 1..1 MS and
    destinationCountry 0..* MS

* extension[transferFlag].value[x] only boolean
* extension[transferFlag].value[x] 1..1

* extension[destinationCountry].value[x] only code
* extension[destinationCountry].value[x] 1..1


// =============================================================================
// 2. MODEL CARD EXTENSIONS
// Resource: EU_AIModelCard (DocumentReference)
// =============================================================================

// Used in: EU_AIModelCard.extension[performance]
// Purpose: Represents one or more quantitative performance measures and
// optional free-text disclosures concerning bias, subgroup performance, or
// known evaluation limitations.
Extension: AIPerformanceMetrics
Id: ai-performance-metrics
Title: "AI Performance Metrics"
Description: "Documents quantitative performance measures and optional disclosures concerning bias, subgroup performance, or limitations of the evaluation."
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
* extension[metric].extension[type].valueCodeableConcept from EUAIPerformanceMetricVS (extensible)

* extension[metric].extension[value].value[x] only Quantity
* extension[metric].extension[value].value[x] 1..1

* extension[biasDisclosure].value[x] only string
* extension[biasDisclosure].value[x] 1..1


// Used in: EU_AIModelCard.extension[clinicalValidationStatus]
// Purpose: States the documented validation stage of the AI system.
//
// Note: This extension records the declared status. It does not independently
// verify the quality, scope, or regulatory sufficiency of the validation.
Extension: AIClinicalValidationStatus
Id: ai-clinical-validation-status
Title: "AI Clinical Validation Status"
Description: "Records the documented validation status of the AI system, such as clinically validated, under clinical validation, technically validated only, or not clinically validated."
Context: DocumentReference
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EUAIClinicalValidationStatusVS (required)


// Used in: EU_AIModelCard.extension[training]
// Purpose: Describes the origin and relevant governance characteristics of the
// data used to train or develop the AI system.
//
// Nested elements:
// - provenance: narrative description of data origin or provenance
// - ehdsCategory: EHDS-related category of the source data
// - ehdsSecondaryUsePurpose: documented secondary-use purpose
// - ehdsPermit: identifier of a relevant permit, where applicable
// - dataQuality: documented quality characteristic or assessment
Extension: AITrainingData
Id: ai-training-data
Title: "AI Training Data Metadata"
Description: "Documents the origin, relevant EHDS-related classifications, applicable permit identifiers, secondary-use purposes, and reported quality characteristics of data used to train or develop the AI system."
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
* extension[ehdsCategory].valueCodeableConcept from EHDSDataCategoryVS (extensible)

* extension[dataQuality].value[x] only CodeableConcept
* extension[dataQuality].value[x] 1..1
* extension[dataQuality].valueCodeableConcept from EUAIDataQualityVS (extensible)

* extension[ehdsSecondaryUsePurpose].value[x] only CodeableConcept
* extension[ehdsSecondaryUsePurpose].value[x] 1..1
* extension[ehdsSecondaryUsePurpose].valueCodeableConcept from EHDSSecondaryUsePurposeVS (extensible)


// Used in: EU_AIModelCard.extension[privacy]
// Purpose: Records the documented retention duration relevant to AI-related
// data, outputs, logs, or technical documentation.
//
// Note: The applicable object of retention should be made explicit in the
// surrounding model-card content because a Duration alone does not state what
// is retained.
Extension: AIRetentionInformation
Id: ai-retention-information
Title: "AI Retention Information"
Description: "Documents the stated retention duration for AI-related data, outputs, logs, or documentation."
Context: DocumentReference
* value[x] 0..0
* extension contains
    retention 1..1 MS

* extension[retention].value[x] only Duration
* extension[retention].value[x] 1..1


// =============================================================================
// 3. EHDS AND PROVENANCE EXTENSIONS
// Resource: EU_AIProvenance
// =============================================================================

// Used in: EU_AIProvenance.extension[usageCategory]
// Purpose: Distinguishes primary use from secondary use of electronic health
// data in the documented processing context.
Extension: EHDSUsageCategory
Id: ehds-usage-category
Title: "EHDS Usage Category"
Description: "Classifies the documented use of electronic health data as primary use or secondary use in the EHDS context."
Context: Provenance
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EHDSUsageCategoryVS (required)


// Used in: EU_AIProvenance.extension[dataPermit]
// Purpose: Records the identifier of a data permit associated with secondary
// use, where such a permit is applicable.
//
// Note: The extension stores a permit identifier; it does not contain the full
// permit or prove that all permit conditions were satisfied.
Extension: EHDSDataPermit
Id: ehds-data-permit
Title: "EHDS Data Permit"
Description: "Records the identifier of an EHDS data permit associated with the documented secondary use, where applicable."
Context: Provenance
* value[x] only Identifier
* value[x] 1..1


// Used in: EU_AIProvenance.extension[secondaryUsePurpose]
// Purpose: Records one or more documented purposes for secondary use of
// electronic health data.
Extension: EHDSSecondaryUsePurpose
Id: ehds-secondary-use-purpose
Title: "EHDS Secondary Use Purpose"
Description: "Records the documented purpose for secondary use of electronic health data in the EHDS context."
Context: Provenance
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EHDSSecondaryUsePurposeVS (required)


// =============================================================================
// 4. OBSERVATION EXTENSIONS
// =============================================================================

// Used in: EU_AIObservation
// Resource: Observation
// Purpose: Records the patient- and encounter-specific clinical reason for
// applying the AI system.
//
// Note: This is distinct from the general intended purpose of the AI system,
// which is documented at system or model-card level.
Extension: CaseSpecificIndication
Id: case-specific-indication
Title: "Case-Specific Indication"
Description: "Records the clinical indication or case-specific reason for applying the AI system in the documented patient context."
Context: Observation
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from EUAICaseSpecificIndicationVS (extensible)


// Used in: EU_AIObservation
// Resource: Observation
// Purpose: Indicates whether the documented result was used in a solely
// automated decision-making process.
//
// Note: A true value should not be interpreted in isolation as a definitive
// legal determination that GDPR Article 22 applies; that assessment depends on
// the full processing context and legal analysis.
Extension: AutomatedDecisionFlag
Id: automated-decision-flag
Title: "Automated Decision-Making Flag"
Description: "Indicates whether the documented AI-supported processing resulted in a decision made solely by automated means."
Context: Observation
* value[x] only boolean
* value[x] 1..1

// =============================================================================
// 5. HUMAN OVERSIGHT AND TRAINING EXTENSIONS
// =============================================================================

// Used in: EU_AIPractitionerRole or a referenced PractitionerRole
// Resource: PractitionerRole
// Purpose: Records whether the person acting in a defined professional role
// has documented system-specific training for the relevant AI system.
//
// Note: The Boolean value does not identify the training course, date,
// provider, scope, or expiry. These details would require additional modelling.
Extension: AISystemTrainingStatus
Id: ai-system-training-status
Title: "AI System-Specific Training Status"
Description: "Records whether the practitioner acting in the documented role has completed training specific to the relevant AI system."
Context: PractitionerRole
* value[x] only boolean
* value[x] 1..1


// =============================================================================
// 6. AUDIT EVENT EXTENSIONS
// =============================================================================

// Used in: EU_AIAuditEvent.extension[logIntegrity]
// Resource: AuditEvent
// Purpose: Stores a digital signature that can support verification of the
// integrity and origin of the audit-event content.
//
// Note: A Signature may contain signature data and related metadata. It should
// not be described merely as a hash unless the implementation actually uses an
// appropriate signature format and verification process.
Extension: LogIntegritySignature
Id: eu-ai-log-integrity
Title: "EU AI Log Integrity Signature"
Description: "Provides a digital signature and associated metadata to support verification of the integrity and origin of the AI execution audit record."
Context: AuditEvent
* value[x] only Signature
* value[x] 1..1
* valueSignature.type 1..*
* valueSignature.when 1..1
* valueSignature.sigFormat 1..1
* valueSignature.who only Reference(Device)
* valueSignature.data 1..1
