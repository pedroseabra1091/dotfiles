#!/usr/bin/env bash

BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[0;31m'
RESET='\033[0m'

function xecho {
  echo "\n$1[$2]: $3"
}

function xecho_info {
  xecho "$BLUE" "$1" "$2"
}

function xecho_success {
  xecho "$GREEN" "$1" "$2"
}

function xecho_error {
  xecho "$RED" "$1" "$2"
}
