# syntax=docker/dockerfile:1

FROM node:18-bookworm-slim AS deps

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      python3 \
      libcairo2-dev \
      libpango1.0-dev \
      libjpeg-dev \
      libgif-dev \
      librsvg2-dev \
      libpixman-1-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY src/GpsMedicalAssistanceBack/FaceRecognitionService/package.json \
     src/GpsMedicalAssistanceBack/FaceRecognitionService/package-lock.json ./
RUN npm ci

FROM node:18-bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
      libcairo2 \
      libpango-1.0-0 \
      libjpeg62-turbo \
      libgif7 \
      librsvg2-2 \
      libpixman-1-0 \
      libfontconfig1 \
      libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY src/GpsMedicalAssistanceBack/FaceRecognitionService/ ./

ENV NODE_ENV=production \
    PORT=3000

EXPOSE 3000

CMD ["node", "app.js"]
