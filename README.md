# PHP 7.3 Full Dev Start Container
This is a PHP container using fpm-7.3 as a base image, configuring the following php-exts (+ deps):

- pod_mysql
- gd
- mbstring
- soap
- xml
- mongodb
- redis
- xdebug
- mcrypt
- solr
- memcached
- zip/unzip

The latest composer is also installed in $PATH. We also drop in our own `php.ini`, it can be
found in `.docker/php/php.ini`. 

# Using this Container
Add the following to your `docker-compose.yml` and adjust as needed:

```
  # It is recommended to rename this block
  my_php_container:
    # It is recommended to rename this container
    container_name: my_php_container
    image: devxyz/fulldev-php73:0.1.0
    working_dir: /var/www
    entrypoint:
      - /bin/bash
      - -c
      # if you have a start script you can replace the line below
      - /usr/local/sbin/php-fpm
      ## Sample start script:
      ## - /devxyz.init/start.sh
    volumes:
      - ~/.ssh:/root/.ssh
      - ./:/var/www/
      ## If you have a start script:
      ## - .docker/php/start.sh:/devxyz.init/start.sh
    # If you would like to use the ITM network:
    # networks:
    #    - itmedia
```


# Build Locally
```bash
docker build -t devxyz/fulldev-php73 .
```

# Push
We track and store this image in the Docker Hub devxyz account. You can push updates
to the image by pushing a new tag to the `master` branch of this repo. If you do,
please also bump the version in the sample block found in "Using this Container".
