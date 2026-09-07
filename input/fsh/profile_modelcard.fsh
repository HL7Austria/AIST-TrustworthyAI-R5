Profile: EU_AIModelCard
Parent: DocumentReference
Id: eu-ai-model-card
Title: "EU AI Act Model Card"
Description: "A DocumentReference profile representing technical documentation about an AI system, such as intended use, limitations, risk-related information, performance-related information, and model documentation."

// =============================================================================
// DOCUMENT METADATA & TRACEABILITY (SYS-05)
// =============================================================================

// SYS-05: Bidirectional link to the specific AI Device
* subject 1..1 MS
* subject only Reference(EU_AIDevice)
* subject ^short = "AI system described by this model card"

* status 1..1
* status ^short = "Publication status of the model card"
* type 1..1 MS
* type = EUAIArtifactTypeCodeSystem#model-card "AI Model Card"
* type ^short = "AI Model Card document type"

* date 1..1 MS
* date ^short = "Date of model card publication"

// =======================================================
// CORE SUMMARY 
// (USE-02 (AI Act Art. 13 | Limitations & Contraindications), USE-03 (GDPR Art. 13 | Clinical Consequences), RISK-01 (AI Act Art. 9| Health & Rights Risks))
// =======================================================

* description 1..1 MS
* description ^short = "Summary of the AI model card"
* description ^definition = "High-level summary of the intended purpose, principal limitations, risks, performance, and operational considerations documented by the model card."

// =======================================================
// STRUCTURED AI METADATA 
// QUAL-01 (AI Act Art. 13 | Performance Metrics)
// QUAL-02a (AI Act Art. 10 | Training Data Info)
// QUAL-02b (EHDS Art. 51 | Secondary Use Permit)
// QUAL-03 (EHDS Art. 78 | Data Quality Label)
// QUAL-04 (AI Act Art. 13 | Target Group Performance)
// LAW-06 (GDPR Art. 13 | Data Retention Period)
// =======================================================
* extension contains 
    AIPerformanceMetrics named performance 1..1 MS and
    AITrainingData named training 1..1 MS and
    AIRetentionInformation named privacy 1..1 MS and
    AIClinicalValidationStatus named clinicalValidationStatus 1..1 MS

* extension[performance] ^short = "Performance metrics and bias information"
* extension[training] ^short = "Training data provenance and EHDS metadata"
* extension[privacy] ^short = "Privacy and retention metadata"
* extension[clinicalValidationStatus] ^short = "Clinical validation status"

// =======================================================
// TECHNICAL DOCUMENTATION 
// SYS-04 (AI Act Annex IV | Hardware/Software Interfaces)
// SYS-06 (AI Act Art. 13 | Explainability Aids)
// HL-04 (AI Act Art. 14 | Oversight Instructions)
// =======================================================
* content 1..* MS
* content.attachment 1..1 MS
* content.attachment.title 1..1 MS
* content.attachment.contentType 1..1 MS

* content.attachment.url 1..1 MS
* content.attachment.data 0..0
* content.attachment ^short = "Technical documentation and instructions for use"
* content.attachment ^definition = "Technical documentation or instructions for use containing intended purpose, limitations, risk information, required maintenance and support measures, maintenance frequency, and required software updates."