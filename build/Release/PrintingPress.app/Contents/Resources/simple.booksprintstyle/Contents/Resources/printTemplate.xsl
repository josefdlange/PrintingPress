<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" />
	
	<xsl:template match="/">
		<html>
			<head>
				<title></title>
				<style>
					body { font-family: "Georgia", sans-serif; font-size: 12px; }
					div.print_header { position: absolute; left: 50%; margin-left: -200px; width: 400px; height: 100px; text-align: center; font-size: 16pt; }
					div.book_record { padding: 20px; margin: 10px; margin-top: 15px; margin-bottom: 25px; }
					img.book_cover { height: 80px; float: right; }
					span.book_title { font-family: "Times New Roman"; font-style: italic; font-size: 14px; line-height: 16px; font-weight: bold; display: block; height: 16px; overflow: hidden; text-overflow: ellipsis; }
					span.book_authors { margin: 10px; display: inline-block; font-style: italic; font-size: 10pt; }
					span.book_isbn { margin: 10px; display: inline-block; font-size: 10pt; }
					span.book_publisher { margin: 10px; display: inline-block; font-size: 10pt; }
				</style>
			</head>
			<body>
				<xsl:apply-templates select="exportData/Book" />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="exportData/Book">
		<div class="book_record">
			<img class="book_cover">
				<xsl:attribute name="src">
					file:///private/tmp/books-export/<xsl:choose><xsl:when test="not(field[@name='coverImage'])">no-image.png</xsl:when><xsl:otherwise><xsl:value-of select="field[@name='coverImage']" /></xsl:otherwise></xsl:choose>
				</xsl:attribute>
			</img>
			<span class="book_title"><xsl:value-of select="field[@name='title']" /></span>
			<span class="book_authors">Authors: <xsl:value-of select="field[@name='authors']" /></span>
			<span class="book_publisher">Publisher: <xsl:value-of select="field[@name='publisher']" /></span>

			<span class="book_isbn">ISBN: <xsl:value-of select="field[@name='isbn']" /></span>
			<div style="clear:both;"></div>
		</div>
		<hr />
	</xsl:template>
</xsl:stylesheet>