import copy
import hashlib
import json
from pathlib import Path
from typing import Any

from fhir_utils import load_json, write_json
from news2_scoring import calculate_simplified_news2_score

BASE_CASE_PATH = Path("poc/input/base_case.json")
CONFIG_DIR = Path("poc/config")
OUTPUT_DIR = Path("poc/output/metadata")


def make_scenario_resource_id(scenario_id: str, local_id: str) -> str:
    return f"{scenario_id}-{local_id}"


def create_input_data_ids(base_case: dict[str, Any], scenario_id: str) -> dict[str, str]:
    templates = base_case["resourceIdTemplates"]["inputObservations"]
    return {
        name: make_scenario_resource_id(scenario_id, local_id)
        for name, local_id in templates.items()
    }


def create_default_ai_output(
    score_result: dict[str, Any],
    base_case: dict[str, Any],
    scenario_id: str,
) -> dict[str, Any]:
    score = score_result["totalScore"]
    execution = base_case["simulationExecution"]

    if score >= 7:
        risk_category = "high-risk"
        confidence = 0.86
        recommendation = "Urgent clinical review recommended"
    elif score >= 5:
        risk_category = "elevated-risk"
        confidence = 0.78
        recommendation = "Clinical review recommended"
    else:
        risk_category = "low-risk"
        confidence = 0.72
        recommendation = "No immediate escalation suggested"

    return {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["aiObservation"],
        ),
        "profileTarget": "EU_AIObservation",
        "riskCategory": risk_category,
        "confidence": confidence,
        "recommendation": recommendation,
        "generatedAt": execution["aiOutputGeneratedAt"],
        "automatedDecision": base_case["legalContext"]["automatedDecision"],
        "simulationMethod": score_result["method"],
        "simplifiedScore": score,
        "scoreDetails": score_result["scoreDetails"],
        "caseSpecificIndication": base_case["clinicalContext"]["caseSpecificIndication"],
        "caseSpecificIndicationDisplay": base_case["clinicalContext"]["caseSpecificIndicationDisplay"],
        "subjectId": base_case["patient"]["id"],
        "encounterId": base_case["encounter"]["id"],
        "deviceId": base_case["aiSystem"]["id"],
    }


def apply_ai_output_config(
    default_ai_output: dict[str, Any],
    config: dict[str, Any],
) -> dict[str, Any]:
    ai_config = config.get("aiOutputConfig", {})

    if not ai_config.get("forceOutput", False):
        return default_ai_output

    forced_output = copy.deepcopy(default_ai_output)
    forced_output["riskCategory"] = ai_config["riskCategory"]
    forced_output["confidence"] = ai_config["confidence"]
    forced_output["recommendation"] = ai_config["recommendation"]
    forced_output["forcedOutput"] = True
    forced_output["forcedOutputReason"] = (
        "The simulated AI output was intentionally configured to deviate "
        "from the score-based output for testing human oversight workflows."
    )

    return forced_output


def create_log_integrity_hash(
    scenario_id: str,
    ai_output: dict[str, Any],
    input_data_ids: list[str],
) -> str:
    content = {
        "scenarioId": scenario_id,
        "aiOutputId": ai_output["id"],
        "riskCategory": ai_output["riskCategory"],
        "inputDataIds": input_data_ids,
    }
    encoded = json.dumps(content, sort_keys=True).encode("utf-8")
    return "sha256-" + hashlib.sha256(encoded).hexdigest()


def create_execution_metadata(
    scenario_id: str,
    base_case: dict[str, Any],
    ai_output: dict[str, Any],
    input_data_ids: list[str],
) -> dict[str, Any]:
    execution = base_case["simulationExecution"]

    return {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["execution"],
        ),
        "executionStart": execution["executionStart"],
        "executionEnd": execution["executionEnd"],
        "recordedAt": execution["recordedAt"],
        "inputDataIds": input_data_ids,
        "outputDataId": ai_output["id"],
        "logIntegrityHash": create_log_integrity_hash(
            scenario_id,
            ai_output,
            input_data_ids,
        ),
    }


def create_audit_event_metadata(
    scenario_id: str,
    base_case: dict[str, Any],
    ai_output: dict[str, Any],
    execution: dict[str, Any],
) -> dict[str, Any]:
    return {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["auditEvent"],
        ),
        "profileTarget": "EU_AIAuditEvent",
        "recordedAt": execution["recordedAt"],
        "occurredPeriod": {
            "start": execution["executionStart"],
            "end": execution["executionEnd"],
        },
        "agent": {
            "aiSystemId": base_case["aiSystem"]["id"],
            "operatorOrganizationId": base_case["aiSystem"]["ownerOrganizationId"],
        },
        "entities": {
            "inputDataIds": execution["inputDataIds"],
            "outputDataId": ai_output["id"],
        },
        "logIntegrityHash": execution["logIntegrityHash"],
        "purpose": base_case["traceabilityMetadata"]["auditPurpose"],
    }


