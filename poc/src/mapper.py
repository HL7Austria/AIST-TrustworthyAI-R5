from pathlib import Path
from typing import Any

from fhir_utils import (
    load_json,
    write_json,
    fhir_reference,
    create_meta,
    codeable_concept,
    loinc_code,
    ucum_quantity,
    create_log_integrity_extension,
)

METADATA_DIR = Path("poc/output/metadata")
FHIR_OUTPUT_DIR = Path("poc/output/fhir")

CANONICAL = "http://example.org/fhir/eu-ai-transparency"

PROFILE_EU_AI_ORGANIZATION = f"{CANONICAL}/StructureDefinition/eu-ai-organization"
PROFILE_EU_AI_DEVICE = f"{CANONICAL}/StructureDefinition/eu-ai-device"
PROFILE_EU_AI_MODELCARD = f"{CANONICAL}/StructureDefinition/eu-ai-model-card"
PROFILE_EU_AI_CONSENT = f"{CANONICAL}/StructureDefinition/eu-ai-consent"
PROFILE_EU_AI_PRACTITIONER_ROLE = f"{CANONICAL}/StructureDefinition/eu-ai-practitionerrole"
PROFILE_EU_AI_OBSERVATION = f"{CANONICAL}/StructureDefinition/eu-ai-observation"
PROFILE_EU_AI_AUDIT_EVENT = f"{CANONICAL}/StructureDefinition/eu-ai-machine-execution-audit-event"
PROFILE_EU_AI_PROVENANCE = f"{CANONICAL}/StructureDefinition/eu-ai-provenance"
PROFILE_EU_AI_HUMAN_OVERSIGHT = f"{CANONICAL}/StructureDefinition/eu-ai-human-oversight"
PROFILE_EU_AI_PATIENT_EXPLANATION = f"{CANONICAL}/StructureDefinition/eu-ai-patient-explanation"

EXT_MODEL_CARD = f"{CANONICAL}/StructureDefinition/ext-model-card"
EXT_THIRD_COUNTRY_DATA_TRANSFER = f"{CANONICAL}/StructureDefinition/third-country-data-transfer"
EXT_AI_PERFORMANCE_METRICS = f"{CANONICAL}/StructureDefinition/ai-performance-metrics"
EXT_AI_TRAINING_DATA = f"{CANONICAL}/StructureDefinition/ai-training-data"
EXT_AI_PRIVACY_METADATA = f"{CANONICAL}/StructureDefinition/ai-privacy-metadata"
EXT_EHDS_USAGE_CATEGORY = f"{CANONICAL}/StructureDefinition/ehds-usage-category"
EXT_CASE_SPECIFIC_INDICATION = f"{CANONICAL}/StructureDefinition/case-specific-indication"
EXT_PATIENT_AI_INFO_PROVIDED = f"{CANONICAL}/StructureDefinition/patient-ai-info-provided"
EXT_AI_TRAINING_STATUS = f"{CANONICAL}/StructureDefinition/ai-system-training-status"
EXT_EXPLANATION_REQUESTED = f"{CANONICAL}/StructureDefinition/eu-ai-explanation-requested"
EXT_LOG_INTEGRITY = f"{CANONICAL}/StructureDefinition/eu-ai-log-integrity"

CS_EU_AI_ACT = f"{CANONICAL}/CodeSystem/EUAIActCodeSystem"
CS_GDPR_ART6 = f"{CANONICAL}/CodeSystem/gdpr-art6-codesystem"
CS_GDPR_ART9 = f"{CANONICAL}/CodeSystem/gdpr-art9-codesystem"


def cc_from_meta(meta: dict[str, Any]) -> dict[str, Any]:
    return codeable_concept(
        meta["system"],
        meta["code"],
        meta.get("display"),
        meta.get("text"),
    )


def category_from_meta(meta: dict[str, Any]) -> list[dict[str, Any]]:
    return [cc_from_meta(meta)]


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

    return {
        "resourceType": "Encounter",
        "id": encounter["id"],
        "status": fhir["status"],
        "class": [cc_from_meta(fhir["class"])],
        "subject": fhir_reference("Patient", metadata["patient"]["id"]),
        "actualPeriod": {
            "start": encounter["startedAt"],
            "end": encounter["endedAt"],
        },
        "reason": [
            {
                "value": [
                    {
                        "concept": {
                            "text": encounter["clinicalIndication"],
                        }
                    }
                ]
            }
        ],
    }


