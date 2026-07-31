"""Map generated PoC metadata to FHIR R5 JSON resources.

This mapper is aligned with the revised EU AI IG profiles and terminology files
shared in the conversation. It intentionally does not emit the optional
LogIntegritySignature extension from the current hash-only metadata, because a
hash string is not a FHIR Signature.
"""

from __future__ import annotations

import base64
import shutil
from pathlib import Path
from typing import Any, Iterable

from fhir_utils import (
    codeable_concept,
    create_meta,
    fhir_reference,
    load_json,
    loinc_code,
    ucum_quantity,
    write_json,
)


# -----------------------------------------------------------------------------
# Paths
# -----------------------------------------------------------------------------

METADATA_DIR = Path("poc/output/metadata")
FHIR_OUTPUT_DIR = Path("poc/output/fhir")


# -----------------------------------------------------------------------------
# Canonical URLs
# -----------------------------------------------------------------------------

CANONICAL = "http://example.org/fhir/eu-ai-transparency"

PROFILE_EU_AI_ORGANIZATION = (
    f"{CANONICAL}/StructureDefinition/eu-ai-organization"
)
PROFILE_EU_AI_DEVICE = f"{CANONICAL}/StructureDefinition/eu-ai-device"
PROFILE_EU_AI_MODELCARD = f"{CANONICAL}/StructureDefinition/eu-ai-model-card"
PROFILE_EU_AI_PRACTITIONER_ROLE = (
    f"{CANONICAL}/StructureDefinition/eu-ai-practitionerrole"
)
PROFILE_EU_AI_OBSERVATION = (
    f"{CANONICAL}/StructureDefinition/eu-ai-observation"
)
PROFILE_EU_AI_AUDIT_EVENT = (
    f"{CANONICAL}/StructureDefinition/eu-ai-machine-execution-audit-event"
)
PROFILE_EU_AI_PROVENANCE = (
    f"{CANONICAL}/StructureDefinition/eu-ai-provenance"
)
PROFILE_EU_AI_HUMAN_OVERSIGHT = (
    f"{CANONICAL}/StructureDefinition/eu-ai-human-oversight"
)
PROFILE_EU_AI_PATIENT_EXPLANATION = (
    f"{CANONICAL}/StructureDefinition/eu-ai-patient-explanation"
)

EXT_MODEL_CARD = f"{CANONICAL}/StructureDefinition/ext-model-card"
EXT_THIRD_COUNTRY_DATA_TRANSFER = (
    f"{CANONICAL}/StructureDefinition/third-country-data-transfer"
)
EXT_AI_PERFORMANCE_METRICS = (
    f"{CANONICAL}/StructureDefinition/ai-performance-metrics"
)
EXT_AI_TRAINING_DATA = f"{CANONICAL}/StructureDefinition/ai-training-data"
EXT_AI_RETENTION_INFORMATION = (
    f"{CANONICAL}/StructureDefinition/ai-retention-information"
)
EXT_EHDS_USAGE_CATEGORY = (
    f"{CANONICAL}/StructureDefinition/ehds-usage-category"
)
EXT_EHDS_SECONDARY_USE_PURPOSE = (
    f"{CANONICAL}/StructureDefinition/ehds-secondary-use-purpose"
)
EXT_EHDS_DATA_PERMIT = f"{CANONICAL}/StructureDefinition/ehds-data-permit"
EXT_CASE_SPECIFIC_INDICATION = (
    f"{CANONICAL}/StructureDefinition/case-specific-indication"
)
EXT_AI_TRAINING_STATUS = (
    f"{CANONICAL}/StructureDefinition/ai-system-training-status"
)
EXT_LOG_INTEGRITY = f"{CANONICAL}/StructureDefinition/eu-ai-log-integrity"
EXT_AI_CLINICAL_VALIDATION_STATUS = (
    f"{CANONICAL}/StructureDefinition/ai-clinical-validation-status"
)
EXT_AUTOMATED_DECISION = (
    f"{CANONICAL}/StructureDefinition/automated-decision-flag"
)

CS_AI_INVOLVEMENT = f"{CANONICAL}/CodeSystem/eu-ai-involvement-cs"
CS_CASE_SPECIFIC_INDICATION = (
    f"{CANONICAL}/CodeSystem/eu-ai-case-specific-indication-cs"
)
CS_AI_PERFORMANCE_METRIC = (
    f"{CANONICAL}/CodeSystem/eu-ai-performance-metric-cs"
)
CS_AI_CLINICAL_VALIDATION_STATUS = (
    f"{CANONICAL}/CodeSystem/eu-ai-clinical-validation-status-cs"
)
CS_AI_DATA_QUALITY = f"{CANONICAL}/CodeSystem/eu-ai-data-quality-cs"
CS_HUMAN_OVERSIGHT = f"{CANONICAL}/CodeSystem/eu-ai-human-oversight-cs"
CS_AI_CONTACT_PURPOSE = f"{CANONICAL}/CodeSystem/eu-ai-contact-purpose-cs"
CS_EHDS_USAGE_CATEGORY = f"{CANONICAL}/CodeSystem/ehds-usage-category-cs"
CS_EHDS_DATA_CATEGORY = f"{CANONICAL}/CodeSystem/ehds-data-category-cs"
CS_EHDS_SECONDARY_USE_PURPOSE = (
    f"{CANONICAL}/CodeSystem/ehds-secondary-use-purpose-cs"
)
CS_GDPR_ART6 = f"{CANONICAL}/CodeSystem/gdpr-art6-codesystem"
CS_GDPR_ART9 = f"{CANONICAL}/CodeSystem/gdpr-art9-codesystem"
CS_AI_ARTIFACT_TYPE = f"{CANONICAL}/CodeSystem/eu-ai-artifact-type-cs"
CS_AI_IDENTIFIER_TYPE = f"{CANONICAL}/CodeSystem/eu-ai-identifier-type-cs"
CS_AI_SYSTEM_PROPERTY = f"{CANONICAL}/CodeSystem/eu-ai-system-property-cs"
CS_AUDIT_ENTITY_ROLE = f"{CANONICAL}/CodeSystem/eu-ai-audit-entity-role"

