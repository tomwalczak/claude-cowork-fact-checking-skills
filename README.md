# Draft Review Skills

A set of skills for [Claude](https://claude.ai) that run a multi-stage review of written drafts: journalistic fact-checking, then two independent critic perspectives (Tyler Cowen's reasoning methods and Matt Yglesias's policy analysis methods), then a freeform synthesis plus a structured verification rubric with 🔴/🟡/🟢 status tracking. Supports ensemble mode — run multiple independent instances of each agent to surface high-confidence findings through convergence analysis.

Works with both **Claude.ai** (web) and **Claude Cowork** (desktop).

## What's included

| Skill | What it does |
|---|---|
| **draft-review** | Orchestrator. Coordinates the pipeline: fact-check → critics in parallel → freeform synthesis + verification rubric. Supports ensemble mode (multiple independent agents per type) for convergence-based confidence. This is the one you invoke. |
| **fact-check** | Verifies every checkable claim in the draft using web search. Produces verdicts (accurate, mostly accurate, disputed, inaccurate, unverified) with sources. |
| **cowen-critique** | Stress-tests the argument using Tyler Cowen's cognitive moves: boring explanations, revealed preferences, cross-domain analogies, market signals, claim decomposition. |
| **yglesias-critique** | Tests policy feasibility using Matt Yglesias's cognitive moves: goal vs. mechanism, cost disease, scale testing, political survival, implementation org charts. |

## Install

### Option A: Claude.ai (web)

Tell Claude:

> Read the SKILL.md files in the skills/ directory of this repo: https://github.com/tomwalczak/claude-cowork-fact-checking-skills — for each one, use your built-in skill creator to either create a new skill from it or update the existing skill if one with the same name already exists.

Claude will fetch the repo, read each SKILL.md, and use its built-in skill creator to save them as permanent skills. They persist across conversations. If you've installed these skills before and are updating to a newer version, Claude will update the existing skills rather than creating duplicates.

### Option B: Claude Cowork (desktop)

Select the folder you want to use as your workspace, then tell Claude:

> Install the draft review skills from https://github.com/tomwalczak/claude-cowork-fact-checking-skills

Claude will read this README, clone the repo, run the install script, and set everything up. The four skill directories end up in `.skills/skills/` in your workspace, which is where Cowork discovers them.

### Option C: Manual install (terminal)

```bash
cd /path/to/your/workspace
git clone https://github.com/tomwalczak/claude-cowork-fact-checking-skills.git /tmp/draft-review-skills
/tmp/draft-review-skills/install.sh
rm -rf /tmp/draft-review-skills
```

## Usage

Say:

> Review my draft.

Then paste or upload your draft. The orchestrator will:

1. Run a fact-check (verifying every checkable claim with web search)
2. Run both critic perspectives in parallel (each receives the fact-check report so they don't duplicate work)
3. Synthesize everything into a freeform chat summary with factual issues, structural critique, strengths, and actionable revision guidance
4. Produce a **verification rubric** — a structured Markdown document with 🔴 (must fix), 🟡 (address or justify), and 🟢 (consider) items, plus a list of verified claims

### Ensemble mode

For higher confidence, ask for multiple independent runs:

> Review my draft. Run 3 of each agent.

This spawns 3 independent fact-checkers, 3 Cowen critics, and 3 Yglesias critics — all in isolation. The orchestrator then compares their outputs: where agents converge, findings are robust; where they diverge, the claim is genuinely uncertain. Convergence counts (e.g., "3/3 agents", "both critics") appear throughout the synthesis and in the rubric's source column.

### Verification workflow

The rubric is designed for iteration. Revise your draft based on the findings, resubmit it, and the pipeline re-runs and updates each status. The goal: all 🔴 items resolved, all 🟡 items resolved or justified with an author note. That's a pass.

In Cowork, the rubric and individual reports (fact-check, each critique) are saved as Markdown files in your workspace.

### Using individual skills

You can also invoke the skills directly:

- **"Fact-check my draft"** — runs only the fact-checker
- **"Give me a Cowen-style critique"** — runs only the Cowen critic
- **"What's the pragmatic policy critique of this?"** — runs only the Yglesias critic

## Customization

Each skill is a single Markdown file (SKILL.md) that you can edit. Some things you might want to change:

- **Add a new critic perspective.** Duplicate one of the critic directories, rewrite the SKILL.md with a different thinker's reasoning methods, and add it to the orchestrator's "Available critics" list.
- **Change the orchestrator's defaults.** The orchestrator runs both critics by default. You can change this in `draft-review/SKILL.md`.
- **Adjust the fact-checker's scope.** The fact-checker currently checks every claim. You could narrow it to only check numerical claims, or broaden it to also check framing and context.

## Uninstall

**Claude.ai:** Go to Settings > Capabilities > Skills and remove each skill, or ask Claude to remove them.

**Cowork:**
```bash
rm -rf .skills/skills/draft-review .skills/skills/fact-check .skills/skills/cowen-critique .skills/skills/yglesias-critique
```
