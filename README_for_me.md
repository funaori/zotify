## Docker Usage

### Build the docker image from the Dockerfile

`docker build -t googolplexed0-zotify .`
`docker build -f my.Dockerfile -t googolplexed0-zotify .`

### Run a container from the image

` docker run --rm -p 4381:4381 --mount type=bind,source="$(pwd)"/dot.config/zotify/config.json,target=/root/.config/zotify/config.json --mount type=bind,source="$(pwd)"/dot.config/zotify/credentials.json,target=/root/.local/share/zotify/credentials.json --mount type=bind,source=/mnt/disk2/zotify,target="/root/Music/Zotify Music" -it googolplexed0-zotify`

#### 保存したアルバムをダウンロードする

` docker run --rm -p 4381:4381 --mount type=bind,source="$(pwd)"/dot.config/zotify/config.json,target=/root/.config/zotify/config.json --mount type=bind,source="$(pwd)"/dot.local,target=/root/.local/share/zotify --mount type=bind,source=/mnt/disk2/zotify,target="/root/Music/Zotify Music" -it googolplexed0-zotify ./download-my-albums.sh `

#### フォロー中のアーティストのアルバムをダウンロードする

` docker run --rm -p 4381:4381 --mount type=bind,source="$(pwd)"/dot.config/zotify/config.json,target=/root/.config/zotify/config.json --mount type=bind,source="$(pwd)"/dot.local,target=/root/.local/share/zotify --mount type=bind,source=/mnt/disk2/zotify,target="/root/Music/Zotify Music" -it googolplexed0-zotify ./download-following-artists.sh `


----

`docker run --rm -p 4381:4381 -v "$PWD/Zotify Music:/root/Music/Zotify Music" -v "$PWD/Zotify Podcasts:/root/Music/Zotify Podcasts" -it zotify`