CS_CONTACT_ENTITY_TYPE = (
    "http://terminology.hl7.org/CodeSystem/contactentity-type"
)


# -----------------------------------------------------------------------------
# Generic helpers
# -----------------------------------------------------------------------------


def cc_from_meta(meta: dict[str, Any]) -> dict[str, Any]:
    """Create a CodeableConcept from a metadata coding object."""
    return codeable_concept(
        meta["system"],
        meta["code"],
        meta.get("display"),
        meta.get("text"),
    )


def category_from_meta(meta: dict[str, Any]) -> list[dict[str, Any]]:
    return [cc_from_meta(meta)]


def text_attachment(
    text: str,
    title: str,
) -> dict[str, Any]:
    encoded = base64.b64encode(
        text.encode("utf-8")
    ).decode("ascii")

    return {
        "contentType": "text/plain",
        "data": encoded,
        "title": title,
    }

def identifier_from_value(value: Any) -> dict[str, Any]:
    """Normalize a string or metadata object to a FHIR Identifier."""
    if isinstance(value, str):
        return {"value": value}
    if isinstance(value, dict):
        return dict(value)
    raise TypeError(f"Cannot map {value!r} to a FHIR Identifier.")


def normalized_coded_concept(
    value: str | dict[str, Any],
    *,
    system: str,
    display: str | None = None,
) -> dict[str, Any]:
    """Use the IG-defined system while preserving code/display metadata."""
    if isinstance(value, str):
        return codeable_concept(system, value, display)

    if not isinstance(value, dict):
        raise TypeError(f"Expected code string or coding object, received {value!r}.")

    return codeable_concept(
        system,
        value["code"],
        value.get("display", display),
        value.get("text"),
    )


def non_empty_strings(values: Iterable[Any]) -> list[str]:
    return [str(value) for value in values if value is not None and str(value)]


# -----------------------------------------------------------------------------
# Core resources
# -----------------------------------------------------------------------------


def map_patient(metadata: dict[str, Any]) -> dict[str, Any]:
    patient = metadata["patient"]
    return {
        "resourceType": "Patient",
        "id": patient["id"],
        "gender": patient["gender"],
        "birthDate": patient["birthDate"],
    }


def map_encounter(metadata: dict[str, Any]) -> dict[str, Any]:
    encounter = metadata["encounter"]
    fhir = metadata["fhirMapping"]["encounter"]

    resource: dict[str, Any] = {
        "resourceType": "Encounter",
        "id": encounter["id"],
        "status": fhir["status"],
        "class": [cc_from_meta(fhir["class"])],
        "subject": fhir_reference("Patient", metadata["patient"]["id"]),
        "actualPeriod": {
            "start": encounter["startedAt"],
            "end": encounter["endedAt"],
        },
    }

    clinical_indication = encounter.get("clinicalIndication")
    if clinical_indication:
        resource["reason"] = [
            {
                "value": [
                    {
                        "concept": {
                            "text": clinical_indication,
                        }
                    }
                ]
            }
        ]

    return resource


