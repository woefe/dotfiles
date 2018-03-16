#!/usr/bin/env bash

# Sends a notification via notify-send with album cover, artist, title
# Usage: $0 audio.mp3 artist tiltle

set -o errexit
set -o pipefail
# set -o xtrace

function hash_file() {
    filename=$1
    # Redirect from stdin to work around sha1sum's escaping algorithm
    sha1sum < "${filename}" | cut -d" " -f1
}

song_file=$1
artist=$2
title=$3
cover_basedir="/tmp/mocp"
cover_file="${cover_basedir}/$(hash_file "${song_file}").jpg"
icon="/usr/share/icons/Arc/devices/48/audio-headphones.png"

if [ -z "${artist}" ] || [ -z "${title}" ]; then
    artist=$(basename "${song_file}")
fi

mkdir -p "${cover_basedir}"

if [ -e "${song_file}" ]; then
    ffmpeg -loglevel quiet -i "${song_file}" -an -vcodec copy "${cover_file}" || true
fi

if [ -e "${cover_file}" ]; then
    # Optionally scale down: convert "${COVER_FILE}.tmp" -thumbnail 100x100 "${COVER_FILE}"
    tmp_file="${cover_basedir}/$(hash_file "${cover_file}").jpg"
    mv "${cover_file}" "${tmp_file}"
    icon="${tmp_file}"
fi

notify-send -i "${icon}" "${artist}" "${title}"
