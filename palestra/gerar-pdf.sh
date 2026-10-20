#!/usr/bin/env bash
# Gera palestra/slides.pdf com o tema do I EECri (visual/eecri.css).
set -euo pipefail
# A ordem importa: --theme-set aceita varios arquivos e engoliria o slides.md se viesse antes dele.
cd "$(dirname "$0")"
npx -y @marp-team/marp-cli --no-stdin --allow-local-files slides.md --theme-set ../visual/eecri.css -o slides.pdf
