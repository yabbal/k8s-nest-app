###################
# BUILD FOR BASE
###################

FROM node:lts-alpine AS base

ARG PNPM_VERSION=7.17.0

RUN npm --global install pnpm@${PNPM_VERSION}

WORKDIR /usr/src/app

###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM base As development

COPY --chown=node:node package.json pnpm-lock.yaml ./

RUN SKIP_POSTINSTALL=1 pnpm install --frozen-lockfile

COPY --chown=node:node . .

USER node

###################
# BUILD FOR PRODUCTION
###################

FROM base As build

ENV CI=1

COPY --chown=node:node package.json pnpm-lock.yaml ./

COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=node:node . .

RUN pnpm run build

ENV NODE_ENV production

RUN SKIP_POSTINSTALL=1 pnpm install --prod --frozen-lockfile

USER node

###################
# PRODUCTION
###################

FROM base As production

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist

EXPOSE 3000

CMD [ "node", "dist/src/main.js" ]