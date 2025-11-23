include .env

up:
	@docker network create we-meet-network 2>/dev/null || true
	docker-compose -f docker-compose.traefik.yml -f docker-compose.coturn.yml --env-file ./.env up -d

down:
	docker-compose -f docker-compose.traefik.yml -f docker-compose.coturn.yml --env-file ./.env down

clean:
	docker-compose -f docker-compose.traefik.yml -f docker-compose.coturn.yml --env-file ./.env down -v --rmi all --remove-orphans
	@cd we-meet-coturn && docker compose --env-file ../.env down -v --rmi all || true