#!/usr/bin/env bash

python3 -m zotify -e --language ja 
python3 -m zotify -e --language en
find "/root/Music/Zotify Music/" -type f -name "*.m4a" -print0 | xargs -0 aacgain -r -c
