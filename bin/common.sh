#!/usr/bin/env bash

source .env
MAGENTO_VERSION_ARRAY=(${MAGENTO_VERSIONES//,/ })

# get version php from version magento
function get_version_php() {
    local php_version=""
    if [[ ${1} == 2.2* ]]; then
        php_version="7.1"
    elif [[ ${1} == 2.1* ]]; then
        php_version="7.0"
    elif [[ ${1} == 1.* ]]; then
        php_version="5.6"
    fi
    echo ${php_version}
}

# get port of service docker.
# if port >= 6 character, remove last character
# ex: version magento is 2.2.6 => port: 22671; 2.1.15 => port: 21157; 1.9.3.10 => port: 19310
function get_port_service_docker() {
    local port_service_docker=''
    local php_version=`get_version_php "${1}"`
    if [[ ! -z "${php_version}" ]]; then
        port_service_docker="${1//./}""${php_version//./}"
        while [[ ${#port_service_docker} > 5 ]]; do
            port_service_docker="${port_service_docker::-1}"
        done
    fi
    echo ${port_service_docker}
}

# print with in one of the colors: red, green, reset
# ex: print_color 'string' 'color'
function print_color() {
    local red=`tput setaf 1`
    local green=`tput setaf 2`
    local yellow=`tput setaf 3`
    local blue=`tput setaf 4`
    local magenta=`tput setaf 5`
    local cyan=`tput setaf 6`
    local reset=`tput sgr0`

    if [[ ! -z  $1 ]]; then
        case "$2" in
            red) echo "${red}${1}"${reset} ;;
            green) echo "${green}${1}"${reset} ;;
            yellow) echo "${yellow}${1}"${reset} ;;
            blue) echo "${blue}${1}"${reset} ;;
            magenta) echo "${magenta}${1}"${reset} ;;
            cyan) echo "${cyan}${1}"${reset} ;;
            *) echo "${reset}${1}" ;;
        esac
    fi
}

function calculate_time_run_command() {
    local start=$(date +%s)
    $1
    local end=$(date +%s)
    local diff=$(( $end - $start ))
    echo "+ ${1}: It took $diff seconds"
}

# quit process
function bail() {
    echo 'Error executing command, exiting'
    exit 1
}

# exec cmd, if error still continuous process
function exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

# exec cmd, if error quit process
function exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

function join_array_to_string {
    local IFS="$1";
    shift;
    echo "$*";
}