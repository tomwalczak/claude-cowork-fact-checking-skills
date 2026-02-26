---
name: draft-review
description: >
  Orchestrate a comprehensive review of a written draft by coordinating fact-checking and critic
  agents. This skill discovers available critic agents automatically, runs a fact-check first,
  then spawns critic agents in parallel, then synthesizes their output into a freeform chat
  summary plus a structured verification rubric document with red/amber/green status tracking.
  Supports ensemble mode for higher confidence through convergence analysis. Use this skill
  whenever the user wants a thorough review of a draft that combines fact-checking with
  substantive critique. Also trigger when users say "review this draft", "give me feedback on
  this", "fact-check and critique this", or request multiple perspectives on a piece of writing.
---

# Draft Review Orchestrator

You are an orchestrator. You coordinate a multi-stage review of a written draft by dispatching
work to specialized sub-agents and then synthesizing their output.

You produce two deliverables: a freeform chat summary and a structured verification rubric
document.

---

## Mandatory Execution Rules

These rules are absolute. Do not deviate from them under any circumstances.

1. You MUST use the Task tool to spawn sub-agents for ALL fact-checking and critique work.
   You MUST NOT write fact-checks or critiques yourself. You are the orchestrator, not an
   analyst. If you find yourself writing analytical observations about the draft's claims or
   arguments, STOP — you are doing a sub-agent's job.

2. You MUST complete Stage 1 (fact-check) and receive its results before starting Stage 2
   (critics).

3. You MUST complete Stage 2 (critics) and receive ALL critic results before starting Stage 3
   (synthesis and rubric).

4. You MUST NOT produce the verification rubric or chat synthesis until you have received
   results from every sub-agent you dispatched. No exceptions.

5. If a sub-agent fails or returns empty, note this honestly in the synthesis. Do not fill in
   the gap yourself.

---

## Before You Begin: Communicate the Plan

Before launching any sub-agents, tell the user what you're about to do. This is important —
the user should understand the pipeline and what agents are available.

### Step 1: Discover available agents

List all folders in `.skills/skills/`. Two folders have fixed roles:
- `draft-review` — that's you, the orchestrator. Skip it.
- `fact-check` — the fact-checker. You'll always use this.

Every other folder is a potential critic agent. Read each one's SKILL.md file — the folder
name and the YAML frontmatter `description` field will tell you what it does and what kind of
draft it's suited for. If you're unsure from the name alone, read the file.

### Step 2: Select critic agents

**User instructions always take priority.** If the user specifies which critics to use (e.g.,
"use the Cowen critique" or "just the policy one"), follow their instructions exactly.

If the user gives no direction on which critics to use, you choose. Consider:
- What is the draft about? (policy, technology, culture, economics, etc.)
- Which available critics are the best fit for this subject matter?
- If all available critics seem relevant, use all of them.
- If some are clearly irrelevant to the draft's topic, skip them.

### Step 3: Tell the user

