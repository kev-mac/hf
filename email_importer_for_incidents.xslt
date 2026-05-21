<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <!--
    ================================================================
    EMAIL IMPORT ROUTER - INCIDENTS ONLY
    ================================================================
  -->

  <!-- ============================================================ -->
  <!-- INCLUDE INCIDENT TEMPLATE FILES                              -->
  <!-- ============================================================ -->

  <xsl:include href="Incident_Standard.xsl"/>
  <xsl:include href="Incident_IAM.xsl"/>
  <xsl:include href="Incident_Epic.xsl"/>
  <xsl:include href="Incident_ITSM.xsl"/>
  <xsl:include href="Incident_Security.xsl"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">

    <!-- ========================================================== -->
    <!-- NORMALIZE EMAIL FROM                                       -->
    <!-- ========================================================== -->

    <xsl:variable name="fromRaw">
      <xsl:choose>
        <xsl:when test="string(BusinessObjectList/BusinessObject/EmailMessage/From)">
          <xsl:value-of select="BusinessObjectList/BusinessObject/EmailMessage/From"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="BusinessObjectList/BusinessObject/FieldList/Field[@Name='From']"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="from"
      select="translate(normalize-space(string($fromRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz')" />

    <!-- ========================================================== -->
    <!-- NORMALIZE EMAIL SUBJECT                                    -->
    <!-- ========================================================== -->

    <xsl:variable name="subjectRaw">
      <xsl:choose>
        <xsl:when test="string(BusinessObjectList/BusinessObject/EmailMessage/Subject)">
          <xsl:value-of select="BusinessObjectList/BusinessObject/EmailMessage/Subject"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="BusinessObjectList/BusinessObject/FieldList/Field[@Name='Subject']"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="subject"
      select="translate(normalize-space(string($subjectRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz')" />

    <!-- ========================================================== -->
    <!-- OUTPUT ROOT                                                -->
    <!-- ========================================================== -->

    <BusinessObjectList SchemaVersion="1.0"
      xsi:noNamespaceSchemaLocation="HierarchicalObjects-1.0.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <!-- ======================================================== -->
      <!-- INCIDENT ROUTING LOGIC                                   -->
      <!-- ======================================================== -->

      <xsl:choose>

        <!-- ROUTE: IAM INCIDENT -->
        <xsl:when test="
          contains($subject,'this is a test')
        ">
          <xsl:call-template name="Incident_IAM"/>
        </xsl:when>

        <!-- ROUTE: EPIC INCIDENT -->
        <xsl:when test="
          contains($subject,'network outage')
          or contains($subject,'vpn issue')
          or contains($subject,'connectivity issue')
        ">
          <xsl:call-template name="Incident_Epic"/>
        </xsl:when>

        <!-- ROUTE: ITSM INCIDENT -->
        <xsl:when test="
          contains($subject,'application error')
          or contains($subject,'app not working')
          or contains($subject,'system error')
        ">
          <xsl:call-template name="Incident_ITSM"/>
        </xsl:when>

        <!-- ROUTE: SECURITY INCIDENT -->
        <xsl:when test="
          contains($subject,'phishing')
          or contains($subject,'suspicious email')
          or contains($subject,'security alert')
        ">
          <xsl:call-template name="Incident_Security"/>
        </xsl:when>

        <!-- DEFAULT: STANDARD INCIDENT -->
        <xsl:otherwise>
          <xsl:call-template name="Incident_Standard"/>
        </xsl:otherwise>

      </xsl:choose>

    </BusinessObjectList>

  </xsl:template>

</xsl:stylesheet>
