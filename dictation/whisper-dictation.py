#!/usr/bin/env python3
"""
Toggle recording: first run starts, second run stops, transcribes, and types.
Bind toggle.sh to any key via GNOME Settings > Keyboard > Custom Shortcuts.
"""
import os
import signal
import subprocess
import sys
import time
import wave

import numpy as np

PIDFILE = '/tmp/whisper-dictation.pid'
WAVFILE = '/tmp/whisper-dictation.wav'
MODEL_SIZE = 'small.en'
SAMPLE_RATE = 16000


def start():
    if os.path.exists(PIDFILE):
        print("Already recording")
        return
    proc = subprocess.Popen(
        ['arecord', '-f', 'S16_LE', '-r', str(SAMPLE_RATE), '-c', '1', WAVFILE],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    with open(PIDFILE, 'w') as f:
        f.write(str(proc.pid))
    print(f"Recording... (PID {proc.pid})")


def stop():
    if not os.path.exists(PIDFILE):
        print("Not recording")
        return

    with open(PIDFILE) as f:
        pid = int(f.read().strip())
    os.unlink(PIDFILE)

    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass

    time.sleep(0.3)

    if not os.path.exists(WAVFILE):
        print("No audio captured")
        return

    print("Transcribing...")
    from faster_whisper import WhisperModel
    model = WhisperModel(MODEL_SIZE, device='cpu', compute_type='int8')
    segments, _ = model.transcribe(
        WAVFILE,
        beam_size=5,
        vad_filter=True,
        no_speech_threshold=0.6,
        condition_on_previous_text=False,
    )
    text = ' '.join(seg.text.strip() for seg in segments).strip()

    try:
        os.unlink(WAVFILE)
    except FileNotFoundError:
        pass

    if not text:
        print("No speech detected")
        return

    subprocess.run(['ydotool', 'type', '--', text], stderr=subprocess.DEVNULL)


def toggle():
    if os.path.exists(PIDFILE):
        stop()
    else:
        start()


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'toggle'
    {'start': start, 'stop': stop, 'toggle': toggle}[cmd]()
