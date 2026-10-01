# Trust AI Transparency Implementation Guide

## Overview

This Implementation Guide (IG) defines a custom FHIR R5 framework for representing selected AI-related transparency, traceability, legal-context, and human-oversight metadata in healthcare.

The IG focuses on how documentation requirements and transparency-relevant concepts from the Trust AI Act, the GDPR, and the European Health Data Space (EHDS) can be represented using machine-readable FHIR artifacts. It provides profiles, extensions, terminology, and examples for documenting AI-supported processing in clinical contexts.

The IG does not claim to provide complete legal compliance or regulatory certification. Instead, it supports structured documentation, traceability, and interoperability for selected AI-related metadata.

## Purpose

AI-supported healthcare workflows require technical documentation that is understandable, traceable, and interoperable across systems. Relevant information may include the identity of the AI system, its intended purpose, technical documentation, training-data context, privacy metadata, legal processing context, generated outputs, execution traces, human oversight, and patient-facing information.

This IG provides a FHIR-based representation of these concepts by defining reusable profiles and extensions. The goal is to make selected AI-related metadata explicit, structured, and linkable within healthcare IT environments.

## Scope

The IG covers selected metadata areas relevant to AI-supported processing in healthcare:

- AI system identification and system-level metadata
- Organizational accountability and contact information
- Model-card and technical-documentation metadata
- Training-data and data-quality context
- Privacy and data-use metadata
- AI-generated clinical outputs
- Execution traceability and audit metadata
- Provenance and legal-context documentation
- Human oversight actions
- Patient-facing information and explanation documentation

The IG does not replace clinical validation, conformity assessment, data protection assessment, national legal review, or organization-specific governance processes.

## Architecture

The Implementation Guide is organized into three main architectural contexts:

- Static System Context
- AI Output and Execution Context
- Clinical Decision and Patient-Facing Context

Detailed descriptions of all profiles are available in the **Profiles** section.

## Regulatory Requirements and Traceability

The profiles in this IG are derived from a structured requirement analysis of the **EU AI Act**, the **GDPR**, and the **European Health Data Space (EHDS)**. The analysis identifies 38 high-level documentation requirements in six categories:

| Category | Prefix | Examples |
|---|---|---|
| System | `SYS` | System name and version, EU Declaration of Conformity, CE marking, EU database registration, audit trail |
| Purpose | `USE` | Intended purpose, limitations and contraindications, case-specific indication |
| Performance | `QUAL` | Performance metrics, training data information, EHDS data category and permit, data quality |
| Risks | `RISK` | Health, safety, and fundamental-rights risks |
| Oversight | `HL` | Responsible human reviewer, qualification, type of intervention, oversight instructions |
| Legal | `LAW` | GDPR legal basis, automated decision flag, primary/secondary use, third-country transfer, right to explanation, log integrity |
{: .grid}

The requirements are refined into three logical data models, one per architectural layer, with 57 logical attributes and their multiplicities:

| Layer | Logical attributes | Implemented by |
|---|---|---|
| Static System Context | 36 | [Trust_AIDevice](StructureDefinition-trust-ai-device.html), [Trust_AIOrganization](StructureDefinition-trust-ai-organization.html), [Trust_AIModelCard](StructureDefinition-trust-ai-model-card.html) |
| AI Output Context | 12 | [Trust_AIObservation](StructureDefinition-trust-ai-observation.html), [Trust_AIProvenance](StructureDefinition-trust-ai-provenance.html), [Trust_AIAuditEvent](StructureDefinition-trust-ai-machine-execution-audit-event.html) |
| Clinical Decision Context | 9 | [Trust_AIHumanOversightAssessment](StructureDefinition-trust-ai-human-oversight.html), [Trust_AIPractitionerRole](StructureDefinition-trust-ai-practitionerrole.html), [Trust_AIPatientExplanation](StructureDefinition-trust-ai-patient-explanation.html) |
{: .grid}

46 of the 57 attributes are fully covered by a dedicated profile element and 10 are partially covered. One, the patient opt-out flag (LAW-05), is not yet modelled.

The complete requirements matrix, the logical data models, the element-level mapping, and the open points are on the **[Requirements Traceability](requirements.html)** page. Each profile page also lists the requirements it implements.

## Contents

This Implementation Guide contains:

- Profiles
- Extensions
- Code Systems
- Value Sets
- Example Instances
- Downloads
- Dependency Information

---
---
**Author:** Selina Adlberger  
**Context:** Developed as part of a Master's Thesis at the University of Applied Sciences Upper Austria (Hagenberg).