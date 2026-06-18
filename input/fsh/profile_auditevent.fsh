Profile: EU_AIAuditEvent
Parent: AuditEvent
Id: eu-ai-machine-execution-audit-event
Title: "EU AI Execution Audit Event"
Description: "An AuditEvent profile documenting execution-related metadata of an AI-supported processing event to support retrospective reconstruction and auditability."

// =======================================================
// 1. BASICS & METADATA
// =======================================================
* code = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
* action = #C 
* recorded 1..1 MS

// =======================================================
// 2. EXTENSIONS (Legal Requirements)
// =======================================================
// LAW-08: AI Act Security

* extension contains LogIntegritySignature named logIntegrity 1..1 MS
* extension[logIntegrity] ^short = "Cryptographic signature of this log entry"

// =======================================================
// 3. EXECUTION PERIOD (SYS-10.1)
// =======================================================
* occurredPeriod 1..1 MS
* occurredPeriod ^short = "Exact execution period (Start/End)"

// =======================================================
// 4. SOURCE & AGENT (The Machine)
// =======================================================
* source 1..1 MS
* source.observer only Reference(EU_AIDevice) 

* agent 1..* MS
* agent.who only Reference(EU_AIDevice)       
* agent.requestor = false

// =======================================================
// 5. ENTITIES (The Traceability Chain: Input -> DB -> Output)
// =======================================================
* entity
* entity ^slicing.discriminator.type = #value
* entity ^slicing.discriminator.path = "role"
* entity ^slicing.rules = #open

* entity contains inputData 1..* MS and referenceDb 0..* and outputData 1..* MS

//  (SYS-10.2)
* entity[inputData].role = http://terminology.hl7.org/CodeSystem/object-role#4
* entity[inputData] ^short = "Input Data Processed"

// (SYS-10.3)
* entity[referenceDb].role = http://terminology.hl7.org/CodeSystem/object-role#17
* entity[referenceDb] ^short = "Identification of specific reference databases or versions (e.g., Clinical Guidelines)"

// (Traceability)
* entity[outputData].role = http://terminology.hl7.org/CodeSystem/object-role#3
* entity[outputData].what only Reference(EU_AIObservation)
* entity[outputData] ^short = "The resulting AI-generated Observation"

