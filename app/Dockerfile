FROM debian:stretch

RUN apt-get update \
    && apt-get install -y \
        wget \
        procps \
        curl \
        git \
        python \
        build-essential \
        xvfb \
        apt-transport-https \
        unzip \
        gettext-base \
        socat \
        netcat

# Install nvm with node and npm
ENV NVM_DIR /usr/local/nvm
RUN mkdir /usr/local/nvm
ENV NODE_VERSION 10.24.1

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.39.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g yarn
# RUN npm install -g pm2
# RUN pm2 install pm2-logrotate
# RUN pm2 set pm2-logrotate:compress true

# install LL app
ENV LL_TAG=v7.1.1
RUN git clone https://github.com/LearningLocker/learninglocker.git /opt/learninglocker \
    && cd /opt/learninglocker \
    && git checkout $LL_TAG \
    # && yarn install \
    && npm_config_build_from_source=true yarn install --ignore-engines \ 
    && yarn build-all

WORKDIR /opt/learninglocker

# make a copy of the origin storage directory that will be used in entrypoint-common.sh
# to fill up a volume mounted here, if it's empty
RUN cp -r storage storage.template

# service api exposes port 8080
# service ui exposes port 3000
# see env.template
EXPOSE 3000 8080

COPY env.template .env.template
COPY entrypoint-common.sh entrypoint-common.sh
COPY entrypoint-ui.sh entrypoint-ui.sh

ENTRYPOINT ["./entrypoint-common.sh"]

