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
	VolumeID<xsl:call-template name="_COL_SEPARATOR_"/>SliceID<xsl:call-template name="_COL_SEPARATOR_"/><xsl:value-of select="$ACQTIMENAME"/>
	<xsl:call-template name="_NEWLINE_"/>

	<!-- Write the volume acquisition times-->
	<xsl:for-each select="Volume">
		<xsl:for-each select="AnatomSlice">
			<xsl:value-of select="../@ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="@ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="@*[name()=$ACQTIMENAME]"/>
			<xsl:call-template name="_NEWLINE_"/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>


<!-- Formatting templates: Table -->
<xsl:template name="_NEWLINE_">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="_COL_SEPARATOR_">
<xsl:text>;</xsl:text>
</xsl:template>

</xsl:stylesheet>
