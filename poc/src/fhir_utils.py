import json
from pathlib import Path
import base64
from typing import Any


def load_json(path: Path) -> dict[str, Any]:
    """Load a JSON file from the given file path."""
    with path.open("r", encoding="utf-8") as file:
        return json.load(file)


def write_json(data: dict[str, Any], path: Path) -> None:
    """Write data to a formatted JSON file."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)



def fhir_reference(resource_type: str, resource_id: str) -> dict[str, str]:
    """Create a FHIR reference."""
    return {
        "reference": f"{resource_type}/{resource_id}"
    }


def create_meta(profile_url: str) -> dict[str, list[str]]:
    """Create the FHIR meta.profile element."""
    return {
        "profile": [profile_url]
    }


def codeable_concept(
    system: str,
    code: str,
    display: str | None = None,
    text: str | None = None,
) -> dict[str, Any]:
    """Create a FHIR CodeableConcept."""
    coding = {
        "system": system,
        "code": code,
    }

    if display is not None:
        coding["display"] = display

    concept = {
        "coding": [coding]
    }

    if text is not None:
        concept["text"] = text
    elif display is not None:
        concept["text"] = display

    return concept


def loinc_code(loinc: dict[str, str]) -> dict[str, Any]:
    """Create a LOINC CodeableConcept."""
    return codeable_concept(
        "http://loinc.org",
        loinc["code"],
        loinc["display"],
    )


def ucum_quantity(value: float, ucum: dict[str, str]) -> dict[str, Any]:
    """Create a UCUM Quantity."""
    return {
        "value": value,
        "unit": ucum["unit"],
        "system": "http://unitsofmeasure.org",
        "code": ucum["code"],
    }


def create_log_integrity_extension(
    extension_url: str,
    hash_value: str,
    recorded_at: str,
    device_id: str,
) -> dict[str, Any]:
    """Create a log integrity extension as a FHIR Signature."""
    encoded_hash = base64.b64encode(hash_value.encode("utf-8")).decode("utf-8")

    return {
        "url": extension_url,
        "valueSignature": {
            "type": [
                {
                    "system": "urn:iso-astm:E1762-95:2013",
                    "code": "1.2.840.10065.1.12.1.5",
                    "display": "Verification Signature",
                }
            ],
            "when": recorded_at,
            "who": fhir_reference("Device", device_id),
            "sigFormat": "text/plain",
            "data": encoded_hash,
        },
    }

def vital_signs_category() -> list[dict[str, Any]]:
    """Create the standard FHIR vital-signs category."""
    return [
        {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                    "code": "vital-signs",
                    "display": "Vital Signs"
                }
            ]
        }
    ]