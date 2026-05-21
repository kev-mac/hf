<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt">

  <!--
    ================================================================
    INCIDENT TEMPLATE - STANDARD INCIDENT
    ================================================================

    PURPOSE:
    This template builds a standard Incident ticket.

    It is intended to be called from the Incident email import router:

      <xsl:call-template name="incident_standard"/>

    ================================================================
  -->

  <xsl:template name="incident_standard">

    <!-- ========================================================== -->
    <!-- SOURCE EMAIL VALUES                                        -->
    <!-- ========================================================== -->

    <xsl:variable name="emailSubject"
      select="BusinessObjectList/BusinessObject/EmailMessage/Subject"/>

    <xsl:variable name="emailBody"
      select="BusinessObjectList/BusinessObject/EmailMessage/Body"/>

    <xsl:variable name="profilelink_recid"
      select="BusinessObjectList/BusinessObject/RelatedBusinessObjectList/RelatedBusinessObject/BusinessObject[@Name='Employee']/FieldList/Field[@Name='RecId']"/>

    <!-- ========================================================== -->
    <!-- CREATE INCIDENT                                            -->
    <!-- ========================================================== -->

    <xsl:for-each select="BusinessObjectList/BusinessObject">

      <BusinessObject Name="Incident">
        <Transaction>Insert</Transaction>

        <UniqueKeyList>
          <UniqueKey>
            <Field Name="IncidentNumber"/>
          </UniqueKey>
        </UniqueKeyList>

        <FieldList>

          <!-- Subject = email subject -->
          <Field Name="Subject" Type="System.String">
            <xsl:value-of select="$emailSubject"/>
          </Field>

          <!-- Symptom = email body -->
          <Field Name="Symptom" Type="System.String">
            <xsl:value-of select="$emailBody"/>
          </Field>

          <!-- Description = email body -->
          <Field Name="Description" Type="System.String">
            <xsl:value-of select="$emailBody"/>
          </Field>

          <!-- Standard Incident defaults -->
          <Field Name="Status" Type="System.String">Logged</Field>
          <Field Name="Source" Type="System.String">Email</Field>

          <!-- Contact link -->
          <Field Name="ProfileLink_RecID" Type="System.String">
            <xsl:value-of select="$profilelink_recid"/>
          </Field>

          <Field Name="ProfileLink_Category" Type="System.String">Employee</Field>

        </FieldList>

        <!-- Preserve related objects from source email import -->
        <RelatedBusinessObjectList>
          <xsl:for-each select="RelatedBusinessObjectList">
            <xsl:copy-of select="node()"/>
          </xsl:for-each>
        </RelatedBusinessObjectList>

      </BusinessObject>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>