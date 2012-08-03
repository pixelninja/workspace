<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	Default Image, everything calls this in the end
-->
	<xsl:template match="item | image | thumbnail | poster" mode="images-single">
		<xsl:param name="jit" />
		<xsl:param name="filter" select="false()" />
		<xsl:param name="caption" select="false()" />
		<xsl:param name="alt"  />
		<xsl:param name="class" />
		<xsl:param name="style" />
		<xsl:param name="gallery" />

		<xsl:variable name='image-path'>
			<xsl:apply-templates select='.' mode='image-path-select' />
		</xsl:variable>

		<figure>
			<img>
				<!-- @src -->
				<xsl:choose>
					<xsl:when test="$filter">
						<xsl:attribute name='src'>
							<xsl:value-of select='concat($workspace, "/assets/image-jit/?filter=", $filter, "&amp;file=", $image-path)' />
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name='src'>
							<xsl:value-of select='concat($root, "/image/", $jit, $image-path)' />
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test='$alt'>
					<xsl:attribute name='class'><xsl:value-of select='$alt' /></xsl:attribute>
				</xsl:if>

				<xsl:if test='$class'>
					<xsl:attribute name='class'><xsl:value-of select='$class' /></xsl:attribute>
				</xsl:if>

				<xsl:if test='$style'>
					<xsl:attribute name='style'><xsl:value-of select='$style' /></xsl:attribute>
				</xsl:if>
			</img>
			<xsl:if test='$caption'>
				<figcaption>
					<xsl:copy-of select='$caption/*' />
				</figcaption>
			</xsl:if>
		</figure>
	</xsl:template>

<!--
	Path Select Building
-->
	<xsl:template match='*' mode='image-path-select'>
		<xsl:choose>
			<xsl:when test='image/file'>
				<xsl:value-of select="concat(image/path,'/',image/file)" />
			</xsl:when>
			<xsl:when test='image/filename'>
				<xsl:value-of select="concat(image/@path,'/',image/filename)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(@path,'/',filename)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>