def map_organization(
    metadata: dict[str, Any],
    organization: dict[str, Any],
) -> dict[str, Any]:
    del metadata  # Mapping is fixed by the revised profile terminology.

    official_email = (
        organization.get("contactEmail")
        or organization.get("officialContactEmail")
        or organization.get("incidentReportingEmail")
        or organization.get("dpoContactEmail")
    )
    if not official_email:
        raise ValueError(
            f"Organization {organization.get('id', '<unknown>')} requires "
            "an official contact email."
        )

    contacts: list[dict[str, Any]] = [
        {
            "purpose": codeable_concept(
                CS_CONTACT_ENTITY_TYPE,
                "ADMIN",
                "Administrative",
            ),
            "telecom": [
                {
                    "system": "email",
                    "value": official_email,
                    "use": "work",
                }
            ],
        }
    ]

    dpo_email = organization.get("dpoContactEmail")
    if dpo_email:
        contacts.append(
            {
                "purpose": codeable_concept(
                    CS_AI_CONTACT_PURPOSE,
                    "dpo",
                    "Data Protection Officer",
                ),
                # In FHIR R5 ExtendedContactDetail.name is repeating in JSON.
                "name": [{"text": "Data Protection Officer"}],
                "telecom": [
                    {
                        "system": "email",
                        "value": dpo_email,
                        "use": "work",
                    }
                ],
            }
        )

    incident_email = organization.get("incidentReportingEmail")
    if incident_email:
        contacts.append(
            {
                "purpose": codeable_concept(
                    CS_AI_CONTACT_PURPOSE,
                    "ai-incident-reporting",
                    "AI Incident Reporting Contact",
                ),
                "name": [{"text": "AI Incident Reporting Contact"}],
                "telecom": [
                    {
                        "system": "email",
                        "value": incident_email,
                        "use": "work",
                    }
                ],
            }
        )

    return {
        "resourceType": "Organization",
        "id": organization["id"],
        "meta": create_meta(PROFILE_EU_AI_ORGANIZATION),
        "active": organization.get("active", True),
        "type": [{"text": organization.get("type", "organization")}],
        "name": organization["name"],
        "contact": contacts,
    }


def map_ai_device(metadata: dict[str, Any]) -> dict[str, Any]:
    ai_system = metadata["aiSystem"]
    manufacturer = metadata["manufacturerOrganization"]
    lifetime = ai_system["expectedLifetime"]
    fhir = metadata["fhirMapping"]["device"]

    properties: list[dict[str, Any]] = [
        {
            "type": codeable_concept(
                CS_AI_SYSTEM_PROPERTY,
                "ce-mark",
                "CE Marking Status",
            ),
            "valueBoolean": bool(ai_system["ceMarked"]),
        },
        {
            "type": codeable_concept(
                CS_AI_SYSTEM_PROPERTY,
                "expected-lifetime",
                "Expected Lifetime",
            ),
            "valueQuantity": {
                "value": lifetime["value"],
                "unit": lifetime["unit"],
                "system": "http://unitsofmeasure.org",
                "code": lifetime["code"],
            },
        },
        {
            "type": codeable_concept(
                CS_AI_SYSTEM_PROPERTY,
                "intended-purpose",
                "Intended Purpose",
            ),
            "valueString": ai_system["intendedPurpose"],
        },
    ]

    notified_body_id = ai_system.get("notifiedBodyId")
    if notified_body_id:
        properties.append(
            {
                "type": codeable_concept(
                    CS_AI_SYSTEM_PROPERTY,
                    "notified-body-id",
                    "Notified Body Identifier",
                ),
                "valueString": notified_body_id,
            }
        )

    target_population = ai_system.get("targetPopulation")
    target_populations = (
        target_population
        if isinstance(target_population, list)
        else [target_population]
    )
    for population in non_empty_strings(target_populations):
        properties.append(
            {
                "type": codeable_concept(
                    CS_AI_SYSTEM_PROPERTY,
                    "target-population",
                    "Target Population",
                ),
                "valueCodeableConcept": {"text": population},
            }
        )

    if not any(
        prop.get("type", {}).get("coding", [{}])[0].get("code")
        == "target-population"
        for prop in properties
    ):
        raise ValueError("EU_AIDevice requires at least one target population.")

    data_transfer = ai_system.get("dataTransfer", {})
    transfer_children: list[dict[str, Any]] = [
        {
            "url": "transferFlag",
            "valueBoolean": bool(data_transfer.get("thirdCountryTransfer", False)),
        }
    ]

    destinations = data_transfer.get("destinationCountries", [])
    if isinstance(destinations, str):
        destinations = [destinations]
    single_destination = data_transfer.get("destinationCountry")
    if single_destination:
        destinations = [*destinations, single_destination]

    for country_code in non_empty_strings(destinations):
        transfer_children.append(
            {
                "url": "destinationCountry",
                "valueCode": country_code,
            }
        )

    contacts = []
    for email in (
        manufacturer.get("contactEmail"),
        manufacturer.get("dpoContactEmail"),
    ):
        if email:
            contacts.append(
                {
                    "system": "email",
                    "value": email,
                    "use": "work",
                }
            )

    notes = []
    for note in (
        ai_system.get("maintenanceNote"),
        ai_system.get("medicalPurpose"),
    ):
        if note:
            notes.append({"text": note})

    resource: dict[str, Any] = {
        "resourceType": "Device",
        "id": ai_system["id"],
        "meta": create_meta(PROFILE_EU_AI_DEVICE),
        "identifier": [
            {
                "type": codeable_concept(
                    CS_AI_IDENTIFIER_TYPE,
                    "eu-ai-registration-number",
                    "EU AI Registration Number",
                ),
                "system": fhir["identifierSystem"],
                "value": ai_system["euDatabaseId"],
            }
        ],
        "status": ai_system["status"],
        "name": [
            {
                "value": ai_system["name"],
                "type": fhir.get("nameType", "registered-name"),
                "display": bool(fhir.get("nameDisplay", True)),
            }
        ],
        "version": [{"value": ai_system["version"]}],
        "manufacturer": manufacturer["name"],
        "owner": fhir_reference(
            "Organization",
            ai_system["ownerOrganizationId"],
        ),
        "property": properties,
        "extension": [
            {
                "url": EXT_THIRD_COUNTRY_DATA_TRANSFER,
                "extension": transfer_children,
            },
            {
                "url": EXT_MODEL_CARD,
                "valueReference": fhir_reference(
                    "DocumentReference",
                    ai_system["modelCardId"],
                ),
            },
        ],
    }

    if contacts:
        resource["contact"] = contacts

    qms_certification = ai_system.get("qmsCertification")
    if qms_certification:
        resource["conformsTo"] = [
            {
                "category": {
                    "text": fhir.get(
                        "qmsCategoryText",
                        "quality-management-system",
                    )
                },
                "specification": {"text": qms_certification},
            }
        ]

    if notes:
        resource["note"] = notes

    return resource


