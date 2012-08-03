<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings" xmlns:dyn="http://exslt.org/dynamic"
 xmlns:form="http://rowanlewis.com/ns/xslt-form" extension-element-prefixes="str dyn form">
	
	
	<xsl:template match="*" mode="create-field">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@* | * | text()" mode="create-field" />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*" mode="create-field">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@role" mode="create-field" />
	
	<xsl:template match="text()" mode="create-field">
		<xsl:value-of select="." />
	</xsl:template>
	
	<xsl:template name="create-field-get-name">
		<xsl:param name="name" />
		
		<xsl:choose>
			<xsl:when test="str:tokenize($name, '[]')[1] = 'sections'">
				<xsl:for-each select="str:tokenize($name, '[]')[2]/following-sibling::*">
					<xsl:if test="position() = 1">
						<xsl:value-of select="." />
					</xsl:if>
					<xsl:if test="position() &gt; 1">
						<xsl:text>[</xsl:text>
						<xsl:value-of select="." />
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:if test="contains($name, '[]') and substring-after($name, '[]') = ''">
					<xsl:text>[]</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="create-field-get-value">
		<xsl:param name="event" />
		<xsl:param name="name" />
		
		<xsl:if test="$event and str:tokenize($name, '[]')[1]">
			<xsl:text>/values</xsl:text>
			<xsl:for-each select="str:tokenize($name, '[]')[position() &gt; 1]">
				<xsl:text>/</xsl:text>
				<xsl:choose>
					<xsl:when test="string(number(.)) != .">
						<xsl:value-of select="." />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>item[@index = </xsl:text>
						<xsl:value-of select=". + 1" />
						<xsl:text>]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="create-field-get-status">
		<xsl:param name="event" />
		<xsl:param name="name" />
		
		<xsl:if test="$event and str:tokenize($name, '[]')[1] = 'fields'">
			<xsl:for-each select="str:tokenize($name, '[]')">
				<xsl:if test="position() != 1">/</xsl:if>
				<xsl:if test="position() != 1">
					<xsl:choose>
						<xsl:when test="string(number(.)) != .">
							<xsl:value-of select="." />
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>item[@index = </xsl:text>
							<xsl:value-of select="." />
							<xsl:text>]</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
<!--
	Create error
-->
	<xsl:template name="create-error">
		<xsl:param name="status" />	

		<xsl:if test="$status/@type">
			<span class="error">
				<xsl:value-of select="$status/@message" />
			</span>
		</xsl:if>
		
		
	</xsl:template>
	
<!--
	Create checkbox
-->
	<xsl:template name="create-checkbox">
		<xsl:param name="event" />
		<xsl:param name="field" />
		
		<xsl:variable name="output">
			<xsl:apply-templates name="field"
				xmlns:exslt="http://exslt.org/common"
				select="exslt:node-set($field)/input[1]"
				mode="create-checkbox"
			>
				<xsl:with-param name="event" select="$event" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:copy-of select="$output" />
	</xsl:template>
	
	<xsl:template match="input" mode="create-checkbox">
		<xsl:param name="event" />
		
		<xsl:variable name="handle">
			<xsl:if test="str:tokenize(@name, '[]')[1] = 'fields'">
				<xsl:value-of select="str:tokenize(@name, '[]')[2]" />
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="name">
			<xsl:call-template name="create-field-get-name">
				<xsl:with-param name="name" select="@name" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="value-path">
			<xsl:call-template name="create-field-get-value">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="value" select="dyn:evaluate(concat('$event', $value-path))" />
		<xsl:variable name="status-path">
			<xsl:call-template name="create-field-get-status">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="status" select="dyn:evaluate(concat('$event', $status-path))" />
		
		<xsl:element name="input">
			<xsl:attribute name="type">checkbox</xsl:attribute>
			
			<xsl:apply-templates select="@*[name() != 'checked']" mode="create-field" />
			
			<xsl:choose>
				<xsl:when test="$value = @value">
					<xsl:attribute name="checked">
						<xsl:text>checked</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="$value != @value">
				</xsl:when>
				<xsl:when test="@checked = 'checked'">
					<xsl:attribute name="checked">
						<xsl:text>checked</xsl:text>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			
			<xsl:apply-templates select="* | text()" mode="create-field" />
		</xsl:element>
	</xsl:template>
	
<!--
	Create input
-->
	<xsl:template name="create-input">
		<xsl:param name="event" />
		<xsl:param name="field" />
		
		<xsl:variable name="output">
			<xsl:apply-templates name="field"
				xmlns:exslt="http://exslt.org/common"
				select="exslt:node-set($field)/input[1]"
				mode="create-input"
			>
				<xsl:with-param name="event" select="$event" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:copy-of select="$output" />
	</xsl:template>
	
	<xsl:template match="input" mode="create-input">
		<xsl:param name="event" />
		
		<xsl:variable name="name">
			<xsl:call-template name="create-field-get-name">
				<xsl:with-param name="name" select="@name" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="value-path">
			<xsl:call-template name="create-field-get-value">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="value" select="dyn:evaluate(concat('$event', $value-path))" />
		
		<xsl:variable name="status-path">
			<xsl:call-template name="create-field-get-status">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="status" select="dyn:evaluate(concat('$event', $status-path))" />
		
		<xsl:element name="input">
			<xsl:attribute name="maxlength">255</xsl:attribute>
			<xsl:attribute name="type">text</xsl:attribute>
			
			<xsl:apply-templates select="@*" mode="create-field" />
			
			<xsl:if test="$event and ($value or $status)">
				<xsl:attribute name="value">
					<xsl:value-of select="$value" />
				</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="* | text()" mode="create-field" />
		</xsl:element>
	</xsl:template>
	
<!--
	Create textarea
-->
	<xsl:template name="create-textarea">
		<xsl:param name="event" />
		<xsl:param name="field" />
		
		<xsl:variable name="output">
			<xsl:apply-templates name="field"
				xmlns:exslt="http://exslt.org/common"
				select="exslt:node-set($field)/textarea[1]"
				mode="create-textarea"
			>
				<xsl:with-param name="event" select="$event" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:copy-of select="$output" />
	</xsl:template>
	
	<xsl:template match="textarea" mode="create-textarea">
		<xsl:param name="event" />
		
		<xsl:variable name="handle">
			<xsl:if test="str:tokenize(@name, '[]')[1] = 'fields'">
				<xsl:value-of select="str:tokenize(@name, '[]')[2]" />
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="name">
			<xsl:call-template name="create-field-get-name">
				<xsl:with-param name="name" select="@name" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="value-path">
			<xsl:call-template name="create-field-get-value">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="value" select="dyn:evaluate(concat('$event', $value-path))" />
		<xsl:variable name="status-path">
			<xsl:call-template name="create-field-get-status">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="status" select="dyn:evaluate(concat('$event', $status-path))" />
		
		<xsl:element name="textarea">
			<xsl:apply-templates select="@*" mode="create-field" />
			
			<xsl:choose>
				<xsl:when test="$event and ($value or $status)">
					<xsl:copy-of select="$value/node()" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="* | text()" mode="create-field" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
<!--
	Create select
-->
	<xsl:template name="create-select">
		<xsl:param name="event" />
		<xsl:param name="field" />
		
		<xsl:variable name="output">
			<xsl:apply-templates name="field"
				xmlns:exslt="http://exslt.org/common"
				select="exslt:node-set($field)/select[1]"
				mode="create-select"
			>
				<xsl:with-param name="event" select="$event" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:copy-of select="$output" />
	</xsl:template>
	
	<xsl:template match="select" mode="create-select">
		<xsl:param name="event" />
		
		<xsl:variable name="handle">
			<xsl:if test="str:tokenize(@name, '[]')[1] = 'fields'">
				<xsl:value-of select="str:tokenize(@name, '[]')[2]" />
			</xsl:if>
		</xsl:variable>
		
		<xsl:element name="select">
			<xsl:apply-templates select="@*" mode="create-field" />
			
			<xsl:apply-templates select="option" mode="create-select">
				<xsl:with-param name="event" select="$event" />
				<xsl:with-param name="handle" select="$handle" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="select/option" mode="create-select">
		<xsl:param name="event" />
		<xsl:param name="handle" />
		<xsl:param name="value">
			<xsl:choose>
				<xsl:when test="@value">
					<xsl:value-of select="@value" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		
		<xsl:element name="option">
			<xsl:attribute name="value">
				<xsl:value-of select="$value" />
			</xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="
					$event and (
						$event/post-values/*[name() = $handle]
						and $value = $event/post-values/*[name() = $handle]
					)
				">
					<xsl:attribute name="selected">
						<xsl:text>selected</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@selected = 'selected' and not($event/post-values/*[name() = $handle])">
					<xsl:attribute name="selected">
						<xsl:text>selected</xsl:text>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			
			<xsl:apply-templates select="* | text()" mode="create-field" />
		</xsl:element>
	</xsl:template>
	
<!--
	Create upload
-->
	<xsl:template name="create-upload">
		<xsl:param name="event" />
		<xsl:param name="field" />

		<xsl:variable name="output">
			<xsl:apply-templates name="field"
				xmlns:exslt="http://exslt.org/common"
				select="exslt:node-set($field)/input[1]"
				mode="create-upload"
			>
				<xsl:with-param name="event" select="$event" />
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:copy-of select="$output" />
	</xsl:template>

	<xsl:template match="input" mode="create-upload">
		<xsl:param name="event" />

		<xsl:variable name="handle">
			<xsl:if test="str:tokenize(@name, '[]')[1] = 'fields'">
				<xsl:value-of select="str:tokenize(@name, '[]')[2]" />
			</xsl:if>
		</xsl:variable>

		<xsl:element name="input">
			<xsl:attribute name="type">file</xsl:attribute>

			<xsl:apply-templates select="@*" mode="create-field" />

			<xsl:if test="
				$event and (
					$event/post-values/*[name() = $handle]
					or $event/*[name() = $handle]
				)
			">
				<xsl:attribute name="value">
					<xsl:value-of select="$event/post-values/*[name() = $handle]" />
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="* | text()" mode="create-field" />
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>