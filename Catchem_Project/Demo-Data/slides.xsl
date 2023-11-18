<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="/Collections/Rows/Row">
			<xsl:value-of select="normalize-space(../@rowID)"/>
			<xsl:text>;</xsl:text>
				<xsl:value-of select="normalize-space(v1)"/>
			<xsl:text>;</xsl:text>
				<xsl:value-of select="normalize-space(translate(v2, '.', ''))"/>					
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>