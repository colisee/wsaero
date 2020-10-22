<?php

/* Define constants */
Define("BASE_URL", "http://aviationweather.gov/adds/dataserver_current/httpparam?requestType=retrieve&format=xml");

/* Retrieve form variables */
$country = array_key_exists('country', $_GET) ? $_GET['country'] : "";
$airport = array_key_exists('airport', $_GET) ? $_GET['airport'] : "";
$nauticalRadius = array_key_exists('radius', $_GET) ? $_GET['radius'] : "";
$output = array_key_exists('output', $_GET) ? $_GET['output'] : "";
$history = array_key_exists('history', $_GET) ? $_GET['history'] : "0";
$minLat = array_key_exists('minLat', $_GET) ? $_GET['minLat'] : "";
$minLon = array_key_exists('minLon', $_GET) ? $_GET['minLon'] : "";
$maxLat = array_key_exists('maxLat', $_GET) ? $_GET['maxLat'] : "";
$maxLon = array_key_exists('maxLon', $_GET) ? $_GET['maxLon'] : "";

/* Define program variables */
$urlInfo = BASE_URL . "&datasource=stations";
$urlMetar = BASE_URL . "&datasource=metars";
$urlTaf = BASE_URL . "&datasource=tafs";
$xmlInfo = "";
$xmlMetar = "";
$xmlTaf = "";
$transform = "";


/* -------------------------------------------------------------------- */
/* Goal : Build the urls needed to access weather.aero			*/
/* -------------------------------------------------------------------- */

  /* Country */
  $country = strtoupper($country);
  $country = str_replace(" ", "", $country);
  if ($country != "") {
  	$country = "~" . $country;
	$country = str_replace(",", ",~", $country);
	$query = "&stationstring=" . $country;
  }

  /* Airport */
  $airport = strtoupper($airport);
  $airport = str_replace(" ", "", $airport);
  if ($airport != "") {

	/* Radius was specified */
	if (is_numeric($nauticalRadius)) {

		/* Convert nautical mile radius into statute mile radius */
        	$statuteRadius = 1.15077945 * $nauticalRadius;

		/* Flightpath mode */
		if (strstr($airport, ';') == TRUE) {
			$query = "&flightpath=" . $statuteRadius. ";" . $airport;
		}

		/* Radius mode */
		else {
			/* Find the longitude & latitude of the first airport */
			$urlTemp = $urlInfo . "&stationstring=" . $airport;
			$domInfo = new DOMDocument();
			$domInfo->loadXML(GetData($urlTemp));

			$latitudes = $domInfo->getElementsByTagName('latitude');
			if (count($latitudes) > 0) {
				$lat = $latitudes[0]->nodeValue;
				$longitudes = $domInfo->getElementsByTagName('longitude');
				$lon = $longitudes[0]->nodeValue;
				$query = "&radialDistance=" . $statuteRadius . ";" . $lon . "," . $lat;
			}

		}
	}

	/* No Radius specified */
	else {
		$query = "&stationstring=" . $airport;
	}
  }

  /* Viewport was specified */
  if ($minLat != "") {
	$query = "&minLat=" . $minLat . "&minLon=" . $minLon . "&maxLat=" . $maxLat . "&maxLon=" . $maxLon;
  }

  /* Set transformation */
  switch ($output) {
	case "HTML": 
		$transform = "wsaeroHTML.xsl";
		break;
	case "RSS":
		$transform = "wsaeroRSS.xsl";
		break;
	case "KML":
		$transform = "wsaeroKML.xsl";
		break;
	default:
		break;
  }

  /* if KML output requested, then ignore the history parameter */
  if ($transform == "wsaeroKML.xsl") {
	$history = "0";
  }

  /* Set the info URL to access aviationweather.gov */
  $urlInfo .= $query;

  if ($history == "0") {
	$query .= "&hoursBeforeNow=3&mostRecentForEachStation=true";
  }
  else {
	$query .= "&hoursBeforeNow=" . $history;
  }

  /* Set the metar & taf URLs to access aviationweather.gov */
  $urlMetar .= $query;
  $urlTaf .= $query;


/* -------------------------------------------------------------------- */
/* Goal : Get the data from aviationweather.gov				*/
/* -------------------------------------------------------------------- */

  $xmlInfo = GetData($urlInfo);


/* -------------------------------------------------------------------- */
/* Goal : Output the result						*/
/* -------------------------------------------------------------------- */

  /* Combine 3 data set into 1 internal xml result */

  $xml1 = new DOMDocument();
  $xml1->loadXML($xmlInfo);
  $xsl1 = new DOMDocument();
  $xsl1->load('wsaero.xsl');

  $xp1 = new XSLTProcessor();
  $xp1->importStylesheet($xsl1);
  $xp1->setParameter('', 'urlMetar', $urlMetar);
  $xp1->setParameter('', 'urlTaf', $urlTaf);
  $xmlTemp = $xp1->transformToXML($xml1);

  /* Output the final result */
  if ($transform == "") {
	header("Content-Type: text/xml");
	echo $xmlTemp;
  }
  else {
	$xml2 = new DOMDocument();
	$xml2->loadXML($xmlTemp);
	$xsl2 = new DOMDocument();
	$xsl2->load($transform);

  	$xp2 = new XSLTProcessor();
	$xp2->importStylesheet($xsl2);
/*
	if (strstr($transform, 'KML') == TRUE)
		header("Content-Type: application/vnd.google-earth.kml+xml");
	else if (strstr($transform, 'RSS') == TRUE)
		header("Content-Type: application/rss+xml");
*/
	echo $xp2->transformToXML($xml2);
  }

/* -------------------------------------------------------------------- */
/* Name : GetData							*/
/* Goal : Get the data from weather.aero				*/
/* Type : Function							*/
/* -------------------------------------------------------------------- */

function GetData($url) {

  do {
	$xml = file_get_contents($url);
  } while (!$xml);

  return($xml);

}

?>
