#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title SpeakEasy Dictate
# @raycast.mode silent
# @raycast.packageName SpeakEasy

# Optional parameters:
# @raycast.icon 🎤
# @raycast.description Toggle: press once to start recording, press again to transcribe and paste

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

SPEAKEASY_BIN="/Users/arhumsavera/scripts/voice/speakeasy/speakeasy"

"$SPEAKEASY_BIN" dictate >> /tmp/speakeasy-raycast.log 2>&1
