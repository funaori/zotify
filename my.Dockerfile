FROM python:3.10-slim-bookworm AS base

RUN apt-get update && apt-get install -y ffmpeg git curl

FROM base AS builder

WORKDIR /install
COPY requirements.txt /requirements.txt

RUN apt-get install -y gcc libc-dev zlib1g zlib1g-dev libjpeg-dev
RUN pip install --prefix="/install" -r /requirements.txt
RUN apt-get install -y build-essential libasound2-dev pkg-config libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev \
    libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev autoconf2.64 automake1.11 libtool unzip

COPY aacgain_proj /app/aacgain_proj
RUN cd /app/aacgain_proj && \
    git clone --depth 1 https://github.com/mecke/aacgain.git
RUN cd /app/aacgain_proj && \
    tar xfj mp4v2-trunk-r355.tar.bz2 && \
    mv mp4v2-trunk-r355 mp4v2
RUN cd /app/aacgain_proj/aacgain && \
    patch -p3 -d ../mp4v2/src/  < mp4v2.patch
RUN cd /app/aacgain_proj/mp4v2 && \
    ./configure && \
    make  CXXFLAGS="-fpermissive -Wno-narrowing" libmp4v2.la
RUN cd /app/aacgain_proj && \
    tar xfj faad2-2.7.tar.bz2 && \
    mv faad2-2.7 faad2
RUN cd /app/aacgain_proj/faad2 && \
    ./configure && \
    cd libfaad && \
    make
RUN cd /app/aacgain_proj && \
    mkdir mp3gain && \
    unzip mp3gain-1_5_1-src.zip -d mp3gain/
RUN sed -i 's@patch -p0 -N <mp3gain.patch@patch -p4 -N -d ../../mp3gain/mpglibDBL/ <mp3gain.patch@' /app/aacgain_proj/aacgain/linux/prepare.sh
RUN chmod +x /app/aacgain_proj/aacgain/linux/prepare.sh && \
    cd /app/aacgain_proj/aacgain/linux && \
    ./prepare.sh && \
    mkdir build && \
    cd build && \
    ../../../configure && \
    make && \
    make install

FROM base

COPY --from=builder /install /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin/aacgain /usr/local/bin/aacgain
RUN mv /usr/local/lib/python3.10/site-packages/lib/python3.10/site-packages/* /usr/local/lib/python3.10/site-packages/

COPY zotify /app/zotify
COPY download-my-albums.sh /app/download-my-albums.sh
COPY download-following-artists.sh /app/download-following-artists.sh
RUN chmod +x /app/download-my-albums.sh
RUN chmod +x /app/download-following-artists.sh
WORKDIR /app
EXPOSE 4381
CMD ["python3", "-m", "zotify"]
