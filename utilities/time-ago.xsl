<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:math="http://exslt.org/math" extension-element-prefixes="date math">

	<xsl:template name="time-ago">
		<xsl:param name="date-and-time"/>

		<xsl:variable name="now" select="date:date-time()" />
		<xsl:variable name="minutes" select="date:seconds(date:difference($date-and-time, $now)) div 60" />
		<xsl:variable name="delta-minutes" select="floor(math:abs($minutes))" />

		<!-- Date tagging -->
		<xsl:variable name="midnight" select="date:seconds(date:difference($now, concat($today, 'T','23:59:59', $timezone))) div 60" />
		<xsl:variable name="dawn" select="date:seconds(date:difference($now, concat($today, 'T','00:00:00', $timezone))) div 60" />
		<xsl:variable name="event" select='date:day-in-week($date-and-time) - 1' />
		<xsl:variable name="today" select='date:day-in-week($now) - 1' />

		<xsl:variable name="delta-in-words">
			<xsl:choose>
				<xsl:when test="$delta-minutes &lt; 1">
					<xsl:text>less than a minute</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes = 1">
					<xsl:text>1 minute</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 45">
					<xsl:value-of select="$delta-minutes"/>
					<xsl:text> minutes</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 90">
					<xsl:text>about an hour</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 1440">
					<xsl:choose>
						<xsl:when test='floor($delta-minutes div 60) = 1'>
							<xsl:text>1 hour</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select='floor($delta-minutes div 60)' />
							<xsl:text> hours</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 2880">
					<xsl:text>one day</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 43200">
					<xsl:value-of select="round($delta-minutes div 1440)"/>
					<xsl:text> days</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 86400">
					<xsl:text> about one month</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 525600">
					<xsl:value-of select="floor($delta-minutes div 43200)"/>
					<xsl:text> months</xsl:text>
				</xsl:when>
				<xsl:when test="$delta-minutes &lt; 1051200">
					<xsl:value-of select="floor($delta-minutes div 10080)"/>
					<xsl:text> about one year</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor($delta-minutes div 525600)"/>
					<xsl:text> years</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<!--
				Negative minutes mean in the future baby
			-->
			<xsl:when test='$minutes &lt; 0'>
				<xsl:choose>
					<xsl:when test='($delta-minutes - $midnight) &lt; 1440'>
						<xsl:text>tomorrow</xsl:text>
					</xsl:when>
					<!--
						If event is less than a week away in seconds
						AND (
						- The event day is greater than the current day (Sat greater than Mon) and today isn't a Sun
						OR
						- The event is on Sun and today isn't Sun
						)
						Then the show is this week!
					-->
					<xsl:when test='$delta-minutes &lt; 10800 and (($event &gt; $today and $today != 0) or ($event = 0 and $today != 0))'>
						<xsl:text>this week</xsl:text>
					</xsl:when>
					<xsl:when test='$delta-in-words = "about one month"'>
						<xsl:text>last month</xsl:text>
					</xsl:when>
					<xsl:when test='$delta-in-words = "about one year"'>
						<xsl:text>last year</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='$delta-in-words' />
						<xsl:text> from now</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test='$delta-in-words = "one day"'>
						<xsl:text>yesterday</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='$delta-in-words' />
						<xsl:text> ago</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='isPast'>
		<xsl:param name="date-and-time"/>

		<xsl:variable name="now" select="concat($today, 'T', $current-time, ':00')" />
		<xsl:variable name="minutes" select="date:seconds(date:difference($date-and-time, $now)) div 60" />

		<xsl:choose>
			<xsl:when test='$minutes &lt; 0'>
				<xsl:text>false</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>true</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>