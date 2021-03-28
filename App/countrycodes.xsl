<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" doctype-system="about:legacy-compat" indent="yes" />

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
        <xsl:element name="title">Aero weather - List of country codes</xsl:element>
      </xsl:element>

      <xsl:element name="body">
	    <xsl:element name="header">
          <xsl:attribute name="class">w3-container w3-blue-grey</xsl:attribute>
	      <xsl:element name="h3">Help - Country code</xsl:element>
        </xsl:element>
        <xsl:element name="div">
          <xsl:attribute name="class">w3-container w3-text-blue-grey</xsl:attribute>
          <xsl:element name="p">
             <xsl:text>List of country codes</xsl:text>
          </xsl:element>
        </xsl:element>

        <xsl:element name="table">
          <xsl:attribute name="class">w3-table-all w3-responsive</xsl:attribute>
            <xsl:element name="thead">
              <xsl:element name="tr">
                <xsl:attribute name="class">w3-blue-grey</xsl:attribute>
                <xsl:element name="th">Country name</xsl:element>
                <xsl:element name="th">Country code</xsl:element> 
              </xsl:element>
            </xsl:element>
          <xsl:apply-templates/>
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

  <xsl:template match="ISO_3166-1_Entry">
    <xsl:element name="tr">
      <xsl:element name="td">
        <xsl:value-of select="ISO_3166-1_Country_name" />
      </xsl:element>
      <xsl:element name="td">
        <xsl:value-of select="ISO_3166-1_Alpha-2_Code_element" />
      </xsl:element>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
