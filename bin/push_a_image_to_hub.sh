#!/usr/bin/env bash

source bin/common.sh
source bin/init_database.sh

function create_dockerfile_build_container() {
    dockerfile='data/Dockerfile'
    rm -f ${dockerfile}
cat >${dockerfile} <<EOL
FROM mariadb

COPY init /docker-entrypoint-initdb.d/
#COPY mysql /var/lib/mysql
EOL
}

function create_dockerfile_build_image() {
    dockerfile='data/Dockerfile'
    rm -f ${dockerfile}
cat >${dockerfile} <<EOL
FROM mariadb

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

# TODO wait for import data to mariadb done _ not done
function wait_for_import_db_done() {
    docker_container_name='docker-magento-multiple-db_php_1'
    for i in "${MAGENTO_VERSION_ARRAY[@]}"
    do
        exec_cmd "docker exec ${docker_container_name} bash -c \"MYSQL_DATABASE=magento`get_port_service_docker "${i}"` php -f mysql.php\""
    done
}

function build_image() {
    sudo chown -R $USER:$USER data/mysql
    docker-compose down
    create_dockerfile_build_image
    docker-compose -f docker-compose-build-image.yml build
}

function push_image_to_docker_hub() {
    local tag_magento_db=`join_array_to_string _ ${MAGENTO_VERSION_ARRAY[@]}`
    docker_hub_name="ngovanhuy0241/docker-magento-multiple-db:${tag_magento_db}"
    docker login
    docker tag docker-magento-multiple-db_db ${docker_hub_name}
    docker push ${docker_hub_name}
}

function main() {
    build_container
    wait_for_import_db_done
    build_image
    push_image_to_docker_hub
}

calculate_time_run_command main