def map_organization(metadata: dict[str, Any], organization: dict[str, Any]) -> dict[str, Any]:
    fhir = metadata["fhirMapping"]["organization"]
    contact = [
        {
            "telecom": [
                {
                    "system": "email",
                    "value": organization["contactEmail"],
                    "use": "work",
                }
            ]
        }
    ]

    if "dpoContactEmail" in organization:
        contact.append(
            {
                "purpose": cc_from_meta(fhir["dpoContactPurpose"]),
                "name": [{"text": fhir["dpoContactPurpose"]["text"]}],
                "telecom": [
                    {
                        "system": "email",
                        "value": organization["dpoContactEmail"],
                        "use": "work",
                    }
                ],
            }
        )

    if "incidentReportingEmail" in organization:
        contact.append(
            {
                "purpose": cc_from_meta(fhir["incidentContactPurpose"]),
                "name": [{"text": fhir["incidentContactPurpose"]["text"]}],
                "telecom": [
                    {
                        "system": "email",
                        "value": organization["incidentReportingEmail"],
                        "use": "work",
                    }
                ],
            }
        )

    return {
        "resourceType": "Organization",
        "id": organization["id"],
        "meta": create_meta(PROFILE_EU_AI_ORGANIZATION),
        "active": organization["active"],
        "type": [{"text": organization["type"]}],
        "name": organization["name"],
        "contact": contact,
    }


def map_ai_device(metadata: dict[str, Any]) -> dict[str, Any]:
    ai_system = metadata["aiSystem"]
    manufacturer = metadata["manufacturerOrganization"]
    lifetime = ai_system["expectedLifetime"]
    fhir = metadata["fhirMapping"]["device"]
    properties = fhir["properties"]

    return {
        "resourceType": "Device",
        "id": ai_system["id"],
        "meta": create_meta(PROFILE_EU_AI_DEVICE),
        "identifier": [
            {
                "type": cc_from_meta(fhir["identifierType"]),
                "system": fhir["identifierSystem"],
                "value": ai_system["euDatabaseId"],
            }
        ],
        "status": ai_system["status"],
        "name": [
            {
                "value": ai_system["name"],
                "type": fhir["nameType"],
                "display": fhir["nameDisplay"],
            }
        ],
        "version": [{"value": ai_system["version"]}],
        "manufacturer": manufacturer["name"],
        "owner": fhir_reference("Organization", ai_system["ownerOrganizationId"]),
        "contact": [
            {"system": "email", "value": manufacturer["contactEmail"], "use": "work"},
            {"system": "email", "value": manufacturer["dpoContactEmail"], "use": "work"},
        ],
        "conformsTo": [
            {
                "category": {"text": fhir["qmsCategoryText"]},
                "specification": {"text": ai_system["qmsCertification"]},
            }
        ],
        "note": [
            {"text": ai_system["maintenanceNote"]},
            {"text": ai_system["intendedPurpose"]},
        ],
        "property": [
            {"type": cc_from_meta(properties["ceMark"]), "valueBoolean": ai_system["ceMarked"]},
            {"type": cc_from_meta(properties["notifiedBodyId"]), "valueString": ai_system["notifiedBodyId"]},
            {
                "type": cc_from_meta(properties["expectedLifetime"]),
                "valueQuantity": {
                    "value": lifetime["value"],
                    "unit": lifetime["unit"],
                    "system": "http://unitsofmeasure.org",
                    "code": lifetime["code"],
                },
            },
            {"type": cc_from_meta(properties["medicalPurpose"]), "valueString": ai_system["medicalPurpose"]},
            {
                "type": cc_from_meta(properties["targetPopulation"]),
                "valueCodeableConcept": {"text": ai_system["targetPopulation"]},
            },
        ],
        "extension": [
            {
                "url": EXT_THIRD_COUNTRY_DATA_TRANSFER,
                "extension": [
                    {
                        "url": "transferFlag",
                        "valueBoolean": ai_system["dataTransfer"]["thirdCountryTransfer"],
                    }
                ],
            },
            {
                "url": EXT_MODEL_CARD,
                "valueReference": fhir_reference("DocumentReference", ai_system["modelCardId"]),
            },
        ],
    }


