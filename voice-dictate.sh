#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Voice Dictate
# @raycast.mode silent
# @raycast.packageName Voice

# Optional parameters:
# @raycast.icon 🎤
# @raycast.description Toggle: press once to start recording, press again to transcribe and paste

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

VOICE_BIN="/Users/arhumsavera/scripts/voice/voice"

echo "$(date): dictate called" >> /tmp/voice-raycast.log
"$VOICE_BIN" dictate 2>&1
