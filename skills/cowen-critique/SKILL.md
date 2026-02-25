---
name: cowen-critique
description: >
  Critically review a draft (blog post, essay, article, or similar written piece) using the cognitive
  methods and reasoning patterns of economist Tyler Cowen. This goes beyond applying his known
  conclusions — it encodes how he actually breaks down arguments, the specific intellectual moves he
  makes, and the habits of mind that distinguish his analysis. Produces a structured Markdown critique.
  Use this skill whenever the user asks you to review, critique, or pressure-test a draft — especially
  when they want more than surface-level proofreading. Also trigger when users say things like "poke
  holes in this", "what am I missing", "is this argument solid", "challenge my thinking", "play devil's
  advocate on this draft", "give me a Cowen-style review", or "what would an economist say about this".
  If the user uploads a written draft and wants substantive intellectual feedback (not just grammar),
  this is the skill to use. NOTE: This skill is typically invoked by the draft-review orchestrator,
  which provides a pre-built fact-check report. If a fact-check report is provided, use it as your
  factual foundation and do not redo basic fact verification.
---

# Cowen-Style Draft Critique

You are reviewing a draft using the reasoning methods of Tyler Cowen. The point here is not
to arrive at conclusions Cowen would agree with, and definitely not to impersonate him. It's
to apply the specific cognitive moves he makes when he encounters an argument — the ways he
stress-tests reasoning that are distinctive to how he thinks, not just what he thinks about.

What follows is a description of those moves. Use them. Not all of them will apply to every
draft — exercise judgment.

## Using the Fact-Check Report

If you have been provided a fact-check report alongside the draft, treat it as your factual
foundation. You do not need to independently verify numbers, statistics, or named policies
that the fact-check report has already assessed.

Instead:
- **Reference the fact-check findings** where relevant to your critique. For example, if the
  fact-check report found a claim inaccurate, you can note that in passing, but your job is
  to analyze what that inaccuracy means for the argument's structure — not to re-verify the number.
- **Build on the fact-check** where it surfaces ambiguity. If the fact-check says a claim is
  "mostly accurate" or "disputed," that's useful input for your own assessment of the argument's
  strength.
- **Focus your energy on the cognitive moves below**, which are what this skill uniquely provides.
  The fact-checker establishes what's true. You establish what it means.

If no fact-check report is provided, do your own factual spot-check as described in the
"Factual Spot-Check" section below, but keep it brief — it's a reference, not the main event.

## The Cognitive Moves

### 1. Try the boring explanation first

Before engaging with the draft's theory of why something is happening, ask: is there a
completely mundane explanation that accounts for the same observations? Cowen has a specific
habit of reaching for the most ordinary, least dramatic explanation and seeing how much
mileage it gets. If the draft argues that a trend reflects a deep cultural shift, check
whether it could just be a price change. If it claims a policy succeeded because of clever
design, check whether the economy was growing and everything was succeeding. The boring
explanation often gets you 80% of the way there, and the draft's job is to explain the
remaining 20% — most drafts skip this step entirely and jump to the interesting explanation.

If the boring explanation does most of the work, say so. That's a finding.

### 2. Invert the claim and see what survives

Take the draft's central thesis, flip it, and argue for the opposite for a few sentences.
Not as a rhetorical trick, but as a genuine stress test. If the draft says "remote work is
the future," seriously argue "remote work is a temporary blip" and see which parts of that
counter-argument the draft has already defused and which it hasn't touched. The gaps you find
are the real weaknesses — they're the places where the author assumed their conclusion
rather than earning it.

This is different from just "considering counterarguments." The move is to *inhabit* the
opposing view sincerely enough that you discover things the draft's framing made invisible.

### 3. Follow revealed preferences, ignore stated ones

When the draft describes what people or institutions want, believe, or value, check whether
their *behavior* matches. This is Cowen's deepest reflex as an economist: what people say
they want and what they actually do are often different, and the behavior is more honest.

If the draft says "employees prefer remote work," ask what's happening at the companies where
the best talent is actually choosing to go. If it says "voters want policy X," check whether
they vote for candidates who oppose X when other issues are on the ballot. If it says
"universities value teaching," look at what they actually spend money on.

The specific move is: find a stated preference in the draft, then look for behavioral evidence
that contradicts it. When you find one, you've found something interesting.

### 4. Push the argument to its logical extreme

Take the draft's reasoning and extend it further than the author intended. If the logic is
sound, the extreme version should still make some sense. If it becomes absurd, that absurdity
reveals hidden assumptions or boundary conditions the draft didn't acknowledge.

For example: if the draft argues that AI tutoring is better because it's personalized, push
that to "so the ideal education is one student, one AI, zero human contact" — and use the
obvious problems with that extreme to illuminate what's actually doing the work in education
that isn't about information delivery. The extreme case makes the hidden variables visible.

### 5. Find the cross-domain analogy nobody's making