# -----------------------------------------------------------------------------
# Model card
# -----------------------------------------------------------------------------


def _map_performance_metric(metric: dict[str, Any]) -> dict[str, Any]:
    type_code = metric.get("typeCode") or metric.get("code")
    if not type_code:
        raise ValueError(
            "Each modelCard.performanceMetrics entry requires typeCode."
        )

    if "value" not in metric:
        raise ValueError(
            f"Performance metric {type_code!r} requires a numeric value."
        )

    return {
        "url": "metric",
        "extension": [
            {
                "url": "type",
                "valueCodeableConcept": codeable_concept(
                    CS_AI_PERFORMANCE_METRIC,
                    type_code,
                    metric.get("typeDisplay") or metric.get("display"),
                ),
            },
            {
                "url": "value",
                "valueQuantity": {
                    "value": metric["value"],
                    "unit": metric.get("unit", "1"),
                    "system": metric.get(
                        "system",
                        "http://unitsofmeasure.org",
                    ),
                    "code": metric.get("unitCode", metric.get("code", "1")),
                },
            },
        ],
    }


def map_model_card(metadata: dict[str, Any]) -> dict[str, Any]:
    model_card = metadata["modelCard"]
    fhir = metadata["fhirMapping"]["modelCard"]

    publication_date = (
        model_card.get("publicationDate")
        or model_card.get("date")
        or model_card.get("createdAt")
    )
    if not publication_date:
        raise ValueError(
            "EU_AIModelCard requires modelCard.publicationDate, "
            "modelCard.date, or modelCard.createdAt."
        )

    metrics = model_card.get("performanceMetrics") or []
    if not metrics:
        raise ValueError(
            "The current AIPerformanceMetrics extension requires metric 1..*. "
            "Add at least one explicitly documented metric to "
            "modelCard.performanceMetrics, or change the extension cardinality "
            "to metric 0..* if a model card without quantitative metrics is "
            "intended. The mapper will not invent a metric."
        )

    performance_children = [_map_performance_metric(metric) for metric in metrics]

    bias_disclosure = model_card.get("biasDisclosure")
    if isinstance(bias_disclosure, str):
        if bias_disclosure:
            performance_children.append(
                {
                    "url": "biasDisclosure",
                    "valueString": bias_disclosure,
                }
            )
    elif isinstance(bias_disclosure, list):
        for disclosure in non_empty_strings(bias_disclosure):
            performance_children.append(
                {
                    "url": "biasDisclosure",
                    "valueString": disclosure,
                }
            )
    elif bias_disclosure is not None:
        raise TypeError("modelCard.biasDisclosure must be a string or list.")

    training_data_description = model_card.get("trainingDataDescription")
    if not training_data_description:
        raise ValueError(
            "AITrainingData requires modelCard.trainingDataDescription."
        )

    training_children: list[dict[str, Any]] = [
        {
            "url": "provenance",
            "valueString": training_data_description,
        }
    ]

    training_data = model_card.get("trainingData", {})
    categories = list(training_data.get("ehdsCategories", []))
    single_category = training_data.get("ehdsCategory")
    if single_category:
        categories.append(single_category)

    for category in categories:
        training_children.append(
            {
                "url": "ehdsCategory",
                "valueCodeableConcept": normalized_coded_concept(
                    category,
                    system=CS_EHDS_DATA_CATEGORY,
                ),
            }
        )

    for purpose in training_data.get("secondaryUsePurposes", []):
        training_children.append(
            {
                "url": "ehdsSecondaryUsePurpose",
                "valueCodeableConcept": normalized_coded_concept(
                    purpose,
                    system=CS_EHDS_SECONDARY_USE_PURPOSE,
                ),
            }
        )

    for permit in training_data.get("permits", []):
        training_children.append(
            {
                "url": "ehdsPermit",
                "valueIdentifier": identifier_from_value(permit),
            }
        )

    data_quality_code = model_card.get("dataQualityCode")
    if data_quality_code:
        training_children.append(
            {
                "url": "dataQuality",
                "valueCodeableConcept": codeable_concept(
                    CS_AI_DATA_QUALITY,
                    data_quality_code,
                    model_card.get("dataQualityDisplay"),
                    text=model_card.get("dataQualityDescription"),
                ),
            }
        )

    retention = model_card.get("retention")
    if not retention:
        raise ValueError("AIRetentionInformation requires modelCard.retention.")

    clinical_validation = model_card.get("clinicalValidationStatus")
    if not clinical_validation:
        raise ValueError(
            "AIClinicalValidationStatus requires modelCard.clinicalValidationStatus."
        )

    extensions = [
        {
            "url": EXT_AI_PERFORMANCE_METRICS,
            "extension": performance_children,
        },
        {
            "url": EXT_AI_TRAINING_DATA,
            "extension": training_children,
        },
        {
            "url": EXT_AI_RETENTION_INFORMATION,
            "extension": [
                {
                    "url": "retention",
                    "valueDuration": {
                        "value": retention["value"],
                        "unit": retention["unit"],
                        "system": "http://unitsofmeasure.org",
                        "code": retention["code"],
                    },
                }
            ],
        },
        {
            "url": EXT_AI_CLINICAL_VALIDATION_STATUS,
            "valueCodeableConcept": normalized_coded_concept(
                clinical_validation,
                system=CS_AI_CLINICAL_VALIDATION_STATUS,
            ),
        },
    ]

    content = [
        {
            "attachment": {
                "contentType": model_card["contentType"],
                "url": model_card["url"],
                "title": model_card["title"],
            }
        }
    ]

    technical_documentation_url = model_card.get("technicalDocumentationUrl")
    if technical_documentation_url:
        content.append(
            {
                 "attachment": {
                    "contentType": fhir[
                        "technicalDocumentationContentType"
                    ],
                    "url": technical_documentation_url,
                    "title": fhir.get(
                        "technicalDocumentationTitle",
                        "Technical Documentation",
                    ),
                }
            }
        )

    return {
        "resourceType": "DocumentReference",
        "id": model_card["id"],
        "meta": create_meta(PROFILE_EU_AI_MODELCARD),
        "status": fhir.get("status", "current"),
        "subject": fhir_reference("Device", metadata["aiSystem"]["id"]),
        "type": codeable_concept(
            CS_AI_ARTIFACT_TYPE,
            "model-card",
            "AI Model Card",
        ),
        "date": publication_date,
        "description": model_card["description"],
        "content": content,
        "extension": extensions,
    }


