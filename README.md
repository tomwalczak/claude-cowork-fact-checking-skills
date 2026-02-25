# Draft Review Skills

A set of skills for [Claude Cowork](https://claude.ai) that run a multi-stage review of written drafts: journalistic fact-checking, then two independent critic perspectives (Tyler Cowen's reasoning methods and Matt Yglesias's policy analysis methods), then a unified synthesis with an actionable revision checklist.

## What's included

| Skill | What it does |
|---|---|
| **draft-review** | Orchestrator. Coordinates the pipeline and produces the final synthesis. This is the one you invoke. |
| **fact-check** | Verifies every checkable claim in the draft using web search. Produces verdicts (accurate, mostly accurate, disputed, inaccurate, unverified) with sources. |
| **cowen-critique** | Stress-tests the argument using Tyler Cowen's cognitive moves: boring explanations, revealed preferences, cross-domain analogies, market signals, claim decomposition. |
| **yglesias-critique** | Tests policy feasibility using Matt Yglesias's cognitive moves: goal vs. mechanism, cost disease, scale testing, political survival, implementation org charts. |

## Install

Clone the repo, then run the install script from your workspace directory (the folder you've selected in Cowork):

```bash
cd /path/to/your/workspace
git clone https://github.com/YOURUSER/draft-review-skills.git /tmp/draft-review-skills
/tmp/draft-review-skills/install.sh
rm -rf /tmp/draft-review-skills
```

Or as a one-liner:

```bash
git clone https://github.com/YOURUSER/draft-review-skills.git /tmp/draft-review-skills && /tmp/draft-review-skills/install.sh && rm -rf /tmp/draft-review-skills
```

This copies the four skill directories into `.skills/skills/` in your workspace, which is where Cowork discovers them.

## Usage

Open Cowork, select your workspace folder, and say:

> Review my draft.

Then paste or upload your draft. The orchestrator will:

1. Run a fact-check (verifying every checkable claim with web search)
2. Run both critic perspectives in parallel (each receives the fact-check report so they don't duplicate work)
3. Synthesize everything into a single response with factual issues, structural critique, strengths, and a prioritized revision checklist

The full individual reports (fact-check, each critique) are saved as Markdown files in your workspace so you can read them for depth.

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

```bash
rm -rf .skills/skills/draft-review .skills/skills/fact-check .skills/skills/cowen-critique .skills/skills/yglesias-critique
```
