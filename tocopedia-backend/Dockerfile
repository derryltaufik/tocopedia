FROM node:24-alpine AS base
WORKDIR /app
COPY package*.json ./

FROM base AS production
RUN npm ci --omit=dev
COPY src/ ./src/
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "src/app.js"]

FROM base AS seed
RUN npm ci
COPY src/ ./src/
CMD ["node", "src/init.js"]
