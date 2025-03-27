<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">
<!-- HTML output, encoding UTF-8 with indentation -->    
    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
    <!-- Extract the document number from the <title> element -->
    <xsl:variable name="docNumber" select="substring-after(tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title, 'dodis.ch/')"/>
<!-- Main template that corresponds to root of document -->
    <xsl:template match="/">
        <html>
            <head>
             <!-- Inlusion of external css stylesheet-->
                <link rel="stylesheet" type="text/css" href="https://www.dodis.ch/resources/fonts/font.css" />
                <link href="https://www.dodis.ch/resources/css/dodis.css" rel="stylesheet" type="text/css" />
                <link href="https://www.dodis.ch/resources/css/style.css" rel="stylesheet" type="text/css" />
                <meta charset="UTF-8" />
                <!-- Size problem with cell in the stylesheet: Adding a new css style but not very elegant at all -->
            </head>
            <body>
              <xsl:comment>docBegin</xsl:comment> <!-- comments docBegin et docEnd as in the goal html page -->
                <div id="document-pane" data-version="1.0">
                    <div class="content ">
                    <!-- templates for 'body' et 'footnotes' in TEI -->
                        <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
                        <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="footnotes"/>
                    </div>
                </div>
                 <xsl:comment>docEnd</xsl:comment>
            </body>
        </html>
    </xsl:template>
    <!-- Template for <tei:div> element with type='doc' attribute-->
    <xsl:template match="tei:div[@type='doc']">
        <div class="tei-div tei-div">
            <xsl:apply-templates select="node()"/>
            <!-- I use node to link relevant templates in the div. Before I specify each templates but it creates some issues -->
        </div>
    </xsl:template>
    <!-- templates for distinct main titles -->
    <xsl:template match="tei:head">
        <h1 class="tei-head6 tei-head-div">
        <xsl:apply-templates select="tei:ref"/>
        <div class="tei-title5 tei-title-main"><xsl:apply-templates select="tei:title[@type='main']"/></div>
        <h1 class="tei-title4 tei-title-sub"><xsl:apply-templates select="tei:title[@type='sub']"/></h1>
        </h1>
    </xsl:template>

    <!-- Template for main and alternative titles -->
    <xsl:template match="tei:title[@type='main']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:title[@type='sub']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Template for the reference of the dodis doc at the top of the html page -->
    <xsl:template match="tei:ref">
        <a href="{@target}" class="tei-ref3 tei-head-nr" target=""><xsl:apply-templates/></a>
    </xsl:template>
    <!-- template for part under the title, including link to dateline template and conditionnal attributes ex. 'edition'-->
    <xsl:template match="tei:opener">
        <div class="tei-opener tei-opener">
            <span class="tei-add1 tei-add-edition">
                <xsl:value-of select="tei:add[@type='edition']"/>
            </span>
            <span class="tei-add2 tei-add-opener">
                <xsl:value-of select="tei:add[not(@type)]"/>
            </span>
            <div class="tei-dateline">
                <xsl:apply-templates select="tei:dateline"/>
            </div>
        </div>
    </xsl:template>

    <!-- Template for date lines <tei:dateline> -->
    <xsl:template match="tei:dateline">
        <div class="tei-dateline tei-dateline">
        <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Template paragraph with node to browse tei:p children like attribute or table--> 
    <xsl:template match="tei:p">
        <p class="tei-p tei-p">
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

    <!-- add only the content of <add type="edition"> to a specific position -->
    <xsl:template match="tei:add[@type='edition']">
        <span class="tei-add1 tei-add-edition">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    
    <!-- add different titles in the content -->
    <xsl:template match="tei:title[@type='doc']">
        <div class="tei-title3 tei-title-doc">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:title[@type='alt']">
         <div class="tei-title7 tei-title-doc">
            <xsl:apply-templates/>
         </div>
    </xsl:template>

    <!-- Template for link entities -->
    <xsl:template match="tei:placeName">
        <a href="{@ref}" class="tei-placeName" target=""><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="tei:orgName">
         <a href="{@ref}" class="tei-orgName" target=""><xsl:apply-templates/></a>
    </xsl:template>
    
      <xsl:template match="tei:persName">
         <a href="{@ref}" class="tei-persName" target=""><xsl:apply-templates/></a>
    </xsl:template>
    <!-- template for italic -->
      <xsl:template match="tei:emph">
        <span class="tei-emph tei-emph"><xsl:apply-templates/></span>
    </xsl:template>
    
       <xsl:template match="tei:orig">
        <span class="tei-orig tei-orig"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- template for dates -->
    <xsl:template match="tei:date">
        <span class="tei-date3 tei-date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

     <!-- Template for specific character like '°', etc -->
     <xsl:template match="tei:hi">
        <span class="tei-hi1 tei-hi1">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Template for AFS cote 'CHBAR' -->
     <xsl:template match="tei:idno">
      <span class="tei-idno tei-idno">
        <xsl:apply-templates/>
      </span>
    </xsl:template>

      <!-- Inline-notes management 
    <xsl:template match="tei:note">
        <xsl:variable name="noteId" select="@xml:id"/>
        <span class="tei-note4">
            <xsl:attribute name="id">fnref_<xsl:value-of select="$noteId"/></xsl:attribute>
            <a class="note" rel="footnote" href="#fn_{$noteId}">
                <xsl:number count="tei:note" level="any" from="tei:div[@type='doc']"/>
            </a>
        </span>
    </xsl:template>
    -->