def map_model_card(metadata: dict[str, Any]) -> dict[str, Any]:
    model_card = metadata["modelCard"]
    privacy_transfer = metadata["aiSystem"]["dataTransfer"]
    fhir = metadata["fhirMapping"]["modelCard"]

    performance_metric_extensions = []
    for metric in model_card.get("performanceMetrics", []):
        performance_metric_extensions.append(
            {
                "url": "metric",
                "extension": [
                    {
                        "url": "type",
                        "valueCodeableConcept": codeable_concept(
                            CS_EU_AI_ACT,
                            metric["typeCode"],
                            metric["typeDisplay"],
                        ),
                    },
                    {
                        "url": "value",
                        "valueQuantity": {
                            "value": metric["value"],
                            "unit": metric["unit"],
                            "system": "http://unitsofmeasure.org",
                            "code": metric["code"],
                        },
                    },
                ],
            }
        )

    if "biasDisclosure" in model_card:
        performance_metric_extensions.append(
            {"url": "biasDisclosure", "valueString": model_card["biasDisclosure"]}
        )

    resource = {
        "resourceType": "DocumentReference",
        "id": model_card["id"],
        "meta": create_meta(PROFILE_EU_AI_MODELCARD),
        "status": fhir["status"],
        "type": cc_from_meta(fhir["type"]),
        "description": model_card["description"],
        "content": [
            {
                "attachment": {
                    "contentType": model_card["contentType"],
                    "url": model_card["url"],
                    "title": model_card["title"],
                }
            }
        ],
    }

    if "technicalDocumentationUrl" in model_card:
        resource["content"].append(
            {
                "attachment": {
                    "contentType": fhir["technicalDocumentationContentType"],
                    "url": model_card["technicalDocumentationUrl"],
                    "title": fhir["technicalDocumentationTitle"],
                }
            }
        )

    extensions = []
    if performance_metric_extensions:
        extensions.append(
            {"url": EXT_AI_PERFORMANCE_METRICS, "extension": performance_metric_extensions}
        )

    training_data_ext = []
    if "trainingDataDescription" in model_card:
        training_data_ext.append(
            {"url": "provenance", "valueString": model_card["trainingDataDescription"]}
        )

    training_data_ext.append(
        {
            "url": "ehdsCategory",
            "valueCodeableConcept": cc_from_meta(model_card["trainingData"]["ehdsCategory"]),
        }
    )

    if "dataQualityCode" in model_card:
        training_data_ext.append(
            {
                "url": "dataQuality",
                "valueCodeableConcept": codeable_concept(
                    CS_EU_AI_ACT,
                    model_card["dataQualityCode"],
                    model_card["dataQualityDisplay"],
                    text=model_card["dataQualityDescription"],
                ),
            }
        )

    extensions.append({"url": EXT_AI_TRAINING_DATA, "extension": training_data_ext})

    privacy_ext = [
        {
            "url": "retention",
            "valueDuration": {
                "value": model_card["retention"]["value"],
                "unit": model_card["retention"]["unit"],
                "system": "http://unitsofmeasure.org",
                "code": model_card["retention"]["code"],
            },
        },
        {"url": "transferFlag", "valueBoolean": privacy_transfer["thirdCountryTransfer"]},
    ]
    extensions.append({"url": EXT_AI_PRIVACY_METADATA, "extension": privacy_ext})
    resource["extension"] = extensions

    return resource


def map_consent(metadata: dict[str, Any]) -> dict[str, Any]:
    consent = metadata["generatedMetadata"]["consent"]

    return {
        "resourceType": "Consent",
        "id": consent["id"],
        "meta": create_meta(PROFILE_EU_AI_CONSENT),
        "status": consent["status"],
        "decision": consent["decision"],
        "category": [cc_from_meta(consent["category"])],
        "subject": fhir_reference("Patient", metadata["patient"]["id"]),
        "date": consent["date"],
        "provision":[{"purpose": [consent["provisionPurpose"]]}],
        "extension": [
            {
                "url": EXT_PATIENT_AI_INFO_PROVIDED,
                "valueBoolean": consent["patientInfoProvided"],
            }
        ],
    }

