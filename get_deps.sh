#!/bin/bash

GLEAM_VER="${GLEAM_VERSION:-1.0.0}"
GLEAM_FILE="gleam-v${GLEAM_VER}-x86_64-unknown-linux-musl.tar.gz"
GLEAM_URL="https://github.com/gleam-lang/gleam/releases/download/v${GLEAM_VER}/${GLEAM_FILE}"

# Download and extract gleam
wget -q ${GLEAM_URL}
tar -xzf ${GLEAM_FILE}
rm ${GLEAM_FILE}

# If you want to update dependencies, uncomment the following line:
# ./gleam update

# Build the project
./gleam build
