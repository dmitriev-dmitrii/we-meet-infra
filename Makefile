include .env

update-all:
    git pull
    git submodule update --remote --recursive
    @echo "All repositories updated"

up:
	@cp -f .env frontend/.env
	@cp -f .env backend/.env
	@docker network create we-meet-network 2>/dev/null || true
	@cd coturn && docker compose --env-file ../.env up -d
	@cd backend && docker compose --env-file ../.env up -d
	@cd nginx && docker compose --env-file ../.env up -d

down:
	@cd coturn && docker compose --env-file ../.env down
	@cd backend && docker compose --env-file ../.env down
	@cd nginx && docker compose --env-file ../.env down
	@docker network rm we-meet-network 2>/dev/null || true

clean:
	@cd coturn && docker compose --env-file ../.env down -v --rmi all
	@cd backend && docker compose --env-file ../.env down -v --rmi all
	@cd nginx && docker compose --env-file ../.env down -v --rmi all
	@docker network rm we-meet-network 2>/dev/null || true

turn-test:  ## Test port availability
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TCP} 2>/dev/null && echo "TURN/TCP:OK" || echo "TURN/TCP:FAIL"
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TLS} 2>/dev/null && echo "TURN/TLS:OK" || echo "TURN/TLS:FAIL"

status:
	@docker ps --filter "name=we-meet" --format "table {{.Names}}\t{{.Status}}"

reload-nginx:
	@docker exec we-meet-nginx nginx -s reload

help:
	@echo "Available commands:"
	@echo "  make up      - Start all services"
	@echo "  make down    - Stop all services"
	@echo "  make clean   - Stop and remove all containers, volumes, images"
	@echo "  make status  - Show running containers"
	@echo "  make turn-test - Test TURN server connectivity"
	@echo "  make reload-nginx - Reload nginx configuration"

