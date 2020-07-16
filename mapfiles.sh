#!/bin/bash

JUMPTEMP=/home/quake2test/quake2/jump_gertest.temp/
BSPTEXTURELIST=/home/quake2test/discordbot/bsptexturelist
ENTDUMP=/home/quake2test/discordbot/entdump
FILELIST=/home/quake2test/discordbot/filelist

if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.filelist') -eq 0 ]]; then
  LC_COLLATE=C comm -13 <(<$FILELIST LC_COLLATE=C sort | uniq) <(($BSPTEXTURELIST "$1" | sed 's/^/textures\//' | sed 's/$/.wal/'; ./entdump "$1" | grep '"noise" "' | sed 's/"//g' | sed 's/^\w*\ *//' | sed 's/^/sound\//'; $ENTDUMP "$1" | grep '"sky" "' | sed 's/"//g' | sed 's/^\w*\ *//' | sed 's/^/env\//' | sed 'p;p;p;p;p' | sed -e 1's/$/bk&/' -e 2's/$/dn&/' -e 3's/$/ft&/' -e 4's/$/lf&/' -e 5's/$/rt&/' -e 6's/$/up&/' | sed 's/$/.tga/') | LC_COLLATE=C sort | uniq)
fi

if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.filelist') -eq 1 ]]; then
  LC_COLLATE=C comm -13 <(<$FILELIST LC_COLLATE=C sort | uniq) <(($BSPTEXTURELIST "$1" | sed 's/^/textures\//' | sed 's/$/.wal/'; ./entdump "$1" | grep '"noise" "' | sed 's/"//g' | sed 's/^\w*\ *//' | sed 's/^/sound\//'; $ENTDUMP "$1" | grep '"sky" "' | sed 's/"//g' | sed 's/^\w*\ *//' | sed 's/^/env\//' | sed 'p;p;p;p;p' | sed -e 1's/$/bk&/' -e 2's/$/dn&/' -e 3's/$/ft&/' -e 4's/$/lf&/' -e 5's/$/rt&/' -e 6's/$/up&/' | sed 's/$/.tga/'; cat "$JUMPTEMP"*.filelist | tr -d '\r') | LC_COLLATE=C sort | uniq)
fi
