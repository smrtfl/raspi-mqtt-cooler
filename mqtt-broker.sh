#!/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() {
	printf "%b%s%b" "${GREEN}" "${1}" "${NC}\n"
}

warning() {
	printf "%b%s%b" "${YELLOW}" "${1}" "${NC}\n"
}

error() {
	printf "%b%s%b" "${RED}" "${1}" "${NC}\n"
}

usage() {
	printf "\nManage MQTT broker for lightweight PubSub\n"
	printf "\nUsage\n"
	printf "  start         Start MQTT broker\n"
	printf "  stop          Stop MQTT broker\n"
	printf "\nExample:\n"
	printf "%s start\n" "$0"

	exit 1
}

start() {
	printf "Starting MQTT broker...\n"

	sudo apt install -y mosquitto mosquitto-clients

	sudo systemctl enable mosquitto
	sudo systemctl start mosquitto

	sudo systemctl status mosquitto

	success "MQTT broker is started"
}

stop() {
	printf "Stopping MQTT broker...\n"

	sudo systemctl stop mosquitto

	sudo systemctl status mosquitto

	success "MQTT broker is stopped"
}

if [ -z "$1" ]; then
	usage
fi

case "$1" in
start)
	start
	;;
stop)
	stop
	;;
*)
	error "Unknown command $1 for $0"
	usage
	;;
esac
