Profile: EU_AIModelCard
Parent: DocumentReference
Id: eu-ai-model-card
Title: "EU AI Act Model Card"
Description: "The official AI Model Card. It mandates the inclusion of intended purpose, risk assessments, and performance metrics as per the EU AI Act and GDPR."


// =============================================================================
// 1. DOCUMENT METADATA & TRACEABILITY (SYS-05)
// =============================================================================

// SYS-05: Bidirectional link to the specific AI Device
//* subject 1..1 MS
//* subject only Reference(EU_AIDevice)
//* subject ^short = "Reference to the specific AI System Device (Traceability)"

* status 1..1 MS
* status ^short = "current | superseded | entered-in-error"
* type 1..1 MS
* type = EUAIActCodeSystem#model-card "AI Model Card"
* type ^short = "AI Model Card"

// =======================================================
// 2. CORE SUMMARY 
// (USE-01, USE-02, USE-03, RISK-02)
// =======================================================
// Mandatory high-level summary of key aspects
* description 1..1 MS
* description ^short = "Mandatory high-level clinical summary and limitations of the AI model."

// =======================================================
// STRUCTURED AI METADATA (QUAL-01, QUAL-02, QUAL-03, QUAL-04, LAW-04, LAW-06)
// =======================================================
* extension contains 
    AIPerformanceMetrics named performance 1..1 MS and
    AITrainingData named training 1..1 MS and
    AIPrivacyMetadata named privacy 1..1 MS

* extension[performance] ^short = "Metrics & Bias"
* extension[training] ^short = "EHDS Permit & Data Quality"
* extension[privacy] ^short = "Transfer & Retention"

// =======================================================
// 4. TECHNICAL DOCUMENTATION (SYS-04, SYS-06, HL-04)
// =======================================================
* content 1..* MS
* content.attachment 1..1 MS
* content.attachment.title 1..1 MS
* content.attachment.contentType 1..1 MS
* content.attachment.url MS
* content.attachment.data MS
* content.attachment ^short = "Detailed technical documentation and risk assessments (PDF, HTML, etc.)"