# -----------------------------------------------------------------------------
# Human reviewer
# -----------------------------------------------------------------------------


def map_practitioner(metadata: dict[str, Any]) -> dict[str, Any]:
    practitioner = metadata["humanReviewer"]["practitioner"]

    return {
        "resourceType": "Practitioner",
        "id": practitioner["id"],
        "name": [
            {
                "family": practitioner["name"]["family"],
                "given": practitioner["name"]["given"],
                "prefix": practitioner["name"].get("prefix", []),
            }
        ],
    }


def map_practitioner_role(metadata: dict[str, Any]) -> dict[str, Any]:
    reviewer_role = metadata["humanReviewer"]["practitionerRole"]
    practitioner = metadata["humanReviewer"]["practitioner"]

    resource: dict[str, Any] = {
        "resourceType": "PractitionerRole",
        "id": reviewer_role["id"],
        "meta": create_meta(PROFILE_EU_AI_PRACTITIONER_ROLE),
        "practitioner": fhir_reference("Practitioner", practitioner["id"]),
        "organization": fhir_reference(
            "Organization",
            reviewer_role["organizationId"],
        ),
        "code": [{"text": reviewer_role["roleCode"]}],
        "specialty": [{"text": reviewer_role["specialty"]}],
    }

    if "aiSpecificTrainingCompleted" in reviewer_role:
        resource["extension"] = [
            {
                "url": EXT_AI_TRAINING_STATUS,
                "valueBoolean": bool(
                    reviewer_role["aiSpecificTrainingCompleted"]
                ),
            }
        ]

    return resource


# -----------------------------------------------------------------------------
# Clinical observations
# -----------------------------------------------------------------------------


