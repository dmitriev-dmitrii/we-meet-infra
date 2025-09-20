include .env

TURN_COMPOSE = docker-compose -f coturn/docker-compose.yml --env-file .env

turn-up:  ## Start TURN server
	$(TURN_COMPOSE) up -d

turn-down:  ## Stop TURN server
	$(TURN_COMPOSE) down

turn-clean:  ## Stop TURN server
	$(TURN_COMPOSE) down -v --rmi local

turn-test:  ## Test port availability
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TCP} 2>/dev/null && echo "TURN/TCP:OK" || echo "TURN/TCP:FAIL"
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TLS} 2>/dev/null && echo "TURN/TLS:OK" || echo "TURN/TLS:FAIL"