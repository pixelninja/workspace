<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name='ds-system-navigation-active' />
	<xsl:param name='ds-system-sub-navigation-active' />
	
	<!-- 
		Main nav wrapper 
	-->
	<xsl:template match="data" mode='navigation'>
		<xsl:param name='type' />
		
		<nav id='nav-{$type}'>
			<ol>
				<xsl:apply-templates select='system-navigation/entry/*[local-name() = $type][text() = "Yes"]/parent::entry' mode='nav-item'>
					<xsl:with-param name='type' select="$type" />
				</xsl:apply-templates>
			</ol>
		</nav>
	</xsl:template>

	<!-- Top level -->
	<xsl:template match='entry' mode='nav-item'>
		<xsl:param name='type' />
		
		<li>
			<!-- Active ? -->
			<xsl:choose>
				<xsl:when test='@id = $ds-system-navigation-active or @id = $ds-system-sub-navigation-active'>
					<xsl:attribute name="class"><xsl:value-of select='name/@handle' /> active</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select='name/@handle' /></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test='no-index = "Yes"'>
					<xsl:value-of select='name' />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select='.' mode='nav-guts' />
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>


	<!-- Common to all navigation elements (header/footer) -->
	<xsl:template match='entry' mode='nav-guts'>
		<a>
			<!-- External ? -->
			<xsl:choose>
				<xsl:when test='starts-with(link, "http")'>
					<xsl:attribute name='href'>
						<xsl:value-of select='link' />
					</xsl:attribute>
					<xsl:attribute name='rel'>
						<xsl:text>external</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name='href'>
						<xsl:choose>
							<xsl:when test='contains(link,"#")'>
								<xsl:value-of select='concat($root,link)' />
							</xsl:when>
							<xsl:when test='link = "/"'>
								<xsl:value-of select='concat($root,"/")' />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select='concat($root,link,"/")' />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- Active ? -->
			<xsl:choose>
				<xsl:when test='@id = $ds-system-navigation-active'>
					<xsl:attribute name="class"><xsl:value-of select='name/@handle' /> active</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select='name/@handle' /></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:value-of select='name' />
		</a>
	</xsl:template>
	
</xsl:stylesheet>