# Introduction

## Overview

This Implementation Guide (IG) defines a custom FHIR R5 framework for representing selected AI-related transparency, traceability, legal-context, and human-oversight metadata in healthcare.

The IG focuses on how documentation requirements and transparency-relevant concepts from the Trust AI Act, the GDPR, and the European Health Data Space (EHDS) can be represented using machine-readable FHIR artifacts. It provides profiles, extensions, terminology, and examples for documenting AI-supported processing in clinical contexts.

The IG does not claim to provide complete legal compliance or regulatory certification. Instead, it supports structured documentation, traceability, and interoperability for selected AI-related metadata.

## Out of Scope

The requirements of [Article 15 of the EU AI Act](https://artificialintelligenceact.eu/article/15/) concerning the accuracy, robustness, and cybersecurity of high-risk AI systems are not represented as computable artifacts, profiles, extensions, or conformance requirements within this Implementation Guide. However, these requirements remain highly relevant for the design, development, deployment, and governance of AI-enabled solutions and should be taken into account when planning and structuring implementation projects. In particular, project teams should consider the need to document and manage performance metrics, system robustness, error handling, resilience measures, and cybersecurity controls in accordance with applicable regulatory obligations. Article 15 applies throughout the lifecycle of high-risk AI systems and requires appropriate levels of accuracy, robustness, and cybersecurity, including protection against AI-specific security threats.

## Regulatory Foundations

The profiles in this IG are derived from a structured [requirement analysis](requirements.html) of the **EU AI Act**, the **GDPR**, and the **European Health Data Space (EHDS)**. The analysis identifies 38 high-level documentation requirements in six categories:

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

## Architecture

The Implementation Guide is organized into three main architectural contexts:

- Static System Context
- AI Output and Execution Context
- Clinical Decision and Patient-Facing Context

Detailed descriptions of all profiles are available in the **Profiles** section.

[![overview](Trust_AI_Ecosystem_Model.png){: style="width: 100%"}](Trust_AI_Ecosystem_Model.png)

FHIR-based traceability model linking AI system, clinical output, human oversight, and patient communication. Green elements represent the Static System Context, purple elements denote the AI output context, and blue elements indicate the clinical decision context. Yellow elements are included as supporting resources required for the representation of the workflow, but are not implemented as dedicated profiles in this IG.
