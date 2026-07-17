// =======================================================
// 1. EU AI / IG CUSTOM CODESYSTEM
// =======================================================

CodeSystem: EUAIActCodeSystem
Id: EUAIActCodeSystem
Title: "EU AI Transparency Custom Codes"
Description: "Custom codes used in this IG to represent AI transparency, data-use, provenance, technical documentation, data-quality, and human-oversight documentation concepts."

* ^status = #active
* ^experimental = false
* ^caseSensitive = true

// -------------------------------------------------------
// Core AI system concepts (SYS-01, SYS-05)
// -------------------------------------------------------

* #ai-system "AI System"
* #high-risk-ai "High-Risk AI System"
* #gpai "General Purpose AI"
* #model-card "AI Model Card"
* #ai-generated "AI Generated Result"

// -------------------------------------------------------
// Core AI system concepts (SYS-01, SYS-05)
// -------------------------------------------------------

* #dpo "Data Protection Officer" "Contact details of the organization's Data Protection Officer."
* #ai-incident-reporting "AI Incident Reporting Contact" "Contact point for reporting AI-related incidents or serious incidents."

// -------------------------------------------------------
// Human oversight (HL-03.1)
// -------------------------------------------------------

* #human-override "Human Override"
* #human-validation "Human Validation"
* #human-correction "Human Correction"

// -------------------------------------------------------
// Transparency and patient-facing information (LAW-07)
// -------------------------------------------------------

* #ai-transparency-info "AI Transparency Information"
* #patient-information-provided "Patient Information Provided"
* #patient-explanation-requested "Patient Explanation Requested"
* #patient-explanation-provided "Patient Explanation Provided"

// -------------------------------------------------------
// Performance metrics (QUAL-01)
// -------------------------------------------------------

* #accuracy "Accuracy"
* #sensitivity "Sensitivity"
* #specificity "Specificity"
* #robustness "Robustness"

// -------------------------------------------------------
// Clinical validation status
// -------------------------------------------------------

* #clinically-validated "Clinically Validated" "The AI system has completed clinical validation."
* #not-clinically-validated "Not Clinically Validated" "The AI system has not completed clinical validation."
* #validation-in-progress "Validation In Progress" "Clinical validation is currently in progress."
* #technical-validation-only "Technical Validation Only" "Only technical or syntactic validation has been performed."

// -------------------------------------------------------
// Case-specific indication (USE-04)
// -------------------------------------------------------

* #triage "Triage and Prioritization"
* #screening "Screening"
* #second-opinion "Second Opinion"
* #diagnostic-support "Diagnostic Support"
* #treatment-planning "Treatment Planning"
* #prognosis "Prognostic Prediction"

// -------------------------------------------------------
// Device and regulatory identifiers (SYS-11)
// -------------------------------------------------------

* #ce-mark "CE Mark" "Indicates whether the device has a CE mark."
* #notified-body-id "Notified Body ID" "Identifier of the notified body."
* #expected-lifetime "Expected Lifetime" "The expected lifetime of the AI system."
* #intended-purpose "Intended Purpose" "The intended purpose of the AI system."
* #target-population "Target Population" "The intended target population."
* #eu-ai-registration-number "EU AI Registration Number" "Unique registration number assigned to the high-risk AI system in the official EU AI database."

// -------------------------------------------------------
// EHDS usage categories (LAW-03.1)
// -------------------------------------------------------

* #primary-use "Primary Use" "Processing for direct patient care."
* #secondary-use "Secondary Use" "Processing for research, AI training, policy making, or other permitted secondary-use purposes."

// -------------------------------------------------------
// EHDS data categories for secondary use (EHDS Art. 51)
// -------------------------------------------------------