def create_provenance_metadata(
    scenario_id: str,
    base_case: dict[str, Any],
    ai_output: dict[str, Any],
    execution: dict[str, Any],
) -> dict[str, Any]:
    return {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["provenance"],
        ),
        "profileTarget": "EU_AIProvenance",
        "targetId": ai_output["id"],
        "occurredPeriod": {
            "start": execution["executionStart"],
            "end": execution["executionEnd"],
        },
        "recordedAt": execution["recordedAt"],
        "agent": {
            "aiSystemId": base_case["aiSystem"]["id"],
            "manufacturerOrganizationId": base_case["aiSystem"]["manufacturerOrganizationId"],
            "operatorOrganizationId": base_case["aiSystem"]["ownerOrganizationId"],
        },
        "entities": {
            "inputDataIds": execution["inputDataIds"],
            "outputDataId": ai_output["id"],
        },
        "legalContext": base_case["legalContext"],
        "purpose": base_case["traceabilityMetadata"]["provenancePurpose"],
    }


def create_human_oversight_metadata(
    scenario_id: str,
    ai_output: dict[str, Any],
    config: dict[str, Any],
    base_case: dict[str, Any],
) -> dict[str, Any] | None:
    oversight_config = config.get("humanOversightConfig", {})

    if not oversight_config.get("enabled", False):
        return None

    mode = oversight_config["mode"]
    oversight = {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["humanOversight"],
        ),
        "profileTarget": "EU_AIHumanOversightAssessment",
        "assessedAiOutputId": ai_output["id"],
        "reviewedAt": oversight_config["reviewedAt"],
        "reviewerId": oversight_config["reviewerId"],
        "interventionAction": mode,
        "rationale": oversight_config["rationale"],
    }

    if mode == "human-validation":
        oversight["finalDecision"] = {
            "status": "accepted",
            "riskCategory": ai_output["riskCategory"],
            "recommendation": ai_output["recommendation"],
        }
    elif mode == "human-override":
        oversight["finalDecision"] = {
            "status": "overridden",
            "overrideDecision": oversight_config["overrideDecision"],
        }
    elif mode == "human-correction":
        correction = oversight_config["correction"]
        corrected_local_id = correction.get(
            "correctedClinicalObservationId",
            base_case["resourceIdTemplates"]["correctedClinicalObservation"],
        )
        corrected_id = make_scenario_resource_id(scenario_id, corrected_local_id)
        oversight["finalDecision"] = {
            "status": "corrected",
            "correctedClinicalObservationId": corrected_id,
        }
    else:
        raise ValueError(f"Unsupported human oversight mode: {mode}")

    return oversight


def create_corrected_clinical_observation_metadata(
    scenario_id: str,
    base_case: dict[str, Any],
    ai_output: dict[str, Any],
    config: dict[str, Any],
) -> dict[str, Any] | None:
    oversight_config = config.get("humanOversightConfig", {})

    if not oversight_config.get("enabled", False):
        return None

    if oversight_config.get("mode") != "human-correction":
        return None

    correction = oversight_config["correction"]
    corrected_local_id = correction.get(
        "correctedClinicalObservationId",
        base_case["resourceIdTemplates"]["correctedClinicalObservation"],
    )

    return {
        "id": make_scenario_resource_id(scenario_id, corrected_local_id),
        "profileTarget": "Observation",
        "subjectId": base_case["patient"]["id"],
        "encounterId": base_case["encounter"]["id"],
        "derivedFromAiOutputId": ai_output["id"],
        "riskCategory": correction["riskCategory"],
        "recommendation": correction["recommendation"],
        "correctedAt": oversight_config["reviewedAt"],
        "correctedBy": oversight_config["reviewerId"],
        "reason": oversight_config["rationale"],
        "note": base_case["fhirMapping"]["correctedClinicalObservation"]["note"],
    }


