#!/bin/bash

JUMPTEMP=/home/quake2test/quake2/jump_gertest.temp/
MAPFILES=/home/quake2test/discordbot/mapfiles.sh
MAPLIST=/home/quake2test/quake2/jump_gertest/28910/maplist.ini
RCON=/home/quake2test/discordbot/rcon.sh
ZIPFILES=/home/quake2test/discordbot/zipfiles.sh

for file in "$JUMPTEMP"*.{bsp,filelist,zip}; do
  if [ -e "$file" ]; then
    rm "$JUMPTEMP"*.{bsp,filelist,zip}
  fi
done

if [[ -n $(curl -sIL "$1" | grep -i '^content-length') ]] && [[ $(curl -sIL "$1" | grep -i '^content-length' | grep -o '[0-9]*' | uniq) -lt 52428800 ]] && [[ "$1" =~ \.zip$ ]]; then
  wget -P $JUMPTEMP "$1" >/dev/null
  if [[ $(file "$JUMPTEMP"*.zip) = *"Zip archive data"* ]]; then
    if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.bsp') -eq 1 ]]; then
      printf "@ $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp')\n@=$(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/maps\//&final_/')\n" | zipnote -w "$JUMPTEMP"*.zip
      unzip -j -L "$JUMPTEMP"*.zip maps/*.bsp -d $JUMPTEMP >/dev/null
      if [[ $(file "$JUMPTEMP"*.bsp) = *"Quake II Map file (BSP)" ]]; then
        if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.filelist') -le 1 ]]; then
          if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.filelist') -eq 1 ]]; then
            printf "@ $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.filelist')\n@=$(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.filelist' | sed 's/maps\//&final_/')\n" | zipnote -w "$JUMPTEMP"*.zip
            unzip -j -L "$JUMPTEMP"*.zip maps/*.filelist -d $JUMPTEMP >/dev/null
          fi
          if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/') = $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.filelist' | sed 's/maps\/\(.*\).filelist/\1/') ]] || [[ -z $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.filelist') ]]; then
            if [[ -z $(comm -13 <($ZIPFILES "$JUMPTEMP"*.zip | sort) <($MAPFILES "$JUMPTEMP"*.bsp | sort)) ]] && [[ -z $(grep "$(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/')" $MAPLIST) ]] && [[ -z $($MAPFILES "$JUMPTEMP"*.bsp | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]') ]] && [[ -z $($ZIPFILES "$JUMPTEMP"*.zip | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]') ]]; then
              zip -d "$JUMPTEMP"*.zip $(comm -23 <($ZIPFILES "$JUMPTEMP"*.zip | sort) <($MAPFILES "$JUMPTEMP"*.bsp | sort) | xargs) >/dev/null
              unzip -o "$JUMPTEMP"*.zip -d $JUMPTEMP >/dev/null
              $RCON "sv addsinglemap $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/')" >/dev/null
              echo "● $(basename "$JUMPTEMP"*.zip): $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/') added to testserver"
            else
              if [[ -n $(grep "$(unzip -Z1 "$JUMPTEMP"*.zip | grep 'maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/')" $MAPLIST) ]]; then
                echo "● $(basename "$JUMPTEMP"*.zip): there is already a map called $(unzip -Z1 "$JUMPTEMP"*.zip | grep 'maps/.*.bsp' | sed 's/maps\/\(.*\).bsp/\1/') on the testserver"
              fi
              if [[ -n $(unzip -Z1 "$JUMPTEMP"*.zip | grep -v 'env\|maps\|sound\|textures') ]]; then
                echo -e "● $(basename "$JUMPTEMP"*.zip): wrong zip structure. the zip must look like this:\n  $(basename "$JUMPTEMP"*.zip)\n  ├── env/\n  ├── maps/\n  ├── sound/\n  └── textures/\n  (no other foldernames are allowed)"
              fi
              if [[ -n $($MAPFILES "$JUMPTEMP"*.bsp | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]') ]]; then
                echo -e "● $(basename "$JUMPTEMP"*.bsp): uppercase file(s):\n$($MAPFILES "$JUMPTEMP"*.bsp | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]' | sort | sed 's/^/  /')"
              fi
              if [[ -n $($ZIPFILES "$JUMPTEMP"*.zip | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]') ]]; then
                echo -e "● $(basename "$JUMPTEMP"*.zip): uppercase file(s):\n$($ZIPFILES "$JUMPTEMP"*.zip | grep '[a-z].*[A-Z]\|[A-Z].*[a-z]' | sort | sed 's/^/  /')"
              fi
              if [[ -n $(comm -13 <($ZIPFILES "$JUMPTEMP"*.zip | sort) <($MAPFILES "$JUMPTEMP"*.bsp | sort)) ]]; then
                echo -e "● $(basename "$JUMPTEMP"*.zip): missing file(s):\n$(comm -13 <($ZIPFILES "$JUMPTEMP"*.zip | sort) <($MAPFILES "$JUMPTEMP"*.bsp | sort) | sed 's/^/  /')"
              fi
            fi
          else
            echo -e "● $(basename "$JUMPTEMP"*.zip): filelist doesn't match mapname:\n$(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.filelist' | sed 's/^/  /'; unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/^/  /')"
          fi
        else
          if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.filelist') -gt 1 ]]; then
            echo "● $(basename "$JUMPTEMP"*.zip): multiple filelists found"
          fi
        fi
      else
        if [[ ! $(file "$JUMPTEMP"*.bsp) = *"Quake II Map file (BSP)" ]]; then
          echo "● $(unzip -Z1 "$JUMPTEMP"*.zip | grep '^maps/.*.bsp' | sed 's/.*\///'): is not a quake 2 map file"
        fi
      fi
    else
      if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.bsp') -lt 1 ]]; then
        echo "● $(basename "$JUMPTEMP"*.zip): no bsp file found"
      fi
      if [[ $(unzip -Z1 "$JUMPTEMP"*.zip | grep -c '^maps/.*.bsp') -gt 1 ]]; then
        echo "● $(basename "$JUMPTEMP"*.zip): multiple bsp files found"
      fi
    fi
  else
    echo "● $(basename "$JUMPTEMP"*.zip): not a zip file"
  fi
else
  if [[ -z $(curl -sIL "$1" | grep -i '^content-length') ]]; then
    echo "● unsupported hoster"
  fi
  if [[ ! "$1" =~ \.zip$ ]]; then
    echo "● $(echo "$1" | sed 's/.*\///'): not a zip file"
  fi
  if [[ ! $(curl -sIL "$1" | grep -i '^content-length' | grep -o '[0-9]*' | uniq) -lt 52428800 ]]; then
    echo "● $(echo "$1" | sed 's/.*\///'): filesize is greater than 50mb"
  fi
fi
