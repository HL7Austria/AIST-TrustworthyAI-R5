
The Implementation Guide defines profiles covering the complete lifecycle of AI-supported clinical decision making.

## Static System Context

These profiles describe the AI system, responsible organizations, and technical documentation independently of a specific clinical execution.

### Trust_AIDevice (Device)

Represents the AI system as an identifiable and versioned system component.

It includes metadata such as:

- system name
- version
- manufacturer
- owner
- CE marking information
- intended purpose
- target population
- expected lifetime
- Trust AI database identifier

### Trust_AIOrganization (Organization)

Represents organizations involved in the AI lifecycle, including manufacturers, deployers, and healthcare providers.

It may also contain contact information for:

- Data Protection Officers
- Incident reporting
- Responsible organizations

### Trust_AIModelCard (DocumentReference)

Represents model-card documentation and technical documentation.

It references supporting documentation and contains structured metadata regarding:

- performance
- training data
- privacy
- clinical validation

---

## AI Output and Execution Context

These profiles document AI execution and legal traceability.

### Trust_AIObservation (Observation)

Represents AI-generated clinical findings.

### Trust_AIAuditEvent (AuditEvent)

Documents technical execution logs and integrity information.

### Trust_AIProvenance (Provenance)

Documents data lineage, legal basis, source data, and execution context.

### Trust_AIConsent (Consent)

Documents patient consent and AI-related transparency information.

---

## Clinical Decision and Patient-Facing Context

These profiles document human oversight and patient communication.

### Trust_AIHumanOversightAssessment (ArtifactAssessment)

Represents human validation, override, correction, and review of AI-generated outputs.

### Trust_AIPractitionerRole (PractitionerRole)

Represents the reviewing healthcare professional and associated AI-specific competencies.

### Trust_AIPatientExplanation (Communication)

Documents patient-facing explanations regarding AI-supported clinical decisions.