# SpeakEasy Compatibility Matrix

This matrix tracks known-good CLI integration versions for narration hooks.

## Agent Integrations

| Integration | Status | Version(s) | Notes |
| --- | --- | --- | --- |
| Claude Code | Stable | Current local config flow | Uses `~/.claude/settings.json` Stop + Notification hooks installed by `speakeasy hook-install claude`. |
| OpenCode | Stable | 1.2.15 | Uses plugin at `~/.config/opencode/plugins/speakeasy.ts` and `file://` plugin reference in `~/.config/opencode/opencode.json`. Speaks assistant text parts only. |

## Runtime Components

| Component | Status | Notes |
| --- | --- | --- |
| whisper.cpp server | Stable | Health check expected at `http://127.0.0.1:8787/health`. |
| kokoro-onnx server | Stable | Health check expected at `http://127.0.0.1:8788/health`. |

## Validation Commands

```bash
speakeasy doctor
speakeasy logs all -n 120
```