def map_practitioner(metadata: dict[str, Any]) -> dict[str, Any]:
    """Map human reviewer person data to a FHIR Practitioner resource."""
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
    """Map human reviewer role data to EU_AIPractitionerRole."""
    reviewer_role = metadata["humanReviewer"]["practitionerRole"]
    practitioner = metadata["humanReviewer"]["practitioner"]

    return {
        "resourceType": "PractitionerRole",
        "id": reviewer_role["id"],
        "meta": create_meta(PROFILE_EU_AI_PRACTITIONER_ROLE),
        "extension": [
            {
                "url": EXT_AI_TRAINING_STATUS,
                "valueBoolean": reviewer_role["aiSpecificTrainingCompleted"],
            }
        ],
        "practitioner": fhir_reference("Practitioner", practitioner["id"]),
        "organization": fhir_reference("Organization", reviewer_role["organizationId"]),
        "code": [
            {
                "text": reviewer_role["roleCode"]
            }
        ],
        "specialty": [
            {
                "text": reviewer_role["specialty"]
            }
        ],
    }


def map_input_observations(metadata: dict[str, Any]) -> list[dict[str, Any]]:
    input_data = metadata["inputData"]
    ids = metadata["generatedMetadata"]["inputObservationIds"]
    patient_id = metadata["patient"]["id"]
    encounter_id = metadata["encounter"]["id"]
    fhir = metadata["fhirMapping"]["inputObservations"]
    observed_at = input_data["observedAt"]
    status = fhir["status"]
    category = category_from_meta(fhir["category"])

    return [
        {
            "resourceType": "Observation",
            "id": ids["temperature"],
            "status": status,
            "category": category,
            "code": loinc_code(input_data["temperature"]["loinc"]),
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "valueQuantity": ucum_quantity(input_data["temperature"]["value"], input_data["temperature"]["ucum"]),
        },
        {
            "resourceType": "Observation",
            "id": ids["heartRate"],
            "status": status,
            "category": category,
            "code": loinc_code(input_data["heartRate"]["loinc"]),
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "valueQuantity": ucum_quantity(input_data["heartRate"]["value"], input_data["heartRate"]["ucum"]),
        },
        {
            "resourceType": "Observation",
            "id": ids["respiratoryRate"],
            "status": status,
            "category": category,
            "code": loinc_code(input_data["respiratoryRate"]["loinc"]),
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "valueQuantity": ucum_quantity(input_data["respiratoryRate"]["value"], input_data["respiratoryRate"]["ucum"]),
        },
        {
            "resourceType": "Observation",
            "id": ids["bloodPressure"],
            "status": status,
            "category": category,
            "code": loinc_code(input_data["bloodPressure"]["loinc"]),
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "component": [
                {
                    "code": loinc_code(input_data["bloodPressure"]["systolicLoinc"]),
                    "valueQuantity": ucum_quantity(input_data["bloodPressure"]["systolic"], input_data["bloodPressure"]["ucum"]),
                },
                {
                    "code": loinc_code(input_data["bloodPressure"]["diastolicLoinc"]),
                    "valueQuantity": ucum_quantity(input_data["bloodPressure"]["diastolic"], input_data["bloodPressure"]["ucum"]),
                },
            ],
        },
        {
            "resourceType": "Observation",
            "id": ids["oxygenSaturation"],
            "status": status,
            "category": category,
            "code": loinc_code(input_data["oxygenSaturation"]["loinc"]),
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "valueQuantity": ucum_quantity(input_data["oxygenSaturation"]["value"], input_data["oxygenSaturation"]["ucum"]),
            "note": [
                {
                    "text": (
                        f"{fhir['oxygenSaturationNotePrefix']}: {input_data['oxygenSaturation']['news2Scale']}; "
                        f"{fhir['supplementalOxygenNotePrefix']}: {input_data['supplementalOxygen']['value']}"
                    )
                }
            ],
        },
        {
            "resourceType": "Observation",
            "id": ids["consciousnessStatus"],
            "status": status,
            "category": category,
            "code": {"text": fhir["consciousnessStatusCodeText"]},
            "subject": fhir_reference("Patient", patient_id),
            "encounter": fhir_reference("Encounter", encounter_id),
            "effectiveDateTime": observed_at,
            "valueCodeableConcept": {"text": input_data["consciousnessStatus"]["value"]},
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
                    CS_EU_AI_ACT,
                    ai_output["caseSpecificIndication"],
                    ai_output["caseSpecificIndicationDisplay"],
                ),
            }
        ],
        "status": fhir["status"],
        "code": {"text": fhir["codeText"]},
        "subject": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "effectiveDateTime": ai_output["generatedAt"],
        "device": fhir_reference("Device", ai_output["deviceId"]),
        "interpretation": [cc_from_meta(fhir["interpretation"])],
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


