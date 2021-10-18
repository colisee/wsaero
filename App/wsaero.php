<?php

// Constants
Define("BASE_URL", "https://aviationweather.gov/adds/dataserver_current/httpparam?requestType=retrieve&format=xml");

// Form variables
$country = array_key_exists('country', $_GET) ? $_GET['country'] : "";
$airport = array_key_exists('airport', $_GET) ? $_GET['airport'] : "";
$nauticalRadius = array_key_exists('radius', $_GET) ? $_GET['radius'] : "";
$output = array_key_exists('output', $_GET) ? $_GET['output'] : "";
$history = array_key_exists('history', $_GET) ? $_GET['history'] : "0";
$minLat = array_key_exists('minLat', $_GET) ? $_GET['minLat'] : "";
$minLon = array_key_exists('minLon', $_GET) ? $_GET['minLon'] : "";
$maxLat = array_key_exists('maxLat', $_GET) ? $_GET['maxLat'] : "";
$maxLon = array_key_exists('maxLon', $_GET) ? $_GET['maxLon'] : "";
$minDegreeDistance = array_key_exists('minDegreeDistance', $_GET) ? $_GET['minDegreeDistance'] : "";
$lat = array_key_exists('lat', $_GET) ? $_GET['lat'] : "";
$lon = array_key_exists('lon', $_GET) ? $_GET['lon'] : "";

// Program variables
$urlInfo = BASE_URL . "&datasource=stations";
$urlMetar = BASE_URL . "&datasource=metars";
$urlTaf = BASE_URL . "&datasource=tafs";
$xmlInfo = "";
$xmlMetar = "";
$xmlTaf = "";
$transform = "";
$contentType = "";


/* -------------------------------------------------------------------- */
/* Goal : Build the Info url needed to access weather.aero		*/
/* -------------------------------------------------------------------- */

// Minimum Degree Distance specified
if ($minDegreeDistance != "") {
	$urlInfo .= "&minDegreeDistance=" . $minDegreeDistance;
}

// Country specified
if ($country != "") {
	$country = strtoupper($country);
	$country = str_replace(" ", "", $country);
  	$country = "~" . $country;
	$country = str_replace(",", ",~", $country);
	$query = "&stationstring=" . $country;
}

// Airport specified
if ($airport != "") {
	$airport = strtoupper($airport);
	$airport = str_replace(" ", "", $airport);

	// Radius specified
	if (is_numeric($nauticalRadius)) {

		// Convert nautical mile radius into statute mile radius
        	$statuteRadius = 1.15077945 * $nauticalRadius;

		// Flightpath mode
		if (strstr($airport, ';') == TRUE) {
			$query = "&flightpath=" . $statuteRadius. ";" . $airport;
		}

		// Radius mode
		else {
			/* Find the longitude & latitude of the first airport */
			$urlTemp = $urlInfo . "&stationstring=" . $airport;
			$domInfo = new DOMDocument();
			$domInfo->loadXML(file_get_contents($urlTemp));

			$latitudes = $domInfo->getElementsByTagName('latitude');
			if (count($latitudes) > 0) {
				$lat = $latitudes[0]->nodeValue;
				$longitudes = $domInfo->getElementsByTagName('longitude');
				$lon = $longitudes[0]->nodeValue;
				$query = "&radialDistance=" . $statuteRadius . ";" . $lon . "," . $lat;
			}
		}
	}

	// No Radius specified
	else {
		$query = "&stationstring=" . $airport;
	}
}

// Viewport was specified
if ($minLat != "") {
	$query = "&minLat=" . $minLat . "&minLon=" . $minLon . "&maxLat=" . $maxLat . "&maxLon=" . $maxLon;
}

// If no country, no airport and no viewport, get the IP-based geo location
if ( ($country == "") && ($airport == "") && ($minLat == "") ) {
	if ( ($lon == 0) && ($lat == 0) ) {
		$geoplugin = unserialize( file_get_contents('http://www.geoplugin.net/php.gp?ip=' . $_SERVER['REMOTE_ADDR']) );
		$lon = $geoplugin['geoplugin_longitude'];
		$lat = $geoplugin['geoplugin_latitude'];
	}
	$query = "&radialDistance=50" . ";" . $lon . "," . $lat;
}

// Set the info URL to access aviationweather.gov
$urlInfo .= $query;

// Get the info data
$xmlInfo = file_get_contents($urlInfo);


/* -------------------------------------------------------------------- */
/* Goal : Build the METAR and TAF urls                                  */
/* -------------------------------------------------------------------- */

// if KML or GEOJSON output requested, then ignore the history parameter
if (($output == "KML") or ($output == "GEOJSON")) {
	$history = "0";
}

if ($history == "0") {
	$urlMetar .= "&hoursBeforeNow=3&mostRecentForEachStation=constraint";
	$urlTaf .= "&hoursBeforeNow=3&mostRecentForEachStation=constraint";
}
else {
	$urlMetar .= "&hoursBeforeNow=" . $history;
	$urlTaf .= "&hoursBeforeNow=" . $history;
}

$urlMetar .= $query;
$urlTaf .= $query;


/* -------------------------------------------------------------------- */
/* Goal : Set the output transformation options                         */
/* -------------------------------------------------------------------- */

switch ($output) {
	case "HTML": 
		$transform = "wsaeroHTML.xsl";
		$contentType = "Content-Type: text/html";
		break;
	case "RSS":
		$transform = "wsaeroRSS.xsl";
		$contentType = "Content-Type: application/rss+xml";
		break;
	case "KML":
		$transform = "wsaeroKML.xsl";
		$contentType = "Content-Type: application/vnd.google-earth.kml+xml";
		break;
	case "GEOJSON":
		$transform = "wsaeroGeoJSON.xsl";
		$contentType = "Content-Type: application/geo+json";
		break;
	default:
		$contentType = "Content-Type: text/xml";
		break;
}


/* -------------------------------------------------------------------- */
/* Goal : Output the result						*/
/* -------------------------------------------------------------------- */

// Combine Info, Metar and Taf data sets into 1 xml result

$xml1 = new DOMDocument();
$xml1->loadXML($xmlInfo);
$xsl1 = new DOMDocument();
$xsl1->load('wsaero.xsl');

$xp1 = new XSLTProcessor();
$xp1->importStylesheet($xsl1);
$xp1->setParameter('', 'urlMetar', $urlMetar);
$xp1->setParameter('', 'urlTaf', $urlTaf);
$xmlTemp = $xp1->transformToXML($xml1);

// Output the result as per user format request
if ($transform == "") {
	header($contentType);
	echo $xmlTemp;
}
else {
	$xml2 = new DOMDocument();
	$xml2->loadXML($xmlTemp);
	$xsl2 = new DOMDocument();
	$xsl2->load($transform);

  	$xp2 = new XSLTProcessor();
	$xp2->importStylesheet($xsl2);

	header($contentType);
	echo $xp2->transformToXML($xml2);
}

?>
