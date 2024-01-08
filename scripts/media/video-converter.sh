#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

convert_to_whatsapp(){
    ffmpeg -i "$1" -vf "scale=iw/${2}:ih/${2}" -vcodec libx265 -acodec aac -crf 20 $(basename "$1" .mp4)-wp.mp4
}

#check if ffmpeg command exists
has_ffmpeg=$(ffmpeg --help)
if [ $? -ne 0 ]; then
    echo -e "${LIGHT_RED}'ffmpeg' tool is required please install using 'sudo apt install ffmpeg'${NC}\n${YELLOW}Or follow next url for more info https://command-not-found.com/ffmpeg${NC}"
    exit
fi

FILE=""

if [ $# -eq 0 ]; then
  echo "You must to provide the environment as first parameter for a file to convert"
  exit 1
else
  FILE="$1"
fi
convert_to_whatsapp $1 4