def map_audit_event(metadata: dict[str, Any]) -> dict[str, Any]:
    audit = metadata["generatedMetadata"]["auditEvent"]
    ai_output = metadata["generatedMetadata"]["simulatedAiOutput"]
    fhir = metadata["fhirMapping"]["auditEvent"]

    return {
        "resourceType": "AuditEvent",
        "id": audit["id"],
        "meta": create_meta(PROFILE_EU_AI_AUDIT_EVENT),
        "extension": [
            create_log_integrity_extension(
                EXT_LOG_INTEGRITY,
                audit["logIntegrityHash"],
                audit["recordedAt"],
                audit["agent"]["aiSystemId"],
            )
        ],
        "code": cc_from_meta(fhir["code"]),
        "action": fhir["action"],
        "recorded": audit["recordedAt"],
        "occurredPeriod": audit["occurredPeriod"],
        "authorization": [{"text": audit["purpose"]}],
        "patient": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "agent": [
            {
                "who": fhir_reference("Device", audit["agent"]["aiSystemId"]),
                "requestor": fhir["agentRequestor"],
            }
        ],
        "source": {"observer": fhir_reference("Device", audit["agent"]["aiSystemId"])},
        "entity": [
            {
                "role": cc_from_meta(fhir["inputEntityRole"]),
                "what": fhir_reference("Observation", input_id),
            }
            for input_id in audit["entities"]["inputDataIds"]
        ]
        + [
            {
                "role": cc_from_meta(fhir["outputEntityRole"]),
                "what": fhir_reference("Observation", audit["entities"]["outputDataId"]),
            }
        ],
    }


def map_provenance(metadata: dict[str, Any]) -> dict[str, Any]:
    provenance = metadata["generatedMetadata"]["provenance"]
    ai_output = metadata["generatedMetadata"]["simulatedAiOutput"]
    legal = provenance["legalContext"]
    fhir = metadata["fhirMapping"]["provenance"]

    return {
        "resourceType": "Provenance",
        "id": provenance["id"],
        "meta": create_meta(PROFILE_EU_AI_PROVENANCE),
        "extension": [
            {
                "url": EXT_EHDS_USAGE_CATEGORY,
                "valueCodeableConcept": codeable_concept(CS_EU_AI_ACT, legal["usageCategory"]),
            }
        ],
        "target": [fhir_reference("Observation", provenance["targetId"])],
        "occurredPeriod": provenance["occurredPeriod"],
        "recorded": provenance["recordedAt"],
        "authorization": [
            {"concept": codeable_concept(CS_GDPR_ART6, legal["gdprArt6"])},
            {"concept": codeable_concept(CS_GDPR_ART9, legal["gdprArt9"])},
        ],
        "patient": fhir_reference("Patient", ai_output["subjectId"]),
        "encounter": fhir_reference("Encounter", ai_output["encounterId"]),
        "activity": {"text": fhir["activityText"]},
        "agent": [{"who": fhir_reference("Device", provenance["agent"]["aiSystemId"])}],
        "entity": [
            {"role": fhir["entityRole"], "what": fhir_reference("Observation", input_id)}
            for input_id in provenance["entities"]["inputDataIds"]
        ],
    }


