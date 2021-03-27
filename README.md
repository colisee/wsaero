# wsaero - Aeronautical Weather Service

wsaero is a web application and a RESTful web service that pulls aviation weather information (METAR, TAF) from the [National Center for Atmospheric Research][NCAR] 
and returns the information in various formats, such as XML, HTML, RSS and KML.

Actually, wsaero is my self-educational project aiming at expanding my professional expertise and passion to new software development techniques, 
such as the above ones plus css, xslt, php, git and docker.

## Pre-requisites
You have the choice of running wsaero through a web server stack on your OS or running wsaero using the docker framework; 
the latter being the easiest and fastest method.

### Web server stack
* web server capable of serving php scripts
* php installed with the xsl module

### Docker framework
* docker installed and running (ex: `sudo systemctl start docker` on a typical debian OS)
  
## Installation
### Web server stack
1. Install a web server stack, php and the xsl module
2. Go to your web server root directory (ex: **/var/www/html** on a typical debian OS)
3. Clone the project file content with the command `https://github.com/colisee/wsaero.git`

### Docker framework
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

## Run the server component
### Web server stack
* Start your web browser service if not enabled (ex: `sudo systemctl start apache2` on a typical debian OS)

### Docker framework
* Launch the container with the following command(s), depending on whether you have 1 or 2 containers

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

## Consume the data
### As a web application
Point your web browser to *your_application_path*:
* Web server stack: http://*your_web_server_host*/wsaero
* docker framework: http://*your_web_server_container* 

### As a RESTful web service
The URL of the restful web service is *your_application_path*/__wsaero.php [country][airport][radius][history][output]__

#### country
* Optional parameter, but it must be specified if [airport] is not defined
* It is the country 2-character-long code (ex: CH for Switzerland)

#### airport
* Optional parameter, but it must be specified if [country] is not defined
* Specify the airport 4-character-long ICAO code (ex: LSGG for Geneva Cointrin)
* You can specify several aiports by entering each ICAO codes, separated by the:
  * "," sign if it is a list of airports
  * ";" sign if the airports represent a flight path 

#### radius
* Optional parameter
* Expressed in nautical miles
* If 1 airport was specified: the API will return the data of all airports within that airport radius
* If a flightpath was specified, the API will return the data of all the airports within the flightpath corridor 

#### history
* Optional parameter
* Expressed in hours (can be a decimal)

#### geographical bounds
* Optional parameters
* 4 parameters:
  * minLat: minimum latitude in degrees (-180, 180)
  * maxLat: maximum latitude in degrees (-180, 180)
  * minLon: minimum longitude in degrees (-180, 180)
  * maxLon: maximum longitude in degrees (-180, 180)

#### output
* Optional parameter
* Possible values are:
  * **XML: data in xml format as per the "wsaero.xsd" schema (default)**
  * HTML: data returned in the HTML format
  * RSS: data returned in the RSS format
  * KML: data returned in the KML format
  * GEOJSON: data returned in the GeoJSON format

#### Examples
* To retrieve the most recent weather information for Geneva Cointrin in the XML format
`http://your_application_path/wsaero.php?airport=LSGG`
* To retrieve the most recent weather information for Geneva Cointrin, Paris Charles de Gaule and Rome Fiumicino in the RSS format
`http://your_application_path/wsaero.php?airport=LSGG,LFPG,LIRF&output=RSS`
* To retrieve the most recent weather information for Geneva Cointrin and all other airports within a 50 Nm radius in the KML format
`http://your_application_path/wsaero.php?airport=LSGG&radius=50&output=KML`
* To retrieve the most recent weather information for all airports within the flightpath from LSGG to LIRF inside a 20 Nm corridor in the HTML format
`http://your_application_path/wsaero.php?airport=LSGG;LIRF&radius=20&output=HTML`
* To retrieve the weather information of LSGG in the last 3 hours in the RSS format
`http://your_application_path/wsaero.php?airport=LSGG&history=3&output=RSS`
* To retrieve the most recent weather information of all airports in Switzerland in the GeoJSON format
`http://your_application_path/wsaero.php?country=CH&output=GEOJSON`
* To retrieve the most recent weather information of all airports within the area (45N, 5W, 50N, 10W) in the GeoJSON format
`http://your_application_path/wsaero.php?minLat=45&maxLat=50&minLon=5&maxLon=10&output=GEOJSON`

[NCAR]: http://weather.aero
