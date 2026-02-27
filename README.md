# Local Voice

A universal, fully local voice interface for CLI agents and terminal workflows. STT via `whisper.cpp`, TTS via `kokoro-onnx`.

This tool provides "warm" background servers for near-instant transcription and speech generation, with a pipelined architecture that starts speaking as soon as the first sentence is ready.

## Features

- **Local STT**: GPU-accelerated Whisper transcription via `whisper-server`.
- **Local TTS**: Neural voice generation via `kokoro-onnx` HTTP server.
- **Push-to-Talk**: Global hotkey (Raycast) for dictation into any app.
- **Plugin System**: Built-in support for Claude Code hooks, easily extensible to other tools.
- **Warm Servers**: Models stay in memory to avoid cold-start latency.
- **Project Context**: Automatically assigns unique voices to different projects/folders.
- **Zero Privacy Leak**: No API keys, no cloud calls, 100% offline.

## Requirements

- macOS (Apple Silicon recommended)
- [Homebrew](https://brew.sh)
- [uv](https://docs.astral.sh/uv/)
- [Raycast](https://raycast.com) (for hotkeys)

## Quick Start

1. **Clone and Link**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/local-voice.git
   cd local-voice
   chmod +x voice voice-dictate.sh voice-mute-toggle.sh
   ln -sf "$(pwd)/voice" ~/.local/bin/voice
   ```

2. **Run Setup**:
   ```bash
   voice setup
   ```

3. **Start Servers**:
   ```bash
   voice server start
   ```

4. **Integration (Claude Code)**:
   ```bash
   voice hook-install
   ```

## Integrations

### Claude Code
Run `voice hook-install` to automatically inject STT and TTS hooks into your `~/.claude/settings.json`.

### Other Tools
To integrate with any other tool, pipe its output to `voice speak`:
```bash
my-agent-tool | voice speak
```
Or use the event-based hooks if the tool supports them.

## Raycast Hotkeys

1. Add this directory to Raycast Script Commands.
2. Assign `Cmd+Opt+L` to **Voice Dictate**.
3. Assign `Cmd+Opt+M` to **Voice Mute Toggle**.

## Architecture

- **Whisper (STT)**: 127.0.0.1:8787
- **Kokoro (TTS)**: 127.0.0.1:8788
- **Audio**: Uses `sox` (rec) and `afplay`.
- **Streaming**: Splitting text into chunks allows for ~1.5s TTS latency on the first sentence.

## Credits

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp)
- [kokoro-onnx](https://github.com/thewh1teagle/kokoro-onnx)
- [sox](https://sox.sourceforge.net/)
