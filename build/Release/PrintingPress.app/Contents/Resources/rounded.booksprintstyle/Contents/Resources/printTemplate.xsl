<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" />
	
	<xsl:template match="/">
		<html>
			<head>
				<title>Books Printout</title>
				<style type="text/css" media="print"> body { margin: 0px; }</style>
				<style type="text/css">
					body { font-family: "HelveticaNeue-Light", sans-serif; font-size: 12px; margin: 10px; padding: 0px;}
					div.book_record { orphans: 0; widows: 0; page-break-inside: avoid; min-height: 140px; border: 3px solid #dfdfdf; padding: 10px; margin: 10px; margin-top: 0px; margin-bottom: 20px; -webkit-border-radius: 10px; }
					div.book_record * { page-break-before: avoid; page-break-after: avoid; }
					img.book_cover { width: 80px; float: right; }
					table.basicMetaTable { -webkit-border-radius: 8px; border: 2px solid #bfbfbf; margin: 5px; padding: 5px; }
					table.basicMetaTable td { padding: 2px; }
					span.book_title { font-size: 12px; line-height: 12px; max-height: 13px; overflow-y: hidden; text-overflow: ellipsis; font-weight: bold; display: block; }
					span.book_authors { display: block; font-family: "HelveticaNeue-LightItalic"; }
					span.book_illustrators { display: block; font-family: "HelveticaNeue-LightItalic"; }
					div.book_summary_container { clear:both; max-height: 52px; padding: 10px; -webkit-border-radius: 8px; margin: 5px; border: 2px solid #bfbfbf } 
					span.book_summary { display: block; font-size: 12px; line-height: 14px; max-height: 42px; overflow-y: hidden; text-overflow: ellipsis; }
					span.book_publishDate { display: block; }
					span.book_isbn { display: block; }
					span.book_publisher { display: block; font-family: "HelveticaNeue-LightItalic";  }
					span.book_editors { display: block; }
					span.book_format { display: block; }
					span.book_genre { line-height: 12px; height: 24px; overflow-y: hidden; text-overflow: ellipsis; display: block; font-family: "HelveticaNeue-LightItalic"; }
					span.book_lastMoved { display: block; }
					span.book_listName { display: block; }
					span.book_translators { display: block; }
					span.book_presentValue { display: block; }
					span.book_originalValue { display: block; }
					span.book_ASIN { display: block; }
					span.book_catalog { display: block; }
					span.book_usedPrice { display: block; }
				</style>
			</head>
			<body>
				<div class="print_header"> </div>
				<xsl:apply-templates select="exportData/Book" />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="exportData/Book">
		<div class="book_record">
			<span class="book_title"><xsl:value-of select="field[@name='title']" /></span>	
			<img class="book_cover">
				<xsl:attribute name="src">
					file:///private/tmp/books-export/<xsl:choose><xsl:when test="not(field[@name='coverImage'])">no-image.png</xsl:when><xsl:otherwise><xsl:value-of select="field[@name='coverImage']" /></xsl:otherwise></xsl:choose>
				</xsl:attribute>
			</img>
			<table class="basicMetaTable">
				<tr>
					<td>
						<span class="book_authors">Authors: <xsl:value-of select="field[@name='authors']" /></span>
					</td>
					<td>
						<span class="book_isbn">ISBN: <xsl:value-of select="field[@name='isbn']" /></span>
					</td>
					<td>
						<span class="book_originalValue">Original Value: <xsl:value-of select="field[@name='List\ Price']" /></span>
					</td>
				</tr>
				<tr>
					<td>
						<span class="book_publisher">Publisher: <xsl:value-of select="field[@name='publisher']" /></span>
					</td>
					<td>
						<span class="book_publishDate">Publish Date: <xsl:value-of select="field[@name='publishDate']" /></span>
					</td>
					<td>
						<span class="book_presentValue">Present Value: <xsl:value-of select="field[@name='Current\ Value']" /></span>
					</td>
				</tr>
				<tr>
					<td>
						<span class="book_genre">Genre: <xsl:value-of select="field[@name='genre']" /></span>
					</td>
					<td>
						<span class="book_editors">Editors: <xsl:value-of select="field[@name='editors']" /></span>
					</td>
					<td>
						<span class="book_usedPrice">Used Price: <xsl:value-of select="field[@name='Used\ Price']" /></span>
					</td>
				</tr>
			</table>
						
 
			<xsl:choose><xsl:when test="not(field[@name='book_summary'])"></xsl:when><xsl:otherwise><div class="book_summary_container"><span class="book_summary">Summary: <xsl:value-of select="field[@name='summary']" /></span></div></xsl:otherwise></xsl:choose>
			
			<!--<span class="book_format">Format: <xsl:value-of select="field[@name='format']" /></span>
			<span class="book_illustrators">Illustrators: <xsl:value-of select="field[@name='illustrators']" /></span>
			<span class="book_lastMoved">Last Moved: <xsl:value-of select="field[@name='lastMoved']" /></span>
			<span class="book_listName">List Name: <xsl:value-of select="field[@name='listName']" /></span>
			<span class="book_translators">Translators: <xsl:value-of select="field[@name='translators']" /></span>
			<span class="book_ASIN">ASIN: <xsl:value-of select="field[@name='ASIN']" /></span>
			<span class="book_catalog">Catalog: <xsl:value-of select="field[@name='Catalog']" /></span> -->
			<div style="clear:both;"></div>
		</div>
	</xsl:template>
</xsl:stylesheet>