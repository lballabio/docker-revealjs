FROM node:4-slim
MAINTAINER Luigi Ballabio <luigi.ballabio@gmail.com>

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bzip2 libfontconfig1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV REVEAL_VERSION 3.5.0
RUN curl -SLO "https://github.com/hakimel/reveal.js/archive/${REVEAL_VERSION}.tar.gz" \
    && tar xzf ${REVEAL_VERSION}.tar.gz \
    && mv /reveal.js-${REVEAL_VERSION} /revealjs \
    && rm *.tar.gz

RUN mkdir -p /revealjs/md

RUN npm install grunt-cli -g

WORKDIR /revealjs

RUN npm install --only=prod

RUN sed -i Gruntfile.js -e 's/port: port,/port: port, hostname: "",/' \
    && grunt --force

ADD title.js /revealjs/plugin/

ADD modified-beige.css /revealjs/css/theme/

EXPOSE 8000

CMD ["npm", "start"]

ONBUILD ADD index.html /revealjs/
ONBUILD ADD slides.md /revealjs/md/
ONBUILD ADD images/ /revealjs/images/
ONBUILD ADD custom.css /revealjs/css/
