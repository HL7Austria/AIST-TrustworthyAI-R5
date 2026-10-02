#!/usr/bin/env python3
"""Summarise an IG Publisher QA report (output/qa.txt) into fixable groups.

Groups identical issues that differ only in resource ids / URLs / numbers, and
points each affected generated file back to the FSH file and line that defines it.

Usage (from the IG root):
    python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py            # errors + warnings
    python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --all      # include information hints
    python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --json     # machine-readable
    python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --totals   # one line: errs/warnings/hints
    python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --suppress 3 5   # ignoreWarnings.txt lines for groups 3 and 5
"""
import argparse
import json
import re
import sys
from collections import OrderedDict
from pathlib import Path

SEVERITIES = ("FATAL", "ERROR", "WARNING", "INFORMATION")
LINE_RE = re.compile(r"^(FATAL|ERROR|WARNING|INFORMATION): (.*)$")
SECTION_RE = re.compile(r"^== (.*) ==$")


def normalise(msg: str) -> str:
    """Turn a concrete message into a template so identical issues group together."""
    t = msg
    t = re.sub(r"https?://[^\s'\"),]+", "<url>", t)
    t = re.sub(r"'[^']*'", "'<x>'", t)
    t = re.sub(r"\b[A-Z][A-Za-z]+/[A-Za-z0-9\-\.]+", "<Type/id>", t)  # CodeSystem/foo-cs
    t = re.sub(r"\[\d+\]", "[n]", t)
    t = re.sub(r"\b\d+\b", "<n>", t)
    t = re.sub(r"\[[^\]]*\.xhtml[^\]]*\]", "[<fragments>]", t)
    return t


# qa.txt prints "<location>: <message>". The location is some of: "Type/id: ", an element path
# ("Device.name.type: ", "StructureDefinition.where(url = '...'): "), "Resource: " or "1: ".
# input/ignoreWarnings.txt must contain only the <message> part.
_LOC_RE = re.compile(
    r"^(?:[A-Z][A-Za-z]+/[A-Za-z0-9\-\.]+: )?"          # Type/id:
    r"(?:(?:[A-Za-z][\w\.\[\]\u200b]*\([^)]*\)[\w\.\[\]]*|[\w\.\[\]\u200b:]+): )?"  # path: / 1:
)


def suppress_text(msg: str) -> str:
    """The part of a qa.txt message that input/ignoreWarnings.txt has to match."""
    m = _LOC_RE.match(msg)
    rest = msg[m.end():] if m else msg
    return rest or msg


def fsh_index(root: Path) -> dict:
    """Map resource id -> 'input/fsh/file.fsh:line' for Instances and Id: declarations."""
    idx = {}
    fsh_dir = root / "input" / "fsh"
    if not fsh_dir.is_dir():
        return idx
    for f in sorted(fsh_dir.rglob("*.fsh")):
        current_instance = None
        for n, line in enumerate(f.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            loc = f"{f.relative_to(root)}:{n}"
            m = re.match(r"^\s*Instance:\s*(\S+)", line)
            if m:
                current_instance = m.group(1)
                idx.setdefault(current_instance, loc)
                continue
            m = re.match(r"^\s*Id:\s*(\S+)", line)
            if m:
                idx.setdefault(m.group(1), loc)
                continue
            m = re.match(r'^\s*\*\s*id\s*=\s*"([^"]+)"', line)
            if m and current_instance:
                idx.setdefault(m.group(1), loc)
    return idx


def source_for(section: str, idx: dict) -> str:
    """fsh-generated/resources/CodeSystem-foo-cs.json -> input/fsh/valuesets.fsh:42"""
    name = Path(section).name
    if not name.endswith(".json"):
        return ""
    stem = name[:-5]
    if "-" not in stem:
        return ""
    rid = stem.split("-", 1)[1]
    return idx.get(rid, "")


def parse(qa_txt: Path):
    section = "n/a"
    items = []
    for raw in qa_txt.read_text(encoding="utf-8", errors="replace").splitlines():
        m = SECTION_RE.match(raw)
        if m:
            section = m.group(1)
            continue
        m = LINE_RE.match(raw)
        if m:
            items.append({"severity": m.group(1), "section": section, "message": m.group(2).strip()})
    return items


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".", help="IG root (contains output/ and input/)")
    ap.add_argument("--all", action="store_true", help="include INFORMATION hints")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--totals", action="store_true")
    ap.add_argument("--suppress", type=int, nargs="+", metavar="N",
                    help="print the exact input/ignoreWarnings.txt lines for these group numbers")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    qa_txt = root / "output" / "qa.txt"
    qa_json = root / "output" / "qa.json"
    if not qa_txt.exists():
        sys.exit(f"No QA report at {qa_txt}. Build the IG first (bash _genonce.sh).")

    totals = {}
    if qa_json.exists():
        q = json.loads(qa_json.read_text(encoding="utf-8"))
        totals = {k: q.get(k) for k in ("errs", "warnings", "hints", "suppressed-warnings", "suppressed-hints", "dateISO8601")}
    if args.totals:
        print(json.dumps(totals))
        return

    wanted = set(SEVERITIES) if args.all else {"FATAL", "ERROR", "WARNING"}
    idx = fsh_index(root)
    groups = OrderedDict()
    for it in parse(qa_txt):
        if it["severity"] not in wanted:
            continue
        key = (it["severity"], normalise(it["message"]))
        g = groups.setdefault(key, {"severity": it["severity"], "template": key[1], "count": 0,
                                    "example": it["message"], "occurrences": []})
        g["count"] += 1
        g["occurrences"].append({"section": it["section"], "source": source_for(it["section"], idx),
                                 "message": it["message"], "suppress_text": suppress_text(it["message"])})

    order = {s: i for i, s in enumerate(SEVERITIES)}
    ordered = sorted(groups.values(), key=lambda g: (order[g["severity"]], -g["count"]))

    if args.json:
        print(json.dumps({"totals": totals, "groups": ordered}, indent=2))
        return

    if args.suppress:
        # The publisher matches whole messages exactly (no wildcards), one per line.
        for n in args.suppress:
            if not 1 <= n <= len(ordered):
                sys.exit(f"No group {n}; there are {len(ordered)} groups.")
            g = ordered[n - 1]
            if g["severity"] in ("ERROR", "FATAL"):
                sys.exit(f"Group {n} is {g['severity']}: errors must be fixed, not suppressed.")
            for line in OrderedDict.fromkeys(o["suppress_text"] for o in g["occurrences"]):
                print(line)
        return

    print(f"QA totals: {totals}")
    print(f"{len(ordered)} distinct issue groups ({sum(g['count'] for g in ordered)} messages)\n")
    for i, g in enumerate(ordered, 1):
        print(f"[{i}] {g['severity']} x{g['count']}")
        distinct = list(OrderedDict.fromkeys(o["message"] for o in g["occurrences"]))
        for msg in distinct[:3]:
            print(f"    message: {msg}")
        if len(distinct) > 3:
            print(f"    ... {len(distinct) - 3} more distinct messages (use --json to see all)")
        seen = OrderedDict()
        for o in g["occurrences"]:
            seen.setdefault((o["section"], o["source"]), True)
        for (section, source) in list(seen)[:12]:
            print(f"    - {section}" + (f"  ->  {source}" if source else ""))
        if len(seen) > 12:
            print(f"    - ... {len(seen) - 12} more")
        print()


if __name__ == "__main__":
    main()
