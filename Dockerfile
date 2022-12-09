########
# BASE #
########

FROM node:lts-alpine AS base

ARG PNPM_VERSION=7.17.0

RUN npm --global install pnpm@${PNPM_VERSION}

WORKDIR /usr/src/app

################
# DEPENDENCIES #
################

FROM base As dependencies

ENV CI=1

COPY --chown=node:node package.json pnpm-lock.yaml ./
COPY --chown=node:node build ./build

ENV NODE_ENV production

RUN SKIP_POSTINSTALL=1 pnpm install --prod --frozen-lockfile

USER node

###################
# PRODUCTION
###################

FROM node:lts-alpine As production

WORKDIR /usr/src/app

COPY --chown=node:node --from=dependencies /usr/src/app/ ./

EXPOSE 3000

CMD [ "node", "build/src/main.js" ]