def map_human_oversight_assessment(metadata: dict[str, Any]) -> dict[str, Any]:
    oversight = metadata["generatedMetadata"]["humanOversightAssessment"]
    reviewer_training = metadata["humanReviewer"]["practitionerRole"]["aiSpecificTrainingCompleted"]

    return {
        "resourceType": "ArtifactAssessment",
        "id": oversight["id"],
        "meta": create_meta(PROFILE_EU_AI_HUMAN_OVERSIGHT),
        "workflowStatus": oversight["workflowStatus"],
        "artifactReference": fhir_reference("Observation", oversight["assessedAiOutputId"]),
        "content": [
            {
                "author": {
                    **fhir_reference("PractitionerRole", oversight["reviewerId"]),
                    "extension": [
                        {"url": EXT_AI_TRAINING_STATUS, "valueBoolean": reviewer_training}
                    ],
                },
                "classifier": [codeable_concept(CS_EU_AI_ACT, oversight["interventionAction"])],
                "summary": oversight["rationale"],
            }
        ],
    }


def map_corrected_clinical_observation(metadata: dict[str, Any]) -> dict[str, Any]:
    corrected = metadata["generatedMetadata"]["correctedClinicalObservation"]
    fhir = metadata["fhirMapping"]["correctedClinicalObservation"]

    return {
        "resourceType": "Observation",
        "id": corrected["id"],
        "status": fhir["status"],
        "code": {"text": fhir["codeText"]},
        "subject": fhir_reference("Patient", corrected["subjectId"]),
        "encounter": fhir_reference("Encounter", corrected["encounterId"]),
        "effectiveDateTime": corrected["correctedAt"],
        "derivedFrom": [fhir_reference("Observation", corrected["derivedFromAiOutputId"])],
        "valueCodeableConcept": {"text": corrected["riskCategory"]},
        "note": [
            {"text": corrected["recommendation"]},
            {"text": corrected["reason"]},
            {"text": corrected["note"]},
        ],
    }


def map_patient_explanation(metadata: dict[str, Any]) -> dict[str, Any]:
    explanation = metadata["generatedMetadata"]["patientExplanation"]
    fhir = metadata["fhirMapping"]["patientExplanation"]

    if explanation["aboutHumanOversightId"] is None:
        raise ValueError(
            "Patient explanation requires aboutHumanOversightId because "
            "EU_AIPatientExplanation.about references EU_AIHumanOversightAssessment."
        )

    return {
        "resourceType": "Communication",
        "id": explanation["id"],
        "meta": create_meta(PROFILE_EU_AI_PATIENT_EXPLANATION),
        "extension": [
            {"url": EXT_EXPLANATION_REQUESTED, "valueBoolean": explanation["requested"]}
        ],
        "status": fhir["status"],
        "category": [cc_from_meta(fhir["category"])],
        "subject": fhir_reference("Patient", explanation["subjectId"]),
        "sender": fhir_reference("PractitionerRole", explanation["senderId"]),
        "sent": explanation["sentAt"],
        "about": [fhir_reference("ArtifactAssessment", explanation["aboutHumanOversightId"])],
        "payload": [{"contentCodeableConcept": {"text": explanation["explanationText"]}}],
    }


def map_scenario(metadata: dict[str, Any]) -> list[dict[str, Any]]:
    resources = []

    resources.append(map_patient(metadata))
    resources.append(map_encounter(metadata))
    resources.append(map_organization(metadata, metadata["manufacturerOrganization"]))
    resources.append(map_organization(metadata, metadata["operatorOrganization"]))
    resources.append(map_model_card(metadata))
    resources.append(map_ai_device(metadata))
    resources.append(map_consent(metadata))
    resources.append(map_practitioner_role(metadata))
    resources.extend(map_input_observations(metadata))
    resources.append(map_ai_observation(metadata))
    resources.append(map_audit_event(metadata))
    resources.append(map_provenance(metadata))

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


def write_scenario_resources(scenario_id: str, resources: list[dict[str, Any]]) -> None:
    scenario_output_dir = FHIR_OUTPUT_DIR / scenario_id

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
