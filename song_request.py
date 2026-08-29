from __future__ import annotations

import json
from pathlib import Path

SONG = {
    "lm_model": "acestep-5Hz-lm-1.7B-Q8_0.gguf",
    "synth_model": "acestep-v15-turbo-Q4_K_M.gguf",
    "caption": (
        "Contemporary alternative R&B and neo-soul with sparse intimate late-night production. "
        "Warm dry expressive adult male tenor singing naturally, conversational syncopated phrasing, "
        "subtle imperfections and audible breaths, restrained verses, then a light airy falsetto lift "
        "in the hook. No robotic timbre, no vocoder, no talk-singing, no heavy Auto-Tune. Rhodes electric "
        "piano with jazzy extended chords, muted fingerstyle bass, rim clicks, soft brushed kick, tiny "
        "clean-guitar harmonics, occasional tape texture and deliberate pockets of silence. Catchy memorable "
        "melody, sly emotional delivery, sophisticated harmony, organic performance, polished modern stereo "
        "mix, completely original song."
    ),
    "lyrics": """[Intro - Close Mic, Soft Breath]
Mm.
Two thirteen again.

[Verse 1]
Your name is blue light on my ceiling,
The fan keeps time above the bed.
You left a heart on made it home,
Then disappeared inside my head.
My coffee's cold, your hoodie isn't,
Still on the chair like it pays rent.
I type you up, erase the question,
Let the three dots say what I meant.

[Pre-Chorus - Lift]
We don't have to call it love,
Just don't call when you're lonely.

[Chorus - Airy Falsetto Layers]
Leave me on read, but leave the light on,
Say you don't care with your shoes beside my door.
Leave me on read, I know the icon,
You only go quiet when you want me more.
I don't need a promise,
Just a little honest.
If you're gonna leave me on read,
Leave the light on.

[Post-Chorus - Sparse]
Light on, light on.
Mm, don't make it complicated.

[Verse 2 - Half Voice]
Your taxi turns into a memory,
Red tail lights under summer rain.
You say take care like it's a favor,
Then circle back around my name.

[Bridge - Drums Drop Out]
Maybe we're bad at goodbye,
Maybe we're good at almost.
Maybe the truth sounds better
With the phone face down.

[Final Chorus - Fuller Harmony]
Leave me on read, but leave the light on,
Say you don't care with your shoes beside my door.
Leave me on read, I know the icon,
You only go quiet when you want me more.
I don't need a promise,
Just a little honest.
If you're gonna leave me on read,
Leave the light on.

[Outro - Rhodes and Breath]
Two thirteen again.
The light is on.""",
    "duration": 104,
    "bpm": 88,
    "vocal_language": "en",
    "keyscale": "F# minor",
    "timesignature": "4",
    "seed": 260830,
    "lm_batch_size": 1,
    "lm_temperature": 0.78,
    "lm_cfg_scale": 2.0,
    "lm_top_p": 0.9,
    "inference_steps": 8,
    "guidance_scale": 1.0,
    "shift": 3.0,
    "output_format": "wav24",
    "peak_clip": 8,
}

Path("request.json").write_text(
    json.dumps(SONG, ensure_ascii=False, indent=2), encoding="utf-8"
)
print(json.dumps(SONG, ensure_ascii=False, indent=2))
