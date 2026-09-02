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

// SYS-10.1: TODO Add Description
* date 1..1 MS
* date ^short = "Date of model card publication"

// =======================================================
// CORE SUMMARY 
// (USE-02, USE-03, RISK-01)
// =======================================================

* description 1..1 MS
* description ^short = "Summary of the AI model card"
* description ^definition = "High-level summary of the intended purpose, principal limitations, risks, performance, and operational considerations documented by the model card."

// =======================================================
// STRUCTURED AI METADATA (QUAL-01, QUAL-02a, QUAL-02b, QUAL-03, QUAL-04, LAW-06)
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
// TECHNICAL DOCUMENTATION (SYS-04, SYS-06, HL-04)
// =======================================================
* content 1..* MS
* content.attachment 1..1 MS
* content.attachment.title 1..1 MS
* content.attachment.contentType 1..1 MS

* content.attachment.url 1..1 MS
* content.attachment.data 0..0
* content.attachment ^short = "Technical documentation and instructions for use"
* content.attachment ^definition = "Technical documentation or instructions for use containing intended purpose, limitations, risk information, required maintenance and support measures, maintenance frequency, and required software updates."