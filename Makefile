include .env

up:
	@docker network create we-meet-network 2>/dev/null || true
	 docker-compose -f docker-compose.traefik.yml --env-file ./.env up -d
	 docker-compose -f docker-compose.coturn.yml --env-file ./.env up -d

down:
	docker-compose -f docker-compose.traefik.yml down || true
	docker-compose -f docker-compose.coturn.yml down || true


clean:
	docker-compose -f docker-compose.traefik.yml down -v --rmi all || true
	docker-compose -f docker-compose.coturn.yml down -v --rmi all || true
	@cd we-meet-coturn && docker compose --env-file ../.env down -v --rmi all || true
