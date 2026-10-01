---
name: ig-qa-fix
description: Read the HL7 FHIR IG Publisher QA report (output/qa.html / qa.txt) after an IG build and fix the errors and warnings at their source — FSH profiles, extensions, terminology, example instances, sushi-config.yaml, IG pages — then rebuild and verify the counts went down. Use this whenever the user mentions the QA report, qa.html, IG build errors or warnings, "clean up the build", broken links in the IG, publisher/validator warnings for the FHIR IG, or asks to get the IG to zero errors — even if they don't say "QA" explicitly.
---

# IG QA Report Fixer

The IG Publisher writes a QA report after every build. This skill turns that report into a short
list of issue groups, fixes each group in the *source* files, rebuilds, and proves the fix worked by
comparing the totals before and after.

## Ground rules (and why)

- **Fix sources, never generated output.** `fsh-generated/`, `output/`, `temp/` and `template/` are
  rebuilt on every run, so edits there vanish. The sources are `input/fsh/*.fsh`,
  `sushi-config.yaml`, `input/pagecontent/*.md`, and `input/ignoreWarnings.txt`.
- **Don't buy a green report by weakening the model.** If an *example* violates a profile, fix
  the example data. Loosening a cardinality, binding strength, or fixed value in a profile changes
  what the IG means, so it is the user's decision. Propose it and ask. The same applies to deleting an
  example or a profile to make its messages disappear.
- **Suppress only with a reason, and never errors.** Some warnings are expected: they come from
  base FHIR, or they need information the project doesn't have yet. These go into
  `input/ignoreWarnings.txt` with a `#` comment above them that says *why*. A suppression
  without a justification hides problems from the next reader.
- **Ask when the fix needs knowledge you don't have**, such as an organisation's OID root, real
  contact details, or which of two plausible codes is clinically right. Make every fix you can
  first, then ask about the rest together at the end.

## Workflow

### 1. Get a current report

If `output/qa.txt` is missing, or older than recent source changes, build first. The build takes
1.5–3 minutes, so run it in the background and write the output to a log:

```bash
bash _genonce.sh > /tmp/ig-build.log 2>&1; tail -3 /tmp/ig-build.log
```

Use `bash`, because the scripts are not executable in git. If the log reports "IG Publisher NOT FOUND",
run `bash _updatePublisher.sh` once. SUSHI runs first. If it fails, the log shows `error` lines with
a FSH file and line number, no new QA report is written, and you should fix those first.

### 2. Summarise

```bash
python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py            # errors + warnings, grouped
python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --totals   # just the counts
```

The script groups messages that differ only in ids or URLs. It also maps each affected
`fsh-generated/...json` back to the FSH file and line that defines it, so you can go straight to
the source. Messages under `n/a` are IG-level: look in `sushi-config.yaml` and
`input/pagecontent/`. Record the starting totals, because you'll report the before/after comparison.

Leave `INFORMATION` hints alone unless the user asks for them (`--all` shows them). They are often
expected, for example references to this IG's own draft code systems.

### 3. Triage each group: Fix, Suppress, or Ask

Check each group against `references/fix-catalog.md`, which lists the messages this IG
Publisher commonly produces and the right handling for each. For a message that isn't in the catalog,
read the full text and work out which source element produces it before you change anything.
One root cause often explains a whole group, so fix it once rather than message by message.

Handle errors first, then warnings. Within warnings, start with the groups where one change clears
many messages.

### 4. Apply, check FSH quickly, then rebuild

- After editing FSH, run `sushi .` (seconds) to catch syntax and path mistakes before the
  full build.
- Then run the full build again and compare `--totals` with your starting numbers.
- Check for **regressions**: any group in the new summary that wasn't there before means one of
  your edits caused it. Fix or revert it.
- If a suppression didn't take effect (`suppressed-warnings` in the totals didn't go up by the
  number of lines you added), the text doesn't match. Regenerate the lines with `--suppress`
  (see the format section below).

Repeat until only Ask items remain, or at most about three rounds. If a group won't go away,
stop and report it instead of trying more and more speculative edits.

### 5. Report

End with a short report in this shape:

```
QA: errors A → B, warnings C → D (suppressed: S), hints E → F

Fixed
- <group>: <what was wrong> → <what you changed> (<file>)

Suppressed (input/ignoreWarnings.txt)
- <group>: <justification>

Needs your decision
- <group>: <why you couldn't fix it> — options: <a> / <b>
```

Also list files you touched, so the user can review the diff. If the user's workflow includes the
PoC under `poc/`, mention whether a profile change might affect `poc/src/mapper.py`.

## `input/ignoreWarnings.txt` format

The publisher matches each line against the message **text only**. In `qa.txt` every message
is written as `<location>: <text>`, for example `Resource: The resource ...` or
`StructureDefinition/x: StructureDefinition.snapshot.element[47].binding: The definition ...`.
If you paste the whole line, including the location, nothing gets suppressed. Matching is exact,
and `%` or other wildcards don't work (tested with IG Publisher 2.3.4). So you need one line per
message.

Let the script produce the lines. It strips the location and refuses to suppress errors:

```bash
python3 .claude/skills/ig-qa-fix/scripts/qa_summary.py --suppress 1 2   # group numbers from the summary
```

File layout:

```
== Suppressed Messages ==

# <why this group is safe to suppress, and when to remove it>
<line from --suppress>
<line from --suppress>
```

Keep the `== Suppressed Messages ==` header as the first line and any existing entries. Group
numbers change after each build, so run the summary again before you use `--suppress`.
