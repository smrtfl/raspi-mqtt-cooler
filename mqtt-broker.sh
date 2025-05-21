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
	cat <<-EOF

		Manage MQTT broker for lightweight PubSub

		Usage:
		  start         Start MQTT broker
		  stop          Stop MQTT broker

		Example:
		  ${0} start

	EOF
	exit 1
}

start() {
	printf "Starting MQTT broker...\n"

	sudo apt update
	sudo apt install -y mosquitto mosquitto-clients

	if init_config; then
		success "MQTT broker is configured"
	else
		error "Failed to configure MQTT broker"
	fi

	if sudo systemctl enable mosquitto && sudo systemctl start mosquitto; then
		success "MQTT broker is started"
	else
		error "Failed to start MQTT broker"
	fi
}

stop() {
	printf "Stopping MQTT broker...\n"

	if sudo systemctl stop mosquitto; then
		warning "Failed to stop MQTT broker"
	else
		success "MQTT broker is stopped"
	fi
}

init_config() {
	cat >/etc/mosquitto/conf.d/default.conf <<-EOF
		listener 1883
		allow_anonymous true
	EOF
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
