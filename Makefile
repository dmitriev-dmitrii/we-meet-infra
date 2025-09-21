include .env

copy-env:
	cp -f .env frontend/.env
	cp -f .env backend/.env

up:
	@docker network create we-meet-network 2>/dev/null || true
	@cd nginx && docker-compose --env-file ../.env up -d
	@cd coturn && docker-compose --env-file ../.env up -d

down:
	@cd nginx && docker-compose --env-file ../.env down
	@cd coturn && docker-compose --env-file ../.env down
	@docker network rm we-meet-network 2>/dev/null || true

clean:
	@cd nginx && docker-compose --env-file ../.env down -v --rmi all
	@cd coturn && docker-compose --env-file ../.env down -v --rmi all
	@docker network rm we-meet-network 2>/dev/null || true

turn-test:  ## Test port availability
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TCP} 2>/dev/null && echo "TURN/TCP:OK" || echo "TURN/TCP:FAIL"
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TLS} 2>/dev/null && echo "TURN/TLS:OK" || echo "TURN/TLS:FAIL"

status:
	@docker ps --filter "name=we-meet" --format "table {{.Names}}\t{{.Status}}"

