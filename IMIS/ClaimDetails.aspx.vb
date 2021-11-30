''Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)
''
''The program users must agree to the following terms:
''
''Copyright notices
''This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
''Free Software Foundation, version 3 of the License.
''This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
''MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.
''
''Disclaimer of Warranty
''There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
''holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
''limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
''performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.
''
''Limitation of Liability 
''In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
''conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
''arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
''sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
''advised of the possibility of such damages.
''
''In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.
'
' 
'

Imports System.Data.SqlClient
Partial Public Class ClaimDetails
    Inherits System.Web.UI.Page
    Private claim As New IMIS_BI.ClaimReviewBI
    Private eClaim As New IMIS_EN.tblClaim
    Protected imisgen As New IMIS_Gen
    Private valuatedValue As Decimal = 0
    Private userBI As New IMIS_BI.UserBI
    Private eClaimAdmin As New IMIS_EN.tblClaimAdmin
    Private eExtra As New Dictionary(Of String, Object)
    Private claimBI As New IMIS_BI.ClaimBI

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblMsg.Text = ""
        eClaim.ClaimID = CType(Request.QueryString("c"), Integer)
        If IsPostBack = True Then Return
        RunPageSecurity()
        Try

            claim.LoadClaim(eClaim, eExtra)
            If Not eClaim.tblHF Is Nothing Then
                lblHFCODEData.Text = If(eClaim.tblHF.HFCode Is Nothing, "", eClaim.tblHF.HFCode & " - " & eClaim.tblHF.HFName)
            End If

            If Not eClaim.tblICDCodes Is Nothing Then
                lblICDData.Text = eClaim.tblICDCodes.ICDCode & " - " & eClaim.tblICDCodes.ICDName
            End If
            Dim NSHID As String
            NSHID = eClaim.tblInsuree.CHFID
            If String.IsNullOrEmpty(NSHID) Then
                Return
            End If
            BindData(NSHID, eClaim.ClaimID, eClaim.DateTo)

            'Addition for Nepal >> Start
            If eExtra.Keys.Contains("ICDCode1") AndAlso eExtra("ICDCode1") IsNot Nothing Then
                lblICDData1.Text = eExtra("ICDCode1")
            End If
            'If eExtra.Keys.Contains("ICDCode2") AndAlso eExtra("ICDCode2") IsNot Nothing Then
            '    lblICDData2.Text = eExtra("ICDCode2")
            'End If
            'If eExtra.Keys.Contains("ICDCode3") AndAlso eExtra("ICDCode3") IsNot Nothing Then
            '    lblICDData3.Text = eExtra("ICDCode3")
            'End If
            'If eExtra.Keys.Contains("ICDCode4") AndAlso eExtra("ICDCode4") IsNot Nothing Then
            '    lblICDData4.Text = eExtra("ICDCode4")
            'End If
            If Not eClaim.VisitType Is Nothing Then
                lblVisitTypeData.Text = claim.GetVisitTypeText(eClaim.VisitType)
            End If
            'Addition for Nepal >> End
            lblCLAIMData.Text = eClaim.ClaimCode
            lblCLAIMDATEData.Text = Format(eClaim.DateClaimed, "dd/MM/yyyy")
            lblSTARTData.Text = If(eClaim.DateFrom = Nothing, "", eClaim.DateFrom)
            lblENDData.Text = If(eClaim.DateTo Is Nothing, "", eClaim.DateTo)
            Dim span As TimeSpan = eClaim.DateTo - eClaim.DateFrom
            lblTotalDays.Text = span.TotalDays
            lblDateProcessed.Text = Format(eClaim.DateProcessed, "dd/MM/yyyy")
            txtEXPLANATION.Text = If(eClaim.Explanation Is Nothing, "", eClaim.Explanation)
            txtClaimStatus.Text = claim.ReturnClaimStatus(eClaim.ClaimStatus)
            txtADJUSTMENTData.Text = If(eClaim.Adjustment Is Nothing, "", eClaim.Adjustment)
            txtADJUSTMENTData.Attributes.Add("InitialAdjust", txtADJUSTMENTData.Text)
            'If Not eClaim.tblClaimAdmin.ClaimAdminCode Is Nothing Then
            'blClaimAdminCodeData.Text = eClaim.tblClaimAdmin.ClaimAdminCode.ToString.Trim
            'End If
            If eClaim.Attachment = 0 Then
                lblAttachment.Visible = False
            End If


            If Not eClaim.GuaranteeId Is Nothing Then
                lblGuaranteeData.Text = eClaim.GuaranteeId.ToString
            End If
            lblOPDIPDData.Text = If(eClaim.CareType = "O", "OPD", "IPD")
            If eClaim.ReferFrom <> 0 Then
                lblrefer.Text = "Refered From"
                lblreferData.Text = eClaim.ReferFromData
            End If
            If eClaim.ReferTo <> 0 Then
                lblrefer.Text = "Refered To"
                lblreferData.Text = eClaim.ReferToData
            End If
            hfClaimAdminId.Value = eClaim.tblClaimAdmin.ClaimAdminId


            Dim ds As New DataSet
            ds = claim.getClaimServiceAndItems(eClaim.ClaimID)
            gvService.DataSource = ds.Tables("ClaimedServices")
            gvService.DataBind()
            completeGridFill(gvService, ds.Tables("ClaimedServices"))

            gvItems.DataSource = ds.Tables("ClaimedItems")
            gvItems.DataBind()
            completeGridFill(gvItems, ds.Tables("ClaimedItems"))
            'txtApproved.Text = approvedValue
            'txtCLAIMTOTALData.Text = claimvalue
            txtPriceVALUATEDData.Text = valuatedValue

        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlPage, alertPopupTitle:="IMIS")
            EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try

    End Sub
    Private Sub BindData(ByVal NSHI As String, ByVal CLAIMID As Integer, ByVal VISITDATETO As Date)
        FillRepeater(NSHI, CLAIMID, VISITDATETO)
        FillPolicyGrid(NSHI)
    End Sub
    Private Sub FillPolicyGrid(ByVal NSHI As String)
        If Not IsNumeric(NSHI) Then Return
        Dim dt As New DataTable
        Dim Insuree As New IMIS_BI.InsureeBI
        dt = Insuree.GetInsureeByCHFIDGrid(NSHI)
        lblFSPDATA.Text = dt.Rows(0)("ProductName")
        lblExpiryData.Text = dt.Rows(0)("ExpiryDate")
        lblStatusData.Text = dt.Rows(0)("Status")
        lblBalacneData.Text = dt.Rows(0)("Ceiling1")

        'gvPolicy.DataSource = dt
        'gvPolicy.DataBind()

    End Sub
    Private Sub FillRepeater(ByVal NSHI As String, ByVal CLAIMID As Integer, ByVal VISITDATETO As Date)
        If Not IsNumeric(NSHI) Then Return
        Dim dt As New DataTable
        Dim Insuree As New IMIS_BI.InsureeBI
        dt = Insuree.GetInsureeByCHFID(NSHI)
        Dim myDOB As DateTime
        If (dt.Rows.Count > 0) Then
            Select Case dt.Rows(0)("Gender").ToString()
                Case "M"
                    dt.Rows(0)("Gender") = "Male"
                Case "F"
                    dt.Rows(0)("Gender") = "Female"
                Case "O"
                    dt.Rows(0)("Gender") = "Other"
                Case Else
                    dt.Rows(0)("Gender") = "Other"
            End Select
            myDOB = DateTime.Parse(dt.Rows(0)("DOB"))

        End If
        rptInsuree.DataSource = dt
        rptInsuree.DataBind()
        Dim intAge As Int16 = Math.Floor(DateDiff(DateInterval.Month, DateValue(myDOB), Now()) / 12)
        For i As Integer = 0 To rptInsuree.Items.Count - 1
            Dim lblInsureeAge As Label = DirectCast(rptInsuree.Items(i).FindControl("lblInsureeAge"), Label)
            lblInsureeAge.Text = " (" + intAge.ToString() + " Years)"
        Next
        'Dim str As String = Web.Configuration.WebConfigurationManager.ConnectionStrings("IMISConnectionString").ConnectionString

        Dim LastVisit As DataTable = claim.getLastVisitDaysForReview(NSHI, CLAIMID, VISITDATETO)
        If LastVisit.Rows.Count > 0 Then
            lblLastVisit.Text = LastVisit.Rows(0)("LastDate") & " days ago"
            lblLastDays.Text = " (" & LastVisit.Rows(0)("Days") & ") ,"
            hfOldClaimID.Value = LastVisit.Rows(0)("ClaimID")
            'lnkOldClaimNew.NavigateUrl = "ClaimReviewNew.aspx?c=" & LastVisit.Rows(0)("ClaimID").ToString()
        Else
            lblLastVisit.Text = "None"
            hfOldClaimID.Value = 0
            'lnkOldClaimNew.NavigateUrl = "#"
        End If
        'lblClaimID.Text = LastVisit.Rows(0)("ClaimID")


    End Sub
    Private Sub RunPageSecurity()
        Dim UserID As Integer = imisgen.getUserId(Session("User"))
        If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.Claim, Page) Then
        Else
            Dim RefUrl = Request.Headers("Referer")
            Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.Claim.ToString & "&retUrl=" & RefUrl)
        End If
    End Sub

    Protected Sub completeGridFill(ByRef gv As GridView, ByVal dtSource As DataTable)

        Dim dtClaimed As New DataTable
        Dim Service As New IMIS_BI.MedicalServiceBI
        dtClaimed = Service.GetServiceType()

        Dim dtStatus As New DataTable
        dtStatus = claim.GetItemServiceStatus


        Dim ddl As New DropDownList
        Dim ddlStatus As New DropDownList

        'For Each row As GridViewRow In gv.Rows
        '    ddlStatus = CType(row.Cells(7).Controls(1), DropDownList)

        '    If gv.ID = "gvService" Then
        '        ddlStatus.DataSource = dtStatus
        '        ddlStatus.DataTextField = "Status"
        '        ddlStatus.DataValueField = "Code"
        '        ddlStatus.DataBind()
        '        ddlStatus.SelectedValue = dtSource.Rows(row.RowIndex)("ClaimServiceStatus")
        '    Else
        '        ddlStatus.DataSource = dtStatus
        '        ddlStatus.DataTextField = "Status"
        '        ddlStatus.DataValueField = "Code"
        '        ddlStatus.DataBind()
        '        ddlStatus.SelectedValue = dtSource.Rows(row.RowIndex)("ClaimItemStatus")
        '    End If


        '    ' claimvalue += if(gv.DataKeys(row.RowIndex).Values("PriceAsked") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceAsked"))
        '    ' approvedValue += if(gv.DataKeys(row.RowIndex).Values("PriceApproved") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceApproved"))
        '    valuatedValue += If(gv.DataKeys(row.RowIndex).Values("PriceValuated") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceValuated"))

        'Next

    End Sub


    Private Sub B_CANCEL_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_CANCEL.Click
        'Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimUUID.ToString())
        Response.Redirect("FindClaims.aspx?c=" & eClaim.ClaimID)
    End Sub


End Class
