#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Voice Mute Toggle
# @raycast.mode silent
# @raycast.packageName Voice

# Optional parameters:
# @raycast.icon 🔇
# @raycast.description Toggle TTS on/off

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

VOICE_BIN="/Users/arhumsavera/scripts/voice/voice"
TTS_FILE="$HOME/.config/voice/tts-enabled"

if [ -f "$TTS_FILE" ]; then
    rm -f "$TTS_FILE"
    pkill -x afplay 2>/dev/null
    afplay /System/Library/Sounds/Basso.aiff &
else
    touch "$TTS_FILE"
    afplay /System/Library/Sounds/Ping.aiff &
fi
