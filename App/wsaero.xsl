<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" />

  <xsl:param name="urlMetar" />
  <xsl:param name="urlTaf" />
  <xsl:variable name="metar" select="document($urlMetar)" />
  <xsl:variable name="taf" select="document($urlTaf)" />

  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">href="wsaero.css" type="text/css"</xsl:processing-instruction>
    <results xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="wsaero.xsd">
      <xsl:apply-templates select="response/data" />
    </results>
  </xsl:template>

  <xsl:template match="data[@num_results=0]">
    <airport>
      <name>
        <xsl:text>No records</xsl:text>
      </name>
    </airport>
  </xsl:template>

  <xsl:template match="Station">
    <xsl:variable name="icao" select="./station_id" />
    <airport>
      <icao>
        <xsl:value-of select="station_id" />
      </icao>
      <name>
        <xsl:value-of select="site" />
      </name>
      <latitude>
        <xsl:value-of select="latitude" />
      </latitude>
      <longitude>
        <xsl:value-of select="longitude" />
      </longitude>
      <xsl:for-each select="$metar/response/data/METAR[station_id = $icao]">
        <xsl:element name="metar">
          <xsl:choose>
            <xsl:when test="string(./flight_category)">
              <xsl:attribute name="flight_cat"><xsl:value-of select="./flight_category" /></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="flight_cat">NA</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="./raw_text" />
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$taf/response/data/TAF[station_id = $icao]">
        <taf>
          <xsl:value-of select="./raw_text" />
        </taf>
      </xsl:for-each>
    </airport>
  </xsl:template>

</xsl:stylesheet>
