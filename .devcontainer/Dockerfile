FROM node:22-slim

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g \
    npm@latest

RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER node

WORKDIR /app
