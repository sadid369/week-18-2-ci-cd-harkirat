FROM node:20.12.0-alpine3.19

WORKDIR /usr/src/app

COPY package.json package-lock.json turbo.json tsconfig.json ./

COPY apps ./apps
COPY packages ./packages

# Install dependencies
RUN npm install --verbose \
    --fetch-timeout 600000 \
    --fetch-retries 5 \
    || (echo "NPM install failed, retrying with clean cache" && \
        npm cache clean --force && \
        npm install --verbose)

# Can you add a script to the global package.json that does this?
RUN npm run db:generate

# Can you filter the build down to just one app?
RUN npm run build

CMD ["npm", "run", "start-user-app"]