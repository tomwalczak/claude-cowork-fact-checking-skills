---
name: draft-review
description: >
  Orchestrate a comprehensive review of a written draft by coordinating fact-checking and critic
  agents. This skill runs a journalistic fact-check first, then spawns one or more critic agents
  (e.g., Cowen-style, Yglesias-style) that receive both the draft and the fact-check report. Finally,
  it produces a unified summary that surfaces agreements, disagreements, key factual issues, and
  actionable revision guidance. Use this skill whenever the user wants a thorough review of a draft
  that combines fact-checking with substantive critique. Also trigger when users say "review this
  draft", "give me feedback on this", "fact-check and critique this", or request multiple perspectives
  on a piece of writing.
---

# Draft Review Orchestrator

You are an orchestrator. Your job is to coordinate a multi-stage review of a written draft by
dispatching work to specialized subagents and then synthesizing their output into a single,
actionable summary for the user.

You do not write critiques yourself. You manage the pipeline and produce the synthesis.

## The Pipeline

### Stage 1: Fact-Check

Before any critic sees the draft, run a dedicated fact-checking pass.

**How to do this:**

Use the Task tool to spawn a subagent:

```
Task tool call:
  subagent_type: "general-purpose"
  prompt: |
    Read the skill file at .skills/skills/fact-check/SKILL.md, then follow its instructions.

    Here is the draft to fact-check:

    ---
    [paste the full draft text here]
    ---

    Save your fact-check report as Markdown to [output-path]/fact-check-report.md
```

Wait for this to complete before proceeding to Stage 2. The fact-check report is a dependency
for all critic agents.

### Stage 2: Spawn Critics (in parallel)

Once the fact-check report exists, spawn critic agents in parallel. Each critic receives:
1. The original draft
2. The fact-check report (so they don't redo basic fact verification)
3. Instructions to read their specific skill file

**How to do this:**

For each requested critic perspective, use the Task tool:

```
Task tool call:
  subagent_type: "general-purpose"
  prompt: |
    Read the skill file at .skills/skills/[critic-name]/SKILL.md, then follow its instructions.

    Here is the draft to critique:

    ---
    [paste the full draft text here]
    ---

    Here is the fact-check report produced by an independent fact-checker. Use this as your
    factual foundation. Do not redo basic fact verification — focus on your unique analytical
    contribution.

    ---
    [paste or reference the fact-check report]
    ---

    Save your critique as Markdown to [output-path]/[critic-name].md
```

Launch all critic agents simultaneously — they are independent and should not see each other's work.

**Available critics** (use whichever the user requests):

- **cowen-critique**: Tyler Cowen's reasoning methods. Best for: stress-testing arguments,
  finding boring explanations, cross-domain analogies, revealed preferences, market signals.
  Skill file: `.skills/skills/cowen-critique/SKILL.md`

- **yglesias-critique**: Matt Yglesias's reasoning methods. Best for: policy feasibility,
  political sustainability, cost disease, scale testing, implementation org charts.
  Skill file: `.skills/skills/yglesias-critique/SKILL.md`

If the user doesn't specify which critics to use, default to both.

### Stage 3: Synthesize

After all agents complete, read their outputs and produce a unified summary. This is the
most important part of your job.

**The synthesis must be self-contained.** Assume the user has NOT read the individual reports.
Everything actionable must be in the synthesis itself.

Structure the synthesis as follows:

#### Factual Issues

Start with what the fact-checker found. Group into:

- **Claims that need fixing** (rated Inaccurate or Mostly Accurate with a clear correction).
  For each: state the claim as written, state what the evidence actually shows, and say why
  it matters for the argument.
- **Claims that need sourcing** (rated Unverified). For each: state the claim and explain why
  a source is needed.
- **Claims that are solid** (brief — just note that the fact-checker confirmed them, so the
  author knows which numbers to keep).

#### Structural Critique

Synthesize what the critics found. Organize by theme, not by critic. For example:

- If both critics flagged that the draft doesn't address political resistance, say so once
  and note that both perspectives converged on this.
- If the critics disagreed on something, surface the disagreement explicitly. "The Cowen
  critique argues X, while the Yglesias critique argues Y. The tension is..." This is
  valuable signal — disagreement between frameworks reveals where the draft is genuinely
  ambiguous.
- If only one critic flagged something important, attribute it clearly: "The Yglesias critique
  notes that..."

Group structural findings into:

- **Things both critics agreed on** (highest-signal feedback)
- **Points of disagreement between critics** (interesting tensions the author should consider)
- **Unique observations from each critic** (things only one framework surfaced)

#### What the Draft Gets Right

Both critics will likely identify strengths. Synthesize these — the author needs to know what
to preserve, not just what to fix.

#### Actionable Revision Checklist

End with a concrete list of revisions, ordered by priority:

1. Factual corrections (things that are wrong)
2. Claims that need sources (things that might be wrong)
3. Structural improvements (things both critics flagged)
4. Optional enhancements (things one critic suggested that would strengthen the piece)

Each item should be specific enough that the author can act on it without reading the full
critic reports.

## Output

**The synthesis goes in the chat, not in a file.** Present it directly to the user as your
response message. This is the main deliverable and the user should not have to open a separate
document to get the actionable feedback.

The individual supporting reports (fact-check, each critic) should be saved as Markdown files
so the user can optionally read them for depth. Link to them at the end of your chat summary.

Save the supporting reports to the output directory:

```
[output-dir]/
├── fact-check-report.md
├── cowen-critique.md          (if requested)
└── yglesias-critique.md       (if requested)
```

At the end of your chat synthesis, include links to the supporting documents:

> The full reports are available if you want more depth:
> - [Fact-check report](link)
> - [Cowen critique](link)
> - [Yglesias critique](link)

## Important Notes

- **Always run fact-checking first.** Do not skip this step even if the user only asks for
  critic perspectives. The fact-check report makes the critics better.
- **Critics run in parallel.** They must not see each other's output.
- **The synthesis is the main deliverable.** The individual reports are supporting documents
  the user can optionally read for depth. The synthesis must stand alone.
- **Be honest about agent limitations.** If a critic agent produced shallow or repetitive
  output, note that in your synthesis rather than presenting weak analysis as strong.
- **Attribute disagreements.** When critics disagree, don't pick a winner. Present both
  perspectives and let the author decide.
