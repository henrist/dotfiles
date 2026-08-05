#!/usr/bin/env bash
# Backward-compatible name — installs Claude Code and Grok @ai hooks.
exec "$(cd "$(dirname "$0")" && pwd)/install-ai-hooks.sh" "$@"
