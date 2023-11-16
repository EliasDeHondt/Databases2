<?xml version="1.0" encoding="UTF-8"?>
<!-- Van Elias De Hondt -->
<xsl:stylesheet xmlns:xsl="DEEL2 Transform">

  <xsl:template match="/">
    <xsl:for-each select="CountryList/country/city">
      <xsl:variable name="cityId" select="@city_id" />
      <xsl:variable name="cityName" select="@ci_name" />
      <xsl:variable name="latitude" select="geo/lat" />
      <xsl:variable name="longitude" select="geo/long" />
      <xsl:variable name="postalCode" select="@post" />
      <xsl:variable name="countryCode" select="../@sc" />

      <!-- SQL INSERT statement for city -->
      <xsl:text>INSERT INTO city (city_id, city_name, latitude, longitude, postal_code, country_code) VALUES (CONVERT(BINARY(16), '</xsl:text>
      <xsl:value-of select="$cityId" />
      <xsl:text>'), N'</xsl:text>
      <xsl:value-of select="$cityName" />
      <xsl:text>', </xsl:text>
      <xsl:value-of select="$latitude" />
      <xsl:text>, </xsl:text>
      <xsl:value-of select="$longitude" />
      <xsl:text>, N'</xsl:text>
      <xsl:value-of select="$postalCode" />
      <xsl:text>', N'</xsl:text>
      <xsl:value-of select="$countryCode" />
      <xsl:text>');&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
