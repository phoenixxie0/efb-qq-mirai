FROM python:3.8.13-alpine3.16
MAINTAINER Phoenix <hkxseven007@gmail.com>

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'

RUN set -ex \
        && apk add --no-cache --virtual .build-deps sed build-base libffi-dev openssl-dev git \
        && apk add --no-cache tzdata ca-certificates ffmpeg libmagic openjpeg zlib-dev libwebp openjdk11-jre \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

RUN set -ex \
        #&& pip3 install --upgrade setuptools \
        && pip3 install git+https://github.com/ehForwarderBot/ehForwarderBot \
        && pip3 install git+https://github.com/ehForwarderBot/efb-telegram-master \
        && pip3 install git+https://github.com/milkice233/efb-qq-slave \
        && pip3 install git+https://github.com/milkice233/efb-qq-plugin-mirai \
        && pip3 install git+https://github.com/xzsk2/efb-filter-middleware \
        && pip3 install python-telegram-bot[socks] \
        && apk del .build-deps \
        && rm -rf ~/.cache \
        && wget https://raw.githubusercontent.com/phoenixxie0/efb-qq-mirai/main/start.sh -O /start.sh \
        && chmod +x /start.sh 
        
CMD ["/start.sh"]