def map_input_observations(metadata: dict[str, Any]) -> list[dict[str, Any]]:
    input_data = metadata["inputData"]
    ids = metadata["generatedMetadata"]["inputObservationIds"]
    patient_id = metadata["patient"]["id"]
    encounter_id = metadata["encounter"]["id"]
    fhir = metadata["fhirMapping"]["inputObservations"]
    observed_at = input_data["observedAt"]
    status = fhir["status"]
    category = category_from_meta(fhir["category"])

    common = {
        "status": status,
        "category": category,
        "subject": fhir_reference("Patient", patient_id),
        "encounter": fhir_reference("Encounter", encounter_id),
        "effectiveDateTime": observed_at,
    }

    consciousness_value = input_data["consciousnessStatus"]
    consciousness_code = consciousness_value.get("code")
    if consciousness_code:
        consciousness_concept = cc_from_meta(consciousness_code)
    else:
        consciousness_concept = {
            "text": consciousness_value["value"],
        }

    return [
        {
            "resourceType": "Observation",
            "id": ids["temperature"],
            **common,
            "code": loinc_code(input_data["temperature"]["loinc"]),
            "valueQuantity": ucum_quantity(
                input_data["temperature"]["value"],
                input_data["temperature"]["ucum"],
            ),
        },
        {
            "resourceType": "Observation",
            "id": ids["heartRate"],
            **common,
            "code": loinc_code(input_data["heartRate"]["loinc"]),
            "valueQuantity": ucum_quantity(
                input_data["heartRate"]["value"],
                input_data["heartRate"]["ucum"],
            ),
        },
        {
            "resourceType": "Observation",
            "id": ids["respiratoryRate"],
            **common,
            "code": loinc_code(input_data["respiratoryRate"]["loinc"]),
            "valueQuantity": ucum_quantity(
                input_data["respiratoryRate"]["value"],
                input_data["respiratoryRate"]["ucum"],
            ),
        },
        {
            "resourceType": "Observation",
            "id": ids["bloodPressure"],
            **common,
            "code": loinc_code(input_data["bloodPressure"]["loinc"]),
            "component": [
                {
                    "code": loinc_code(
                        input_data["bloodPressure"]["systolicLoinc"]
                    ),
                    "valueQuantity": ucum_quantity(
                        input_data["bloodPressure"]["systolic"],
                        input_data["bloodPressure"]["ucum"],
                    ),
                },
                {
                    "code": loinc_code(
                        input_data["bloodPressure"]["diastolicLoinc"]
                    ),
                    "valueQuantity": ucum_quantity(
                        input_data["bloodPressure"]["diastolic"],
                        input_data["bloodPressure"]["ucum"],
                    ),
                },
            ],
        },
        {
            "resourceType": "Observation",
            "id": ids["oxygenSaturation"],
            **common,
            "code": loinc_code(input_data["oxygenSaturation"]["loinc"]),
            "valueQuantity": ucum_quantity(
                input_data["oxygenSaturation"]["value"],
                input_data["oxygenSaturation"]["ucum"],
            ),
            "note": [
                {
                    "text": (
                        f"{fhir['oxygenSaturationNotePrefix']}: "
                        f"{input_data['oxygenSaturation']['news2Scale']}; "
                        f"{fhir['supplementalOxygenNotePrefix']}: "
                        f"{input_data['supplementalOxygen']['value']}"
                    )
                }
            ],
        },
        {
            "resourceType": "Observation",
            "id": ids["consciousnessStatus"],
            **common,
            "code": {"text": fhir["consciousnessStatusCodeText"]},
            "valueCodeableConcept": consciousness_concept,
        },
    ]


def map_ai_observation(metadata: dict[str, Any]) -> dict[str, Any]:
    ai_output = metadata["generatedMetadata"]["simulatedAiOutput"]
    fhir = metadata["fhirMapping"]["aiObservation"]

    return {
        "resourceType": "Observation",
        "id": ai_output["id"],
        "meta": create_meta(PROFILE_EU_AI_OBSERVATION),
        "extension": [
            {
                "url": EXT_CASE_SPECIFIC_INDICATION,
                "valueCodeableConcept": codeable_concept(
                    CS_CASE_SPECIFIC_INDICATION,
                    ai_output["caseSpecificIndication"],
                    ai_output.get("caseSpecificIndicationDisplay"),
                ),
            },
            {
                "url": EXT_AUTOMATED_DECISION,
                "valueBoolean": bool(ai_output["automatedDecision"]),
            },
        ],
        "status": fhir["status"],
        "code": {"text": fhir["codeText"]},
        "subject": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "effectiveDateTime": ai_output["generatedAt"],
        "device": fhir_reference("Device", ai_output["deviceId"]),
        "interpretation": [
            codeable_concept(
                CS_AI_INVOLVEMENT,
                "ai-generated",
                "AI Generated",
            )
        ],
        "valueCodeableConcept": {"text": ai_output["riskCategory"]},
        "component": [
            {
                "code": {"text": fhir["confidenceComponentText"]},
                "valueQuantity": {
                    "value": ai_output["confidence"],
                    "unit": "1",
                    "system": "http://unitsofmeasure.org",
                    "code": "1",
                },
            },
            {
                "code": {"text": fhir["simplifiedScoreComponentText"]},
                "valueInteger": ai_output["simplifiedScore"],
            },
        ],
        "note": [{"text": ai_output["recommendation"]}],
    }


# -----------------------------------------------------------------------------
# Traceability
# -----------------------------------------------------------------------------


def _optional_signature_extension(
    audit: dict[str, Any],
) -> list[dict[str, Any]] | None:
    """Map a real Signature object when explicitly supplied.

    The current simulator emits logIntegrityHash only. A hash is not silently
    represented as Signature.data because the revised extension describes a
    digital signature. Consequently, no extension is emitted for hash-only
    metadata.
    """
    signature = audit.get("logIntegritySignature")
    if not signature:
        return None

    required = ("type", "when", "who", "sigFormat", "data")
    missing = [name for name in required if not signature.get(name)]
    if missing:
        raise ValueError(
            "logIntegritySignature is missing required field(s): "
            + ", ".join(missing)
        )

    value_signature = dict(signature)
    who = value_signature["who"]
    if isinstance(who, str):
        value_signature["who"] = fhir_reference("Device", who)

    return [
        {
            "url": EXT_LOG_INTEGRITY,
            "valueSignature": value_signature,
        }
    ]


