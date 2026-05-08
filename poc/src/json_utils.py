import json
from pathlib import Path
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