<!-- Inline-notes management -->
<xsl:template match="tei:note">
    <xsl:variable name="noteId" select="@xml:id"/>
    <span class="tei-note4" id="fnref_{$docNumber}_{$noteId}">
        <a class="note" rel="footnote" href="#fn_{$docNumber}_{$noteId}">
            <xsl:number count="tei:note" level="any" from="tei:div[@type='doc']"/>
        </a>
    </span>
</xsl:template>

    <!-- Template for displaying footnotes -->
    <xsl:template match="tei:body" mode="footnotes">
        <div class="footnotes">
            <xsl:apply-templates select="//tei:note" mode="footnote"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:ref" mode="footnote">
        <a href="{@target}" class="tei-ref7" target=""><xsl:apply-templates/></a>
    </xsl:template>
    
        <!-- Managing individual footnotes 
    <xsl:template match="tei:note[@xml:id]" mode="footnote">
        <dl class="footnote" id="fn_{@xml:id}">
            <dt class="fn-number">
                <xsl:number count="tei:note" level="any"/>
            </dt>
            <dd class="fn-content">
                <xsl:apply-templates mode="footnote"/>
                <a class="fn-back" href="#fnref_{@xml:id}">↩</a>
            </dd>
        </dl>
    </xsl:template> -->

<!-- Managing individual footnotes -->
<xsl:template match="tei:note[@xml:id]" mode="footnote">
    <dl class="footnote" id="fn_{$docNumber}_{@xml:id}">
        <dt class="fn-number">
            <xsl:number count="tei:note" level="any"/>
        </dt>
        <dd class="fn-content">
            <xsl:apply-templates mode="footnote"/>
            <!-- Ensure back reference links correctly to inline -->
            <a class="fn-back" href="#fnref_{$docNumber}_{@xml:id}">↩</a>
        </dd>
    </dl>
</xsl:template>

    <!-- Template for the tei:table -->
    <xsl:template match="tei:table">
        <table class="tei-table tei-table">
            <tbody>
                <xsl:apply-templates select="tei:row"/>
            </tbody>
        </table>
    </xsl:template>

    <!-- Template for the tei:row -->
    <xsl:template match="tei:row">
        <tr class="tei-row tei-row">
            <xsl:apply-templates select="tei:cell"/>
        </tr>
    </xsl:template>

    <!-- Template for the tei:cell -->
    <xsl:template match="tei:cell">
        <!-- add my new css style -->
        <td class="tei-cell tei-cell">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

</xsl:stylesheet> 