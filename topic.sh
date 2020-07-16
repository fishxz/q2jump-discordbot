#!/bin/bash

if [[ $(./rcon.sh "status" | sed '1,3d' | sed '$d' | cut -b 16-30 | sed 's/ *$//' | sed '$!s/$/, /' | tr -d '\n') ]]; then
  echo Current map: $(./rcon.sh "status" | sed -n 1p | sed 's/^Current map: //') \| Players: $(./rcon.sh "status" | sed '1,3d' | sed '$d' | cut -b 16-30 | sed 's/ *$//' | sed '$!s/$/, /' | tr -d '\n')
else
  echo Current map: $(./rcon.sh "status" | sed -n 1p | sed 's/^Current map: //') \| Players: No players.
fi
