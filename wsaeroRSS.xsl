<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" />

  <xsl:variable name="items" select="count(/results/airport)" />

  <xsl:template match="/">
    <rss version="2.0">
      <channel>
        <title>Aviation weather feed</title>
        <link>http://magnolias.duckdns.org/wsaero</link>
        <description>Aviation weather feed</description>
        <xsl:apply-templates select="/results/airport" />
      </channel>
    </rss>
  </xsl:template>

  <xsl:template match="airport[count(metar) = 0 and count(taf) = 0]">
    <xsl:if test="$items = 1">
      <item>
        <title>
          <xsl:choose>
            <xsl:when test="count(name) = 0">
              <xsl:value-of select="icao"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
            </xsl:otherwise>
          </xsl:choose>
        </title>
        <description>
          Data not found
        </description>
      </item>
    </xsl:if>
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    <item>
      <title>
        <xsl:value-of select="icao"/> - <xsl:value-of select="name"/>
      </title>
      <description>
        <xsl:apply-templates select="metar" />
        <xsl:apply-templates select="taf" />
      </description>
    </item>
  </xsl:template>

  <xsl:template match="metar">
    <xsl:text disable-output-escaping="no">&lt;br /&gt;</xsl:text>    
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="taf">
    <xsl:text disable-output-escaping="no">&lt;br /&gt;</xsl:text>    
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>
