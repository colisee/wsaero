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
	          background-color: green;
	        }
	        .MVFR {
	          background-color: blue;
	        }
	        .IFR {
	          background-color: red;
	        }
	        .LIFR {
      	    background-color: black;
	        }
	        .NA {
	          background-color: lightgrey;
	        }
        </xsl:element>
      </xsl:element>

      <xsl:element name="body">
        <xsl:attribute name="class">w3-text-blue-grey</xsl:attribute>
	      <xsl:element name="header">
          <xsl:attribute name="class">w3-container w3-blue-grey</xsl:attribute>
	        <xsl:element name="h2">Aviation weather</xsl:element>
        </xsl:element>
        <xsl:element name="ul">
          <xsl:attribute name="class">w3-ul w3-border-top w3-border-bottom</xsl:attribute> 
          <xsl:apply-templates />
        </xsl:element>
        <xsl:element name="div">
        <xsl:attribute name="class">w3-container w3-padding-16</xsl:attribute>
        <xsl:element name="table">
          <xsl:attribute name="style">text-align: left;</xsl:attribute>
          <xsl:element name="tr">
            <xsl:element name="th">Flight</xsl:element>
            <xsl:element name="th">conditions</xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:element name="span">
                <xsl:attribute name="class">w3-badge w3-small VFR</xsl:attribute>
                <xsl:text>V</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td">Visual Flight Rules</xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:element name="span">
                <xsl:attribute name="class">w3-badge w3-small MVFR</xsl:attribute>
                <xsl:text>M</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td">Marginal Visual Flight Rules</xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:element name="span">
                <xsl:attribute name="class">w3-badge w3-small IFR</xsl:attribute>
                <xsl:text>I</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td">Instrumental Flight Rules</xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:element name="span">
                <xsl:attribute name="class">w3-badge w3-small LIFR</xsl:attribute>
                <xsl:text>L</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td">Low Instrumental Flight Rules</xsl:element>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:element name="td">
              <xsl:element name="span">
                <xsl:attribute name="class">w3-badge w3-small NA</xsl:attribute>
                <xsl:text>N</xsl:text>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td">Not Available</xsl:element>
          </xsl:element>
        </xsl:element>
        </xsl:element>
	      <xsl:element name="footer">
          <xsl:attribute name="class">w3-container w3-blue-grey</xsl:attribute>
	        <xsl:element name="p">
            <xsl:text>Data provided by </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">https://aviationweather.gov</xsl:attribute>
              <xsl:text>Aviation weather</xsl:text>
            </xsl:element>
            <xsl:element name="br" />
            <xsl:element name="a">
              <xsl:attribute name="href">https://github.com/colisee/wsaero</xsl:attribute>
              <xsl:text>Source code</xsl:text>
            </xsl:element>
	        </xsl:element>
        </xsl:element>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <xsl:template match="airport[count(metar) = 0 and count(taf) = 0]">
    <xsl:if test="$items = 1">
      <xsl:element name="li">
        <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
        <xsl:element name="span">
          <xsl:attribute name="class">w3-tag w3-blue-grey</xsl:attribute>
          <xsl:value-of select="icao" />
        </xsl:element>
        <xsl:text> </xsl:text><xsl:value-of select="name" />
      </xsl:element>
      <xsl:element name="li">
        <xsl:text>Data not found</xsl:text>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="airport[count(metar) > 0 or count(taf) > 0]">
    <xsl:element name="li">
      <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
      <xsl:element name="span">
        <xsl:attribute name="class">w3-tag w3-blue-grey</xsl:attribute>
        <xsl:value-of select="icao" />
      </xsl:element>
      <xsl:text> </xsl:text><xsl:value-of select="name" />
    </xsl:element>
    <xsl:apply-templates select="./metar" />
    <xsl:apply-templates select="./taf" />
  </xsl:template>

  <xsl:template match="metar">
    <xsl:element name="li">
      <xsl:element name="span">
        <xsl:attribute name="class">w3-badge w3-small <xsl:value-of select="@flight_cat" /></xsl:attribute>
        <xsl:value-of select="substring(@flight_cat,1,1)" />
      </xsl:element>
      <xsl:text> METAR </xsl:text>
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

  <xsl:template match="taf">
    <xsl:element name="li">
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
