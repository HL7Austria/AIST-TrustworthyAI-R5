Profile: EU_AIAuditEvent
Parent: AuditEvent
Id: eu-ai-machine-execution-audit-event
Title: "EU AI Execution Audit Event"
Description: "An AuditEvent profile documenting execution-related metadata of an AI-supported processing event to support retrospective reconstruction and auditability."

// =======================================================
// BASICS
// =======================================================
//* code = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
//* action = #C 
* recorded 1..1 MS

// =======================================================
// EXTENSIONS (Legal Requirements)
// =======================================================
// LAW-08: AI Act Security
* extension contains LogIntegritySignature named logIntegrity 0..1 MS
* extension[logIntegrity] ^short = "Cryptographic signature of this log entry"

// =======================================================
// EXECUTION PERIOD (SYS-10.1)
// =======================================================
* occurred[x] only Period

* occurredPeriod.start 1..1 MS
* occurredPeriod.end 1..1 MS

// =======================================================
// SOURCE & AGENT (The Machine)
// =======================================================
* source 1..1 MS
* source.observer only Reference(EU_AIDevice) 
* source.observer ^short = "AI system that generated this audit record"

* agent 1..* MS
* agent.who only Reference(EU_AIDevice)
* agent.who ^short = "AI system that performed the processing activity"

// =======================================================
// TRACEABILITY (SYS-10.2 & SYS-10.3)
// =======================================================

* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "role"
* entity ^slicing.rules = #open

* entity contains inputData 1..* MS and referenceDb 0..* and outputData 1..* MS

//  (SYS-10.2)
* entity[inputData].role = http://terminology.hl7.org/CodeSystem/object-role#4
* entity[inputData].what 1..1
* entity[inputData].what only Reference(Observation or ImagingStudy or DocumentReference)
* entity[inputData] ^short = "Input data used by the AI system"

// (SYS-10.3)
* entity[referenceDb].role = http://terminology.hl7.org/CodeSystem/object-role#17
* entity[referenceDb].what 1..1
* entity[referenceDb] ^short = "Reference database or knowledge source used by the AI system"

// (Traceability)
* entity[outputData].role = http://terminology.hl7.org/CodeSystem/object-role#3
* entity[outputData].what 1..1
* entity[outputData].what only Reference(EU_AIObservation)
* entity[outputData] ^short = "AI-generated clinical output"

