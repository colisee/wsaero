# wsaero - Aeronautical Weather Service

wsaero is a web application that pulls aviation weather information (METAR, TAF) from the [National Center for Atmospheric Research][NCAR] and returns the information in various formats, such as XML, HTML, RSS and KML.

Actually, wsaero is my self-educational project aiming at expanding my professional expertise and passion to new software development techniques, such as the above ones plus css, xslt, php, git and docker.

## Pre-requisites
You have the choice of running wsaero through a web server stack on your OS or running wsaero using the docker framework; the latter being the easiest method.
### Standard (the hard way)
* web server capable of serving php scripts
* php installed with the xsl module

### Docker (the easy way)
* docker installed and running (ex: `sudo systemctl start docker` on a typical debian OS)
  
## Installation
### Standard
1. Install a web server stack, php and the xsl module (included in the php-xml packlage on a typical debian OS)
2. Go to your web server root directory (ex: /var/www/html on a typical debian OS)
3. Clone the project file content with the command `https://github.com/colisee/wsaero.git`

### Docker
You have the choice of running wsaero in 2 ways: with 1 or 2 containers. The former being very easy to run while the latter better conforming to the micro-service concepts.
#### One container
```
docker pull colisee/wsaero
``` 

#### Two containers
```
docker pull colisee/wsaero:app-latest
docker pull colisee/wsaero:httpd-latest
```

## Run
### Standard
* Start your web browser service if not enabled (ex: `sudo systemctl start apache2` on a typical debian OS)
* Point your web browser to http://your_host/wsaero/App 

Please note that the url must end with "/App" since version 6.50).

### Docker
* Launch the container with the following command(s), depending on whether you have 1 or 2 containers
* Point your web browser to http://your_host/
#### One container

```
docker run --name colisee-wsaero -p 80:80 -d colisee/wsaero

```
#### Two containers
```
docker run --name colisee-wsaero-app --mount type=volume,source=wsaero-vol,target=/wsaero -d colisee/wsaero:app-latest
docker run --name colisee-wsaero-httpd -p 80:80 --mount type=volume,source=wsaero-vol,target=/var/www/html -d colisee/wsaero:httpd-latest
```

You can combine the installation and execution phase by creating the following **docker-compose.yml** file and by running the command `docker compose -d up`
```
version: "3.2"
services:
  app:
    build:
      context: '.'
      dockerfile: Dockerfile-app
    image: colisee/wsaero-app:6.1
    container_name: wsaero-app
    volumes:
      - type: volume
        source: wsaero-vol
        target: /wsaero

  httpd:
    build:
      context: '.'
      dockerfile: Dockerfile-httpd
    image: colisee/wsaero-httpd:6.1
    container_name: wsaero-httpd
    depends_on:
      - app
    ports:
      - "80:80"
    volumes:
      - type: volume
        source: wsaero-vol
        target: /var/www/html/

volumes:
  wsaero-vol:
```

[NCAR]: http://weather.aero
