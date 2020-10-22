<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" doctype-system="about:legacy-compat" indent="yes" />
  <xsl:variable name="items" select="count(/results/airport)" />

  <xsl:template match="/">
    <html lang="en"> 
      <head>
	<meta name="viewport" content="width=device-width, initial-scale=1" />
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="href">https://www.w3schools.com/w3css/4/w3.css</xsl:attribute>
        </xsl:element>
        <title>Aero weather</title>

        <style>
	  .VFR {
	    border-left: 5px solid MediumSeaGreen;
	  }
	  .MVFR {
	    border-left: 5px solid Orange;
	  }
	  .IFR {
	    border-left: 5px solid Tomato;
	  }
	  .LIFR {
	    border-left: 5px solid SlateBlue;
	  }
	  .TAF {
	    border-left: 5px solid White;
	  }
	  .ICAO {
	    font-weight: bold;
	  }
        </style>

      </head>

      <body>
	<header class="w3-container w3-blue-grey">
	  <h2>Aviation weather</h2>
	</header>
        <ul class="w3-ul w3-border-top w3-border-bottom"> 
          <xsl:apply-templates />
        </ul>
        <div class="w3-container">
          <p>
	  Legend:
          </p>
	  <ul class="w3-ul">
            <li class="VFR">VFR : Visual Flight Rules conditions</li>
            <li class="MVFR">MVFR : Marginal Visual Flight Rules conditions</li>
            <li class="IFR">IFR : Instrument Flight Rules conditions</li>
            <li class="LIFR">LIFR : Low Instrument Flight Rules conditions</li>
	  </ul>
	</div>
	<footer class="w3-container w3-blue-grey">
	  <p>
          Data provided by <a href="http://weather.aero">Weather.aero</a>
          <br />
          Developped by Robin Alexander
	  </p>
        </footer>
      </body>

    </html>
  </xsl:template>

  <xsl:template match="airport[count(metar) = 0 and count(taf) = 0]">
    <xsl:if test="$items = 1">
      <li class="ICAO w3-sand">
        <xsl:choose>
          <xsl:when test="count(name) = 0">
            <xsl:value-of select="icao"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li>
        Data not found
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    <li class="ICAO">
      <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
    </li>
    <xsl:apply-templates select="./metar" />
    <xsl:apply-templates select="./taf" />
  </xsl:template>

  <xsl:template match="metar">
    <xsl:element name="li">
      <xsl:attribute name="class"><xsl:value-of select="@flight_cat" /></xsl:attribute>
      <xsl:text>METAR </xsl:text>
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

  <xsl:template match="taf">
    <li class="TAF">
      <xsl:value-of select="." />
    </li>
  </xsl:template>

</xsl:stylesheet>
