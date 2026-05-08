from typing import Any


def score_respiratory_rate(value: float) -> int:
    if value <= 8:
        return 3
    if value <= 11:
        return 1
    if value <= 20:
        return 0
    if value <= 24:
        return 2
    return 3


def score_oxygen_saturation(value: float, scale: str = "scale-1") -> int:
    if scale != "scale-1":
        raise ValueError("Only SpO2 scale-1 is supported in this simplified PoC simulation.")

    if value <= 91:
        return 3
    if value <= 93:
        return 2
    if value <= 95:
        return 1
    return 0


def score_supplemental_oxygen(value: bool) -> int:
    return 2 if value else 0


def score_systolic_blood_pressure(value: float) -> int:
    if value <= 90:
        return 3
    if value <= 100:
        return 2
    if value <= 110:
        return 1
    if value <= 219:
        return 0
    return 3


def score_heart_rate(value: float) -> int:
    if value <= 40:
        return 3
    if value <= 50:
        return 1
    if value <= 90:
        return 0
    if value <= 110:
        return 1
    if value <= 130:
        return 2
    return 3


def score_consciousness_status(value: str) -> int:
    return 0 if value.lower() == "alert" else 3


def score_temperature(value: float) -> int:
    if value <= 35.0:
        return 3
    if value <= 36.0:
        return 1
    if value <= 38.0:
        return 0
    if value <= 39.0:
        return 1
    return 2


def calculate_simplified_news2_score(input_data: dict[str, Any]) -> dict[str, Any]:
    oxygen_saturation = input_data["oxygenSaturation"]

    score_details = {
        "respiratoryRate": score_respiratory_rate(
            input_data["respiratoryRate"]["value"]
        ),
        "oxygenSaturation": score_oxygen_saturation(
            oxygen_saturation["value"],
            oxygen_saturation.get("news2Scale", "scale-1")
        ),
        "supplementalOxygen": score_supplemental_oxygen(
            input_data["supplementalOxygen"]["value"]
        ),
        "systolicBloodPressure": score_systolic_blood_pressure(
            input_data["bloodPressure"]["systolic"]
        ),
        "heartRate": score_heart_rate(
            input_data["heartRate"]["value"]
        ),
        "consciousnessStatus": score_consciousness_status(
            input_data["consciousnessStatus"]["value"]
        ),
        "temperature": score_temperature(
            input_data["temperature"]["value"]
        )
    }

    return {
        "method": "simplified-news2-inspired-scoring",
        "totalScore": sum(score_details.values()),
        "scoreDetails": score_details,
        "note": (
            "This is a simplified NEWS2-inspired scoring logic for PoC metadata "
            "generation only. It is not a clinically validated NEWS2 implementation."
        )
    }