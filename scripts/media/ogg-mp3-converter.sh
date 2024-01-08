#!/bin/bash

# ========================
# By Triad for lazy-developer-tools
# Version 1.1
# ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

FOLDER=converted

function recode(){
    # Ej: ffmpeg -i video-de-navidad.mp4 -ss 00:00:00 -to 00:00:25 -c:v copy -c:a copy primer-video.mp4
    for file in *.ogg; do ffmpeg -i ${file} -acodec libmp3lame "$1/$(basename "$file" .ogg).mp3";done
}

#check if oggdec command exists
has_oggdec=$(oggdec --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'oggdec' tool is required please install using 'sudo apt-get install vorbis-tools'${NC}\n${YELLOW}Or follow next url for more info https://command-not-found.com/oggdec${NC}"
    exit
fi

#check if lame command exists
has_lame=$(lame --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'lame' tool is required please install using 'sudo apt-get install lame'${NC}\n${YELLOW}Or follow next url for more info https://command-not-found.com/lame${NC}"
    exit
fi


if [ ! -d $FOLDER ]; then
    mkdir $FOLDER
fi

recode $FOLDER