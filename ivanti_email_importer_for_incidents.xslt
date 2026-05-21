<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <!--
    EMAIL IMPORT ROUTER - INCIDENTS ONLY

    PURPOSE:
    This file ONLY routes incoming emails to the correct
    Incident template.

    It does NOT build the Incident itself.
  -->

  <!-- INCLUDE ALL INCIDENT TEMPLATE FILES -->
  <xsl:include href="incident_standard.xsl"/>
  <xsl:include href="incident_iam.xsl"/>
  <xsl:include href="incident_epic.xsl"/>
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">

    <!-- NORMALIZE EMAIL FROM -->
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
      select="translate(
        normalize-space(string($fromRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz'
      )" />

    <!-- NORMALIZE EMAIL SUBJECT -->
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
      select="translate(
        normalize-space(string($subjectRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz'
      )" />

    <!-- MAIN OUTPUT WRAPPER -->
    <BusinessObjectList SchemaVersion="1.0"
      xsi:noNamespaceSchemaLocation="HierarchicalObjects-1.0.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <!-- INCIDENT ROUTING LOGIC -->
      <xsl:choose>

        <!-- ROUTE: IAM INCIDENT -->
        <xsl:when test="
          ($from = 'kevin.mcgowan@hf.org')
          and contains($subject,'this is a test')
        ">
          <xsl:call-template name="incident_iam"/>
        </xsl:when>

        <!-- ROUTE: EPIC INCIDENT -->
        <xsl:when test="
          contains($subject,'network outage')
          or contains($subject,'vpn issue')
          or contains($subject,'connectivity issue')
        ">
          <xsl:call-template name="incident_epic"/>
        </xsl:when>

        <!-- ROUTE: APPLICATION INCIDENT -->
        <xsl:when test="
          contains($subject,'application error')
          or contains($subject,'app not working')
          or contains($subject,'system error')
        ">
          <xsl:call-template name="incident_itsm"/>
        </xsl:when>

        <!-- ROUTE: SECURITY INCIDENT -->
        <xsl:when test="
          contains($subject,'phishing')
          or contains($subject,'suspicious email')
          or contains($subject,'security alert')
        ">
          <xsl:call-template name="incident_security"/>
        </xsl:when>

        <!-- DEFAULT: NO MATCH -->
        <xsl:otherwise>
          <!-- No Incident created -->
        </xsl:otherwise>

      </xsl:choose>

    </BusinessObjectList>

  </xsl:template>

</xsl:stylesheet>