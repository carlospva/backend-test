FROM node:22 AS build 

WORKDIR /usr/app

COPY ./ /usr/app

RUN npm install

RUN npm run lint

RUN npm run test:cov

RUN npm run build

FROM node:22-alpine AS runner

WORKDIR /usr/app

COPY --from=build /usr/app/dist /usr/app/dist
COPY --from=build /usr/app/package*.json /usr/app/
RUN npm install --only=production

CMD ["node", "dist/main"]



