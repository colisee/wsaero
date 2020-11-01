# wsaero - Aeronautical Weather Service

wsaero is a web application that pulls aviation weather information (METAR, TAF) from the National Center for Atmospheric Research (http://weather.aero) and returns the information in various formats, such as XML, HTML, RSS and KML.

Actually, wsaero is my self-educational project aiming at expanding my professional expertise and passion to new software development techniques, such as the above ones plus css, xslt, php, git and docker.

## Pre-requisites
You have the choice of running wsaero through a web server stack on your OS or running wsaero using the docker framework; the latter being the easiest method.
### Standard (the hard way)
1. web server capable of serving php scripts
2. php installed with the xsl extension

### Docker (the easy way)
1. Make sure that docker is installed and running
  
## Installation
### Standard
1. Install a web server stack, php and the xsl module (included in the php-xml on a typical debian OS)
2. Go into your web server root directory (ex: /var/www/html on a typical debian OS)
3. Clone the project file content with the command line git clone https://github.com/colisee/wsaero.git

### Docker
You have the choice of running wsaero in 2 ways: with 1 or 2 containers. The former being very easy to run while the latter better conforms to the micro-service concept.
#### One container
docker pull colisee/wsaero:latest 

#### Two containers
docker pull colisee/wsaero:app-latest
docker pull colisee/wsaero:httpd-latest

## Run
### Standard
* Start your web browser service if not enabled (ex: sudo systemctl start apache2 on a typical debian OS)
* point your web browser to http://your_host/wsaero/

### Docker
#### One container
docker run --name colisee-wsaero -p 80:80 -d colisee/wsaero:latest

#### Two containers
docker run --name colisee-wsaero-app --mount type=volume,source=wsaero-col,target=/wsaero -d colisee/wsaero:app-latest
docker run --name colisee-wsaero-httpd -p 80:80 --mount type=volume,source=wsaero-vol,target=/var/www/html --rm -d colisee/wsaero:httpd-latest
