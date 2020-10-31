<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8" />

  <xsl:template match="/">
    <kml xmlns="http://earth.google.com/kml/2.2">
      <NetworkLink>
        <name><xsl:value-of select="/doc/airport" /></name>
        <description>Aero Weather</description>
        <Style>
          <ListStyle>
            <listItemType>check</listItemType>
            <bgColor>00ffffff</bgColor>
          </ListStyle>
        </Style>
        <Url>
          <href><xsl:value-of select="/doc/url" /></href>
          <refreshMode>onInterval</refreshMode>
          <refreshInterval>3600</refreshInterval>
        </Url>
      </NetworkLink>
    </kml>
  </xsl:template>
</xsl:stylesheet>
