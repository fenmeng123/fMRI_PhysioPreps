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

<xsl:template match="/PhysioData">
	<!-- Write the header-->
	<xsl:call-template name="_HEADER_"/>
	<xsl:call-template name="_NEWLINE_"/>
	<!-- Write the volume acquisition times-->
	<xsl:for-each select="VolumeAcquisitionDescription/Volume">
		<xsl:for-each select="AnatomSlice">
			<xsl:value-of select="@*[name()=$ACQTIMENAME]"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<!-- Volume ID -->
			<xsl:value-of select="../@ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<!-- Slice ID -->
			<xsl:value-of select="@ID"/>
			<xsl:call-template name="_COL_SEPARATOR_"/>
			<!-- Write corresponding physio information-->
			<xsl:call-template name="_PHYSIO_OF_TIMEPOINT_">
				<xsl:with-param name="ACQ_TIME" select="@*[name()=$ACQTIMENAME]"/>
			</xsl:call-template>
			<xsl:call-template name="_NEWLINE_"/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>
<!-- Generate formatted output: END -->


<!-- Formatting templates: Table -->
<xsl:template name="_HEADER_">
	<xsl:choose>
		<xsl:when test="name(/PhysioData/VolumeAcquisitionDescription/Volume[1]/@*[starts-with(name(),'ACQUISITION_TIME')])='ACQUISITION_TIME_TICS'">
			<xsl:text>Time_tics</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Time_ms</xsl:text>
		</xsl:otherwise>
	</xsl:choose>                        <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>Volume_ID</xsl:text>       <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:text>Slice_ID</xsl:text>        <xsl:call-template name="_COL_SEPARATOR_"/>
	<xsl:call-template name="_PHYSIO_VALUES_HEADER_"/>
</xsl:template>

<xsl:template name="_NEWLINE_">
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="_COL_SEPARATOR_">
<xsl:text> </xsl:text>
</xsl:template>

<xsl:template name="_PHYSIO_TIME_HEADER_">
	<xsl:value-of select="name(/PhysioData/PhysioStream/PMU/@*[name=$PHYSIOTIMENAME])"/>
</xsl:template>

<xsl:template name="_PHYSIO_VALUES_HEADER_">
	<xsl:for-each select="/PhysioData/PhysioStream">
		<xsl:value-of select="$PHYSIOTIMENAME"/>
		<xsl:call-template name="_COL_SEPARATOR_"/>
		<xsl:value-of select="@TYPE"/>
		<xsl:call-template name="_COL_SEPARATOR_"/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="_PHYSIO_OF_TIMEPOINT_">
	<xsl:param name="ACQ_TIME"/>
	<xsl:for-each select="/PhysioData/PhysioStream">
		<xsl:for-each select="PMU[@*[name()=$PHYSIOTIMENAME] &lt;= $ACQ_TIME and @DATA != '']">
			<xsl:sort select="@*[name()=$PHYSIOTIMENAME][1]" order="descending"/>
			<xsl:if test="position() = 1">
				<xsl:value-of select="@*[name()=$PHYSIOTIMENAME]"/>
				<xsl:call-template name="_COL_SEPARATOR_"/>
				<xsl:value-of select="@DATA"/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="count(PMU[@*[name()=$PHYSIOTIMENAME] &lt;= $ACQ_TIME and @DATA != '']) = 0">
			<xsl:call-template name="_COL_SEPARATOR_"/>
		</xsl:if>
		<xsl:call-template name="_COL_SEPARATOR_"/>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>