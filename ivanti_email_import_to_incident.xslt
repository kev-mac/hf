<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">

    <!-- =========================================================== -->
    <!-- INCOMING EMAIL 'FROM' EXTRACTION                            -->
    <!-- =========================================================== -->
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
               'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />


    <!-- =========================================================== -->
    <!-- INCOMING EMAIL 'SUBJECT' EXTRACTION                         -->
    <!-- =========================================================== -->
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
               'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />


    <!-- =========================================================== -->
    <!-- EMAIL BODY + PARSED FIELDS                                  -->
    <!-- =========================================================== -->

    <!-- Full Email Body -->
    <xsl:variable name="body"
      select="string(BusinessObjectList/BusinessObject/EmailMessage/Body)"/>

    <!-- First Name -->
    <xsl:variable name="firstRaw"
      select="substring-after($body, 'First Name: ')"/>

    <xsl:variable name="firstName"
      select="normalize-space(substring-before($firstRaw, '&#10;'))"/>

    <!-- Last Name -->
    <xsl:variable name="lastRaw"
      select="substring-after($body, 'Last Name: ')"/>

    <xsl:variable name="lastName"
      select="normalize-space(substring-before($lastRaw, '&#10;'))"/>


    <!-- =========================================================== -->
    <!-- OUTPUT ROOT                                                 -->
    <!-- =========================================================== -->
    <BusinessObjectList SchemaVersion="1.0"
      xsi:noNamespaceSchemaLocation="HierarchicalObjects-1.0.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <xsl:choose>

        <!-- ======================================================= -->
        <!-- INCIDENT ROUTING                                        -->
        <!-- ======================================================= -->
        <xsl:when test="
             ($from = 'kevin.mcgowan@hf.org')
             and contains($subject,'this is a test')
        ">

          <BusinessObject Name="Incident">
            <Transaction>Insert</Transaction>

            <UniqueKeyList>
              <UniqueKey>
                <Field Name="IncidentNumber"/>
              </UniqueKey>
            </UniqueKeyList>

            <FieldList>

              <!-- Owner team -->
              <Field Name="OwnerTeam" Type="System.String">IAM Engineering</Field>

              <!-- Subject = pulled from email subject -->
              <Field Name="Subject" Type="System.String">
                <xsl:value-of select="$subjectRaw"/>
              </Field>

              <!-- Symptom = short description of the issue (incident-specific) -->
              <Field Name="Symptom" Type="System.String">
                <xsl:value-of select="$subjectRaw"/>
              </Field>

              <!-- Description = full email body -->
              <Field Name="Description" Type="System.String">
                <xsl:value-of select="$body"/>
              </Field>

              <!-- Contact detail -->
              <Field Name="ContactDetail" Type="System.String">IAM.Management@hf.org</Field>

              <!-- Required validated fields -->
              <Field Name="ImpactedDivision" Type="System.String">CORP</Field>
              <Field Name="Status" Type="System.String">Logged</Field>
              <Field Name="Source" Type="System.String">Email</Field>

              <!-- Incident classification - customize to match your tenant's picklists -->
              <Field Name="Category" Type="System.String">Application Access</Field>
              <Field Name="Subcategory" Type="System.String">Access</Field>

              <!-- Urgency and Impact -->
              <Field Name="Urgency" Type="System.String">Work Impacted</Field>
              <Field Name="Impact" Type="System.String">Business Unit</Field>

              <!-- Contact link -->
              <Field Name="ProfileLink_RecID" Type="System.String">
                3734B48625D043B0939456EBF5B07F43
              </Field>
              <Field Name="ProfileLink_Category" Type="System.String">Employee</Field>

            </FieldList>

          </BusinessObject>

        </xsl:when>

        <!-- ======================================================= -->
        <!-- DEFAULT NO-MATCH CASE                                   -->
        <!-- ======================================================= -->
        <xsl:otherwise>
          <!-- No ticket created -->
        </xsl:otherwise>

      </xsl:choose>

    </BusinessObjectList>
  </xsl:template>

</xsl:stylesheet>
