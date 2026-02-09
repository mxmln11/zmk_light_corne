#!/bin/bash

# Exit on error
set -e

# 1. SDK Paths
export ZEPHYR_SDK_INSTALL_DIR="/Users/max/Programming/zephyr-sdk-0.17.4"
export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"
CONFIG_PATH="$(pwd)/config"

# 2. Clean up
mkdir -p artifacts
rm -f artifacts/*.uf2
rm -rf build/

# --- Build Left Side ---
echo "🚀 Building Left Side: blk_n_white_corne_left..."
KCONFIG_WERROR=0 west build -s zmk/app -d build/left -b nice_nano_v2 -- \
  -DZMK_CONFIG="$CONFIG_PATH" \
  -DCONFIG_ZMK_KEYBOARD_NAME=\"Blk_n_White\" \
  -DCONFIG_PICOLIBC=y \
  -DCONFIG_PICOLIBC_IO_FLOAT=y \
  -DCONFIG_PICOLIBC_USE_MODULE=y \
  -DSHIELD="corne_left nice_view_adapter nice_view_gem"

# --- Build Right Side ---
echo "🚀 Building Right: blk_n_white_corne_right..."
KCONFIG_WARN_AS_ERROR=n KCONFIG_WERROR=0 west build -s zmk/app -d build/right -b nice_nano_v2 -- \
  -DZMK_CONFIG="$CONFIG_PATH" \
  -DCONFIG_ZMK_KEYBOARD_NAME=\"Blk_n_White\" \
  -DCONFIG_PICOLIBC=y \
  -DCONFIG_PICOLIBC_IO_FLOAT=y \
  -DCONFIG_PICOLIBC_USE_MODULE=y \
  -DSHIELD="corne_right"
  # -DZEPHYR_SHIELD_MODULES="$(pwd)/zmk/app/boards/shields/corne" \
  #-DZMK_EXTRA_MODULES="$(pwd)/zmk-driver-azoteq-iqs5xx" \
  #-DBOARD_ROOT="$(pwd)/zmk/app"

# --- Organize Artifacts ---
cp build/left/zephyr/zmk.uf2 artifacts/blk_n_white_corne_left.uf2
cp build/right/zephyr/zmk.uf2 artifacts/blk_n_white_corne_right.uf2

echo "----------------------------------------"
echo "Build complete! Files are in the /artifacts folder:"
ls -1 artifacts/