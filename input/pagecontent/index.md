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