def map_audit_event(metadata: dict[str, Any]) -> dict[str, Any]:
    audit = metadata["generatedMetadata"]["auditEvent"]
    ai_output = metadata["generatedMetadata"]["simulatedAiOutput"]
    fhir = metadata["fhirMapping"]["auditEvent"]

    entities: list[dict[str, Any]] = [
        {
            "role": codeable_concept(
                CS_AUDIT_ENTITY_ROLE,
                "ai-output",
                "AI Output",
            ),
            "what": fhir_reference(
                "Observation",
                audit["entities"]["outputDataId"],
            ),
        }
    ]

    for reference_db in audit.get("entities", {}).get(
        "referenceDatabases",
        [],
    ):
        entities.append(
            {
                "role": codeable_concept(
                    CS_AUDIT_ENTITY_ROLE,
                    "reference-database",
                    "Reference Database",
                ),
                "what": fhir_reference(
                    reference_db.get("resourceType", "DocumentReference"),
                    reference_db["id"],
                ),
            }
        )

    resource: dict[str, Any] = {
        "resourceType": "AuditEvent",
        "id": audit["id"],
        "meta": create_meta(PROFILE_EU_AI_AUDIT_EVENT),
        "code": cc_from_meta(fhir["code"]),
        "action": fhir["action"],
        "recorded": audit["recordedAt"],
        "occurredPeriod": audit["occurredPeriod"],
        "authorization": [{"text": audit["purpose"]}],
        "patient": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "agent": [
            {
                "who": fhir_reference(
                    "Device",
                    audit["agent"]["aiSystemId"],
                ),
                "requestor": bool(fhir["agentRequestor"]),
            }
        ],
        "source": {
            "observer": fhir_reference(
                "Device",
                audit["agent"]["aiSystemId"],
            )
        },
        "entity": entities,
    }

    signature_extensions = _optional_signature_extension(audit)
    if signature_extensions:
        resource["extension"] = signature_extensions

    return resource


def map_provenance(metadata: dict[str, Any]) -> dict[str, Any]:
    provenance = metadata["generatedMetadata"]["provenance"]
    ai_output = metadata["generatedMetadata"]["simulatedAiOutput"]
    legal = provenance["legalContext"]
    fhir = metadata["fhirMapping"]["provenance"]

    extensions: list[dict[str, Any]] = [
        {
            "url": EXT_EHDS_USAGE_CATEGORY,
            "valueCodeableConcept": codeable_concept(
                CS_EHDS_USAGE_CATEGORY,
                legal["usageCategory"],
                legal.get("usageCategoryDisplay"),
            ),
        }
    ]

    if legal.get("usageCategory") == "secondary-use":
        for purpose in legal.get("secondaryUsePurposes", []):
            extensions.append(
                {
                    "url": EXT_EHDS_SECONDARY_USE_PURPOSE,
                    "valueCodeableConcept": normalized_coded_concept(
                        purpose,
                        system=CS_EHDS_SECONDARY_USE_PURPOSE,
                    ),
                }
            )

        permit = legal.get("dataPermit")
        if permit:
            extensions.append(
                {
                    "url": EXT_EHDS_DATA_PERMIT,
                    "valueIdentifier": identifier_from_value(permit),
                }
            )

    return {
        "resourceType": "Provenance",
        "id": provenance["id"],
        "meta": create_meta(PROFILE_EU_AI_PROVENANCE),
        "extension": extensions,
        "target": [
            fhir_reference("Observation", provenance["targetId"])
        ],
        "occurredPeriod": provenance["occurredPeriod"],
        "recorded": provenance["recordedAt"],
        "authorization": [
            {
                "concept": codeable_concept(
                    CS_GDPR_ART6,
                    legal["gdprArt6"],
                )
            },
            {
                "concept": codeable_concept(
                    CS_GDPR_ART9,
                    legal["gdprArt9"],
                )
            },
        ],
        "patient": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "activity": {"text": fhir["activityText"]},
        "agent": [
            {
                "who": fhir_reference(
                    "Device",
                    provenance["agent"]["aiSystemId"],
                )
            }
        ],
        "entity": [
            {
                "role": "source",
                "what": fhir_reference("Observation", input_id),
            }
            for input_id in provenance["entities"]["inputDataIds"]
        ],
    }


# -----------------------------------------------------------------------------
# Human oversight and patient explanation
# -----------------------------------------------------------------------------


def map_human_oversight_assessment(
    metadata: dict[str, Any],
) -> dict[str, Any]:
    oversight = metadata["generatedMetadata"]["humanOversightAssessment"]

    content: dict[str, Any] = {
        "author": fhir_reference(
            "PractitionerRole",
            oversight["reviewerId"],
        ),
        "classifier": [
            codeable_concept(
                CS_HUMAN_OVERSIGHT,
                oversight["interventionAction"],
            )
        ],
    }

    rationale = oversight.get("rationale")
    if rationale:
        content["summary"] = rationale

    return {
        "resourceType": "ArtifactAssessment",
        "id": oversight["id"],
        "meta": create_meta(PROFILE_EU_AI_HUMAN_OVERSIGHT),
        "date": oversight["reviewedAt"],
        "artifactReference": fhir_reference(
            "Observation",
            oversight["assessedAiOutputId"],
        ),
        "content": [content],
    }


