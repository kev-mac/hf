<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <!--
    ================================================================
    EMAIL IMPORT ROUTER
    ================================================================

    PURPOSE:
    This file ONLY routes incoming emails to the correct
    Service Request template.

    It does NOT build the Service Request itself.

    Each separate XSL file should build ONE specific type
    of Service Request.

    EXAMPLES:
      ServiceReq_DragonDAX.xsl
      ServiceReq_Network.xsl
      ServiceReq_Hardware.xsl
      ServiceReq_Software.xsl

    ================================================================
  -->

  <!-- ============================================================ -->
  <!-- INCLUDE ALL SERVICE REQUEST TEMPLATE FILES                   -->
  <!-- ============================================================ -->

  <xsl:include href="service_request_dragon_dax.xsl"/>
  <xsl:include href="service_request_iam.xsl"/>
  <xsl:include href="service_request_identity_access.xsl"/>
  <xsl:include href="service_request_standard.xsl"/>
  
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
      select="translate(
        normalize-space(string($fromRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz'
      )" />

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
      select="translate(
        normalize-space(string($subjectRaw)),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz'
      )" />

    <!-- ========================================================== -->
    <!-- MAIN OUTPUT WRAPPER                                        -->
    <!-- ========================================================== -->

    <BusinessObjectList SchemaVersion="1.0"
      xsi:noNamespaceSchemaLocation="HierarchicalObjects-1.0.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <!-- ======================================================== -->
      <!-- ROUTING LOGIC                                            -->
      <!-- ======================================================== -->

      <xsl:choose>

        <!-- ====================================================== -->
        <!-- ROUTE: DRAGON DAX LICENSE REQUEST                      -->
        <!-- ====================================================== -->

        <xsl:when test="
          ($from = 'notify@healthfirst.exceedlms.com')
          and contains($subject,'request dragon dax license')">
          <xsl:call-template name="service_request_dragon_dax"/>
        </xsl:when>

        <!-- ====================================================== -->
        <!-- ROUTE: IAM ACCESS REQUEST                              -->
        <!-- ====================================================== -->

        <xsl:when test="contains($subject,'vpn access request')">
          <xsl:call-template name="service_request_iam"/>
        </xsl:when>

        <!-- ====================================================== -->
        <!-- ROUTE: HARDWARE REQUEST                                -->
        <!-- ====================================================== -->

        <xsl:when test="contains($subject,'hardware request')">
          <xsl:call-template name="service_request_hardware"/>
        </xsl:when>

        <!-- ====================================================== -->
        <!-- DEFAULT: NO MATCH                                      -->
        <!-- ====================================================== -->

        <xsl:otherwise>
          <xsl:call-template name="service_request_standard"/>
        </xsl:otherwise>
      
      </xsl:choose>

    </BusinessObjectList>
  </xsl:template>
</xsl:stylesheet>
