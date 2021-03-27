<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" doctype-system="about:legacy-compat" indent="yes" />
  <xsl:variable name="items" select="count(/results/airport)" />

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:attribute name="lang">en</xsl:attribute> 

      <xsl:element name="head">
	<xsl:element name="meta">
          <xsl:attribute name="name">viewport</xsl:attribute>
          <xsl:attribute name="content">width=device-width, initial-scale=1</xsl:attribute>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="href">https://www.w3schools.com/w3css/4/w3.css</xsl:attribute>
        </xsl:element>
        <xsl:element name="title">Aero weather</xsl:element>
        <xsl:element name="style">
	  .VFR {
	    border-left: 5px solid MediumSeaGreen;
	  }
	  .MVFR {
	    border-left: 5px solid Blue;
	  }
	  .IFR {
	    border-left: 5px solid Red;
	  }
	  .LIFR {
	    border-left: 5px solid Black;
	  }
	  .TAF {
	    border-left: 5px solid White;
	  }
	  .ICAO {
	    font-weight: bold;
	  }
        </xsl:element>
      </xsl:element>

      <xsl:element name="body">
	<xsl:element name="header">
          <xsl:attribute name="class">w3-container w3-blue-grey</xsl:attribute>
	  <xsl:element name="h2">Aviation weather</xsl:element>
        </xsl:element>
        <xsl:element name="ul">
          <xsl:attribute name="class">w3-ul w3-border-top w3-border-bottom</xsl:attribute> 
          <xsl:apply-templates />
        </xsl:element>
        <xsl:element name="div">
          <xsl:attribute name="class">w3-container</xsl:attribute>
          <xsl:element name="p">Flight conditions:</xsl:element>
	  <xsl:element name="ul">
            <xsl:attribute name="class">w3-ul</xsl:attribute>
            <xsl:element name="li">
              <xsl:attribute name="class">VFR</xsl:attribute>
              <xsl:text>VFR : Visual Flight Rules</xsl:text>
            </xsl:element>
            <xsl:element name="li"> 
              <xsl:attribute name="class">MVFR</xsl:attribute>
              <xsl:text>MVFR: Marginal Visual Flight Rules</xsl:text>
            </xsl:element>
            <xsl:element name="li"> 
              <xsl:attribute name="class">IFR</xsl:attribute>
              <xsl:text>IFR : InstrumentFlight Rules</xsl:text>
            </xsl:element>
            <xsl:element name="li"> 
              <xsl:attribute name="class">LIFR</xsl:attribute>
              <xsl:text>LIFR: Low Instrument Flight Rules</xsl:text>
            </xsl:element>
	  </xsl:element>
	</xsl:element>
	<xsl:element name="footer">
          <xsl:attribute name="class">w3-container w3-blue-grey</xsl:attribute>
	  <xsl:element name="p">
            <xsl:text>Data provided by </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">http://weather.aero</xsl:attribute>
              <xsl:text>Weather.aero</xsl:text>
            </xsl:element>
            <xsl:element name="br" />
            <xsl:text>Developped by </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">https://colisee.github.io</xsl:attribute>
              <xsl:text>Robin Alexander</xsl:text>
            </xsl:element>
	  </xsl:element>
        </xsl:element>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <xsl:template match="airport[count(metar) = 0 and count(taf) = 0]">
    <xsl:if test="$items = 1">
      <xsl:element name="li">
        <xsl:attribute name="class">ICAO w3-sand</xsl:attribute>
        <xsl:choose>
          <xsl:when test="count(name) = 0">
            <xsl:value-of select="icao" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="icao" />
            <xsl:text> - </xsl:text>
            <xsl:value-of select="name" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="li">
        <xsl:text>Data not found</xsl:text>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    <xsl:element name="li">
      <xsl:attribute name="class">ICAO</xsl:attribute>
      <xsl:value-of select="icao" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="name" />
    </xsl:element>
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
    <xsl:element name="li">
      <xsl:attribute name="class">TAF</xsl:attribute>
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