def map_corrected_clinical_observation(
    metadata: dict[str, Any],
) -> dict[str, Any]:
    corrected = metadata["generatedMetadata"]["correctedClinicalObservation"]
    fhir = metadata["fhirMapping"]["correctedClinicalObservation"]

    resource: dict[str, Any] = {
        "resourceType": "Observation",
        "id": corrected["id"],
        "status": fhir["status"],
        "code": {"text": fhir["codeText"]},
        "subject": fhir_reference("Patient", corrected["subjectId"]),
        "encounter": fhir_reference("Encounter", corrected["encounterId"]),
        "effectiveDateTime": corrected["correctedAt"],
        "derivedFrom": [
            fhir_reference(
                "Observation",
                corrected["derivedFromAiOutputId"],
            )
        ],
        "valueCodeableConcept": {"text": corrected["riskCategory"]},
        "note": [
            {"text": text}
            for text in non_empty_strings(
                [
                    corrected.get("recommendation"),
                    corrected.get("reason"),
                    corrected.get("note"),
                ]
            )
        ],
    }

    corrected_by = corrected.get("correctedBy")
    if corrected_by:
        resource["performer"] = [
            fhir_reference("PractitionerRole", corrected_by)
        ]

    return resource


def map_patient_explanation(metadata: dict[str, Any]) -> dict[str, Any]:
    explanation = metadata["generatedMetadata"]["patientExplanation"]
    fhir = metadata["fhirMapping"]["patientExplanation"]

    about = [
        fhir_reference(
            "Observation",
            explanation["aboutAiOutputId"],
        )
    ]

    if explanation.get("aboutHumanOversightId"):
        about.append(
            fhir_reference(
                "ArtifactAssessment",
                explanation["aboutHumanOversightId"],
            )
        )

    return {
        "resourceType": "Communication",
        "id": explanation["id"],
        "meta": create_meta(PROFILE_EU_AI_PATIENT_EXPLANATION),
        "status": fhir["status"],
        "category": [cc_from_meta(fhir["category"])],
        "subject": fhir_reference("Patient", explanation["subjectId"]),
        "sender": fhir_reference(
            "PractitionerRole",
            explanation["senderId"],
        ),
        "sent": explanation["sentAt"],
        "about": about,
        "payload": [
            {
                "contentAttachment": text_attachment(
                    explanation["explanationText"],
                    "Patient-facing explanation of AI-supported decision",
                )
            }
        ],
    }


# -----------------------------------------------------------------------------
# Scenario orchestration and output
# -----------------------------------------------------------------------------


def map_scenario(metadata: dict[str, Any]) -> list[dict[str, Any]]:
    resources: list[dict[str, Any]] = [
        map_patient(metadata),
        map_encounter(metadata),
        map_organization(metadata, metadata["manufacturerOrganization"]),
        map_organization(metadata, metadata["operatorOrganization"]),
        map_model_card(metadata),
        map_ai_device(metadata),
        map_practitioner(metadata),
        map_practitioner_role(metadata),
    ]

    resources.extend(map_input_observations(metadata))
    resources.extend(
        [
            map_ai_observation(metadata),
            map_audit_event(metadata),
            map_provenance(metadata),
        ]
    )

    generated = metadata["generatedMetadata"]
    if "humanOversightAssessment" in generated:
        resources.append(map_human_oversight_assessment(metadata))
    if "correctedClinicalObservation" in generated:
        resources.append(map_corrected_clinical_observation(metadata))
    if "patientExplanation" in generated:
        resources.append(map_patient_explanation(metadata))

    return resources


def get_resource_filename(resource: dict[str, Any]) -> str:
    return f"{resource['resourceType']}-{resource['id']}.json"


def write_scenario_resources(
    scenario_id: str,
    resources: list[dict[str, Any]],
) -> None:
    scenario_output_dir = FHIR_OUTPUT_DIR / scenario_id

    # Avoid validating stale files left over from an earlier mapping version.
    if scenario_output_dir.exists():
        shutil.rmtree(scenario_output_dir)
    scenario_output_dir.mkdir(parents=True, exist_ok=True)

    for resource in resources:
        output_path = scenario_output_dir / get_resource_filename(resource)
        write_json(resource, output_path)
        print(f"Generated: {output_path}")


def map_metadata_file(metadata_path: Path) -> None:
    metadata = load_json(metadata_path)
    resources = map_scenario(metadata)
    write_scenario_resources(metadata["scenarioId"], resources)


def map_all_metadata_files() -> None:
    metadata_paths = sorted(METADATA_DIR.glob("sc-*.json"))

    if not metadata_paths:
        raise FileNotFoundError(f"No metadata files found in {METADATA_DIR}")

    for metadata_path in metadata_paths:
        map_metadata_file(metadata_path)


def main() -> None:
    map_all_metadata_files()


if __name__ == "__main__":
    main()
