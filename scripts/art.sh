#!/usr/bin/env bash

#-------------------------------#
# Generate current song cover   #
# ffmpeg version                #
#-------------------------------#

MUSIC_DIR="/mnt/ehdd2/Music"
COVER="/tmp/cover.png"
COVER_SIZE=400

BORDERS=false
BORDER_WIDTH=6
BORDER_COLOR="#54ff3f"

ffmpeg_cover() {
    if ${BORDERS}; then
        ffmpeg -loglevel 0 -y -i "${1}" -vf "scale=${COVER_SIZE}:-1,pad=${COVER_SIZE}+${BORDER_WIDTH}:ow:(ow-iw)/2:(oh-ih)/2:${BORDER_COLOR}" "${COVER}"
    else
        ffmpeg -loglevel 0 -y -i "${1}" -vf "scale=${COVER_SIZE}:-1" "${COVER}"
    fi
}

fallback_find_cover() {
    album="${file%/*}"
    album_cover="$(find "${album}" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(cover\|folder\|artwork\|front\|scans\).*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    album_cover="$(echo -n "${album_cover}" | head -n1)"
}

{
    file="${MUSIC_DIR}/$(mpc --format %file% current)"

    if [[ -n "${file}" ]] ; then
        if ffmpeg_cover "${file}"; then
            exit
        else
            fallback_find_cover
            ffmpeg_cover "${album_cover}"
        fi
    fi
} &
