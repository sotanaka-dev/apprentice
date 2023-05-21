FROM mysql:8.0-debian

RUN apt-get update \
    && apt-get install -y \
        locales-all \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/datacharmer/test_db.git

ENV TZ=Asia/Tokyo
ENV LANG ja_JP.UTF-8
