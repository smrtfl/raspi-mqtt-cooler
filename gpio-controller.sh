#!/usr/bin/bash

green='\033[0;32m'
red='\033[0;31m'
yellow='\033[1;33m'
nc='\033[0m'

success() {
    printf "${green}%s${nc}\n" "$1"
}

warning() {
    printf "${yellow}%s${nc}\n" "$1"
}

error() {
    printf "${red}%s${nc}\n" "$1" >&2
}

usage() {
    cat <<-EOF

    GPIOpium to control pins on a circuit

    usage:
      low <gpio_pin_number>    # set pin to low
      high <gpio_pin_number>   # set pin to high

    example:
      ${0} low 17

EOF
    exit 1
}

low() {
    if gpioset gpiochip0 "$1"=0; then
        success "GPIO $1 set to LOW"
    else
        error "Failed to set GPIO $1 to LOW. Are you running as root?"
        exit 1
    fi
}

high() {
    if gpioset gpiochip0 "$1"=1; then
        success "GPIO $1 set to HIGH"
    else
        error "Failed to set GPIO $1 to HIGH. Are you running as root?"
        exit 1
    fi
}

if ! command -v gpioset >/dev/null 2>&1; then
    error "gpioset command not found. Please install it"
    echo "sudo apt install gpiod"
    exit 1
fi

if [ $# -ne 2 ]; then
    usage
fi

if ! [[ "$2" =~ ^[0-9]+$ ]]; then
    error "Invalid GPIO pin number: $2"
    usage
fi

case "$1" in
low)
    low "$2"
    ;;
high)
    high "$2"
    ;;
*)
    error "Unknown command: $1"
    usage
    ;;
esac
