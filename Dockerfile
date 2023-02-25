FROM node:lts-alpine
ENV NODE_ENV=production
ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true \
NEW_RELIC_LOG=stdout
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev \
    && apk add libffi-dev
COPY . .
EXPOSE 3000
RUN chown -R node /usr/src/app
USER root
RUN npm run build
CMD ["npm","run","newstart"]
