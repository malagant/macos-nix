#!/usr/bin/env sh
set -e

CONFIG_DIR=$HOME/.config/nix
darwin-rebuild switch --flake "$CONFIG_DIR#T000dce235" --impure
