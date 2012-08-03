<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../utilities/form-controls.xsl" />
	<xsl:import href="../utilities/format-date.xsl" />
	<xsl:import href="../utilities/images.xsl" />
	<xsl:import href="../utilities/linkahashify.xsl" />
	<xsl:import href="../utilities/navigation.xsl" />
	<xsl:import href="../utilities/output.xsl" />
	<xsl:import href="../utilities/pagination.xsl" />
	<xsl:import href="../utilities/string-replace.xsl" />
	<xsl:import href="../utilities/time-ago.xsl" />

	<xsl:output
		omit-xml-declaration="no"
		method="html"
		indent='yes'
	/>

<!--
	Global Datasources
-->
	<xsl:variable name='g-copy' select='/data/system-copy-by-page' />
	<xsl:variable name='g-seo' select='/data/system-seo/entry' />

<!--
	Constants
-->
	<xsl:variable name='is-logged-in' select='/data/events/member-login-info/@logged-in' />
	<xsl:variable name='date-output' select="'%d;%ds; %m+; %y+;'" />
	<xsl:variable name='time-output' select="'#h;:#0m;#ts;'" />
	<xsl:variable name='assets-version' select='"0"' />
	<xsl:param name="site-mode" />
	<xsl:param name="mode" />

<!--
	Title
-->
	<xsl:template match="/" mode="title">
		<xsl:choose>
			<xsl:when test='$g-seo/meta-title'>
				<xsl:value-of select='$g-seo/meta-title' />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$page-title" />
				<xsl:text> | </xsl:text>
				<xsl:value-of select="$website-name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="data" mode="title">
		<title>
			<xsl:apply-templates select="/" mode="title" />
		</title>
	</xsl:template>

<!--
	Descriptions
-->
	<xsl:template match="/" mode="descriptions">
		<meta name="description" content="{$g-seo/meta-description}" />
	</xsl:template>

	<xsl:template match="/" mode="keywords">
		<meta name="keywords">
			<xsl:attribute name="content">
				<xsl:for-each select='$g-seo/meta-keywords/item'>
					<xsl:value-of select="."/>
					<xsl:if test='following-sibling::*'>
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</meta>
	</xsl:template>

	<xsl:template match="data" mode="descriptions">
		<xsl:apply-templates select="/" mode="keywords" />
		<xsl:apply-templates select="/" mode="descriptions" />
	</xsl:template>

<!--
	Open Graph Includes
-->
	<xsl:template match="/" mode="og-includes">
		<xsl:choose>
			<xsl:when test="$g-seo/meta-title">
				<meta property="og:title" content="{$g-seo/meta-title}"/>
			</xsl:when>
			<xsl:otherwise>
				<meta property="og:title" content="{$page-title} | {$website-name}"/>
			</xsl:otherwise>
		</xsl:choose>		
		
		<meta property="og:description" content="{$g-seo/meta-description}"/>
		<meta property="og:url" content="{$current-url}"/>
		<meta property="og:type" content="website"/>
		<meta property="og:image" content="{$workspace}/assets/images/example.jpg"/>
	</xsl:template>

	<xsl:template match="data" mode="og-includes">
		<xsl:apply-templates select="/" mode="og-includes" />
	</xsl:template>

<!--
	Includes
-->
	<xsl:template match="/" mode="includes">

		<xsl:choose>
			<xsl:when test='$mode = "production"'>
				<link rel="stylesheet" href="{$workspace}/assets/css/production.min.css?v={$assets-version}" />
			</xsl:when>
			<xsl:otherwise>
				<link rel="stylesheet" type="text/css" media="screen, projection" href="{$workspace}/assets/css/reset.css" />
				<link rel="stylesheet" type="text/css" media="screen, projection" href="{$workspace}/assets/css/default.css" />
			</xsl:otherwise>
		</xsl:choose>

		<link rel="alternate" type="application/rss+xml" title="{$website-name} example Feed" href="{$root}/rss/example/" />
		<link rel="shortcut icon" href="{$root}/favicon.ico" type="image/x-icon" />
		<link rel="apple-touch-icon" href="{$root}/apple-touch-icon.png" />

		<!-- All JavaScript at the bottom, except for Modernizr which enables HTML5 elements & feature detects -->
		<script src="{$workspace}/assets/js/libs/modernizr.min.js"></script>
		<!-- Very handy script to bend IE to our will -->
		<xsl:comment>[if lte IE 8]&gt;
		&lt;script type='text/javascript' src="<xsl:value-of select='$workspace' />/assets/js/libs/selectivizr.js";&gt;&lt;/script&gt;
		&lt;![endif]</xsl:comment>
	</xsl:template>

	<xsl:template match="data" mode="includes">
		<xsl:apply-templates select="/" mode="includes" />
	</xsl:template>

