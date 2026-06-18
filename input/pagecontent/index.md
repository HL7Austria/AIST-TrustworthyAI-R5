# EU AI Transparency Implementation Guide

## Overview

This Implementation Guide (IG) defines a custom FHIR R5 framework for representing selected AI-related transparency, traceability, legal-context, and human-oversight metadata in healthcare.

The IG focuses on how documentation requirements and transparency-relevant concepts from the EU AI Act, the GDPR, and the European Health Data Space (EHDS) can be represented using machine-readable FHIR artifacts. It provides profiles, extensions, terminology, and examples for documenting AI-supported processing in clinical contexts.

The IG does not claim to provide complete legal compliance or regulatory certification. Instead, it supports structured documentation, traceability, and interoperability for selected AI-related metadata.

## Purpose

AI-supported healthcare workflows require technical documentation that is understandable, traceable, and interoperable across systems. Relevant information may include the identity of the AI system, its intended purpose, technical documentation, training-data context, privacy metadata, legal processing context, generated outputs, execution traces, human oversight, and patient-facing information.

This IG provides a FHIR-based representation of these concepts by defining reusable profiles and extensions. The goal is to make selected AI-related metadata explicit, structured, and linkable within healthcare IT environments.

## Scope

The IG covers selected metadata areas relevant to AI-supported processing in healthcare:

- AI system identification and system-level metadata,
- organizational accountability and contact information,
- model-card and technical-documentation metadata,
- training-data and data-quality context,
- privacy and data-use metadata,
- AI-generated clinical outputs,
- execution traceability and audit metadata,
- provenance and legal-context documentation,
- human oversight actions,
- patient-facing information and explanation documentation.

The IG does not replace clinical validation, conformity assessment, data protection assessment, national legal review, or organization-specific governance processes.

## Architectural Structure

The IG organizes the profiles into three main contexts.

### 1. Static System Context

These profiles describe the AI system, responsible organizations, and technical documentation independently of a specific clinical execution.

- **EU_AIDevice** (`Device`): Represents the AI system as an identifiable and versioned system component. It includes metadata such as system name, version, manufacturer, owner, CE marking information, intended purpose, target population, expected lifetime, and EU AI database identifier where applicable.
- **EU_AIOrganization** (`Organization`): Represents organizations involved in the AI system context, such as the manufacturer, deployer, or healthcare provider. It can document relevant contact points such as data protection or incident-reporting contacts.
- **EU_AIModelCard** (`DocumentReference`): Represents model-card and technical-documentation metadata. It can reference documentation artifacts and includes structured extensions for performance information, training-data context, privacy metadata, and clinical validation status.

### 2. AI Output and Execution Context

These profiles document AI-generated outputs, execution events, provenance, and selected legal-context metadata.

- **EU_AIObservation** (`Observation`): Represents an AI-generated clinical output, such as a risk classification, recommendation, or other clinical result. It documents the case-specific indication and whether the output was used in a solely automated decision-making context.
- **EU_AIAuditEvent** (`AuditEvent`): Records the technical execution trace, including references to input data, output data, the AI system, and log-integrity metadata.
- **EU_AIProvenance** (`Provenance`): Links the AI-generated output to the AI system, source data, execution context, and selected legal-context metadata, including GDPR Article 6 and Article 9 documentation.
- **EU_AIConsent** (`Consent`): Documents patient-facing processing context, including whether AI-related information was provided and whether the documented processing context is permitted or denied, for example in relation to an opt-out. It is not used as the sole GDPR legal basis.

### 3. Clinical Decision and Patient-Facing Context

These profiles document human oversight and patient-facing explanation.

- **EU_AIHumanOversightAssessment** (`ArtifactAssessment`): Documents the human review of an AI-generated output. It can represent validation, override, or correction by a human reviewer without overwriting the original AI output.
- **EU_AIPractitionerRole** (`PractitionerRole`): Represents the reviewer in their clinical and organizational role, including whether AI-specific training was completed.
- **EU_AIPatientExplanation** (`Communication`): Documents patient-facing explanation related to the AI-supported process, where such an explanation is requested or provided.

## Validated Clinical Use Case (Instances)

To demonstrate the practical application and interoperability of these profiles, this IG includes a fully validated example instance graph. 

The scenario follows a fictitious patient (Elias Vance) undergoing a Thorax CT scan evaluated by the **AuraScan Pulmo-Net v3** AI system at **St. Chronos Medical Center**. It demonstrates the complete lifecycle of AI compliance:
1. Recording the patient's processing consent and EHDS opt-out preferences (`EU_AIConsent`).
2. The AI's preliminary (false-positive) finding of a pulmonary nodule (`EU_AIObservation`).
3. The cryptographic audit logging and data lineage of the execution (`EU_AIAuditEvent` & `EU_AIProvenance`).
4. The final clinical override by a specially trained human radiologist, Dr. Thorne, based on an explainability heatmap (`EU_AIHumanOversightAssessment`).
5. The subsequent communication of the human-AI decision workflow to the patient (`EU_AIPatientExplanation`).


## Terminology

The IG defines custom terminology where existing FHIR or clinical terminologies do not directly represent the required AI transparency and legal-context concepts.

The terminology includes:

- EU AI transparency and human-oversight codes,
- case-specific AI indication codes,
- AI performance and clinical-validation status codes,
- EHDS usage and data-category codes,
- EHDS secondary-use purpose codes,
- GDPR Article 6 legal-basis codes,
- GDPR Article 9 exception codes.

These codes are used to support structured bindings in the profiles and to make the selected metadata explicit and machine-readable.

---
**Author:** Selina Adlberger  
**Context:** Developed as part of a Master's Thesis at the University of Applied Sciences Upper Austria (Hagenberg).