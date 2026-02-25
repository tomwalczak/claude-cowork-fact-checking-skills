---
name: draft-review
description: >
  Orchestrate a comprehensive review of a written draft by coordinating fact-checking and critic
  agents. This skill runs an ensemble of independent fact-checkers first, then spawns an ensemble
  of independent critic agents (e.g., Cowen-style, Yglesias-style) that receive both the draft and
  the fact-check findings. It produces a freeform synthesis in chat plus a structured verification
  rubric document that tracks every finding with red/amber/green status. Use this skill whenever
  the user wants a thorough review of a draft that combines fact-checking with substantive critique.
  Also trigger when users say "review this draft", "give me feedback on this", "fact-check and
  critique this", or request multiple perspectives on a piece of writing.
---

# Draft Review Orchestrator

You are an orchestrator. Your job is to coordinate a multi-stage review of a written draft by
dispatching work to specialized subagents and then synthesizing their output into two deliverables:
a freeform chat summary and a structured verification rubric document.

You do not write critiques yourself. You manage the pipeline and produce the synthesis.

## The Pipeline

### Stage 1: Fact-Check (with optional ensemble)

Before any critic sees the draft, run a fact-checking pass. By default, spawn **one** fact-check
agent. If the user requests higher thoroughness (e.g., "run 3 of each", "use ensemble mode",
"run N agents per type"), spawn that many independent fact-check agents in parallel instead.

**How to do this:**

Use the Task tool to spawn subagent(s). If running an ensemble, each receives identical
instructions but runs in isolation with its own context, search queries, and reasoning chain.

```
For each fact-check agent instance, use:

Task tool call:
  subagent_type: "general-purpose"
  prompt: |
    [Paste the FULL contents of .skills/skills/fact-check/SKILL.md here as the agent's instructions]

    Here is the draft to fact-check:

    ---
    [paste the full draft text here]
    ---

    IMPORTANT: Use web search for EVERY checkable claim. Do not rely on memory or training
    data alone. Return ONLY the markdown report, nothing else.
```

**Critical:** Paste the fact-check skill instructions directly into each agent's prompt. Do NOT
tell the agent to read a file path — subagents may not have access to the same filesystem.

Wait for all fact-check agents to complete before proceeding.

**If running an ensemble** (2+ agents), compare their findings to identify:
- **Consensus findings** (all agree) — highest confidence
- **Majority findings** (most agree) — high confidence
- **Split findings** (agents disagree) — flag the disagreement

**If running a single agent**, use its findings directly.

### Stage 2: Critic Agents (with optional ensemble, in parallel)

Once all fact-check agents have returned, spawn critic agents. By default, spawn **one** instance
of each requested critic perspective. If the user requests higher thoroughness, spawn that many
independent instances of each critic — all launching simultaneously.

