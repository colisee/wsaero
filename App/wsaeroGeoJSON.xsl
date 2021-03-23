<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:output method="text" omit-xml-declaration="yes" indent="yes" encoding="UTF-8" />

  <xsl:variable name="items" select="count(/results/airport)" />

  <xsl:template match="/">
    {
      "type": "FeatureCollection",
      "features": [
      <xsl:apply-templates select="/results/airport[count(metar) > 0 or count(taf) > 0]" />
      ]
    }
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [<xsl:value-of select="longitude"/>,<xsl:value-of select="latitude"/>]
      },
      "properties": {
        "name": "<xsl:value-of select="icao"/> - <xsl:value-of select="name"/>",
        "flightCat": "<xsl:value-of select="metar/@flight_cat"/>"
        <xsl:apply-templates select="metar" />
        <xsl:apply-templates select="taf" />
      }
    }
    <xsl:if test="position() &lt; last()">,</xsl:if>
  </xsl:template>

  <xsl:template match="metar">
    ,"metar": "<xsl:value-of select="." />"
  </xsl:template>

  <xsl:template match="taf">
    ,"taf": "<xsl:value-of select="." />"
  </xsl:template>

</xsl:stylesheet>