<!--
	Footer Includes
-->
	<xsl:template match="/" mode="footer-includes">

		<xsl:choose>
			<xsl:when test='$mode = "production"'>
				<script type="text/javascript" src="{$workspace}/assets/js/production.min.js?v={$assets-version}"></script>
				<xsl:call-template name='analytics' />
			</xsl:when>
			<xsl:otherwise>
				<script src="{$workspace}/assets/js/common.js"></script>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='analytics'>
		<script type="text/javascript">
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', '']);
			_gaq.push(['_trackPageview']);
			_gaq.push(['_trackPageLoadTime']);

			(function(d, t) {
				var g = d.createElement(t),
				s = d.getElementsByTagName(t)[0];
				g.async = true;
				g.src = '//www.google-analytics.com/ga.js';
				s.parentNode.insertBefore(g, s);
			}(document, 'script'));
		</script>
	</xsl:template>

	<xsl:template match="data" mode="footer-includes">
		<xsl:apply-templates select="/" mode="footer-includes" />
	</xsl:template>

<!--
	Content
-->
	<xsl:template match="data" />

<!--
	Main
-->
	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!DOCTYPE html<xsl:text disable-output-escaping="yes">&gt;&#10;</xsl:text>
		<xsl:comment>[if IE 7]&gt;&lt;html id="ie" xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" class="lt10 lt9 lt8 v7"&gt;&lt;![endif]</xsl:comment>
		<xsl:comment>[if IE 8]&gt;&lt;html id="ie" xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" class="lt10 lt9 v8"&gt;&lt;![endif]</xsl:comment>
		<xsl:comment>[if IE 9]&gt;&lt;html id="ie" xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" class="lt10 v9"&gt;&lt;![endif]</xsl:comment>
		<xsl:comment>[if !IE]&gt;&lt;html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" &gt;&lt;![endif]</xsl:comment>
		
			<head charset='utf-8'>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<meta http-equiv="imagetoolbar" content="false" />
				<meta name="MSSmartTagsPreventParsing" content="true" />

				<xsl:apply-templates select="data" mode="title" />
				<xsl:apply-templates select="data" mode="descriptions" />
				<xsl:apply-templates select="data" mode="includes" />
				<xsl:apply-templates select="data" mode="og-includes" />
			</head>
			
			<body itemscope="itemscope" itemtype="http://schema.org/WebPage">
				<xsl:attribute name='id'>
					<xsl:value-of select='concat($current-page, "-page")' />
				</xsl:attribute>

				<section id="skyline">
				
				</section>

				<section id="header">
					<header>
						<h1>
							<a href='{$root}'><xsl:value-of select="$website-name" /></a>
						</h1>

						<xsl:apply-templates select='data' mode='navigation'>
							<xsl:with-param name='type' select='"menu"' />
						</xsl:apply-templates>
					</header>
				</section>
				
				<section id="content">
					<xsl:apply-templates select='data' mode='content' />
				</div>

				<section id="footer">
					<footer>
					
					</footer>
				</section>

				<!-- Grab Google CDN's jQuery. -->
				<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
				<xsl:apply-templates select="data" mode="footer-includes" />
			</body>
		<xsl:comment>[if (IE) | (!IE)]&gt;&lt;/html&gt;&lt;![endif]</xsl:comment>
	</xsl:template>

</xsl:stylesheet>