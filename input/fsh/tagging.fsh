Profile: EUAIData
Parent: Resource
Id: eu-ai-data
Title: "EU AI Data"
Description: """
A resource-independent profile indicating that an AI system was
involved in generating, reporting, assisting with, or asserting
the content of a FHIR resource.

This profile is intended as a common validation and documentation
pattern across different FHIR resource types.
"""

* meta.security 1..* MS

* meta.security ^slicing.discriminator.type = #value
* meta.security ^slicing.discriminator.path = "system"
* meta.security ^slicing.rules = #open

* meta.security contains
    aiInvolvement 1..* MS

* meta.security[aiInvolvement].system =
    "http://example.org/fhir/eu-ai-transparency/CodeSystem/eu-ai-involvement-cs"

* meta.security[aiInvolvement] from EUAIInvolvementVS (required)

* meta.security[aiInvolvement] ^short =
    "Indicates how an AI system was involved in the resource content"