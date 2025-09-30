# 1. Purpose
Authoritative operational workflow for autonomous AI assistants contributing to this repository. Defines planning, gating, testing, DCO, PR standards, safety guardrails, idempotent re-entry, and failure handling. Humans MAY reference but this document is AI-targeted.

# 2. Repository Structure
```
./
├── .expeditor/               # Expeditor release automation config (version bump, changelog, publishing)
├── .github/                  # GitHub meta: workflows, templates, AI prompts
│   ├── CODEOWNERS            # Ownership declarations (Protected File)
│   ├── ISSUE_TEMPLATE.md     # User issue intake form
│   ├── PULL_REQUEST_TEMPLATE.md # Human PR template (AI must extend, not replace)
│   ├── dependabot.yml        # Dependency update automation
│   ├── prompts/              # AI prompt source material
│   └── workflows/            # CI pipelines (lint + unit tests)
├── CHANGELOG.md              # Historical & unreleased change log managed partly by Expeditor
├── CODE_OF_CONDUCT.md        # Conduct policy (Protected File)
├── CONTRIBUTING.md           # Contribution guidance (points to Chef OSS practices)
├── Gemfile                   # Development dependency declarations
├── Rakefile                  # Test, style, docs tasks
├── README.md                 # Project summary & usage notes (not for direct consumption of library)
├── VERSION                   # Current gem version (bumped via Expeditor workflow)
├── win32-ipc.gemspec         # Gem specification, runtime & dev deps (ffi, test-unit)
├── lib/
│   ├── win32-ipc.rb          # Entry point; requires core ipc file
│   └── win32/
│       └── ipc.rb            # Core Win32::Ipc abstract base class + FFI bindings
└── test/
    └── test_win32_ipc.rb     # Test::Unit test suite validating public behavior & constants
```
Notes:
- Release automation present via `.expeditor` (AI MUST NOT modify without explicit approval).

# 3. Tooling & Ecosystem
- Language: Ruby (target Ruby 3.1 baseline; CI also tests 3.4 on Windows).
- Test Framework: test-unit.
- Lint/Style: Cookstyle (Chefstyle) & RuboCop via GitHub Action and Rake `:style` task.
- FFI for Windows API bindings.
- CI: GitHub Actions workflows `lint.yml` (Ubuntu), `unit.yml` (Windows matrix).
- Release: Expeditor handles version bump, changelog update, gem build & publish.
- Dependency automation: Dependabot + Expeditor.

# 4. Issue (Jira/Tracker) Integration
If an external issue key (e.g., ABC-123) is supplied:
1. Fetch via configured MCP (e.g., atlassian) invocation conceptually: `getIssue ABC-123`.
2. Parse & present: summary, description, acceptance criteria bullets, issue type, labels/tags, linked issues, story points (if any).
3. Draft Implementation Plan (see Section 16 template) BEFORE code changes.
4. If acceptance criteria missing → prompt user to provide or confirm inferred criteria.
5. Await explicit user "yes" before proceeding (Freeze Point). No code modifications prior to approval.

# 5. Workflow Overview
Phases (sequential & gated):
1. Intake & Clarify
2. Repository Analysis
3. Plan Draft
4. Plan Confirmation (user gate)
5. Incremental Implementation
6. Lint / Style
7. Test & Coverage Validation
8. DCO Commit
9. Push & Draft PR Creation
10. Label & Risk Application
11. Final Validation
Each phase ends with: Step Summary + Checklist + prompt: "Continue to next step? (yes/no)".
Non-affirmative response → PAUSE.

# 6. Detailed Step Instructions
Principles:
- Minimal cohesive change per commit.
- Add/adjust tests with each logic change.
- Provide mapping (changed logic → test assertions) pre-commit.
Example Output Block:
```
Step: Add boundary guard in wait_for_multiple
Summary: Added nil handle guard; tests for invalid handle & empty array.
Checklist:
- [x] Plan
- [x] Implementation
- [ ] Tests
Proceed? (yes/no)
```
Rules:
- Abort if user denies proceed.
- If ambiguity persists after one clarification attempt → Abort per Section 12.

# 7. Branching & PR Standards
- Branch name: EXACT issue key if provided (ABC-123). Else kebab-case ≤40 chars (e.g., `improve-timeout-handling`).
- Single logical change set per branch.
- PR must stay Draft until: lint pass + tests pass + coverage mapping provided.
- PR Description must integrate Section 17 template with existing `PULL_REQUEST_TEMPLATE.md` headings (augment, do not replace).
- Risk Classification (choose one): Low / Moderate / High per definitions in Section 11 & 19.
- Rollback Strategy: typically `git revert <commit-sha>`; mention if feature toggle present (none today).

