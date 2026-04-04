---
name: minimal-clean-ui
description: 'Design and implement minimal, clean UI that avoids generic AI-slop patterns. Use when building or refactoring frontend screens, components, landing pages, or app shells; includes typography choices, color systems, layout rules, motion, and responsive quality checks.'
argument-hint: '[surface or page] [brand tone optional] [platform: web/mobile/both]'
user-invocable: true
---

# Minimal Clean UI

## What This Skill Produces
- A deliberate, minimal interface with clear hierarchy and visual intent.
- UI direction that avoids repetitive template aesthetics.
- A responsive result that works on desktop and mobile.

## When to Use
- Creating a new page or screen from scratch.
- Refactoring UI that feels generic, cluttered, or inconsistent.
- Tightening visual polish without adding unnecessary complexity.

## Inputs To Gather First
- Product goal: what this screen must help users do.
- Primary audience and tone: editorial, premium, technical, playful, etc.
- Constraints: existing design system, required brand colors, accessibility target, and deadline.
- Platform scope: web, mobile, or both.

## Workflow
1. Define one visual thesis.
Set a single sentence that governs choices, for example: "Quiet, editorial, and confident with generous spacing." Use this to reject mismatched styles quickly.

2. Build a constrained foundation.
Define tokens first:
- Typography: one expressive display face plus one readable body face.
- Color: 5 to 8 semantic tokens (`bg`, `surface`, `text`, `muted`, `accent`, `border`, optional `success`/`danger`).
- Spacing: a consistent scale (for example 4/8/12/16/24/32).
- Radius and shadow: keep subtle and limited to 1 to 2 levels.

3. Compose with minimal structure.
- Start with one strong focal area and one supporting area.
- Remove non-essential cards, dividers, badges, and icon noise.
- Keep line lengths readable and maintain clear vertical rhythm.
- Use whitespace as structure, not decoration.

4. Add personality without clutter.
- Use contrast in type scale and weight instead of many colors.
- Introduce one atmospheric background element (soft gradient, grain, or geometric shape).
- Keep motion purposeful: entry reveal, section stagger, or state transition only where it clarifies flow.

5. Handle responsive behavior intentionally.
- Desktop: preserve hierarchy, avoid oversized empty regions.
- Mobile: keep primary action visible, collapse secondary content progressively.
- Test at narrow and wide breakpoints before finalizing details.

6. Validate quality before shipping.
Run the checklist below and revise anything that feels interchangeable or over-decorated.

## Decision Points
- Existing design system present?
If yes, preserve tokens and component patterns; apply this skill through composition, hierarchy, and restraint.
If no, create a small token system first and avoid ad hoc values.

- Minimal vs expressive conflict?
If UI feels sterile, add one bold typographic or background move.
If UI feels busy, reduce color count and remove secondary effects.

- Motion needed?
If motion does not improve comprehension, remove it.
If motion is used, keep duration consistent and subtle.

## Anti-AI-Slop Guardrails
- Do not default to `Inter`, `Roboto`, `Arial`, or system stacks unless required.
- Do not use flat single-color backgrounds by default.
- Do not stack many interchangeable cards with identical spacing and shadows.
- Do not add micro-animations everywhere; keep 1 to 3 meaningful motions.
- Do not rely on purple-first palettes unless explicitly requested.

## Definition of Done
- Visual direction can be described in one clear sentence.
- Typography and spacing hierarchy are obvious in under 3 seconds.
- Color usage is restrained and semantic.
- Desktop and mobile both preserve the same content priority.
- Interface looks specific to the product, not a template clone.
- Primary action and primary message are immediately discoverable.

## Output Format For Agent Responses
When using this skill, respond with:
1. `Visual Thesis`
2. `Token Set` (fonts, colors, spacing, radius/shadow)
3. `Layout Plan` (desktop + mobile)
4. `Motion Plan` (max 3 purposeful animations)
5. `Implementation Notes` (components/CSS structure)
6. `Quality Check Results` (pass/fail against Definition of Done)

## Example Prompts
- `/minimal-clean-ui Design a booking dashboard for short-term rentals, premium and calm, web and mobile.`
- `/minimal-clean-ui Refactor this pricing page so it feels minimal and editorial, not generic SaaS.`
- `/minimal-clean-ui Create a clean onboarding screen for a mobile rental app with subtle motion.`
