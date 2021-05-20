﻿''Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)
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
Partial Public Class ClaimReviewNew
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

            If txtClaimStatus.Text = imisgen.getMessage("T_CHECKED") Then
                If CType(Session("ReviewPage"), String) = imisgen.getMessage("T_REVIEWNOT") Then
                    pnlPage.Enabled = False
                    B_SAVE.Visible = False
                    B_REVIEWED.Visible = False
                ElseIf CType(Session("ReviewPage"), String) = imisgen.getMessage("B_REVIEWED") Then
                    B_REVIEWED.Visible = False
                End If
            Else
                pnlPage.Enabled = False
                B_SAVE.Visible = False
                B_REVIEWED.Visible = False
            End If



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
        If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.ClaimReview, Page) Then
            pnlServiceDetails.Enabled = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimReview, UserID)
            pnlItemsDetails.Enabled = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimReview, UserID)

            If Not pnlServiceDetails.Enabled And Not pnlItemsDetails.Enabled Then
                B_SAVE.Visible = False
                B_REVIEWED.Visible = False
            End If
        Else
            Dim RefUrl = Request.Headers("Referer")
            Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.ClaimReview.ToString & "&retUrl=" & RefUrl)
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

        For Each row As GridViewRow In gv.Rows
            ddlStatus = CType(row.Cells(7).Controls(1), DropDownList)

            If gv.ID = "gvService" Then
                ddlStatus.DataSource = dtStatus
                ddlStatus.DataTextField = "Status"
                ddlStatus.DataValueField = "Code"
                ddlStatus.DataBind()
                ddlStatus.SelectedValue = dtSource.Rows(row.RowIndex)("ClaimServiceStatus")
            Else
                ddlStatus.DataSource = dtStatus
                ddlStatus.DataTextField = "Status"
                ddlStatus.DataValueField = "Code"
                ddlStatus.DataBind()
                ddlStatus.SelectedValue = dtSource.Rows(row.RowIndex)("ClaimItemStatus")
            End If


            ' claimvalue += if(gv.DataKeys(row.RowIndex).Values("PriceAsked") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceAsked"))
            ' approvedValue += if(gv.DataKeys(row.RowIndex).Values("PriceApproved") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceApproved"))
            valuatedValue += If(gv.DataKeys(row.RowIndex).Values("PriceValuated") Is DBNull.Value, 0, gv.DataKeys(row.RowIndex).Values("PriceValuated"))

        Next

    End Sub
    Private Function SaveClaimReview(ByVal ReviewStatus As Integer) As String
        Try
            Dim chkSaveClmReview, chkSaveClmItemsReview, chkSaveClmServicesReview As Boolean
            Dim eClaimReviewItem As New IMIS_EN.tblClaimItems
            Dim eClaimReviewServices As New IMIS_EN.tblClaimServices
            Dim AdjustFalg As Boolean

            For Each r As GridViewRow In gvItems.Rows
                If Not gvItems.DataKeys.Item(r.RowIndex).Values("ClaimItemStatus") = CType(gvItems.Rows(r.RowIndex).Cells(7).Controls(1), DropDownList).SelectedValue Then
                    eClaimReviewItem.ClaimItemStatus = CType(gvItems.Rows(r.RowIndex).Cells(7).Controls(1), DropDownList).SelectedValue
                    If eClaimReviewItem.ClaimItemStatus = 1 Then
                        eClaimReviewItem.ClaimItemID = gvItems.DataKeys.Item(r.RowIndex).Values("ClaimItemID")
                        If claim.IsItSystemRejectedItem(eClaimReviewItem) Then
                            lblMsg.Text = imisgen.getMessage("M_CANNOTPASSITEMREJECTED")
                            Return "Exit"
                        End If
                    End If
                End If

            Next
            For Each r As GridViewRow In gvService.Rows
                If Not gvService.DataKeys.Item(r.RowIndex).Values("ClaimServiceStatus") = CType(gvService.Rows(r.RowIndex).Cells(7).Controls(1), DropDownList).SelectedValue Then
                    eClaimReviewServices.ClaimServiceStatus = CType(gvService.Rows(r.RowIndex).Cells(7).Controls(1), DropDownList).SelectedValue
                    If eClaimReviewServices.ClaimServiceStatus = 1 Then
                        eClaimReviewServices.ClaimServiceID = gvService.DataKeys.Item(r.RowIndex).Values("ClaimServiceID")
                        If claim.IsItSystemRejectedService(eClaimReviewServices) Then
                            lblMsg.Text = imisgen.getMessage("M_CANNOTPASSSERVICEREJECTED")
                            Return "Exit"
                        End If
                    End If
                End If

            Next

            If ReviewStatus = 8 Then
                eClaim.ReviewStatus = 8
            End If

            If Not txtADJUSTMENTData.Attributes("InitialAdjust") = txtADJUSTMENTData.Text Then
                AdjustFalg = True
            Else
                If Not hfClaimedValue.Value = hfApprovedValue.Value Then
                    eClaim.Approved = hfApprovedValue.Value
                    claim.UpdateClaimApprovedValue(eClaim)
                End If
            End If

            If (eClaim.ReviewStatus = 8) Or (AdjustFalg = True) Then
                If Not hfClaimedValue.Value = hfApprovedValue.Value Then
                    eClaim.Approved = hfApprovedValue.Value
                End If
                'eClaim.DateProcessed = Today
                eClaim.Adjustment = IIf(txtADJUSTMENTData.Text Is Nothing, "", txtADJUSTMENTData.Text)

                eClaim.AuditUserID = imisgen.getUserId(Session("User"))
                chkSaveClmReview = claim.SaveClaimReview(eClaim)
            End If

            For Each row In gvItems.Rows
                If Not gvItems.DataKeys.Item(row.RowIndex).Values("ClaimItemStatus") = CType(gvItems.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue Then
                    eClaimReviewItem.ClaimItemStatus = CType(gvItems.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue
                    If eClaimReviewItem.ClaimItemStatus = 2 Then
                        eClaimReviewItem.RejectionReason = -1
                    Else
                        eClaimReviewItem.RejectionReason = 0
                    End If
                ElseIf Not gvItems.DataKeys.Item(row.RowIndex).Values("QtyApproved").ToString = CType(gvItems.Rows(row.rowindex).Cells(4).Controls(1), TextBox).Text Then
                ElseIf Not gvItems.DataKeys.Item(row.RowIndex).Values("PriceApproved").ToString = CType(gvItems.Rows(row.rowindex).Cells(5).Controls(1), TextBox).Text Then
                ElseIf Not gvItems.DataKeys.Item(row.RowIndex).Values("Justification").ToString = CType(gvItems.Rows(row.rowindex).Cells(6).Controls(1), TextBox).Text Then
                Else
                    Continue For
                End If

                If Not CType(row.Cells(4).Controls(1), TextBox).Text = "" Then
                    eClaimReviewItem.QtyApproved = CDec(CType(row.Cells(4).Controls(1), TextBox).Text)
                End If
                If Not CType(row.Cells(5).Controls(1), TextBox).Text = "" Then
                    eClaimReviewItem.PriceApproved = CDec(CType(row.Cells(5).Controls(1), TextBox).Text)
                End If
                eClaimReviewItem.ClaimItemStatus = CType(gvItems.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue
                eClaimReviewItem.Justification = CType(row.Cells(6).Controls(1), TextBox).Text
                eClaimReviewItem.AuditUserID = imisgen.getUserId(Session("User"))
                eClaimReviewItem.ClaimItemID = gvItems.DataKeys.Item(row.RowIndex).Values("ClaimItemID")
                eClaimReviewItem.ClaimItemStatus = CType(gvItems.Rows(row.RowIndex).Cells(7).Controls(1), DropDownList).Text
                'If eClaimReviewItem.RejectionReason Is Nothing Then
                '    Return "Exit"
                'End If
                chkSaveClmItemsReview = claim.SaveClaimItemsforReview(eClaimReviewItem)
                'Resetting the values
                eClaimReviewItem.QtyApproved = Nothing
                eClaimReviewItem.PriceApproved = Nothing
            Next

            For Each row In gvService.Rows
                If Not gvService.DataKeys.Item(row.RowIndex).Values("ClaimServiceStatus") = CType(gvService.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue Then
                    eClaimReviewServices.ClaimServiceStatus = CType(gvService.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue
                    If eClaimReviewServices.ClaimServiceStatus = 2 Then
                        eClaimReviewServices.RejectionReason = -1
                    Else
                        eClaimReviewServices.RejectionReason = 0
                    End If
                ElseIf Not gvService.DataKeys.Item(row.RowIndex).Values("QtyApproved").ToString = CType(gvService.Rows(row.rowindex).Cells(4).Controls(1), TextBox).Text Then
                ElseIf Not gvService.DataKeys.Item(row.RowIndex).Values("PriceApproved").ToString = CType(gvService.Rows(row.rowindex).Cells(5).Controls(1), TextBox).Text Then
                ElseIf Not gvService.DataKeys.Item(row.RowIndex).Values("Justification").ToString = CType(gvService.Rows(row.rowindex).Cells(6).Controls(1), TextBox).Text Then

                Else
                    Continue For
                End If
                If Not CType(row.Cells(4).Controls(1), TextBox).Text = "" Then
                    eClaimReviewServices.QtyApproved = CDec(CType(row.Cells(4).Controls(1), TextBox).Text)
                End If
                If Not CType(row.Cells(5).Controls(1), TextBox).Text = "" Then
                    eClaimReviewServices.PriceApproved = CDec(CType(row.Cells(5).Controls(1), TextBox).Text)
                End If
                eClaimReviewServices.ClaimServiceStatus = CType(gvService.Rows(row.rowindex).Cells(7).Controls(1), DropDownList).SelectedValue
                eClaimReviewServices.Justification = CType(row.Cells(6).Controls(1), TextBox).Text
                eClaimReviewServices.AuditUserID = eClaimReviewItem.AuditUserID
                eClaimReviewServices.ClaimServiceID = gvService.DataKeys.Item(row.RowIndex).Values("ClaimServiceID")
                eClaimReviewServices.ClaimServiceStatus = CType(gvService.Rows(row.RowIndex).Cells(7).Controls(1), DropDownList).Text
                'If eClaimReviewServices.RejectionReason Is Nothing Then
                '    Return "Exit"
                'End If


                chkSaveClmServicesReview = claim.SaveClaimServicesforReview(eClaimReviewServices)
                'Resetting the values
                eClaimReviewServices.QtyApproved = Nothing
                eClaimReviewServices.PriceApproved = Nothing
            Next
            AfterSaveMessage(chkSaveClmReview, chkSaveClmItemsReview, chkSaveClmServicesReview)
        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlPage, alertPopupTitle:="IMIS")
            EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return "Exit"
        End Try
        Return "Continue"
    End Function
    Private Sub B_REVIEWED_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_REVIEWED.Click
        Try
            If Not claim.IsClaimStatusChecked(eClaim) Then
                imisgen.Alert(imisgen.getMessage("M_CLMSTATUSALREADYCHANGEDBYUSER"), pnlButtons, alertPopupTitle:="IMIS")
                Return
            ElseIf claim.IsClaimReviewStatusChanged(eClaim) Then
                imisgen.Alert(imisgen.getMessage("M_CLMALREADYREVIEWEDBYUSER"), pnlButtons, alertPopupTitle:="IMIS")
                Return
            End If
            If SaveClaimReview(8) = "Exit" Then Return
        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlPage, alertPopupTitle:="IMIS")
            EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
        'Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimUUID.ToString())
        Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimID)
    End Sub

    Private Sub B_SAVE_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_SAVE.Click
        Try
            If Not claim.IsClaimStatusChecked(eClaim) Then
                imisgen.Alert(imisgen.getMessage("M_CLMSTATUSALREADYCHANGEDBYUSER"), pnlButtons, alertPopupTitle:="IMIS")
                Return
            End If
            If SaveClaimReview(Nothing) = "Exit" Then Return
        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlPage, alertPopupTitle:="IMIS")
            EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
        'Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimUUID.ToString()
        Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimID)
    End Sub
    Private Sub AfterSaveMessage(ByVal chkSaveClmReview As Boolean, ByVal chkSaveClmItemsReview As Boolean, ByVal chkSaveClmServicesReview As Boolean)

        If chkSaveClmReview = True And chkSaveClmItemsReview = False And chkSaveClmServicesReview = False Then
            Session("Msg") = imisgen.getMessage("M_CLAIMPASSEDWITHOUTCHANGE")
        ElseIf chkSaveClmReview = True And chkSaveClmItemsReview = False And chkSaveClmServicesReview = True Then
            Session("Msg") = imisgen.getMessage("M_CLAIMPASSEDWITHSERVICECHANGE")
        ElseIf chkSaveClmReview = True And chkSaveClmItemsReview = True And chkSaveClmServicesReview = False Then
            Session("Msg") = imisgen.getMessage("M_CLAIMPASSEDWITHITEMCHANGE")
        ElseIf chkSaveClmReview = True And chkSaveClmItemsReview = True And chkSaveClmServicesReview = True Then
            Session("Msg") = imisgen.getMessage("M_CLAIMPASSEDWITHSERVICEITEMCHANGES")
        ElseIf chkSaveClmReview = False And chkSaveClmItemsReview = False And chkSaveClmServicesReview = True Then
            Session("Msg") = imisgen.getMessage("M_CLMITEMNOCHANGESERVICEYES")
        ElseIf chkSaveClmReview = False And chkSaveClmItemsReview = True And chkSaveClmServicesReview = False Then
            Session("Msg") = imisgen.getMessage("M_CLMSERVICENOCHANGEITEMYES")
        ElseIf chkSaveClmReview = False And chkSaveClmItemsReview = True And chkSaveClmServicesReview = True Then
            Session("Msg") = imisgen.getMessage("M_CLMNOCHANGEITEMSERVICEYES")
        End If
    End Sub

    Private Sub B_CANCEL_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_CANCEL.Click
        'Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimUUID.ToString())
        Response.Redirect("ClaimOverview.aspx?c=" & eClaim.ClaimID)
    End Sub


End Class
