---
name: skill-creator
description: Guide for creating effective skills that extend agent capabilities with
  specialized knowledge, workflows, or tool integrations. Use when the user wants
  to create or update a skill.
license: Apache-2.0
---

# Skill Creator

Use this skill whenever you need to create or update an agent skill.

## File format

Skills live at `~/.openhands/skills/<name>/SKILL.md` and follow the [agentskills.io](https://agentskills.io) specification.

```markdown
---
name: my-skill
description: "Trigger sentence: what it does and when to activate it."
license: MIT
compatibility: "Requires Node.js 18+"   # optional
allowed-tools: "Bash Read Write"        # optional
---

Markdown body with step-by-step instructions…
```

## Writing good skills

1. **Description** – agents use this field to decide whether to activate the skill. Make it specific and trigger-oriented (e.g. "Use when the user asks to create a Docker container").
2. **Body** – step-by-step instructions, examples, edge-cases, tool invocations. This is loaded when the skill activates.
3. **Name** – lowercase slug that matches the directory name (e.g. `my-skill` → `~/.openhands/skills/my-skill/SKILL.md`).
4. **Scope** – one skill per concern. Split large skills into smaller focused ones.

## When to create a skill

- A repeated workflow that needs consistent execution
- Domain knowledge or coding conventions specific to this project
- Environment-specific tooling (e.g. a custom deploy script)

## Example workflow

1. Decide on a clear name and a one-sentence trigger description.
2. Outline the step-by-step instructions in the body.
3. Add examples and edge-cases.
4. Save, then verify with a quick test run.