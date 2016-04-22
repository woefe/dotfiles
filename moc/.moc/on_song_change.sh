#!/usr/bin/sh

# Sends a notification via notify-send with album cover, artist, title
# Usage: $0 audio.mp3 artist tiltle

SONG_FILE=$1
ARTIST=$2
TITLE=$3
COVER_FILE="/tmp/moc_cover.jpg"
ICON="/usr/share/icons/HighContrast/48x48/devices/audio-headphones.png"


if [ -z "$ARTIST" -o -z "$TITLE" ]; then
    ARTIST=$(basename "$SONG_FILE")
fi

test -e "${COVER_FILE}" && rm "${COVER_FILE}"
test -e "${COVER_FILE}.tmp" && rm "${COVER_FILE}.tmp"

if [ -e "${SONG_FILE}" ]; then
    ffmpeg -loglevel quiet -i "${SONG_FILE}" -an -vcodec copy "${COVER_FILE}"
fi

if [ -e ${COVER_FILE} ]; then
    mv "${COVER_FILE}" "${COVER_FILE}.tmp"
    convert "${COVER_FILE}.tmp" -thumbnail 100x100 "${COVER_FILE}"
    ICON=${COVER_FILE}
fi

notify-send -i "${ICON}" "${ARTIST}" "${TITLE}"
