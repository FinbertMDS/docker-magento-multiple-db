# Build database for version Magento

## [Docker Hub](https://hub.docker.com/r/ngovanhuy0241/docker-magento-multiple-db/)
## Some bash in folder bin
1. `bin/common.sh`: Some function used for other script.
2. `bin/main.sh`: Build and push image to Docker Hub with tag `latest` and with all database of version magento config in file `.env`
3. `bin/init_database.sh`: Validate, copy sql between 2 folder `data/backups` and `data/init`
4. `bin/get_magento_db_name.sh`: Get magento db name of a version magento
5. `bin/push_a_image_to_hub`: Push a image to Docker Hub with tag `is version of magento` and with all database of version magento config in file `.env`
6. `bin/push_all_image_to_hub`: Push all image to Docker Hub which every image has tag `is version of magento` and all database of version magento config in file `.env.all`
## List version Magento had has tag in [Docker Hub](https://hub.docker.com/r/ngovanhuy0241/docker-magento-multiple-db/tags/):

    - Magento 1 - Php 5.6
        + 1.9.3.10: magento19310
    - Magento 2.1 - Php 7.0
        + 2.1.3: magento21370
        + 2.1.15: magento21157
        + 2.1.16: magento21167
    - Magento 2.2 - Php 7.1
        + 2.2.1: magento22171
        + 2.2.5: magento22571
        + 2.2.6: magento22671
        + 2.2.7: magento22771
    - Magento 2.3 - Php 7.1
        + 2.2.7: magento22771
    - 19310_2116_227
        + Magento 1.9.3.10, 2.1.16, 2.2.7
    - 19310_2115_225_226
        + Magento 1.9.3.10, 2.1.15, 2.2.5, 2.2.6

## Rule named database Magento: magento + ('versionMagento' + 'versionPhp') (max is 5 character).

    - Note: You can get database name for version Magento by bash `bin/get_magento_db_name.sh` with param is version Magento
    
## If you want add database to image, execute follow steps below:
    
    1. Remove folder `data/mysql` of last build image
       ```bash
       rm -rf data/mysql
       ```
    2. Edit file `.env` add version magento to variable `MAGENTO_VERSIONES` after `,` 
    3. Run command to validate sql in folder `data/init` and create file `data/init/database.sql` with versions magento
        ```bash
        ./bin/init_database.sh
        ```
    4. Edit file `data/Dockerfile` to add sql file to docker images which these files will run when docker compose up: Uncomment line `3`. Comment line `4`. 
    5. Run command to build docker image and run it into container.
        ```bash
        docker-compose build
        docker-compose up
        ```
    6. `Ctrl + C` to stop docker compose.
    7. Change permission for folder persist data mysql by command.
        ```bash
        sudo chown -R $USER:$USER data/mysql
        ```
    8. Edit file `data/Dockerfile` to copy all database to image: Comment line `3`. Uncomment line `4`.
    9. Run command to build docker image.
        ```bash
        docker-compose build
        ```
    10. Commit image to https://hub.docker.com
        ```bash
        docker login
        docker tag source_image target_image
        docker push target_image
        ```