#!/bin/bash
set -euo pipefail

# Build a macOS .app bundle from the SPM executable
# Usage: ./scripts/bundle.sh [release|debug]

CONFIG="${1:-release}"
APP_NAME="GlazeWM Indicator"
EXECUTABLE="GlazeWMIndicator"
BUNDLE_DIR=".build/${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building ${CONFIG}..."
swift build -c "${CONFIG}"

echo "Creating app bundle..."
rm -rf "${BUNDLE_DIR}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}"

cp ".build/${CONFIG}/${EXECUTABLE}" "${MACOS_DIR}/${EXECUTABLE}"
cp "GlazeWMIndicator/Info.plist" "${CONTENTS_DIR}/Info.plist"

# Update version from tag if available
if [ -n "${VERSION:-}" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${VERSION}" "${CONTENTS_DIR}/Info.plist"
fi

echo "Bundle created at: ${BUNDLE_DIR}"
