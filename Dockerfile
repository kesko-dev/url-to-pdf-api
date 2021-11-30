FROM node:14

ARG NPM_TOKEN

ENV NODE_ENV production
ENV NPM_CONFIG_PRODUCTION false

# Install Puppeteer dependencies
# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y ca-certificates libappindicator3-1 \
      libasound2 libatk-bridge2.0-0 libatk1.0-0 \
      libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
      libfontconfig1 libgbm1 libgcc1 libglib2.0-0 \
      libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
      libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
      libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 \
      libxrandr2 libxrender1 libxss1 libxtst6 lsb-release xdg-utils \
      fonts-liberation fonts-ipafont-gothic fonts-wqy-zenhei \
      fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc
COPY package*.json ./

RUN npm install

COPY . .

RUN rm .npmrc

USER node

CMD [ "npm", "start" ]

