#!/usr/bin/env bash

source bin/common.sh

function main() {
    if [[ ! -z $1 ]]; then
        port_service_docker=`get_port_service_docker $1`
        echo 'magento'${port_service_docker}
    else
        echo 'You need run with param is version Magento.'
    fi
}

main $1