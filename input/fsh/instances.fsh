// =======================================================
// 1. BASE ACTORS (Patient, Doctor, Organizations)
// =======================================================

Instance: patient-elias-vance
InstanceOf: Patient
Usage: #example
Title: "Patient: Elias Vance"
Description: "A fictional 61-year-old patient undergoing a routine thorax CT scan."
* name.family = "Vance"
* name.given = "Elias"
* birthDate = "1965-04-12"
* gender = #male

Instance: doctor-aris-thorne
InstanceOf: Practitioner
Usage: #example
Title: "Practitioner: Dr. Aris Thorne"
Description: "The clinical expert performing the human oversight." 
* name.family = "Thorne"
* name.given = "Aris"
* name.prefix = "Dr. med."

Instance: org-aetheria-health
InstanceOf: EU_AIOrganization
Usage: #example
Title: "Manufacturer: Aetheria HealthTech Systems"
Description: "The fictional AI provider (Manufacturer) containing the AI Incident Reporting Contact."
* name = "Aetheria HealthTech Systems Corp."
* contact[incident].name.text = "AI Safety & Vigilance Nexus"
* contact[incident].telecom[0].system = #phone
* contact[incident].telecom[0].value = "+49 000 12345678"

Instance: org-chronos-medical
InstanceOf: EU_AIOrganization
Usage: #example
Title: "Deployer: St. Chronos Medical Center"
Description: "The fictional healthcare provider (Owner/Deployer) utilizing the AI system."
* name = "St. Chronos Medical Center"
* contact[dpo].name.text = "DPO: Mag. Lyra Solis"
* contact[dpo].telecom[0].system = #email
* contact[dpo].telecom[0].value = "datenschutz@chronos-medical.test"

// =======================================================
// 2. PATIENT CONSENT & EHDS OPT-OUT
// =======================================================

Instance: consent-vance-ai
InstanceOf: EU_AIConsent
Usage: #example
Title: "Consent: Elias Vance (AI & EHDS)"
Description: "Patient was informed about AI usage but opts OUT of secondary data use."
* status = #active
* subject = Reference(patient-elias-vance)
* extension[aiInfoProvided].valueBoolean = true
* decision = #deny
* provision.purpose = http://terminology.hl7.org/CodeSystem/v3-ActReason#RESCH

// =======================================================
// 3. THE AI SYSTEM & MODEL CARD
// =======================================================

Instance: device-aurascan-ai
InstanceOf: EU_AIDevice 
Usage: #example
Title: "Device: AuraScan Pulmo-Net System"
Description: "The specific High-Risk AI System instance deployed at St. Chronos."
* name[0].value = "AuraScan Pulmo-Net Diagnostics"
* name[0].type = #registered-name
* version[0].value = "3.1.0"
* manufacturer = "Aetheria HealthTech Systems Corp."
* owner = Reference(org-chronos-medical)

* contact[0].value = "support@aetheria-health.test"
* contact[0].system = #email 
* contact[0].use = #work
* contact[1].value = "+49 000 98765432" 
* contact[1].system = #phone 
* contact[1].use = #work

* identifier[euDatabaseId].system = "http://example.org/fhir/eu-ai-transparency/sid/eu-ai-database"
* identifier[euDatabaseId].value = "EU-AI-2042-XJ992"

* conformsTo[0].specification.text = "ISO 13485:2016 Medical devices - QMS"
* conformsTo[1].specification.text = "EU AI Act High-Risk Compliance"

* note[0].text = "Maintenance: Hardware calibration required every 12 months."
* note[1].text = "Security: Software patches are deployed monthly via remote update."

* extension[modelCard].valueReference = Reference(modelcard-aurascan)
* extension[dataTransfer].extension[transferFlag].valueBoolean = false
* extension[dataTransfer].extension[destinationCountry].valueCode = #AT 

* property[ceMark].valueBoolean = true
* property[notifiedBody].valueString = "0123"
* property[expectedLifetime].valueQuantity = 5 'a' "years"
* property[medicalPurpose].valueString = "Automated detection of lung nodules in CT Thorax scans."
* property[targetPopulation][0].valueCodeableConcept = http://snomed.info/sct#38033009

