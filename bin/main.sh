#!/usr/bin/env bash

source bin/common.sh
source bin/init_database.sh

function create_dockerfile_build_container() {
    dockerfile='data/Dockerfile'
    rm -f ${dockerfile}
cat >${dockerfile} <<EOL
FROM mariadb:10.0

COPY init /docker-entrypoint-initdb.d/
#COPY mysql /var/lib/mysql
EOL
}

function create_dockerfile_build_image() {
    dockerfile='data/Dockerfile'
    rm -f ${dockerfile}
cat >${dockerfile} <<EOL
FROM mariadb:10.0

#COPY init /docker-entrypoint-initdb.d/
COPY mysql /var/lib/mysql
EOL
}

function build_container() {
    sudo rm -rf data/mysql
    mkdir -p data/mysql
    create_dockerfile_build_container
    docker-compose down
    docker-compose build
    docker-compose up -d
}

function wait_for_import_db_done() {
    local docker_container_name='docker-magento-multiple-db_php_1'
    for i in "${MAGENTO_VERSION_ARRAY[@]}"
    do
        exec_cmd "docker exec ${docker_container_name} bash -c \"MYSQL_DATABASE=test php -f mysql.php\""
    done
}

function build_image() {
    sudo chown -R $USER:$USER data/mysql
    docker-compose down
    create_dockerfile_build_image
    docker-compose -f docker-compose-build-image.yml build
}

function push_image_to_docker_hub() {
    docker login
    docker tag docker-magento-multiple-db_db ngovanhuy0241/docker-magento-multiple-db
    docker push ngovanhuy0241/docker-magento-multiple-db
}

function main() {
    build_container
    wait_for_import_db_done
    build_image
    push_image_to_docker_hub
}

calculate_time_run_command main
