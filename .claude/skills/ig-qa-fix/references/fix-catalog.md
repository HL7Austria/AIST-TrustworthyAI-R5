# QA message catalog

Known IG Publisher / validator messages and how to handle them. Each entry shows the message
pattern, the action (**Fix**, **Suppress**, or **Ask**), and the reason. Match on the gist of the
message, because exact wording shifts between publisher versions.

## Contents
- [IG-level (n/a) messages](#ig-level-na-messages)
- [Terminology resources](#terminology-resources)
- [Profiles and extensions](#profiles-and-extensions)
- [Example instances](#example-instances)
- [Pages and links](#pages-and-links)
- [Environment / build](#environment--build)

---

## IG-level (n/a) messages

### "The HTML fragment 'X.xhtml' is not included anywhere in the produced implementation guide"
**Fix.** The publisher generates standard fragments and expects a page to include them. A page that
tries to include one with Liquid-variable syntax (`{{ip-statements}}`, `{{{dependency-table}}}`)
renders nothing, so this warning appears. Use a Jekyll include in the matching page:

| Fragment | Include in | Line |
|---|---|---|
| `ip-statements.xhtml` | `input/pagecontent/ip-statements.md` | `{% include ip-statements.xhtml %}` |
| `dependency-table.xhtml` (or `-short` / `-nontech`) | `input/pagecontent/dependencies.md` | `{% include dependency-table.xhtml %}` |
| `globals-table.xhtml` | `input/pagecontent/dependencies.md` (under a "Global Profiles" heading) | `{% include globals-table.xhtml %}` |
| `cross-version-analysis.xhtml` | `dependencies.md` or `index.md` | `{% include cross-version-analysis.xhtml %}` |

### "Unable to find ImplementationGuide.definition.resource.description for the resource Type/id"
**Fix.** Give the resource a description. Prefer adding `Description: "..."` (and `Title:`) to the
`Instance:` in FSH, because it keeps the text next to the content. The alternative is an entry under
`resources:` in `sushi-config.yaml`:
```yaml
resources:
  DocumentReference/eu-conformity-declaration:
    description: "EU Declaration of Conformity for the example AI system."
```
Write a real one-line description of what the resource is, not filler.

### "The resource X should have an OID assigned ... (see ...ig-parameters-auto-oid-root)"
**Ask, and suppress in the meantime.** The proper fix is an OID root that the organisation owns:
```yaml
# sushi-config.yaml
parameters:
  auto-oid-root: <OID owned by the publisher, e.g. 1.2.40.0.34....>
```
Never invent an OID, because an OID claims namespace ownership. If the user doesn't have one yet,
suppress all messages of this kind with a comment such as
`# Draft IG: no OID root assigned yet (auto-oid-root pending). Remove when assigned.`

---

## Terminology resources

### "Published code systems SHOULD conform to the ShareableCodeSystem profile ... CodeSystem.experimental is mandatory" (same for ValueSet)
**Fix.** Add `* ^experimental = false` to the CodeSystem / ValueSet in FSH. Look at the sibling
terminology resources in the same file and use the same value, because usually most of them already
have it and only one is missing.

### "Reference to draft CodeSystem ..." (INFORMATION)
**Leave.** It is expected while the IG's own code systems have status draft.

### "None of the codings provided are in the value set ..." on an *example* (WARNING/INFORMATION)
**Fix** the example if a standard code exists for the concept. If the binding is `example` or
`preferred` and a local code is intentional, **leave** it and mention it in the report.

---

## Profiles and extensions

### "The definition for the element 'X' binds to the value set '...' which is experimental, but this structure is not labeled as experimental"
**Suppress**, as long as the element and binding come from the *base* FHIR resource (the value set URL is
`http://hl7.org/fhir/ValueSet/...` and your FSH doesn't touch that element's binding). The warning
comes from core and can't be fixed without marking the profile experimental, which would be false.
Use a comment such as `# Bindings inherited unchanged from core FHIR R5 to value sets that core marks experimental.`
If your FSH *did* set that binding, **Fix** it by binding to a non-experimental value set.

### "The Implementation Guide contains no examples for this profile / extension"
**Fix** by adding a small, realistic example instance (`Usage: #example`) that uses the
profile/extension, ideally extending an existing example scenario so it stays coherent. For an
extension, you can often just set it on an existing example of the profile it belongs to. If a
meaningful example needs domain input (for example, what a real DPIA reference looks like), **Ask**, or
use clearly synthetic values and say so in the report.

### Profile snapshot / differential errors (e.g. "Error in constraint", "path not found", slicing errors)
**Fix** in the FSH profile. Run `sushi .` to reproduce quickly. If the only fix changes the intended
constraint, **Ask**.

---

## Example instances

### Validation errors on an example ("minimum required = N, but only found M", "Slice ... a matching slice is required", "value not in required value set", "Unknown code")
**Fix the example**, not the profile: add the missing element, use the code from the required value set,
or correct the slice discriminator value. Look at other examples of the same profile for the pattern
this IG uses. Only if the profile is clearly wrong (for example, it requires something that can't exist)
should you **Ask** about changing it.

### "Attachments have data and/or url, or else SHOULD have either contentType and/or language"
**Fix.** Complete the Attachment in the example: add `contentType` (e.g. `#application/pdf`) and,
where it makes sense, a `url`. An inline `Usage: #inline` Attachment instance counts too.

### "A resource should have narrative for robust management" (dom-6)
**Leave.** The publisher generates narrative for IG examples, so this rarely appears in QA. It
shows up when validating standalone JSON.

---

## Pages and links

### Broken links ("The link 'X' for 'Y' cannot be resolved")
**Fix** the link in `input/pagecontent/*.md`. Find the real target in `output/` (for example,
`ls output/StructureDefinition-*.html`). Profile pages are `StructureDefinition-<id>.html`,
element anchors are `StructureDefinition-<id>-definitions.html#<Path>`, and slices use `:` (for example,
`#Device.extension:modelCard`).

### "Illegal HTML: illegal html element: X"
**Fix.** The publisher only allows a safe subset of HTML in pages. The element named in the message is
the one it rejected (for example, `<small>`). Not every legacy tag is reported (`<font>` was accepted by
IG Publisher 2.3.4), so only act on elements the QA report actually names. Use Markdown or allowed tags
(`<br/>`, `<b>`, `<i>`, `<a>`, `<table>`). Tables render without borders unless followed by `{: .grid}`.

---

## Environment / build

### Terminology server unreachable / "tx.fhir.org" timeouts / "-tx n/a" warnings
**Leave, rebuild online.** `_genonce.sh` falls back to `-tx n/a` when offline, which produces
terminology warnings that aren't real. Report it and rerun the build when online.

### "IG Publisher NOT FOUND"
Run `bash _updatePublisher.sh` once. It downloads `input-cache/publisher.jar`.

### SUSHI errors in the build log (`error <message>` with `File: input/fsh/x.fsh  Line: n`)
**Fix** in FSH first. The rest of the QA report is stale or absent until SUSHI succeeds.