# 8. Commit & DCO Policy
Commit Message Format:
```
TYPE(SCOPE): Subject (ISSUE_KEY)

Rationale explaining what & why; include brief test impact.

Issue: ISSUE_KEY or none
Signed-off-by: Full Name <email@domain>
```
MUST: DCO sign-off trailer present. Missing → block & request name/email.
One logical change per commit; may batch trivial style changes.

# 9. Testing & Coverage
- Required mapping table for each commit affecting logic:
```
| File | Method/Block | Change Type | Test File | Assertion Reference |
```
- Coverage Threshold: ≥80% of changed lines (qualitative reasoning acceptable if tooling absent).
- Edge Cases (enumerate in plan):
  - Large / boundary inputs (e.g., max object array for `wait_for_multiple`)
  - Empty / nil input arrays
  - Invalid handles / system call failures (FFI errno)
  - Platform differences (Windows vs non-Windows skip logic if added later)
  - Concurrency / timing (wait timeouts)
  - External dependency failures (FFI load issues)
- Optionally propose SimpleCov; require user approval before adding.

# 10. Labels Reference
Fetched dynamically (2025-09). Use table below; if labels fetch fails → Abort.
```
Name | Description | Typical Use
---- | ----------- | -----------
Aspect: Documentation | How do we use this project? | Docs-related changes
Aspect: Integration | Works correctly with other projects or systems. | Cross-project compatibility
Aspect: Packaging | Distribution of the projects 'compiled' artifacts. | Gemspec / release packaging
Aspect: Performance | Works without negatively affecting the system running it. | perf improvements
Aspect: Portability | Does this project work correctly on the specified platform? | Windows-specific portability
Aspect: Security | Can an unwanted third party affect the stability or look at privileged information? | Security fix
Aspect: Stability | Consistent results. | Flakiness / reliability
Aspect: Testing | Does the project have good coverage, and is CI working? | Test infra changes
Aspect: UI | (UI/interaction) | (Rare here) interface semantics
Aspect: UX | (User experience) | Behavioral ergonomics
dependencies | Pull requests that update a dependency file | Dependabot or manual bump
Expeditor: Bump Version Major | Bump Major via automation | Release coordination
Expeditor: Bump Version Minor | Bump Minor via automation | Release coordination
Expeditor: Skip All | Skip all merge actions | Special-case maintenance
Expeditor: Skip Changelog | Skip changelog update | Manual release adjustments
Expeditor: Skip Habitat | Skip habitat build | Infra
Expeditor: Skip Omnibus | Skip omnibus build | Infra
Expeditor: Skip Version Bump | Skip version bump | Hotfix w/out release
hacktoberfest-accepted | Hacktoberfest credit | Seasonal contribution
oss-standards | OSS standardization | Repo standard updates
Platform: AWS | (null) | Platform reference
Platform: Azure | (null) | Platform reference
Platform: Debian-like | (null) | Platform reference
Platform: Docker | (null) | Platform reference
Platform: GCP | (null) | Platform reference
Platform: Linux | (null) | Platform reference
Platform: macOS | (null) | Platform reference
Platform: RHEL-like | (null) | Platform reference
Platform: SLES-like | (null) | Platform reference
Platform: Unix-like | (null) | Platform reference
```
Mapping Guidance:
- Bug → Stability / Security / Performance as appropriate.
- Feature → feat + possibly Integration / Portability labels.
- Maintenance → chore + dependencies / oss-standards.

# 11. CI / Release Automation Integration
Workflows:
- `lint.yml`: Trigger on PR & push to main; runs Cookstyle/Rubocop on Ubuntu.
- `unit.yml`: Trigger on PR & push to master (NOTE: branch misalignment; main vs master) matrix (windows-2019, windows-2022) Ruby 3.1 & 3.4 executing tests.
Release Automation:
- Expeditor (`.expeditor/config.yml`) manages: version bump (VERSION file), changelog rollup, gem build & publish, tag format `win32-ipc-<version>`.
Versioning:
- VERSION file authoritative; gemspec and `Ipc::VERSION` must match (currently mismatch: gemspec=0.8.0, VERSION=0.8.2, code constant=0.8.2; test expects 0.8.0 – indicates test/gemspec drift). AI MUST raise mismatch in planning if touching version.
Policy:
- AI MUST NOT directly edit `.expeditor` configs or workflows without explicit instruction.

