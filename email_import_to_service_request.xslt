
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
    <!-- IMCOMING EMAIL 'SUBJECT' EXTRACTION                         -->
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
        <!-- DRAGON DAX REQUEST ROUTING                              -->
        <!-- ======================================================= -->
        <xsl:when test="
             ($from = 'notify@healthfirst.exceedlms.com')
             and contains($subject,'request dragon dax license')
        ">

          <BusinessObject Name="ServiceReq">
            <Transaction>Insert</Transaction>

            <UniqueKeyList>
              <UniqueKey>
                <Field Name="ServiceReqNumber"/>
              </UniqueKey>
            </UniqueKeyList>

            <FieldList>

              <!-- Owner team -->
              <Field Name="OwnerTeam" Type="System.String">IAM Engineering</Field>

              <!-- Subject = "Access Request DAX Copilot: First Last" -->
              <Field Name="Subject" Type="System.String">
                <xsl:text>Access Request DAX Copilot: </xsl:text>
                <xsl:value-of select="$firstName"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$lastName"/>
              </Field>

              <!-- Description = full email body -->
              <Field Name="Description" Type="System.String">
                <xsl:value-of select="$body"/>
              </Field>

              <!-- Contact detail -->
              <Field Name="ContactDetail" Type="System.String">IAM.Management@hf.org</Field>

              <!-- Required validated fields -->
              <Field Name="ImpactedDivision" Type="System.String">CORP</Field>
              <Field Name="Status" Type="System.String">Submitted</Field>
              <Field Name="Source" Type="System.String">Email</Field>

              <!-- Set Urgency and Impact -->
              <Field Name="Urgency" Type="System.String">Work Impacted</Field>
              <Field Name="Impact" Type="System.String">Business Unit</Field>

              <!-- Contact link -->
              <Field Name="ProfileLink_RecID" Type="System.String">
                3734B48625D043B0939456EBF5B07F43
              </Field>
              <Field Name="ProfileLink_Category" Type="System.String">Employee</Field>

              <!-- Template + Subscription -->
              <Field Name="SvcReqTmplLink_RecID" Type="System.String">
                C45EE8A0FDB6430E8255B3BE7CCB4F52
              </Field>
              <Field Name="SvcReqSubscLink_RecID" Type="System.String">
                3AFE5311434B4437842C1D95D6B06A40
              </Field>

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