Instance: modelcard-aurascan
InstanceOf: EU_AIModelCard 
Usage: #example
Title: "Model Card: AuraScan Pulmo-Net v3.1.0"
Description: "Regulatory metadata, performance metrics, and technical documentation."
* subject = Reference(device-aurascan-ai)
* status = #current
* description = "Intended for adult thorax CTs. Residual Risk: Potential for false-positive vascular artifacts."

* extension[performance].extension[metric][0].extension[type].valueCodeableConcept.text = "Accuracy"
* extension[performance].extension[metric][0].extension[value].valueQuantity = 98 '%'
* extension[performance].extension[metric][1].extension[type].valueCodeableConcept.text = "Sensitivity"
* extension[performance].extension[metric][1].extension[value].valueQuantity = 96 '%'
* extension[performance].extension[biasDisclosure].valueString = "Validated evenly across standard demographics."

* extension[training].extension[provenance].valueString = "Data from Fictional Central Health Grid"
* extension[training].extension[ehdsCategory].valueCodeableConcept = EUAIActCodeSystem#ehr "Electronic Health Records (EHRs)"
* extension[training].extension[ehdsPermit].valueIdentifier.value = "EHDS-TEST-2042-991"
* extension[training].extension[dataQuality].valueCodeableConcept = EUAIActCodeSystem#representative "Representative"

* extension[privacy].extension[retention].valueDuration = 10 'a'
* extension[privacy].extension[transferFlag].valueBoolean = false
* extension[privacy].extension[destination][0].valueCode = #AT

* content[0].attachment.title = "AuraScan Technical Documentation"
* content[0].attachment.contentType = #application/pdf
* content[0].attachment.url = "https://aetheria-health.test/docs/v3/technical-manual.pdf"
* content[1].attachment.title = "Human Oversight Instructions (HL-04)"
* content[1].attachment.contentType = #text/markdown
* content[1].attachment.url = "https://aetheria-health.test/docs/v3/oversight_guide.md"

// =======================================================
// 4. CLINICAL DATA (Input -> Output -> Traceability)
// =======================================================

Instance: input-ct-thorax
InstanceOf: ImagingStudy
Usage: #example
Title: "Input: Patient CT Thorax Scan"
Description: "The raw CT scan data acting as the input for the AI system."
* status = #available
* subject = Reference(patient-elias-vance)
* started = "2026-04-08T07:45:00Z"

Instance: observation-ai-nodule
InstanceOf: EU_AIObservation
Usage: #example
Title: "Output: AI-Generated Finding (Pulmonary Nodule)"
Description: "The preliminary clinical result generated autonomously by the AI."
* status = #preliminary 
* code.coding = http://snomed.info/sct#786838002 "Nodule of lung (disorder)"
* subject = Reference(patient-elias-vance)
* device = Reference(device-aurascan-ai) 
* interpretation[aiGeneratedFlag].coding = EUAIActCodeSystem#ai-generated
* method.text = "AuraScan Neural Engine v3.1"
* extension[caseIndication].valueCodeableConcept = EUAIActCodeSystem#screening "Screening"
* effectiveDateTime = "2026-04-08T08:00:00Z"
//performer started ai execution
* performer = Reference(doctor-aris-thorne)
Instance: doc-ai-heatmap
InstanceOf: DocumentReference
Usage: #example
Title: "Explainability Artifact: AI Heatmap"
Description: "A visual heatmap generated by the AI model to explain its finding."
* status = #current
* content[0].attachment.url = "http://chronos-medical.test/pacs/heatmaps/vance-123.png"
* content[0].attachment.contentType = #image/png

Instance: audit-ai-execution
InstanceOf: EU_AIAuditEvent
Usage: #example
Title: "Audit Log: AI Execution Trace"
Description: "Cryptographically signed trace connecting the CT scan, the AI device, and the resulting observation."
* extension[logIntegrity].valueSignature.type = http://uri.etsi.org/01903/v1.2.2#ProofOfOrigin
* extension[logIntegrity].valueSignature.when = "2026-04-08T08:00:06Z"
* extension[logIntegrity].valueSignature.who = Reference(device-aurascan-ai)
* extension[logIntegrity].valueSignature.data = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
* recorded = "2026-04-08T08:00:06Z"
* occurredPeriod.start = "2026-04-08T08:00:00Z"
* occurredPeriod.end = "2026-04-08T08:00:05Z"
* source.observer = Reference(device-aurascan-ai)
* agent[0].who = Reference(device-aurascan-ai)
* agent[0].requestor = false
* entity[inputData].what = Reference(input-ct-thorax)
* entity[referenceDb].what.identifier.system = "http://example.org/fhir/eu-ai-transparency/identifier/reference-database"
* entity[referenceDb].what.identifier.value = "Atlas-Version-9"
* entity[outputData].what = Reference(observation-ai-nodule)

