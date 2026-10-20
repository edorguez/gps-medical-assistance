# Despliegue de gps-medical-assistance

## URLs

- Local: `http://localhost:8082`
- Público: `https://gps-medical-assistance.edoutput.dev`
- API interna: `http://gps-medical-assistance-api:8080`
- Edge: `http://gps-medical-assistance-edge:80`

## Componentes

- `gps-medical-assistance-edge`: Nginx + Angular
- `gps-medical-assistance-api`: .NET 6
- `gps-medical-assistance-face`: Node 18 + face-api.js + canvas
- `gps-medical-assistance-db`: PostgreSQL 16
- `gps-medical-assistance-mongo`: MongoDB 6

## Prueba local

```bash
docker network inspect shared-edge >/dev/null 2>&1 || docker network create shared-edge
cp .env.example .env
# Edita POSTGRES_PASSWORD y, si quieres SMS, las variables de Twilio.
./deploy/bootstrap.sh
docker compose up -d --build
```

Verificar:

```bash
curl -f http://localhost:8082/healthz
curl -f http://localhost:8082/api/familyType
```

## Servidor

```bash
sudo mkdir -p /opt/docker-projects /opt/docker-projects-data
sudo chown -R "$USER":"$USER" /opt/docker-projects /opt/docker-projects-data

git clone https://github.com/EdoRguez/gps-medical-assistance.git /opt/docker-projects/gps-medical-assistance
cd /opt/docker-projects/gps-medical-assistance

cp .env.example .env
nano .env
./deploy/bootstrap.sh
docker compose up -d --build
```

Usa una contraseña de Postgres simple (letras/números) o ajusta la cadena de conexión; caracteres como `;` pueden romper el connection string de .NET.

## Persistencia

Todo queda fuera de los contenedores:

```text
/opt/docker-projects-data/gps-medical-assistance/postgres
/opt/docker-projects-data/gps-medical-assistance/mongo
/opt/docker-projects-data/gps-medical-assistance/uploads/UserFaceImage
```

## Cambios funcionales incluidos

- El frontend usa `/api` en el mismo origen.
- Nginx hace proxy de `/api/` hacia `gps-medical-assistance-api:8080`.
- La API aplica las migraciones EF al arrancar.
- La URL del servicio facial se lee de `FaceRecognitionService__BaseUrl`.
- El servicio facial lee `MONGODB_URI`.
- Se eliminó la redirección HTTPS interna; TLS lo termina Cloudflare.

## Twilio

Si `TWILIO_*` queda vacío, la aplicación sigue funcionando y las alertas se crean, pero el envío de SMS falla silenciosamente.

## Cloudflare

Los DNS y el `config.yml` compartido se documentan en `tourism-agency/DEPLOY.md` y se crean directamente en el servidor (`/opt/docker-projects/edge`). No se versionan.