def create_patient_explanation_metadata(
    scenario_id: str,
    config: dict[str, Any],
    ai_output: dict[str, Any],
    human_oversight: dict[str, Any] | None,
    base_case: dict[str, Any],
) -> dict[str, Any] | None:
    explanation_config = config.get("patientExplanationConfig", {})

    if not explanation_config.get("enabled", False):
        return None

    return {
        "id": make_scenario_resource_id(
            scenario_id,
            base_case["resourceIdTemplates"]["patientExplanation"],
        ),
        "profileTarget": "EU_AIPatientExplanation",
        "subjectId": base_case["patient"]["id"],
        "senderId": base_case["humanReviewer"]["practitionerRole"]["id"],
        "requested": explanation_config["requested"],
        "provided": explanation_config["provided"],
        "sentAt": explanation_config["sentAt"],
        "aboutAiOutputId": ai_output["id"],
        "aboutHumanOversightId": human_oversight["id"] if human_oversight else None,
        "explanationText": explanation_config["explanationText"],
    }


def create_generated_metadata_summary(
    score_result: dict[str, Any],
    expected_ai_output: dict[str, Any],
    simulated_ai_output: dict[str, Any],
    config: dict[str, Any],
) -> dict[str, Any]:
    return {
        "simulationMethod": score_result["method"],
        "simplifiedScore": score_result["totalScore"],
        "expectedScoreBasedRiskCategory": expected_ai_output["riskCategory"],
        "actualSimulatedRiskCategory": simulated_ai_output["riskCategory"],
        "forcedOutputUsed": config.get("aiOutputConfig", {}).get("forceOutput", False),
        "humanOversightEnabled": config.get("humanOversightConfig", {}).get("enabled", False),
        "patientExplanationEnabled": config.get("patientExplanationConfig", {}).get("enabled", False),
    }


def generate_scenario_metadata(
    base_case: dict[str, Any],
    config: dict[str, Any],
) -> dict[str, Any]:
    scenario_id = config["scenarioOutputId"]

    metadata = copy.deepcopy(base_case)
    metadata["scenarioId"] = scenario_id
    metadata["scenarioDescription"] = (
        f"Generated metadata for {scenario_id} based on the synthetic base case."
    )

    input_observation_ids_by_name = create_input_data_ids(base_case, scenario_id)
    input_observation_ids = list(input_observation_ids_by_name.values())

    score_result = calculate_simplified_news2_score(base_case["inputData"])
    expected_ai_output = create_default_ai_output(score_result, base_case, scenario_id)
    simulated_ai_output = apply_ai_output_config(expected_ai_output, config)

    execution = create_execution_metadata(
        scenario_id,
        base_case,
        simulated_ai_output,
        input_observation_ids,
    )
    audit_event = create_audit_event_metadata(
        scenario_id,
        base_case,
        simulated_ai_output,
        execution,
    )
    provenance = create_provenance_metadata(
        scenario_id,
        base_case,
        simulated_ai_output,
        execution,
    )
    human_oversight = create_human_oversight_metadata(
        scenario_id,
        simulated_ai_output,
        config,
        base_case,
    )
    corrected_observation = create_corrected_clinical_observation_metadata(
        scenario_id,
        base_case,
        simulated_ai_output,
        config,
    )
    patient_explanation = create_patient_explanation_metadata(
        scenario_id,
        config,
        simulated_ai_output,
        human_oversight,
        base_case,
    )

    metadata["generatedMetadata"] = {
        "summary": create_generated_metadata_summary(
            score_result,
            expected_ai_output,
            simulated_ai_output,
            config,
        ),
        "inputObservationIds": input_observation_ids_by_name,
        "scoreResult": score_result,
        "expectedScoreBasedAiOutput": expected_ai_output,
        "simulatedAiOutput": simulated_ai_output,
        "execution": execution,
        "auditEvent": audit_event,
        "provenance": provenance,
    }

    if human_oversight is not None:
        metadata["generatedMetadata"]["humanOversightAssessment"] = human_oversight
    if corrected_observation is not None:
        metadata["generatedMetadata"]["correctedClinicalObservation"] = corrected_observation
    if patient_explanation is not None:
        metadata["generatedMetadata"]["patientExplanation"] = patient_explanation

    return metadata


def generate_all_scenarios() -> None:
    base_case = load_json(BASE_CASE_PATH)

    config_paths = sorted(CONFIG_DIR.glob("scenario_*.json"))
    if not config_paths:
        raise FileNotFoundError(f"No scenario config files found in {CONFIG_DIR}")

    for config_path in config_paths:
        config = load_json(config_path)
        metadata = generate_scenario_metadata(base_case, config)

        output_path = OUTPUT_DIR / f"{config['scenarioOutputId']}.json"
        write_json(metadata, output_path)

        print(f"Generated: {output_path}")


def main() -> None:
    generate_all_scenarios()


if __name__ == "__main__":
    main()
