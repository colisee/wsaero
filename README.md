Table of contents:
- [Introduction](#introduction)
- [Pre-requisites](#pre-requisites)
- [Quick start](#quick-start)
- [Consume the data](#consume-the-data)
- [Advanced](#advanced)

# Introduction
__wsaero__ is a web application and a RESTful web service that pulls aviation weather information (METAR, TAF) from the [National Center for Atmospheric Research][NCAR] and returns the information in various formats, such as XML, HTML, RSS, KML and GeoJSON.

Actually, wsaero is my self-educational project aiming at expanding my  expertise and passion to new software development techniques, 
such as the above ones plus css, xslt, php, git and docker.

# Pre-requisites
You have the choice of running wsaero using a web server stack installed on your host or using the docker framework; 
the latter being the easiest and fastest method

## Web server stack
* web server capable of serving php scripts
* php installed with the php-xsl module
* Copy the content of the "App" directory to the web server file directory

## Docker framework
* docker installed and running

The rest of this guide will focus on the docker option.
  
# Quick start
1. Build the docker image
```
docker build --tag colisee/wsaero .
```
2. Run the docker image (server)
```
docker run --detach --rm --name wsaero --publish 80:80 colisee/wsaero
``` 
# Consume the data
This guide assumes you are accessing the application from the host that is running the server. If this is not the case, then replace *localhost* with the name or IP address of the server.

## As a web application
Point your browser to http://localhost. By default, the application will select the best display based on the size of your device, but you can decide which one to access:
* Map display: http://localhost/desktop.html
* Text display: http://localhost/mobile.html 

## As a RESTful web service
The URL of the RESTful web service is http://localhost/wsaero.php [country][airport][radius][history][output]

### country
* Optional parameter (see [remarks](#remarks))
* It is the country 2-character-long code (ex: CH for Switzerland)

### airport
* Optional parameter (see [remarks](#remarks))
* Specify the airport 4-character-long ICAO code (ex: LSGG for Geneva Cointrin)
* You can specify several aiports by entering each ICAO codes, separated by the:
  * "," sign if it is a list of airports
  * ";" sign if the airports represent a flight path 

### radius
* Optional parameter
* Expressed in nautical miles
* If 1 airport was specified: the API will return the data of all airports within that airport radius
* If a flightpath was specified, the API will return the data of all the airports within the flightpath corridor 

### history
* Optional parameter
* Expressed in hours (can be a decimal)

### geographical bounds
* Optional parameters (see [remarks](#remarks))
* 4 parameters:
  * minLat: minimum latitude in degrees (-180, 180)
  * maxLat: maximum latitude in degrees (-180, 180)
  * minLon: minimum longitude in degrees (-180, 180)
  * maxLon: maximum longitude in degrees (-180, 180)

### output
* Optional parameter
* Possible values are:
  * **XML: data in xml format as per the "wsaero.xsd" schema (default)**
  * HTML: data returned in the HTML format
  * RSS: data returned in the RSS format
  * KML: data returned in the KML format
  * GEOJSON: data returned in the GeoJSON format

### Remarks
If no country, no airport and no geographical bounds are passed to the RESTful web service, then the web service will try to get the current location
from the caller's ip address and apply a 50 nautical miles radius. 

### Examples
* To retrieve the most recent weather information for Geneva Cointrin in the XML format
`http://localhost/wsaero.php?airport=LSGG`
* To retrieve the most recent weather information for Geneva Cointrin, Paris Charles de Gaule and Rome Fiumicino in the RSS format
`http://localhost/wsaero.php?airport=LSGG,LFPG,LIRF&output=RSS`
* To retrieve the most recent weather information for Geneva Cointrin and all other airports within a 50 Nm radius in the KML format
`http://localhost/wsaero.php?airport=LSGG&radius=50&output=KML`
* To retrieve the most recent weather information for all airports within the flightpath from LSGG to LIRF inside a 20 Nm corridor in the HTML format
`http://localhost/wsaero.php?airport=LSGG;LIRF&radius=20&output=HTML`
* To retrieve the weather information of LSGG in the last 3 hours in the RSS format
`http://localhost/wsaero.php?airport=LSGG&history=3&output=RSS`
* To retrieve the most recent weather information of all airports in Switzerland in the GeoJSON format
`http://localhost/App/wsaero.php?country=CH&output=GEOJSON`
* To retrieve the most recent weather information of all airports within the area (45N, 5W, 50N, 10W) in the XML format
`http://localhost/App/wsaero.php?minLat=45&maxLat=50&minLon=5&maxLon=10`

# Advanced
## Running the application with 2 containers
You have the option to run the application, using 2 containers: one for the web server and one for the application code:
1. Build the 2 docker images
```
docker build --file Dockerfile-app --tag colisee/wsaero-app .
docker build --file Dockerfile-httpd --tag colisee/wsaero-httpd .
```
2. Run the 2 docker images
```
docker run --detach --rm --name wsaero-app --volume wsaero:/wsaero colisee/wsaero:app
docker run --detach --rm --name wsaero-httpd --publish 80:80 --volume wsaero:/var/www/html colisee/wsaero:httpd
```

[NCAR]: http://weather.aero
