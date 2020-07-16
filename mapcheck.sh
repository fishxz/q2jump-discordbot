#!/bin/bash

JUMPTEMP=/home/quake2test/quake2/jump_gertest.temp/
MAPFILES=/home/quake2test/discordbot/mapfiles.sh

for file in "$JUMPTEMP"*.{bsp,filelist,zip}; do
  if [ -e "$file" ]; then
    rm "$JUMPTEMP"*.{bsp,filelist,zip}
  fi
done

if [[ -n $(curl -sIL "$1" | grep -i '^content-length') ]] && [[ $(curl -sIL "$1" | grep -i '^content-length' | grep -o '[0-9]*' | uniq) -lt 52428800 ]] && [[ "$1" =~ \.bsp$ ]]; then
  wget -P $JUMPTEMP "$1" >/dev/null
  if [[ -n $($MAPFILES "$JUMPTEMP"*.bsp) ]]; then
    echo -e "● $(basename "$JUMPTEMP"*.bsp): required file(s):\n$($MAPFILES "$JUMPTEMP"*.bsp | sort | sed 's/^/  /')"
  else
    echo ● $(basename "$JUMPTEMP"*.bsp): no additional file(s) required
  fi
else
  if [[ -z $(curl -sIL "$1" | grep -i '^content-length') ]]; then
    echo "● unsupported hoster"
  fi
  if [[ ! "$1" =~ \.bsp$ ]]; then
    echo "● $(echo "$1" | sed 's/.*\///'): not a bsp file"
  fi
  if [[ ! $(curl -sIL "$1" | grep -i '^content-length' | grep -o '[0-9]*' | uniq) -lt 52428800 ]]; then
    echo "● $(echo "$1" | sed 's/.*\///'): filesize is greater than 50mb"
  fi
fi