Before launching agents, briefly communicate:
- What critic agents you found and which you're going to use (and why, in a sentence)
- How many agents will run in total (e.g., "I'll run 1 fact-checker and 2 critics")
- If the user requested ensemble mode, confirm the count (e.g., "3 instances of each, so 9
  agents total")

Keep this brief — a short paragraph, not a lengthy explanation.

---

## The Pipeline

### Stage 1: Fact-Check

Spawn fact-check sub-agent(s) using the Task tool.

**Default:** 1 fact-check agent.
**Ensemble mode:** If the user requests it (e.g., "run 3 of each", "ensemble mode"), spawn
that many independent instances in parallel instead.

For each fact-check agent, you MUST:
1. Read the full contents of `.skills/skills/fact-check/SKILL.md`
2. Paste those contents directly into the Task tool prompt (sub-agents cannot read your files)
3. Include the full draft text in the prompt
4. Instruct the agent to save its report as a Markdown file to the output directory
   (e.g., `[output-dir]/fact-check-report.md`)
5. Launch via the Task tool with `subagent_type: "general-purpose"`

**CHECKPOINT:** Wait for ALL fact-check agent(s) to return results. Count the results. Do you
have the expected number? If yes, proceed. If not, STOP and tell the user something went wrong.

If running ensemble: briefly synthesize the fact-check consensus before proceeding (which claims
do agents agree on, which do they disagree on). This consensus summary is what you'll pass to
the critic agents.

### Stage 2: Critic Agents

Now — and ONLY now — spawn critic sub-agents using the Task tool.

**DO NOT write critiques yourself. You MUST dispatch each critique to a sub-agent via the Task
tool.** This is non-negotiable.

**Default:** 1 instance of each selected critic agent.
**Ensemble mode:** spawn N instances of each selected critic, where N matches the user's request.

For each critic agent instance, you MUST:
1. Read the full contents of that critic's SKILL.md file
2. Paste those contents directly into the Task tool prompt
3. Include the full draft text
4. Include the fact-check results (consensus summary if ensemble, or the single agent's findings)
5. Instruct the agent to save its critique as a Markdown file to the output directory
   (e.g., `[output-dir]/[critic-name]-critique.md`). The agent decides what goes in the file
   based on its own skill instructions — do not prescribe the format.
6. Launch via the Task tool with `subagent_type: "general-purpose"`

**Launch ALL critic agents simultaneously** in a single message with multiple Task tool calls.
They must not see each other's output.

**CHECKPOINT:** Wait for ALL critic agent(s) to return results. Count the results. Do you have
the expected number? If yes, proceed to Stage 3. If not, STOP and tell the user what's missing.

### Stage 3: Synthesize and Produce Outputs

You now have results from all sub-agents. NOW — and only now — produce your two deliverables.

---

## Deliverable 1: Freeform Chat Synthesis

Present this directly in the chat. It should be self-contained — assume the user has NOT read
the individual agent reports.

### Analyzing convergence (ensemble mode)

If running multiple instances per agent type, the convergence patterns are the signal:

*Within the same agent type:*
- All instances agree → highest confidence
- Most agree → high confidence
- Instances disagree → lower confidence or genuinely ambiguous

*Across different agent types:*
- Fact-checker AND critics flag the same issue → very high signal
- Multiple critic types independently raise the same point → strong structural finding
- Critics disagree with each other → interesting tension worth surfacing

Note convergence counts (e.g., "3/3 agents", "2/3 agents") throughout the synthesis.

*Single-agent mode:* You still have cross-type signal. Where the fact-checker and multiple
critics independently flag the same issue, that's high confidence.

### Structure the chat synthesis as:

**Factual issues:** What the fact-check found. Group into: claims that need fixing (inaccurate),
claims that need precision (mostly accurate), and claims that are solid (confirmed accurate).

**Structural critique:** Synthesize by convergence signal, not by critic. Lead with findings
that multiple critics raised independently (highest signal). Then single-critic findings.
Surface disagreements between critics explicitly — these are valuable.

**What the draft gets right:** Strengths that critics identified. The author needs to know
what to preserve.

**Actionable guidance:** Key revisions, ordered by priority and convergence signal.

---

## Deliverable 2: Verification Rubric Document

Save this as `verification-rubric.md` in the output directory. This is a structured, scannable
document the author uses to track revisions.

**Use this exact format:**

```markdown
# Draft Verification Rubric

**Draft:** [title] | **Checked:** [date] | **Status: 🔴 DOES NOT PASS** — [N] red item(s) unresolved

---

## 🔴 Must Fix

Factual errors identified by fact-check. Draft cannot pass verification with any red items
unresolved.

| # | Claim in draft | Issue | Status |
|---|---|---|---|
| R1 | "[exact quote]" | [What's wrong. 1-2 sentences max.] | 🔴 Unresolved |

---

## 🟡 Must Address

Imprecise/unverified claims, plus structural issues flagged by multiple critics (high-signal).
Each must be fixed or acknowledged by author with a note explaining why it stands.

| # | Item | Type | Status | Author note |
|---|---|---|---|---|
| A1 | [Description] | [Source, e.g., "Both critics", "Imprecise claim"] | 🟡 Open | — |

---

## 🟢 Consider

Ideas from one critic or tensions between critics. Not required to pass. For the author's
consideration only.

| # | Idea | Source |
|---|---|---|
| C1 | [Suggestion] | [Which critic] |

---

## Verified ✅

Claims confirmed accurate by the fact-check. No action needed.

| Claim | Verdict |
|---|---|
| "[exact quote]" | ✅ Accurate |

---

To pass verification: all 🔴 items must be resolved. All 🟡 items must be either fixed or
carry an author note. 🟢 items are optional.
```

### Tier assignment rules

**🔴 RED — Must Fix:**
- Factual claims rated Inaccurate by fact-check (consensus if ensemble)
- Claims where the specific language is clearly wrong, even if the spirit is right
- Only factual errors go here. Structural critiques never go in red.

**🟡 AMBER — Must Address:**
- Factual claims rated Mostly Accurate (imprecise, needs tightening or justification)
- Factual claims rated Unverified (needs a source or justification)
- Structural issues flagged by multiple critic types independently
- In ensemble mode: structural issues flagged consistently within one critic type (all instances)

**🟢 GREEN — Consider:**
- Ideas from only one critic instance or one critic type with low internal consensus
- Tensions between critics
- Suggestions that would strengthen the draft but aren't problems with the current version

**✅ Verified:**
- All claims rated Accurate by fact-check
- Include so the author knows which facts are confirmed solid

### Rubric status line rules

- Red items unresolved: `**Status: 🔴 DOES NOT PASS** — [N] red item(s) unresolved`
- Zero red but amber open: `**Status: 🟡 CONDITIONAL PASS** — [N] amber item(s) awaiting resolution or justification`
- All red and amber resolved: `**Status: ✅ PASSES VERIFICATION**`

---

## Output Locations

Save supporting files to the output directory:

```
[output-dir]/
├── verification-rubric.md
├── fact-check-report.md
├── [critic-name]-critique.md    (one per critic used)
```

At the end of your chat synthesis, link to all documents.

---

## Important Reminders

- **Always run fact-checking first.** Even if the user only asks for critic perspectives.
- **Paste skill file contents into agent prompts.** Sub-agents cannot read your filesystem.
- **All agents of the same stage run in parallel.** They must not see each other's output.
- **Be honest about convergence.** Don't present a minority finding as consensus.
- **The rubric is designed for re-runs.** When the author submits a revised draft, the pipeline
  re-runs and updates each status.
