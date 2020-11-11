<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8" />

  <xsl:variable name="items" select="count(/results/airport)" />

  <xsl:template match="/">
    <kml xmlns="http://www.opengis.net/kml/2.2">
      <Document>
        <Style id="VFR">
          <IconStyle>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/grn-pushpin.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id="MVFR">
          <IconStyle>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id="IFR">
          <IconStyle>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/red-pushpin.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id="LIFR">
          <IconStyle>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/pink-pushpin.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id="NA">
          <IconStyle>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <xsl:apply-templates select="/results/airport" />
      </Document>
    </kml>
  </xsl:template>

  <xsl:template match="airport[count(metar) = 0 and count(taf) = 0]">
    <xsl:if test="$items = 1">
      <Placemark>
        <name>
          <xsl:choose>
            <xsl:when test="count(name) = 0">
              <xsl:value-of select="icao"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
            </xsl:otherwise>
          </xsl:choose>
        </name>
        <description>
          Data not found
        </description>
      </Placemark>
    </xsl:if>
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    <Placemark>
      <name>
        <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
      </name>
      <xsl:choose>
        <xsl:when test="string(metar/@flight_cat)">
          <styleUrl>#<xsl:value-of select="metar/@flight_cat"/></styleUrl>
        </xsl:when>
        <xsl:otherwise>
          <styleUrl>#NA</styleUrl>
        </xsl:otherwise>
      </xsl:choose>
      <description>
        <xsl:apply-templates select="metar" />
        <xsl:apply-templates select="taf" />
      </description>
      <Point>
        <coordinates>
          <xsl:value-of select="longitude"/>,<xsl:value-of select="latitude"/>
        </coordinates>
      </Point>
    </Placemark>
  </xsl:template>

  <xsl:template match="metar">
    <![CDATA[<p>]]>
        <xsl:value-of select="." />
    <![CDATA[</p>]]>
  </xsl:template>

  <xsl:template match="taf">
    <![CDATA[<p>]]>
      <xsl:value-of select="." />
    <![CDATA[</p>]]>
  </xsl:template>

</xsl:stylesheet>
