<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt">

  <xsl:template name="ServiceReq_Standard">

    <xsl:for-each select="BusinessObjectList/BusinessObject">

      <xsl:variable name="emailSubject"
        select="(EmailMessage/Subject, FieldList/Field[@Name='Subject'])[1]"/>

      <xsl:variable name="emailBody"
        select="(EmailMessage/Body, FieldList/Field[@Name='Body'])[1]"/>

      <xsl:variable name="profilelink_recid"
        select="RelatedBusinessObjectList/RelatedBusinessObject/BusinessObject[@Name='Employee']/FieldList/Field[@Name='RecId']"/>

      <BusinessObject Name="ServiceReq">
        <Transaction>Insert</Transaction>

        <UniqueKeyList>
          <UniqueKey>
            <Field Name="ServiceReqNumber"/>
          </UniqueKey>
        </UniqueKeyList>

        <FieldList>
          <Field Name="OwnerTeam" Type="System.String">Service Desk</Field>

          <Field Name="Subject" Type="System.String">
            <xsl:value-of select="$emailSubject"/>
          </Field>

          <Field Name="Status" Type="System.String">Submitted</Field>
          <Field Name="Source" Type="System.String">Email</Field>

          <Field Name="ProfileLink_RecID" Type="System.String">
            <xsl:value-of select="if ($profilelink_recid) then $profilelink_recid else 'UNKNOWN'"/>
          </Field>

          <Field Name="ProfileLink_Category" Type="System.String">Employee</Field>
        </FieldList>

        <RelatedBusinessObjectList>
          <RelatedBusinessObject Relationship="ServiceReqContainsServiceReqParam">
            <BusinessObject Name="ServiceReqParam">
              <Transaction>Insert</Transaction>
              <LinkTransaction>Link</LinkTransaction>

              <UniqueKeyList>
                <UniqueKey>
                  <Field Name="RecId"/>
                </UniqueKey>
              </UniqueKeyList>

              <FieldList>
                <Field Name="ParameterName">details</Field>

                <Field Name="ParameterValue">
                  <xsl:value-of select="$emailBody"/>
                </Field>

                <Field Name="ParameterDisplayValue">
                  <xsl:value-of select="$emailBody"/>
                </Field>

                <Field Name="DisplayType">text</Field>
              </FieldList>
            </BusinessObject>
          </RelatedBusinessObject>
        </RelatedBusinessObjectList>

      </BusinessObject>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>