Each critic agent receives:
1. The original draft
2. A summary of the fact-check findings (synthesize the consensus if ensemble was used; otherwise
   pass the single agent's findings)
3. The critic skill instructions pasted directly into the prompt

**How to do this:**

```
For each instance of each critic, use:

Task tool call:
  subagent_type: "general-purpose"
  prompt: |
    [Paste the FULL contents of .skills/skills/[critic-name]/SKILL.md here as instructions]

    Here is the draft to critique:

    ---
    [paste the full draft text here]
    ---

    Here is a summary of the fact-check findings from an independent fact-checking pass.
    Use this as your factual foundation. Do not redo basic fact verification — focus on
    your unique analytical contribution.

    ---
    [paste the synthesized fact-check consensus or single agent findings here]
    ---

    IMPORTANT: Use web search to verify any claims you're uncertain about. Return ONLY
    the markdown critique document, nothing else.
```

**Available critics** (use whichever the user requests):

- **cowen-critique**: Tyler Cowen's reasoning methods. Best for: stress-testing arguments,
  finding boring explanations, cross-domain analogies, revealed preferences, market signals.
  Skill file: `.skills/skills/cowen-critique/SKILL.md`

- **yglesias-critique**: Matt Yglesias's reasoning methods. Best for: policy feasibility,
  political sustainability, cost disease, scale testing, implementation org charts.
  Skill file: `.skills/skills/yglesias-critique/SKILL.md`

If the user doesn't specify which critics to use, default to both.

**All critic agents launch simultaneously.** They must not see each other's output. If using
both critics with N instances each, that's 2×N Task tool calls in a single message.

### Stage 3: Synthesize and Produce Outputs

After all agents complete, read their outputs and produce two deliverables:

1. **A freeform chat synthesis** (the main response to the user)
2. **A verification rubric document** (saved as a Markdown file)

---

## Deliverable 1: Freeform Chat Synthesis

Present this directly in the chat. It should be self-contained — assume the user has NOT read
the individual reports.

### How to Analyze the Results

**If running in ensemble mode (2+ agents per type):**

The value of running multiple independent agents is in the convergence and divergence patterns:

*Across runs of the same agent type:*
- Where all instances agree → highest confidence finding
- Where most instances agree → high confidence finding
- Where instances disagree → the finding is less reliable or the claim is genuinely ambiguous

*Across different agent types:*
- Where fact-checkers AND critics flag the same issue → very high signal
- Where Cowen and Yglesias critics independently raise the same point → strong structural finding
- Where critics disagree with each other → interesting tension the author should consider

Note convergence counts (e.g., "3/3 agents", "2/3 agents") throughout your synthesis and in
the rubric's Type column. These counts are the signal.

**If running in single-agent mode (1 agent per type):**

You won't have convergence data within agent types, but you still have cross-type signal:
where the fact-checker and both critics independently flag the same issue, that's high
confidence. Where only one critic raises something, note that it's a single-perspective finding.

### Structure the Chat Synthesis As:

#### Factual Issues
Start with what the fact-check ensemble found. Group into:
- **Claims that need fixing** (consensus: inaccurate). State the claim, what evidence shows, why it matters.
- **Claims that need precision** (consensus: mostly accurate). State the issue and the correction.
- **Claims that are solid** (brief — just note the fact-checkers confirmed them).

#### Structural Critique
Synthesize what the critic ensembles found. Organize by convergence signal, not by critic:
- **Things all/most critic instances agreed on across both perspectives** (highest signal)
- **Things one perspective consistently raised** (attribute clearly)
- **Points of disagreement between perspectives** (present both sides)
- **Unique observations from single instances** (lower confidence, but potentially interesting)

#### What the Draft Gets Right
Synthesize the strengths both critics identified.

#### Actionable Guidance
End with the key revisions, ordered by priority and convergence signal.

---

## Deliverable 2: Verification Rubric Document

Save this as a Markdown file to the output directory. This is a structured, scannable tracking
document the author uses to verify their revisions.

**The rubric must follow this exact format:**

```markdown
# Draft Verification Rubric

**Draft:** [title] | **Checked:** [date] | **Status: 🔴 DOES NOT PASS** — [N] red item(s) unresolved

---

## 🔴 Must Fix

Factual errors identified by fact-check consensus ([N]/3 agents). Draft cannot pass verification
with any red items unresolved.

| # | Claim in draft | Issue | Status |
|---|---|---|---|
| R1 | "[exact quote from draft]" | [What's wrong and what evidence shows. Concise — 1-2 sentences max.] | 🔴 Unresolved |

---

## 🟡 Must Address

Imprecise or unverified claims, plus structural issues flagged independently by multiple critique
agents (high-signal convergence). Each item must be either fixed or acknowledged by the author
with a written note explaining why it stands.

| # | Item | Type | Status | Author note |
|---|---|---|---|---|
| A1 | [Description of the issue — what the draft says or doesn't say, and what agents found] | [Source: e.g., "Imprecise claim", "Both critics (6/6 agents)", "Yglesias (3/3 agents)"] | 🟡 Open | — |

---

## 🟢 Consider

Ideas surfaced by one or two agents, or by tensions between critics. Not required to pass
verification. Included for the author's consideration only.

| # | Idea | Source |
|---|---|---|
| C1 | [The suggestion — specific enough to act on] | [Which critic or agent type, with count] |

---

## Verified ✅

Claims confirmed accurate by the fact-check. No action needed.

| Claim | Verdict |
|---|---|
| "[exact quote from draft]" | ✅ Accurate |

---

To pass verification: all 🔴 items must be resolved. All 🟡 items must be either fixed or carry
an author note. 🟢 items are optional.
```

### Rules for Assigning Tiers

**🔴 RED — Must Fix:**
- Factual claims rated **Inaccurate** by fact-check consensus (all or majority of agents, or
  the single agent if running in single-agent mode)
- Factual claims where the specific language used is clearly wrong, even if the spirit is right
- Only factual errors go here. Structural critiques never go in red.

**🟡 AMBER — Must Address:**
- Factual claims rated **Mostly Accurate** by fact-check (imprecise, outdated, or slightly off —
  needs tightening or author justification)
- Factual claims rated **Unverified** (no source found — needs a citation or author justification)
- Structural issues flagged independently by **both critic perspectives** (if using 2 critic
  types). In ensemble mode, weight by how many instances of each type raised it.
- Structural issues flagged **consistently** within one critic type (all instances agreed, if
  running ensemble)

**🟢 GREEN — Consider:**
- Ideas raised by only one agent instance (or one critic perspective with low internal consensus)
- Interesting tensions between critic perspectives
- Suggestions that would strengthen the draft but aren't problems with the current version
- Lower-convergence observations

**✅ Verified:**
- All claims rated **Accurate** by fact-check consensus
- Include these so the author knows which facts are confirmed solid

### Rubric Writing Rules

- Keep descriptions concise. One to two sentences per item, max.
- Quote the draft's exact language in red and amber items where possible.
- In the "Type" column for amber items, always note the convergence signal (e.g., "Both critics
  (5/6 agents)" or "Fact-check (3/3)").
- The status line at the top must state the current pass/fail verdict and the count of red items.
- If there are zero red items, the status line reads:
  `**Status: 🟡 CONDITIONAL PASS** — [N] amber item(s) awaiting resolution or author justification`
- If all red and amber items are resolved:
  `**Status: ✅ PASSES VERIFICATION**`

---

## Output Locations

Save the verification rubric and supporting reports to the output directory:

```
[output-dir]/
├── verification-rubric.md        ← the structured rubric (Deliverable 2)
├── fact-check-report.md          ← synthesized fact-check consensus
├── cowen-critique.md             ← synthesized Cowen critique (if used)
└── yglesias-critique.md          ← synthesized Yglesias critique (if used)
```

At the end of your chat synthesis, link to all documents.

---

## Important Notes

- **Always run fact-checking first.** Do not skip this step even if the user only asks for
  critic perspectives. The fact-check report makes the critics better.
- **Paste skill instructions into agent prompts.** Do not tell agents to read file paths.
  Copy the full contents of each SKILL.md into the agent's prompt directly.
- **All agents of the same stage run in parallel.** They must not see each other's output.
  The ensemble value comes from independence.
- **The chat synthesis is the main deliverable.** The verification rubric is the tracking
  document. Both are required outputs.
- **Be honest about convergence.** If agents mostly disagreed on something, say so — don't
  present a 1/3 finding as if it were consensus.
- **Attribute disagreements.** When critics disagree, present both perspectives and let the
  author decide.
- **The verification rubric is designed for re-runs.** When the author submits a revised draft,
  the same pipeline runs again and updates each status. Design the rubric items so they have
  clear, testable pass conditions.
