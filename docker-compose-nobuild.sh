docker container stop jenkins
docker container rm jenkins
docker compose --env-file ./.env.local build
docker compose --env-file ./.env.local push
docker compose --env-file ./.env.local up --no-build -d