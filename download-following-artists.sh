#!/usr/bin/env bash

rm /root/.local/share/zotify/.song_archive

ln  /root/.local/share/zotify/dot.song_archive_ja /root/.local/share/zotify/.song_archive
python3 -m zotify -a --language ja -ip True

#rm /root/.local/share/zotify/.song_archive

#ln /root/.local/share/zotify/dot.song_archive_en /root/.local/share/zotify/.song_archive
#python3 -m zotify -a --language en -ip True

#find "/root/Music/Zotify Music/" -type f -name "*.m4a" -exec aacgain -r -c {} \;