* #ehr "Electronic Health Records (EHRs)" "Electronic health data from electronic health records (Art. 51 1a)."
* #health-factors "Health Determinants" "Data impacting health, including socioeconomic, environmental and behavioural determinants (Art. 51 1b)."
* #healthcare-resources "Aggregated Healthcare Data" "Aggregated data on healthcare needs, resources, access and financing (Art. 51 1c)."
* #pathogen-data "Pathogen Data" "Data on pathogens impacting human health (Art. 51 1d)."
* #admin-claims "Administrative and Claims Data" "Health-related administrative data, including claims and reimbursement data (Art. 51 1e)."
* #human-genomic "Human Genomic Data" "Human genetic, epigenomic and genomic data (Art. 51 1f)."
* #molecular-omics "Molecular Omic Data" "Other human molecular data, such as proteomic, transcriptomic, metabolomic, lipidomic and other omic data (Art. 51 1g)."
* #device-generated-personal "Device-Generated Personal Data" "Person-generated electronic health data automatically generated by medical devices (Art. 51 1h)."
* #wellness-apps "Wellness Application Data" "Data from wellness applications (Art. 51 1i)."
* #professional-status "Healthcare Professional Data" "Data on the professional status, specialization and institution of healthcare professionals (Art. 51 1j)."
* #public-health-registry "Public Health Registries" "Data from population-wide health data registries (Art. 51 1k)."
* #medical-mortality-registry "Medical and Mortality Registries" "Data from medical registries and mortality registries (Art. 51 1l)."
* #clinical-trial "Clinical Trial Data" "Data from clinical trials, clinical studies and performance studies (Art. 51 1m)."
* #medical-device-other "Other Medical Device Data" "Other health data from medical devices (Art. 51 1n)."
* #medicinal-device-registry "Medicinal and Device Registries" "Data from registries for medicinal products and medical devices (Art. 51 1o)."
* #research-cohort-survey "Research Cohorts and Surveys" "Data from research cohorts, questionnaires and health-related surveys (Art. 51 1p)."
* #biobank "Biobank Data" "Health data from biobanks and associated databases (Art. 51 1q)."

// -------------------------------------------------------
// AI training-data quality (Art. 10 AI Act)
// -------------------------------------------------------

* #representative "Representative" "Data are sufficiently representative of the target population."
* #error-free "Error-Free" "Data are free of errors to the best extent possible."
* #complete "Complete" "Data are complete with regard to the intended purpose."
* #relevant "Relevant" "Data are relevant for the intended purpose."

// =======================================================
// 2. EHDS PURPOSE CODESYSTEM
// =======================================================

CodeSystem: EHDSPurposeCodeSystem
Id: ehds-purpose-codesystem
Title: "EHDS Secondary Use Purpose CodeSystem"
Description: "Code system defining permitted EHDS secondary-use purposes relevant for documenting secondary use of electronic health data."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #public-health "Public Health"
* #policy-regulatory "Policy and Regulatory Activities"
* #statistics "Statistics"
* #education-teaching "Education or Teaching"
* #scientific-research "Scientific Research"
* #development-innovation "Development and Innovation"
* #algorithm-training-testing "Training, Testing and Evaluation of Algorithms"
* #care-improvement "Improvement of Care Delivery"

// =======================================================
// 3. GDPR CODESYSTEMS
// =======================================================

CodeSystem: GDPRArt6CodeSystem
Id: gdpr-art6-codesystem
Title: "GDPR Article 6 Legal Basis CodeSystem"
Description: "Code system defining GDPR Article 6 legal bases relevant for documenting legal-basis metadata in AI-supported processing contexts."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #gdpr-art-6-1-a "Consent (Art. 6(1)(a))"
* #gdpr-art-6-1-b "Contract (Art. 6(1)(b))"
* #gdpr-art-6-1-c "Legal Obligation (Art. 6(1)(c))"
* #gdpr-art-6-1-d "Vital Interests (Art. 6(1)(d))"
* #gdpr-art-6-1-e "Public Interest or Official Authority (Art. 6(1)(e))"
* #gdpr-art-6-1-f "Legitimate Interests (Art. 6(1)(f))"

CodeSystem: GDPRArt9CodeSystem
Id: gdpr-art9-codesystem
Title: "GDPR Article 9 Exception CodeSystem"
Description: "Code system defining GDPR Article 9 exceptions relevant for documenting the processing context of special categories of personal data, including health data."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #gdpr-art-9-2-a "Explicit Consent (Art. 9(2)(a))"
* #gdpr-art-9-2-c "Vital Interests (Art. 9(2)(c))"
* #gdpr-art-9-2-g "Substantial Public Interest (Art. 9(2)(g))"
* #gdpr-art-9-2-h "Health or Social Care (Art. 9(2)(h))"
* #gdpr-art-9-2-i "Public Health (Art. 9(2)(i))"
* #gdpr-art-9-2-j "Research (Art. 9(2)(j))"

// =======================================================
// 4. EU AI VALUESETS
// =======================================================

ValueSet: EUCaseSpecificIndicationVS
Id: eu-case-specific-indication-vs
Title: "EU AI Case-Specific Indication ValueSet"
Description: "Clinical and administrative reasons for applying an AI system in a specific case (USE-04)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#triage
* EUAIActCodeSystem#screening
* EUAIActCodeSystem#second-opinion
* EUAIActCodeSystem#diagnostic-support
* EUAIActCodeSystem#treatment-planning
* EUAIActCodeSystem#prognosis

