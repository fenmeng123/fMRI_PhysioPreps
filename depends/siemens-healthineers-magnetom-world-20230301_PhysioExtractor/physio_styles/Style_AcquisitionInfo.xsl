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
	
	<!-- Write the volume acquisition times-->
	<xsl:for-each select="Volume">
		<xsl:for-each select="AnatomSlice">
			<xsl:value-of select="../@SET_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@ECO_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@PHS_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@REP_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@AVE_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@IDA_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@IDB_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@IDC_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@IDD_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@IDE_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="../@Slab_ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="@ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<xsl:value-of select="@*[name()=$ACQTIMENAME]"/>
			<xsl:call-template name="_NEWLINE_"/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<!-- Formatting templates: Table -->
<xsl:template name="_HEADER_">
	<xsl:text>SET_ID</xsl:text><xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>ECO_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>PHS_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>REP_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>AVE_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>IDA_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>IDB_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>IDC_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>IDD_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>IDE_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>Slab_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>Slice_ID</xsl:text> <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:choose>
		<xsl:when test="name(/PhysioData/VolumeAcquisitionDescription/Volume[1]/@*[starts-with(name(),'ACQUISITION_TIME')])='ACQUISITION_TIME_TICS'">
			<xsl:text>AcqTime_Tics</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>AcqTime_ms</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="_NEWLINE_">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="_COL_SEPARATOR_">
<xsl:text> </xsl:text>
</xsl:template>

</xsl:stylesheet>
