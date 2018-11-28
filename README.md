# Build database for version Magento

0. https://hub.docker.com/r/ngovanhuy0241/docker-magento-multiple-db/
1. List version Magento had import data:

    - Magento 1 - Php 5.6
      + 1.9.3.10: magento19310
    - Magento 2.1 - Php 7.0
      + 2.1.15: magento21157
    - Magento 2.2 - Php 7.1
      + 2.2.5: magento22571
      + 2.2.6: magento22671
      
2. Rule named database Magento: magento + ('versionMagento' + 'versionPhp') (max is 5 character).

    - Note: You can get database name for version Magento by bash `bin/get_magento_db_name.sh` with param is version Magento
    
3. If you want add database to image, execute follow steps below:
    
    0. Remove folder `data/mysql` of last build image
        ```bash
        rm -rf data/mysql
        ```
    1. Edit file `.env` add version magento to variable `MAGENTO_VERSIONES` after `,` 
    2. Run command to validate sql in folder `data/init` and create file `data/init/database.sql` with versions magento
        ```bash
        ./bin/init_database.sh
        ```
    3. Edit file `data/Dockerfile` to add sql file to docker images which these files will run when docker compose up: Uncomment line `3`. Comment line `4`. 
    4. Run command to build docker image and run it into container.
        ```bash
        docker-compose build
        docker-compose up
        ```
    5. `Ctrl + C` to stop docker compose.
    6. Change permission for folder persist data mysql by command.
        ```bash
        sudo chown -R $USER:$USER data/mysql
        ```
    7. Edit file `data/Dockerfile` to copy all database to image: Comment line `3`. Uncomment line `4`.
    8. Run command to build docker image.
        ```bash
        docker-compose build
        ```
    9. Commit image to https://hub.docker.com
        ```bash
        docker login
        docker tag source_image target_image
        docker push target_image
        ```