ValueSet: EU_AI_PerformanceMetricVS
Id: eu-ai-performance-metric-vs
Title: "AI Performance Metric ValueSet"
Description: "Codes for technical quality and performance metrics (QUAL-01)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#accuracy
* EUAIActCodeSystem#sensitivity
* EUAIActCodeSystem#specificity
* EUAIActCodeSystem#robustness

ValueSet: EU_AI_ClinicalValidationStatusVS
Id: eu-ai-clinical-validation-status-vs
Title: "AI Clinical Validation Status ValueSet"
Description: "Codes describing the clinical validation status of an AI system."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#clinically-validated
* EUAIActCodeSystem#not-clinically-validated
* EUAIActCodeSystem#validation-in-progress
* EUAIActCodeSystem#technical-validation-only

ValueSet: EU_AI_DataQualityVS
Id: eu-ai-data-quality-vs
Title: "AI Data Quality ValueSet"
Description: "Codes describing data-quality characteristics relevant for training-data documentation (Art. 10 AI Act)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#representative
* EUAIActCodeSystem#error-free
* EUAIActCodeSystem#complete
* EUAIActCodeSystem#relevant

ValueSet: EU_AI_Intervention_ValueSet
Id: eu-ai-intervention-vs
Title: "Human Intervention Type ValueSet"
Description: "Codes representing the type of human oversight or intervention (HL-03.1)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#human-override
* EUAIActCodeSystem#human-validation
* EUAIActCodeSystem#human-correction

// =======================================================
// 5. EHDS VALUESETS
// =======================================================

ValueSet: EHDS_UsageCategoryVS
Id: ehds-usage-category-vs
Title: "EHDS Usage Category ValueSet"
Description: "Codes defining whether data usage is documented as primary use or secondary use (LAW-03.1)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#primary-use
* EUAIActCodeSystem#secondary-use

ValueSet: EHDS_DataCategoryVS
Id: ehds-data-category-vs
Title: "EHDS Data Category ValueSet"
Description: "Categories of electronic health data relevant for secondary-use documentation under the EHDS (EHDS Art. 51)."
* ^status = #active
* ^experimental = false
* EUAIActCodeSystem#ehr
* EUAIActCodeSystem#health-factors
* EUAIActCodeSystem#healthcare-resources
* EUAIActCodeSystem#pathogen-data
* EUAIActCodeSystem#admin-claims
* EUAIActCodeSystem#human-genomic
* EUAIActCodeSystem#molecular-omics
* EUAIActCodeSystem#device-generated-personal
* EUAIActCodeSystem#wellness-apps
* EUAIActCodeSystem#professional-status
* EUAIActCodeSystem#public-health-registry
* EUAIActCodeSystem#medical-mortality-registry
* EUAIActCodeSystem#clinical-trial
* EUAIActCodeSystem#medical-device-other
* EUAIActCodeSystem#medicinal-device-registry
* EUAIActCodeSystem#research-cohort-survey
* EUAIActCodeSystem#biobank

ValueSet: EHDS_SecondaryUsePurposeVS
Id: ehds-secondary-use-purpose-vs
Title: "EHDS Secondary Use Purpose ValueSet"
Description: "Permitted purposes for secondary use of electronic health data under the EHDS."
* ^status = #active
* ^experimental = false
* EHDSPurposeCodeSystem#public-health
* EHDSPurposeCodeSystem#policy-regulatory
* EHDSPurposeCodeSystem#statistics
* EHDSPurposeCodeSystem#education-teaching
* EHDSPurposeCodeSystem#scientific-research
* EHDSPurposeCodeSystem#development-innovation
* EHDSPurposeCodeSystem#algorithm-training-testing
* EHDSPurposeCodeSystem#care-improvement

// =======================================================
// 6. GDPR VALUESETS
// =======================================================

ValueSet: GDPR_Art6_LegalBasisVS
Id: gdpr-art6-legal-basis-vs
Title: "GDPR Article 6 Legal Basis ValueSet"
Description: "Value set including GDPR Article 6 legal bases relevant for documenting the lawful processing of personal data."
* ^status = #active
* ^experimental = false
* include codes from system GDPRArt6CodeSystem

ValueSet: GDPR_Art9_ExceptionVS
Id: gdpr-art9-exception-vs
Title: "GDPR Article 9 Exception ValueSet"
Description: "Value set including GDPR Article 9 exceptions relevant for documenting the processing of special categories of personal data, including health data."
* ^status = #active
* ^experimental = false
* include codes from system GDPRArt9CodeSystem
