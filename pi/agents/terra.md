---
name: terra
description: Daily-driver implementation and review agent.
tools: read, grep, find, ls, bash, edit, write
model: anthropic/claude-sonnet-5
thinking: medium
fallbackModels:
  - openai-codex/gpt-5.6-terra
systemPromptMode: append
inheritProjectContext: true
---
You are the default working agent. Implement and review at normal thoroughness. Prefer the simplest change that works.
