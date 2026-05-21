<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt">

  <!--
    ================================================================
    SERVICE REQUEST TEMPLATE - IDENTITY ACCESS REQUEST
    ================================================================

    PURPOSE:
    Creates a Service Request for Identity Access Requests.

    Intended to be called from the Service Request email router:

      <xsl:call-template name="SR_IdentityAccessRequest"/>

    ================================================================
  -->

  <xsl:template name="SR_IdentityAccessRequest">

    <!-- ========================================================== -->
    <!-- DEFINE VARIABLES                                           -->
    <!-- ========================================================== -->

    <xsl:variable name="emailBody"
      select="BusinessObjectList/BusinessObject/EmailMessage/Body"/>

    <xsl:variable name="emailSubject"
      select="BusinessObjectList/BusinessObject/EmailMessage/Subject"/>

    <xsl:variable name="emailSubjectID"
      select="BusinessObjectList/BusinessObject/EmailMessage/SubjectID"/>

    <xsl:variable name="emailMessageID"
      select="BusinessObjectList/BusinessObject/EmailMessage/MessageID"/>

    <!-- Extract Employee Name -->
    <xsl:variable name="CustomerName"
      select="substring-before(
        substring-after($emailBody, 'Employee: '),
        '|'
      )"/>

    <!-- Extract UID -->
    <xsl:variable name="CustomerUID"
      select="substring-before(
        substring-after($emailBody, 'UID: '),
        '|'
      )"/>

    <!-- Extract Owner Team -->
    <xsl:variable name="OwnerTeam"
      select="substring-before(
        substring-after($emailBody, 'Team Assignment: '),
        '|'
      )"/>

    <!-- Employee Profile RecID -->
    <xsl:variable name="profilelink_recid"
      select="
        BusinessObjectList
        /BusinessObject
        /RelatedBusinessObjectList
        /RelatedBusinessObject
        /BusinessObject[@Name='Employee']
        /FieldList
        /Field[@Name='RecId']
      "/>

    <!-- ========================================================== -->
    <!-- CREATE SERVICE REQUEST                                     -->
    <!-- ========================================================== -->

    <xsl:for-each select="BusinessObjectList/BusinessObject">

      <BusinessObject Name="ServiceReq">

        <Transaction>Insert</Transaction>

        <!-- ====================================================== -->
        <!-- UNIQUE KEY                                              -->
        <!-- ====================================================== -->

        <UniqueKeyList>
          <UniqueKey>
            <Field Name="ServiceReqNumber"/>
          </UniqueKey>
        </UniqueKeyList>

        <!-- ====================================================== -->
        <!-- FIELD LIST                                               -->
        <!-- ====================================================== -->

        <FieldList>

          <!-- Subject -->
          <Field Name="Subject" Type="System.String">
            Identity Access Request
          </Field>

          <!-- Email Subject ID -->
          <Field Name="emailSubjectID" Type="System.String">
            <xsl:value-of select="$emailSubjectID"/>
          </Field>

          <!-- Symptom -->
          <Field Name="Symptom" Type="System.String">
            <xsl:value-of select="$emailBody"/>
          </Field>

          <!-- Status -->
          <Field Name="Status" Type="System.String">
            Submitted
          </Field>

          <!-- Source -->
          <Field Name="Source" Type="System.String">
            Email
          </Field>

          <!-- Owner Team -->
          <Field Name="OwnerTeam" Type="System.String">
            <xsl:value-of select="$OwnerTeam"/>
          </Field>

          <!-- Profile Link -->
          <Field Name="ProfileLink_RecID" Type="System.String">
            <xsl:value-of select="$profilelink_recid"/>
          </Field>

          <Field Name="ProfileLink_Category" Type="System.String">
            Employee
          </Field>

          <!-- Contact UID -->
          <Field Name="ContactUID" Type="System.String">
            <xsl:value-of select="$CustomerUID"/>
          </Field>

          <!-- Service Request Template -->
          <Field Name="SvcReqTmplLink_RecID" Type="System.String">
            120F2E187E5D4C93BD3314FD362B28C2
          </Field>

          <!-- Service Request Subscription -->
          <Field Name="SvcReqSubscLink_RecID" Type="System.String">
            4ACAFA28D3CD49E9A5031BC8A52990D8
          </Field>

        </FieldList>

        <!-- ====================================================== -->
        <!-- SERVICE REQUEST PARAMETERS                              -->
        <!-- ====================================================== -->

        <RelatedBusinessObjectList>

          <!-- SUMMARY -->
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

                <Field Name="ParameterName">summary</Field>

                <Field Name="ParameterValue">
                  <xsl:value-of select="$emailSubject"/>
                </Field>

                <Field Name="ParameterDisplayValue">
                  <xsl:value-of select="$emailSubject"/>
                </Field>

                <Field Name="DisplayType">text</Field>

              </FieldList>

            </BusinessObject>

          </RelatedBusinessObject>

          <!-- DETAILS -->
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

          <!-- UID -->
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

                <Field Name="ParameterName">UID</Field>

                <Field Name="ParameterValue">
                  <xsl:value-of select="$CustomerUID"/>
                </Field>

                <Field Name="ParameterDisplayValue">
                  <xsl:value-of select="$CustomerUID"/>
                </Field>

                <Field Name="DisplayType">label</Field>

              </FieldList>

            </BusinessObject>

          </RelatedBusinessObject>

          <!-- REQUESTED BY -->
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

                <Field Name="ParameterName">
                  Requested_By_label
                </Field>

                <Field Name="ParameterValue">
                  <xsl:value-of select="$CustomerName"/>
                </Field>

                <Field Name="ParameterDisplayValue">
                  <xsl:value-of select="$CustomerName"/>
                </Field>

                <Field Name="DisplayType">label</Field>

              </FieldList>

            </BusinessObject>

          </RelatedBusinessObject>

        </RelatedBusinessObjectList>

      </BusinessObject>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>