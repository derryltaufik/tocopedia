#!/usr/bin/env bash
set -euo pipefail
flutter build web --release --tree-shake-icons
