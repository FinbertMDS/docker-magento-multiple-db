#!/usr/bin/env bash

source .env.all
ALL_MAGENTO_VERSION_ARRAY=(${ALL_MAGENTO_VERSIONES//,/ })

function init_file_env_a_version_magento() {
    if [[ ! -z ${1} ]]; then
        rm -f .env
        echo "MAGENTO_VERSIONES='${1}'" > ".env"
    fi
}

function calculate_time_run_command() {
    start=$(date +%s)
    $1
    end=$(date +%s)
    diff=$(( $end - $start ))
    echo "+ ${1}: It took $diff seconds"
}

function main() {
    for i in "${ALL_MAGENTO_VERSION_ARRAY[@]}"
    do
        init_file_env_a_version_magento ${i}
        source bin/push_a_image_to_hub.sh
    done
}

calculate_time_run_command main
