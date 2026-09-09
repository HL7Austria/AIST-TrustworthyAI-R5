
# AIST-TrustworthyAI-R5: FHIR Implementation Guide for AI Transparency

![FHIR Version](https://img.shields.io/badge/FHIR-R5-firebrick.svg)
![FSH](https://img.shields.io/badge/FSH-supported-blue.svg)

This repository contains the HL7 FHIR Implementation Guide (IG) developed as part of a Master's thesis. It provides a standardized, interoperable data model to fulfill the transparency, accountability, and traceability requirements of the **EU AI Act**, the **GDPR**, and the **European Health Data Space (EHDS)** in clinical settings.

## Overview

The integration of Artificial Intelligence (AI) in healthcare requires strict adherence to legal transparency mandates. This IG bridges the gap between legal texts and technical interoperability by profiling FHIR R5 resources. 

The architecture is divided into three interconnected traceability layers:
1. **Static System Context:** Profiles for the AI model's metadata, regulatory clearance (CE marking), and Model Cards (`Device`, `Organization`, `DocumentReference`).
2. **AI Output Context:** Profiles for the dynamic execution of the AI, including automated decision flags and data provenance (`Observation`, `Provenance`, `AuditEvent`).
3. **Clinical Decision Context:** Profiles representing the "Human-in-the-Loop", tracking clinician oversight and patient communication (`ArtifactAssessment`, `PractitionerRole`, `Communication`).

## Repository Structure

* `input/fsh/`: Contains all FHIR Shorthand (FSH) files defining the Profiles, Extensions, and ValueSets.
* `input/pagecontent/`: Contains the Markdown files that make up the narrative pages of the generated HTML guide.
* `input/images/`: Diagrams and visual assets for the IG.
* `docs/`: Additional documentation and detailed requirement mapping matrices.

* Note: For a detailed mapping of EU AI Act requirements to these FHIR profiles, please refer to the documentation matrices located in the `docs/` folder or the generated IG website.*

## Prerequisites and Building the IG

This project is built using **FHIR Shorthand (FSH)** and the **HL7 IG Publisher**.

### Prerequisites
1. **Node.js**: Ensure Node.js is installed.
2. **SUSHI**: Install the FSH compiler globally:
   ```bash
   npm install -g fsh-sushi
   ```
3. **Java**: Required for the HL7 IG Publisher.

### Building Instructions
To compile the FSH files and generate the HTML-based Implementation Guide:
1. Open your terminal in the reoot directory of this repository.
2. Run the update script to ensure you have the latest publisher `.jar`:
* Windows: `_updatePublisher.bat`
* Linux/Mac: `./_updatePublisher.sh`
3. Run the build script to generate the IG.
* Windows: `_genonce.bat`
* Linux/Mac: `./_genonce.sh`

The generated HTML files will be located in the `output/` directory. Open `output/index.htmL` in your browser to view the guide.

### Contributing and Academic Context
This repository is part of an ongoing Master's thesis research project at the University of Applied Sciences Upper Austria (Hagenberg).

If you wish to explore the code, please refer to the definitions in the input/fsh/ directory. Feedback, discussions, and issues regarding the FHIR mapping strategy for regulatory compliance are welcome via GitHub Issues.