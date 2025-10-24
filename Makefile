include .env

up:
	@docker network create we-meet-network 2>/dev/null || true
	@cd we-meet-traefik && docker compose --env-file ../.env up -d
	@cd we-meet-coturn && docker compose --env-file ../.env up -d

down:
	@cd we-meet-traefik && docker compose --env-file ../.env down || true
	@cd we-meet-coturn && docker compose --env-file ../.env down || true


clean:
	@cd we-meet-traefik && docker compose --env-file ../.env down -v --rmi all || true
	@cd we-meet-coturn && docker compose --env-file ../.env down -v --rmi all || true

status:
	@docker ps --filter "name=we-meet" --format "table {{.Names}}\t{{.Status}}"

# nginx больше не используется

traefik-logs:
	@docker logs -f we-meet-traefik | cat

help:
	@echo "Available commands:"
	@echo "  make up         - Start all services"
	@echo "  make down       - Stop all services"
	@echo "  make clean      - Stop and remove all containers, volumes, images"
	@echo "  make status     - Show running containers"
	@echo "  make traefik-logs - Tail Traefik logs"
	@echo "  make add-traefik-user - Add/replace Traefik dashboard user"