Instance: prov-ai-lineage
InstanceOf: EU_AIProvenance
Usage: #example
Title: "Data Provenance: AI Lineage"
Description: "Lineage linking the clinical observation directly back to the CT scan."
* target = Reference(observation-ai-nodule)
* occurredPeriod.start = "2026-04-08T08:00:00Z"
* occurredPeriod.end = "2026-04-08T08:00:05Z"
// LAW-01a: Art. 6
* authorization[gdprBasis].concept.coding = GDPRArt6CodeSystem#gdpr-art-6-1-b
// LAW-01b: Art. 9
* authorization[gdprException].concept.coding = GDPRArt9CodeSystem#gdpr-art-9-2-h

* agent[0].who = Reference(device-aurascan-ai)
* entity[0].role = #source
* entity[0].what = Reference(input-ct-thorax)
* extension[usageCategory].valueCodeableConcept = EUAIActCodeSystem#secondary-use "Secondary Use"
* extension[dataPermit].valueIdentifier.system = "http://example.org/fhir/eu-ai-transparency/sid/ehds-data-permit"
* extension[dataPermit].valueIdentifier.value = "EHDS-TEST-2042-991"
// =======================================================
// 5. HUMAN OVERSIGHT (The Intervention)
// =======================================================

Instance: role-dr-thorne
InstanceOf: EU_AIPractitionerRole
Usage: #example
Title: "Role: Dr. Thorne (Trained Overseer)"
Description: "Links Dr. Thorne to the hospital and proves specific AI training."
* practitioner = Reference(doctor-aris-thorne) 
* specialty = http://snomed.info/sct#394914008 "Radiology"
* extension[trainingFlag].valueBoolean = true
* organization = Reference(org-chronos-medical)
* code = http://terminology.hl7.org/CodeSystem/practitioner-role#doctor "Doctor"

Instance: oversight-dr-thorne-override
InstanceOf: EU_AIHumanOversightAssessment
Usage: #example
Title: "Assessment: Human Override of AI Finding"
Description: "Dr. Thorne reviews the AI finding and the heatmap, determining it to be a false positive."
* workflowStatus = #submitted 
* date = "2026-04-08T14:05:00Z"
* artifactReference = Reference(observation-ai-nodule)
* content[0].author = Reference(role-dr-thorne)
* content[0].author.extension[ai-system-training-status].valueBoolean = true
* content[0].classifier = EUAIActCodeSystem#human-override "Human Override"
* content[0].summary = "Clinical review of the CT and AI Heatmap confirms a vascular crossing artifact, not a true pulmonary lesion. Finding dismissed."
* content[0].relatedArtifact[0].type = #citation
* content[0].relatedArtifact[0].resourceReference = Reference(doc-ai-heatmap)

// =======================================================
// 6. PATIENT COMMUNICATION (LAW-07)
// =======================================================

Instance: doc-patient-explanation
InstanceOf: DocumentReference
Usage: #example
Title: "Document: Patient AI Explanation Letter"
Description: "A patient-friendly PDF explaining the AI's role and the doctor's override."
* status = #current
* type = http://loinc.org#11502-2 "Laboratory report"
* subject = Reference(patient-elias-vance)
* content[0].attachment.url = "http://chronos-medical.test/docs/vance-ai-info.pdf"
* content[0].attachment.contentType = #application/pdf

Instance: comm-patient-explanation
InstanceOf: EU_AIPatientExplanation
Usage: #example
Title: "Communication: Right to Explanation Fulfilled"
Description: "Logs that the patient was actively informed about the human-AI decision."
* status = #completed
* subject = Reference(patient-elias-vance)
* sender = Reference(role-dr-thorne)
* extension[explanationRequested].valueBoolean = false 
* about[0] = Reference(oversight-dr-thorne-override)
* payload[0].contentReference = Reference(doc-patient-explanation)
* sent = "2026-04-08T15:30:00Z"