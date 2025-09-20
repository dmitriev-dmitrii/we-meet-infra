include .env

up:
	docker-compose up -d

down:
	docker-compose down

clean:
	docker-compose down -v --rmi local

turn-test:  ## Test port availability
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TCP} 2>/dev/null && echo "TURN/TCP:OK" || echo "TURN/TCP:FAIL"
	@nc -zv ${TURN_PUBLIC_IP} ${TURN_PORT_TLS} 2>/dev/null && echo "TURN/TLS:OK" || echo "TURN/TLS:FAIL"

status:
	@docker ps --filter "name=${APP_NAME}" --format "table {{.Names}}\t{{.Status}}"

