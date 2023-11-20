<?xml version="1.0" ?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method = "text" indent = "no"/>
<xsl:strip-space elements="*"/>

<!-- Variables -->
<xsl:variable name="ACQTIMENAME">
	<xsl:value-of select="name(/PhysioData/VolumeAcquisitionDescription/Volume[1]/@*[starts-with(name(),'ACQUISITION_TIME')])"/>
</xsl:variable>

<xsl:variable name="PHYSIOTIMENAME">
	<xsl:value-of select="name(/PhysioData/PhysioStream/PMU[1]/@*[starts-with(name(),'TIME')])"/>
</xsl:variable>

<!-- Generate formatted output: BEGIN -->
<xsl:template match="PhysioData/VolumeAcquisitionDescription">
	<!-- Write the header-->
	<xsl:call-template name="_HEADER_"/>
	<xsl:call-template name="_NEWLINE_"/>

	
	<xsl:for-each select="Volume">
		<xsl:apply-templates select="@ID"/>
		<xsl:call-template name="_COL_SEPARATOR_"/>
		<xsl:apply-templates select="@*[starts-with(name(),'ACQUISITION_TIME')][1]"/>
		<xsl:call-template name="_NEWLINE_"/>
	</xsl:for-each>
</xsl:template>

<!-- Generate formatted output: END -->

<!-- Formatting templates: Entries -->
<xsl:template match="@ID">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="@ACQUISITION_TIME_TICS">
<xsl:apply-templates/>
</xsl:template>

<!-- Formatting templates: Table -->
<xsl:template name="_HEADER_">
	<xsl:text>Volume_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:choose>
		<xsl:when test="name(/PhysioData/VolumeAcquisitionDescription/Volume[1]/@*[starts-with(name(),'ACQUISITION_TIME')])='ACQUISITION_TIME_TICS'">
			<xsl:text>Time_tics</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Time_ms</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Formatting templates: Table -->
<xsl:template name="_NEWLINE_">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="_COL_SEPARATOR_">
<xsl:text> </xsl:text>
</xsl:template>

</xsl:stylesheet>