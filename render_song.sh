#!/usr/bin/env bash
set -euxo pipefail

export HF_HOME="${RUNNER_TEMP:-/tmp}/huggingface"
export HF_HUB_DISABLE_TELEMETRY=1
export HF_XET_HIGH_PERFORMANCE=1
export OMP_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2
export MKL_NUM_THREADS=2

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential cmake ninja-build git git-lfs \
  libopenblas-dev libcurl4-openssl-dev libssl-dev pkg-config \
  ffmpeg jq python3-pip

git clone --depth 1 --recurse-submodules --shallow-submodules \
  https://github.com/ServeurpersoCom/acestep.cpp.git acestep-cpp

cmake -S acestep-cpp -B acestep-cpp/build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_BLAS=ON \
  -DGGML_BLAS_VENDOR=OpenBLAS
cmake --build acestep-cpp/build -j 2

ACE_LM=$(find acestep-cpp/build -type f -name ace-lm -perm -111 | head -n 1)
ACE_SYNTH=$(find acestep-cpp/build -type f -name ace-synth -perm -111 | head -n 1)
test -x "$ACE_LM"
test -x "$ACE_SYNTH"

python3 -m pip install --user --upgrade huggingface_hub hf_xet
export PATH="$HOME/.local/bin:$PATH"
mkdir -p models
hf download Serveurperso/ACE-Step-1.5-GGUF \
  acestep-5Hz-lm-1.7B-Q8_0.gguf \
  Qwen3-Embedding-0.6B-Q8_0.gguf \
  acestep-v15-turbo-Q4_K_M.gguf \
  vae-BF16.gguf \
  --local-dir models
ls -lh models

python3 song_request.py
/usr/bin/time -v "$ACE_LM" --models models --request "$GITHUB_WORKSPACE/request.json"
test -s request0.json

# Free disk space before the synthesis stage; the LM process has already exited.
rm -f models/acestep-5Hz-lm-1.7B-Q8_0.gguf
/usr/bin/time -v "$ACE_SYNTH" --models models --request "$GITHUB_WORKSPACE/request0.json"

RAW=$(find "$GITHUB_WORKSPACE" -maxdepth 2 -type f \
  \( -name 'request00.wav' -o -name 'request00.mp3' -o -name 'request0*.wav' -o -name 'request0*.mp3' \) \
  | head -n 1)
test -n "$RAW"
test -s "$RAW"

mkdir -p release
cp "$RAW" "release/READ_RECEIPTS_raw.${RAW##*.}"

ffmpeg -y -i "$RAW" \
  -af "highpass=f=24,acompressor=threshold=-18dB:ratio=1.45:attack=24:release=220:makeup=1.2,loudnorm=I=-14:TP=-1.0:LRA=9" \
  -ar 48000 -c:a pcm_s24le release/READ_RECEIPTS_master_24bit.wav

ffmpeg -y -i release/READ_RECEIPTS_master_24bit.wav \
  -c:a libmp3lame -b:a 320k release/READ_RECEIPTS_master_320kbps.mp3

ffmpeg -y -ss 27 -t 34 -i release/READ_RECEIPTS_master_24bit.wav \
  -c:a libmp3lame -b:a 320k release/READ_RECEIPTS_hook_preview.mp3

cp request.json release/READ_RECEIPTS_prompt_and_lyrics.json
cp request0.json release/READ_RECEIPTS_generation_data.json
ffprobe -v error -show_format -show_streams \
  release/READ_RECEIPTS_master_24bit.wav > release/audio_report.txt
sha256sum release/* > release/SHA256SUMS.txt
ls -lh release
