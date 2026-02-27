#!/usr/bin/env python3
"""Warm kokoro TTS server. Loads model once, serves via HTTP."""

import io
import json
import sys
import struct
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler

import kokoro_onnx
import numpy as np
import soundfile as sf

MODEL = None
VOICES = None
VOICE_NAME = "af_heart"
SPEED = 1.1
LANG = "en-us"


def load_model(model_path, voices_path):
    global MODEL, VOICES
    print(f"Loading model from {model_path}...")
    MODEL = kokoro_onnx.Kokoro(model_path, voices_path)
    print("Model loaded and warm.")


class TTSHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass  # silence request logs

    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(b"ok")
            return
        self.send_response(404)
        self.end_headers()

    def do_POST(self):
        if self.path != "/speak":
            self.send_response(404)
            self.end_headers()
            return

        content_length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_length)

        try:
            data = json.loads(body)
            text = data.get("text", "")
            voice = data.get("voice", VOICE_NAME)
            speed = float(data.get("speed", SPEED))
            lang = data.get("lang", LANG)
        except (json.JSONDecodeError, ValueError):
            text = body.decode("utf-8", errors="replace")
            voice = VOICE_NAME
            speed = SPEED
            lang = LANG

        if not text.strip():
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"no text")
            return

        # Truncate
        if len(text) > 2000:
            text = text[:2000] + "..."

        try:
            samples, sample_rate = MODEL.create(
                text, voice=voice, speed=speed, lang=lang
            )

            # Encode as WAV in memory
            buf = io.BytesIO()
            sf.write(buf, samples, sample_rate, format="WAV")
            wav_bytes = buf.getvalue()

            self.send_response(200)
            self.send_header("Content-Type", "audio/wav")
            self.send_header("Content-Length", str(len(wav_bytes)))
            self.end_headers()
            self.wfile.write(wav_bytes)

        except Exception as e:
            self.send_response(500)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(str(e).encode())


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Kokoro TTS Server")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8788)
    parser.add_argument("--model", required=True)
    parser.add_argument("--voices", required=True)
    args = parser.parse_args()

    load_model(args.model, args.voices)

    server = HTTPServer((args.host, args.port), TTSHandler)
    print(f"TTS server listening on {args.host}:{args.port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down.")
        server.server_close()


if __name__ == "__main__":
    main()