# 12. Security & Protected Files
Protected (require explicit user approval before modification):
- LICENSE (if added later), CODE_OF_CONDUCT.md, CODEOWNERS, SECURITY* docs
- `.expeditor/**`, `.github/workflows/**`, release automation scripts
- VERSION (only via approved release workflow context)
- CHANGELOG.md (Expeditor manages; edits only with approval)
Constraints:
- Never exfiltrate or insert secrets.
- No force pushes to default branch.
- Do not merge PRs autonomously.
- Do not fabricate issue or label data.
- No new binaries committed.

# 13. Prompts Pattern (Interaction Model)
At each workflow phase output block:
```
Step: <NAME>
Summary: <RESULT>
Checklist:
- [x] Intake & Clarify
- [ ] Repository Analysis
... (current statuses)
Continue to next step? (yes/no)
```
User must answer "yes" to proceed.

# 14. Validation & Exit Criteria
Task COMPLETE ONLY IF:
1. Feature/fix branch exists & pushed.
2. Lint/style passes.
3. Tests pass (all CI matrix relevant where feasible locally).
4. Coverage mapping complete (≥80% changed lines or justified).
5. Draft or Ready PR open with required HTML sections.
6. Appropriate labels applied.
7. All commits DCO-compliant.
8. No unauthorized Protected File edits.
9. User explicitly confirms completion.
Unmet → report deltas with remediation guidance.

# 16. Issue Planning Template
```
Issue: ABC-123
Summary: <from issue>
Acceptance Criteria:
- ...
Implementation Plan:
- Goal:
- Impacted Files:
- Public API Changes:
- Data/Integration Considerations:
- Test Strategy:
- Edge Cases:
- Risks & Mitigations:
- Rollback:
Proceed? (yes/no)
```

# 17. PR Description Canonical Template
If `.github/PULL_REQUEST_TEMPLATE.md` present (yes), AI MUST augment (not replace) by appending sections below if missing:
```
<h2>Tests & Coverage</h2>
<p>Changed lines: N; Estimated covered: ~X%; Mapping complete.</p>
<h2>Risk & Mitigations</h2>
<p>Risk: Low|Moderate|High – Rationale. Mitigation: revert commit SHA / additional tests.</p>
<h2>DCO</h2>
<p>All commits signed off.</p>
```
If template absent → fallback HTML template. Do NOT duplicate fallback when template exists.

# 18. Idempotency Rules
On re-entry:
1. Check branch existence: `git rev-parse --verify <branch>`.
2. Check PR existence: `gh pr list --head <branch>`.
3. Check uncommitted changes: `git status --porcelain`.
Produce Delta Summary:
```
Added Sections:
Modified Sections:
Deprecated Sections:
Rationale:
```
Avoid redoing work; only progress missing phases.

# 19. Failure Handling
Decision Tree:
- Labels fetch fails → Abort: request manual list or auth fix (Retry? yes/no).
- Issue fetch incomplete (missing summary or description) → Abort per Section 4.
- Missing acceptance criteria → Prompt: provide or proceed with inferred.
- Coverage < threshold → Add tests; block commit.
- Missing DCO → Request name/email; block commit.
- Attempt to modify Protected File sans approval → Reject & restate policy.
Risk Classification:
- Low: Localized, non-breaking.
- Moderate: Shared module / light interface change.
- High: Public API change, performance critical, security sensitive, or migration.
Rollback Strategy: revert commit `<SHA>`; if multiple commits revert merge commit or sequentially.

# 20. Glossary
- Changed Lines Coverage: Portion of modified lines executed by tests.
- Implementation Plan Freeze Point: Approval gate before coding.
- Protected Files: Restricted assets requiring explicit authorization.
- Idempotent Re-entry: Safe continuation without duplication.
- Risk Classification: Qualitative impact tier.
- Rollback Strategy: Defined reversal action.
- DCO: Developer Certificate of Origin confirmation of rights.

# 21. Quick Reference Commands
```bash
# Branch creation
git checkout -b <BRANCH>

# Install deps
gem install bundler
bundle install

# Lint
bundle exec rake style
# or rely on CI lint.yml

# Run tests (Windows-specific behaviors mocked locally)
bundle exec rake test

# Stage & commit
git add .
git commit -m "feat(ipc): improve wait error handling (ABC-123)" -m "Rationale: clarify timeout errors\n\nIssue: ABC-123" -m "Signed-off-by: Full Name <email@domain>"

# Push & open PR
git push -u origin <BRANCH>
gh pr create --base main --head <BRANCH> --title "ABC-123: Improve wait error handling" --draft

# Apply labels (examples)
gh pr edit <PR_NUMBER> --add-label "Aspect: Stability" --add-label "dependencies"
```
