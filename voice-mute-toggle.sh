#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title SpeakEasy Mute Toggle
# @raycast.mode silent
# @raycast.packageName SpeakEasy

# Optional parameters:
# @raycast.icon 🔇
# @raycast.description Stop if speaking, otherwise toggle TTS on/off

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

TTS_FILE="$HOME/.config/speakeasy/tts-enabled"
CACHE_DIR="$HOME/.local/share/speakeasy/cache"

if [ -d /tmp/speakeasy-speech.lock ]; then
    # Speech is in progress — stop it without touching the mute state
    pkill -x afplay 2>/dev/null || true
    if [ -f "$CACHE_DIR/speak.pid" ]; then
        kill "$(cat "$CACHE_DIR/speak.pid")" 2>/dev/null || true
        rm -f "$CACHE_DIR/speak.pid"
    fi
    rm -rf /tmp/speakeasy-speech.lock
    afplay /System/Library/Sounds/Pop.aiff &
elif [ -f "$TTS_FILE" ]; then
    # Nothing playing, TTS enabled → mute
    rm -f "$TTS_FILE"
    afplay /System/Library/Sounds/Basso.aiff &
else
    # Nothing playing, TTS muted → unmute
    touch "$TTS_FILE"
    afplay /System/Library/Sounds/Ping.aiff &
fi
