# syntax=docker/dockerfile:1

FROM node:18-bullseye AS build

WORKDIR /app

COPY src/GpsMedicalAssistanceFront/package.json src/GpsMedicalAssistanceFront/package-lock.json ./
RUN npm ci

COPY src/GpsMedicalAssistanceFront/ ./
RUN npm run build -- --configuration production

FROM nginx:1.27-alpine AS runtime

COPY deploy/gps-medical-assistance.nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/gps-medical-assistance-front /usr/share/nginx/html
RUN chmod -R a+rX /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