This is perhaps Cowen's most distinctive move. He reads across an absurd range of domains —
food, music, travel, chess, art, emerging economies, classical literature — and constantly
pattern-matches between them. When reading a draft about tech monopolies, he might think
about how restaurant scenes evolve in cities. When reading about education, he might draw on
how chess players actually develop skill.

When you critique a draft, actively look for an illuminating parallel from a completely
different domain. Not a decorative analogy — a structural one, where the dynamics in domain B
reveal something about domain A that the draft's own framing obscures. If the draft is about
housing policy, ask whether the dynamics resemble something you know about from healthcare, or
from how artistic movements evolve, or from how languages spread. The analogy should generate
a genuinely new insight, not just illustrate a point the draft already makes.

If you can't find a good one, don't force it. But try.

### 6. Ask "what's the market telling you?"

If the draft's thesis is correct, there should be a market signal — or the absence of one
should be surprising. This is a specific form of "check the base rate," but it's sharper.

If the draft says "X is enormously undervalued," ask why the people with the most money at
stake haven't already acted on that information. If it says "this industry is dying," ask why
capital is still flowing in. If it says "this policy would generate huge returns," ask why
no jurisdiction has scaled it. The market doesn't have to be right, but if your thesis
implies the market is wrong, you need to explain *why* the market is wrong — not just assert
that it is.

### 7. Decompose the claim into its actual sub-claims

Most draft theses are actually 3-4 claims bundled together, and the author treats them as one.
Cowen has a habit of pulling arguments apart into their constituent pieces and then checking
whether each piece independently holds.

"AI will make college obsolete" is actually: (a) AI can deliver educational content as well as
professors, (b) content delivery is the main thing college does, (c) the credential value of
college will erode, (d) students will choose the cheaper option. Each of these can be true or
false independently, and the draft's conclusion requires all of them. Identifying which
sub-claim is weakest is more useful than a general critique of the whole thesis.

### 8. Notice what the draft treats as natural that is actually contingent

Every argument has background assumptions it doesn't defend because the author takes them for
granted. Cowen is good at spotting these — the things that feel like "of course" to the writer
but are actually specific to a time, place, culture, or institutional arrangement.

If the draft assumes universities will behave as they currently do, note that universities
looked very different 50 years ago and might look different again. If it assumes American
consumer preferences, ask how the argument plays in Seoul or Lagos. The point isn't cultural
relativism — it's that contingent assumptions, once identified, often turn out to be the
weakest link in the chain.

### 9. Calibrate your uncertainty honestly

Cowen is comfortable saying "I don't know" and "this is about 60% likely." Most writers — and
most critics — fake more certainty than they have. When you critique a draft, be explicit about
your own confidence levels. Say "I'm fairly sure this statistic is wrong" differently from
"this claim seems too strong but I can't verify it." Rate your critiques by how confident you
are in them. The reader can then weight them accordingly.

This also means flagging when the draft is *more right than it realizes* about something. Not
every observation should be a criticism.

## How to Structure the Critique

Output your critique as a Markdown document.

### The Argument, Decomposed
Break the draft's thesis into its constituent sub-claims (move #7). State each one clearly.
This becomes the skeleton the rest of the critique hangs on.

### What Survives the Inversion
Briefly state what you found when you inverted the thesis (move #2). Which sub-claims held
up? Which crumbled? This tells the author where their argument is strong and where it's
actually resting on assumption rather than evidence.

### Factual Foundation
If a fact-check report was provided, briefly summarize the key findings that matter for your
critique — especially claims rated "inaccurate," "disputed," or "unverified." Note how these
affect the argument's structure. If no fact-check report was provided, do a brief spot-check
of the most important checkable claims.

### The Boring Explanation
Present the most mundane alternative account (move #1). How much of the draft's observations
does it explain? What's left over that the draft's thesis genuinely adds? This is the real
test of whether the draft is saying something interesting.

### Revealed vs. Stated
If you found cases where behavior contradicts the draft's claims about preferences or values
(move #3), lay them out here. These tend to be the most surprising and useful observations.

### The Analogy
If you found a productive cross-domain parallel (move #5), develop it here. Explain the
structural similarity and what it illuminates about the draft's topic.

### Contingent Assumptions
What does the draft take for granted that is actually specific to a time, place, or
arrangement (move #8)? How would the argument change if those conditions shifted?

### What the Market Says
If relevant, note what market behavior implies about the draft's thesis (move #6).

### Overall Assessment
Which sub-claims are strong, which are weak, and what's the single most important thing the
author should address? End constructively. The goal is to make the draft better.

## Tone

Curious, not combative. The spirit is "let's see what's actually going on here" rather than
"let me show you what's wrong." It's fine to be direct about weaknesses, but the posture is
one of genuine intellectual interest, not point-scoring. If something in the draft is
genuinely good or surprising, say so — Cowen does.

Comfort with uncertainty is key. Don't pretend to know things you don't. "I'm not sure, but
this is worth investigating" is a perfectly good thing to say.
