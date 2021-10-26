﻿Public Class ClaimOverviewSampling
    Inherits System.Web.UI.Page

    Dim ClaimsDAL As New IMIS_DAL.ClaimsDAL
    Protected imisgen As New IMIS_Gen
    Private eClaim As New IMIS_EN.tblClaimFilter
    Private Family As New IMIS_BI.FamilyBI
    Private ClaimOverviews As New IMIS_BI.ClaimOverviewBI

    Private eUsers As New IMIS_EN.tblUsers
    Dim eHF As New IMIS_EN.tblHF
    Private eClaimAdmin As New IMIS_EN.tblClaimAdmin
    Private userBI As New IMIS_BI.UserBI
    Private claimBI As New IMIS_BI.ClaimBI
    Dim ClaimUUID As Guid
    Dim ClaimID As Integer
    Dim ClaimSampleBatchId As Integer

    Private Sub FormatForm()

        Dim Adjustibility As String = ""

        'ClaimAdministrator
        Adjustibility = General.getControlSetting("ClaimAdministrator")
        lblClaimAdmin0.Visible = Not (Adjustibility = "N")
        ddlClaimAdmin.Visible = Not (Adjustibility = "N")

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblMessage.Text = ""
        txtvalue.Enabled = chkvalue.Checked
        If Not IsPostBack = True Then
            If Not HttpContext.Current.Request.QueryString("i") Is Nothing Then
                txtCHFID.Text = HttpContext.Current.Request.QueryString("i")
            Else
                txtCHFID.Text = ""
            End If

        End If
        Dim noob = ClaimsDAL.GetUserRoleID(imisgen.getUserId(Session("User")))

        'ddlClaimReviewers.Visible = False
        If Request.Form("__EVENTTARGET") = btnselectionexecute.ClientID Then
            btnSelectionExecute_Click(sender, New System.EventArgs)
        End If
        If Request.Form("__EVENTTARGET") = B_ProcessClaimStatus.ClientID Then
            B_ProcessClaimStatus_Click(sender, New System.EventArgs)
        End If

        If IsPostBack = True Then Return
        RunPageSecurity()
        FormatForm()

        If Request.QueryString("c") IsNot Nothing Then
            'ClaimUUID = Guid.Parse(Request.QueryString("c"))
            'ClaimID = If(ClaimUUID.Equals(Guid.Empty), 0, claimBI.GetClaimIdByUUID(ClaimUUID))            
            ClaimID = If(ClaimUUID.Equals(Guid.Empty), 0, Request.QueryString("c"))
        End If
        If Request.QueryString("ClaimSampleBatchId") IsNot Nothing Then
            ClaimSampleBatchId = Convert.ToInt32(Request.QueryString("ClaimSampleBatchId"))
            txtClaimSampleBatchID.Text = ClaimSampleBatchId
        End If


        Try
            Dim UserID As Integer
            UserID = imisgen.getUserId(Session("User"))

            Dim dtRegions As DataTable = ClaimOverviews.GetRegions(imisgen.getUserId(Session("User")), True)
            ddlRegion.DataSource = dtRegions
            ddlRegion.DataValueField = "RegionId"
            ddlRegion.DataTextField = "RegionName"
            ddlRegion.DataBind()
            If dtRegions.Rows.Count = 1 Then
                FillDistrict()
            End If
            ' add by Purushottam Sapkota
            ddlGender.DataSource = Family.GetGender
            ddlGender.DataValueField = "Code"
            ddlGender.DataTextField = "Gender"
            ddlGender.DataBind()
            txtMinAmount.Text = 0
            txtMaxAmount.Text = 1000000
            ' add by Purushottam Sapkota

            ddlselectiontype.DataSource = ClaimOverviews.GetReviewSelection(True)
            ddlselectiontype.DataTextField = "ReviewText"
            ddlselectiontype.DataValueField = "ReviewCode"
            ddlselectiontype.DataBind()

            ddlFBStatus.DataSource = ClaimOverviews.GetFeedbackStatus()
            ddlFBStatus.DataTextField = "Status"
            ddlFBStatus.DataValueField = "Code"
            ddlFBStatus.DataBind()
            Dim dtReviewStatus As DataTable = ClaimOverviews.GetReviewStatus()
            ddlReviewStatus.DataSource = dtReviewStatus
            ddlReviewStatus.DataTextField = "Status"
            ddlReviewStatus.DataValueField = "Code"
            ddlReviewStatus.DataBind()

            ddlClaimStatus.DataSource = ClaimOverviews.GetClaimStatus(61)
            ddlClaimStatus.DataTextField = "Status"
            ddlClaimStatus.DataValueField = "Code"
            ddlClaimStatus.DataBind()
            ddlClaimStatus.SelectedValue = 4 'Checked default selected Item
            'ddlICD.DataSource = ClaimOverviews.GetICDCodes(True)
            'ddlICD.DataTextField = "ICDNAMES"
            'ddlICD.DataValueField = "ICDID"
            'ddlICD.DataBind()

            FillClaimSampleBatch(imisgen.getUserId(Session("User")))
            FillReviewers()
            FillVisitTypes()

            HFCodeAndBatchRunBinding(UserID)
            If ddlHFCode.Items.Count = 1 Then
                txtHFName.Enabled = False
            End If
            '  ClaimCodeTxtControl()
            ButtonDisplayControl(0)

            If eHF.HfID = 0 And ClaimID = 0 And ClaimSampleBatchId = 0 Then
                Exit Sub
            End If
            loadGrid()

        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
    End Sub
    Private Sub FillDistrict()
        ddlDistrict.DataSource = ClaimOverviews.GetDistricts(imisgen.getUserId(Session("User")), True, ddlRegion.SelectedValue)
        ddlDistrict.DataValueField = "DistrictId"
        ddlDistrict.DataTextField = "DistrictName"
        ddlDistrict.DataBind()
    End Sub

    Private Sub FillClaimSampleBatch(UserID)
        ddlClaimSampleBatch.DataSource = ClaimOverviews.GetClaimSampleBatches(UserID)
        ddlClaimSampleBatch.DataValueField = "Value"
        ddlClaimSampleBatch.DataTextField = "Text"
        ddlClaimSampleBatch.DataBind()
    End Sub
    'reviewers'
    Private Sub FillReviewers()
        ddlClaimReviewers.DataSource = ClaimOverviews.GetClaimReviewers()
        ddlClaimReviewers.DataValueField = "UserID"
        ddlClaimReviewers.DataTextField = "Name"
        ddlClaimReviewers.DataBind()
    End Sub

    Private Sub FillVisitTypes()
        ddlVisitType.DataSource = ClaimOverviews.GetVisitTypes(True)
        ddlVisitType.DataValueField = "Code"
        ddlVisitType.DataTextField = "Visit"
        ddlVisitType.DataBind()
    End Sub

    Private Sub FillHF(ByVal UserID As Integer)
        Dim LocationId As Integer = 0
        If Val(ddlDistrict.SelectedValue) > 0 Then
            LocationId = Val(ddlDistrict.SelectedValue)
        ElseIf Val(ddlRegion.SelectedValue) > 0 Then
            LocationId = Val(ddlRegion.SelectedValue)
        End If

        ddlHFCode.DataSource = ClaimOverviews.GetHFCodes(UserID, LocationId)
        ddlHFCode.DataValueField = "HfID"
        ddlHFCode.DataTextField = "HFCODE"
        ddlHFCode.DataBind()
        If Request.QueryString("c") = "c" Then
            If IsPostBack = False Then
                ddlHFCode.SelectedValue = CType(Session("HFID"), Integer)
                ''''Clear HFID session
                Session.Remove("HFID")
            End If
        End If

    End Sub

    Private Sub HFCodeAndBatchRunBinding(ByVal UserID As Integer)
        FillHF(UserID)

        If Not Val(ddlDistrict.SelectedValue) = 0 Then
            ddlBatchRun.Enabled = True
            ddlBatchRun.DataSource = ClaimOverviews.GetBatchRun(ddlDistrict.SelectedValue)

            ddlBatchRun.DataTextField = "Batch"
            ddlBatchRun.DataValueField = "RunID"
            ddlBatchRun.DataBind()
        Else
            ddlBatchRun.Enabled = False
        End If

        FillClaimAdminCodes()
    End Sub
    Private Sub FillClaimAdminCodes()
        Dim HFID As Integer = 0
        If ddlHFCode.SelectedIndex > -1 Then HFID = ddlHFCode.SelectedValue
        ddlClaimAdmin.DataSource = ClaimOverviews.GetHFClaimAdminCodes(HFID, True)
        ddlClaimAdmin.DataTextField = "Description"
        ddlClaimAdmin.DataValueField = "ClaimAdminID"
        ddlClaimAdmin.DataBind()
    End Sub
    Private Sub RunPageSecurity(Optional ByVal which As Integer = 0)
        Dim RoleID As Integer = imisgen.getRoleId(Session("User"))
        Dim UserID As Integer = imisgen.getUserId(Session("User"))
        Dim RefUrl = Request.Headers("Referer")

        If which = 0 Then
            If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.ClaimOverview, Page) Then
                btnUpdateClaims.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimUpdate, UserID)
                B_ProcessClaimStatus.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimProcess, UserID)
                pnlMiddle.Enabled = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimUpdate, UserID)
                B_FEEDBACK.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimFeedback, UserID)
                B_REVIEW.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimReview, UserID)
                btnSearch.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.ClaimSearch, UserID)

                If Not btnUpdateClaims.Visible And Not B_ProcessClaimStatus.Visible Then
                    pnlBody.Enabled = False
                End If
                btnSelectionExecute.Visible = btnUpdateClaims.Visible

            Else
                Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.ClaimOverview.ToString & "&retUrl=" & RefUrl)
            End If
        ElseIf which = 1 Then
            If Not ClaimOverviews.checkRights(IMIS_EN.Enums.Rights.ClaimUpdate, UserID) Then
                Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.ClaimOverview.ToString & "&retUrl=" & RefUrl)
            End If
        ElseIf which = 2 Then
            If Not ClaimOverviews.checkRights(IMIS_EN.Enums.Rights.ClaimProcess, UserID) Then
                Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.ClaimOverview.ToString & "&retUrl=" & RefUrl)
            End If
        End If
    End Sub
    Private Sub FilterStatusCombination(ByRef dropDownlst As DropDownList)
        Dim Index = dropDownlst.SelectedIndex - 1
        For x As Integer = 0 To Index
            dropDownlst.Items.RemoveAt(0)
        Next
        If dropDownlst.SelectedValue = 4 Then
            For x As Integer = 0 To 1
                dropDownlst.Items.RemoveAt(1)
            Next
        ElseIf dropDownlst.SelectedValue = 8 Then
            dropDownlst.Items.RemoveAt(1)
        ElseIf dropDownlst.SelectedValue = 2 Then
            For x As Integer = 0 To 1
                dropDownlst.Items.RemoveAt(2)
            Next
        ElseIf dropDownlst.SelectedValue = 1 Then
            For x As Integer = 0 To 1
                dropDownlst.Items.RemoveAt(3)
            Next
        End If
    End Sub
    Protected Sub completeGridFill(ByRef gv As GridView)
        Dim dt As New DataTable
        Dim dt2 As New DataTable

        dt = ClaimOverviews.GetReviewStatus(31)
        dt2 = ClaimOverviews.GetFeedbackStatus(31)
        Dim ddl, ddl2 As New DropDownList

        Dim duplicateCHFIDCheck As String = ""
        For Each row As GridViewRow In gv.Rows
            ddl = CType(row.Cells(5).Controls(1), DropDownList)
            ddl.DataSource = dt
            ddl.DataTextField = "Status"
            ddl.DataValueField = "Code"
            ddl.DataBind()
            ddl.SelectedValue = gvClaims.DataKeys(row.RowIndex).Values("ReviewStatus")

            FilterStatusCombination(ddl)


            ddl2 = CType(row.Cells(4).Controls(1), DropDownList)
            ddl2.DataSource = dt2
            ddl2.DataTextField = "Status"
            ddl2.DataValueField = "Code"
            ddl2.DataBind()
            ddl2.SelectedValue = gvClaims.DataKeys(row.RowIndex).Values("FeedbackStatus")
            'Start of color coding by Nirmal
            Dim claimAmount As Double
            claimAmount = Convert.ToDouble(row.Cells(6).Text)
            If claimAmount >= 5000 Then
                row.BackColor = System.Drawing.Color.FromArgb(255, 170, 255)
            End If
            Dim ImgClaimDocumentURL = CType(row.Cells(12).Controls(1), Image)
            'ImgClaimDocumentURL.ImageUrl = System.Configuration.ConfigurationManager.AppSettings("ClaimDocumentURL").ToString() + row.Cells(10).Text.ToString()
            ImgClaimDocumentURL.ImageUrl = "Images/blank.png"
            If row.Cells(13).Text.ToString = "True" Then
                ImgClaimDocumentURL.ImageUrl = "Images/attach.png"
            End If
            If String.Equals(row.Cells(1).Text, duplicateCHFIDCheck) Then
                row.BackColor = System.Drawing.Color.FromArgb(170, 255, 200)
                gv.Rows(row.RowIndex - 1).BackColor = System.Drawing.Color.FromArgb(170, 255, 200)
            End If
            duplicateCHFIDCheck = row.Cells(1).Text
            'End of color coding by Nirmal
            FilterStatusCombination(ddl2)
        Next
    End Sub
    Private Sub loadGrid() Handles gvClaims.PageIndexChanged, btnSearch.Click
        Try
            Dim eICDCodes As New IMIS_EN.tblICDCodes
            Dim eInsuree As New IMIS_EN.tblInsuree
            Dim eBatchRun As New IMIS_EN.tblBatchRun

            If (Not ClaimID = 0) And (ScriptManager.GetCurrent(Me.Page).IsInAsyncPostBack() = False) Then

                hfClaimID.Value = ClaimID

                Dim dic As New Dictionary(Of String, String)
                If Not Session("ClaimOverviewCriteria") Is Nothing Then
                    dic = CType(Session("ClaimOverviewCriteria"), Dictionary(Of String, String))
                End If

                eClaim.LegacyID = Val(dic("LocationId")) 'Used as a carrier for DistrictID
                eHF.HfID = dic("HFID")
                eClaim.FeedbackStatus = dic("FeedbackStatus")
                eClaim.ReviewStatus = dic("ReviewStatus")
                eClaim.ClaimStatus = dic("ClaimStatus")
                If dic("ICDID") <> "" Then
                    eICDCodes.ICDID = dic("ICDID")
                End If


                If Not dic("CHFNo") = "" Then
                    eInsuree.CHFID = dic("CHFNo")
                End If
                If Not dic("VisitDateTo") = "" Then
                    eClaim.DateTo = Date.Parse(dic("VisitDateTo"))
                End If

                If Not dic("VisitDateFrom") = "" Then
                    eClaim.DateFrom = Date.Parse(dic("VisitDateFrom"))
                End If
                If Not dic("ClaimedDateFrom") = "" Then
                    eClaim.DateClaimed = Date.Parse(dic("ClaimedDateFrom"))
                End If

                If Not dic("ClaimedDateTo") = "" Then
                    eClaim.DateProcessed = Date.Parse(dic("ClaimedDateTo")) 'Used as a carrier for ClaimedDate to range 
                End If
                If Not dic("HFName") = "" Then
                    eHF.HFName = dic("HFName")
                End If
                If Not dic("BatchRun") = "" Then
                    eBatchRun.RunID = dic("BatchRun")
                End If
                If Not dic("ClaimCode") = "" Then
                    eClaim.ClaimCode = dic("ClaimCode")
                End If
                If dic("ClaimAdminID") IsNot Nothing Then
                    If dic("ClaimAdminID").Trim <> String.Empty Then
                        eClaimAdmin.ClaimAdminId = dic("ClaimAdminID")
                    End If
                End If
                If dic("VisitType") IsNot Nothing AndAlso dic("VisitType").Trim <> String.Empty Then
                    eClaim.VisitType = dic("VisitType")
                End If
                ' puru
                If Not dic("Min") = "" Then
                    eClaim.Claimed = dic("Min")
                End If
                If Not dic("Max") = "" Then
                    eClaim.Adjuster = dic("Max")
                End If

                If Not dic("Gender") = "" Then
                    eClaim.ClaimCategory = dic("Gender") ' used as carrier for Gender
                End If
                'If Not dic("Age") = "" Then
                'eClaim.Reinsured = dic("Age") ' used as carrier for Age
                'End If
                ' puru
                eClaim.tblClaimAdmin = eClaimAdmin
                ddlDistrict.SelectedValue = eClaim.LegacyID
                ddlHFCode.SelectedValue = eHF.HfID
                FillClaimAdminCodes()
                ddlFBStatus.SelectedValue = eClaim.FeedbackStatus
                ddlReviewStatus.SelectedValue = eClaim.ReviewStatus
                ddlClaimStatus.SelectedValue = eClaim.ClaimStatus
                hfICDID.Value = eICDCodes.ICDID

                txtClaimCode.Text = If(eClaim.ClaimCode Is Nothing, "", eClaim.ClaimCode)
                txtHFName.Text = eHF.HFName
                txtCHFID.Text = eInsuree.CHFID
                txtClaimTo.Text = If(eClaim.DateTo Is Nothing, "", eClaim.DateTo)
                txtClaimFrom.Text = If(eClaim.DateFrom = Nothing, "", eClaim.DateFrom)
                txtClaimedDateFrom.Text = If(eClaim.DateClaimed = Nothing, "", eClaim.DateClaimed)
                txtClaimedDateTo.Text = If(eClaim.DateProcessed Is Nothing, "", eClaim.DateProcessed) 'Used as a carrier for ClaimedDate to range 
                ddlBatchRun.SelectedValue = If(eBatchRun.RunID = Nothing, Nothing, eBatchRun.RunID)
                ddlClaimAdmin.SelectedValue = eClaim.tblClaimAdmin.ClaimAdminId
                ddlVisitType.SelectedValue = eClaim.VisitType
                ddlGender.SelectedValue = eClaim.ClaimCategory
                txtMinAmount.Text = If(eClaim.Claimed Is Nothing, "", eClaim.Claimed)
                txtMaxAmount.Text = If(eClaim.Adjuster Is Nothing, "", eClaim.Adjuster)
                '''''clear Session("ClaimOverviewCriteria")....
                Session.Remove("ClaimOverviewCriteria")

            Else

                eHF.RegionId = Val(ddlRegion.SelectedValue)
                eHF.DistrictId = Val(ddlDistrict.SelectedValue)

                'Added by Hiren 05/03/2018
                If eHF.DistrictId > 0 Then
                    eClaim.LegacyID = eHF.DistrictId
                ElseIf eHF.RegionId > 0 Then
                    eClaim.LegacyID = eHF.RegionId
                End If

                If ddlHFCode.SelectedIndex >= 0 Then
                    eHF.HfID = ddlHFCode.SelectedValue
                End If

                eClaim.FeedbackStatus = ddlFBStatus.SelectedValue
                eClaim.ReviewStatus = ddlReviewStatus.SelectedValue
                eClaim.ClaimStatus = ddlClaimStatus.SelectedValue
                eICDCodes.ICDID = IIf(hfICDID.Value = "", 0, eICDCodes.ICDID)
                If Not ddlBatchRun.SelectedValue = "" Then
                    eBatchRun.RunID = ddlBatchRun.SelectedValue
                End If

                If Not txtClaimCode.Text = "" Then
                    eClaim.ClaimCode = txtClaimCode.Text
                End If
                If Not txtCHFID.Text = "" Then
                    eInsuree.CHFID = txtCHFID.Text
                End If
                If Not txtClaimTo.Text = "" Then
                    eClaim.DateTo = Date.Parse(txtClaimTo.Text)
                End If

                If Not txtClaimFrom.Text = "" Then

                    eClaim.DateFrom = Date.Parse(txtClaimFrom.Text)

                End If

                If Not txtClaimedDateFrom.Text = "" Then
                    eClaim.DateClaimed = Date.Parse(txtClaimedDateFrom.Text)
                End If
                If Not txtHFName.Text = "" Then
                    eHF.HFName = txtHFName.Text
                End If
                If Not txtClaimedDateTo.Text = "" Then
                    eClaim.DateProcessed = Date.Parse(txtClaimedDateTo.Text) 'Used as a carrier for ClaimedDate to range 
                End If
                If ddlClaimAdmin.SelectedIndex > -1 Then
                    eClaimAdmin.ClaimAdminId = ddlClaimAdmin.SelectedValue
                End If
                If ddlVisitType.SelectedIndex > 0 Then
                    eClaim.VisitType = ddlVisitType.SelectedValue
                End If
                ' Change By Purushottam Starts
                If Not txtMinAmount.Text = "" Then
                    eClaim.Claimed = txtMinAmount.Text ' Used as a carrier for Claimed Amount
                End If
                If Not txtMaxAmount.Text = "" Then
                    eClaim.Adjuster = txtMaxAmount.Text ' Used as a carrier for Claimed Amount
                End If
                If Not ddlGender.Text = "" Then
                    eClaim.ClaimCategory = ddlGender.Text ' Used as a carrier for Gender
                End If
                eClaim.Attachment = 0
                If chkAttachment.Checked = True Then
                    eClaim.Attachment = 1
                End If
                'If Not txtMinAge.Text = "" Then
                'eClaim.Reinsured = ddlAgeGroup.SelectedValue 
                'End If

                'Change By Purushottam Ends
                If ddlClaimSampleBatch.SelectedValue <> "0" Then 'If txtClaimSampleBatchID.Text <> "" Then
                    eClaim.ClaimSampleBatchID = Convert.ToInt32(ddlClaimSampleBatch.SelectedValue)
                    txtClaimSampleBatchID.Text = ""
                End If
                If txtClaimSampleBatchID.Text <> "" Then
                    eClaim.ClaimSampleBatchID = Convert.ToInt32(txtClaimSampleBatchID.Text)
                    ddlClaimSampleBatch.SelectedValue = "0"
                End If

                If chkLoadAllBatchClaims.Checked Then
                    eClaim.LoadAllBatchClaims = 1
                End If
            End If

            eClaim.tblHF = eHF
            eClaim.tblInsuree = eInsuree
            eClaim.tblICDCodes = eICDCodes
            eClaim.tblBatchRun = eBatchRun
            eClaim.tblClaimAdmin = eClaimAdmin



            Dim dt As DataTable
            If eClaim.ClaimSampleBatchID <> 0 Then
                dt = ClaimOverviews.GetBatchClaims(eClaim, imisgen.getUserId(Session("User")))
            Else
                eClaim.ClaimStatus = 4 'Only Checked status allowed to be filterd for new claimSampleBatch
                ddlClaimStatus.SelectedValue = "4"
                eClaim.ClaimSampleBatchID = -1 'dont select rows which already have batch id
                If ClaimOverviews.GetReviewClaimsCount(eClaim, imisgen.getUserId(Session("User"))) = 1 Then
                    imisgen.Alert(imisgen.getMessage("M_CLAIMSEXCEEDLIMIT"), pnlButtons, alertPopupTitle:="IMIS")
                    Return
                End If
                dt = ClaimOverviews.GetReviewClaims(eClaim, imisgen.getUserId(Session("User")))
            End If

            L_CLAIMSSELECTED.Text = If(dt.Rows.Count = 0, imisgen.getMessage("L_NO"), Format(dt.Rows.Count, "#,###")) & " " & imisgen.getMessage("L_CLAIMSFOUND")



            Session("dtGrid") = dt
            'L_CLAIMSELECTIONUPDATE.Text = If(dt.Rows.Count = 0, imisgen.getMessage("L_NO"), Format(dt.Rows.Count, "#,###")) & " " & imisgen.getMessage("L_CLAIMSELECTIONUPDATE")
            gvClaims.DataSource = dt
            gvClaims.DataBind()
            completeGridFill(gvClaims)
            ButtonDisplayControl(gvClaims.Rows.Count)

        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
    End Sub
    Private Sub ButtonDisplayControl(ByVal GridCount As Integer)
        RunPageSecurity()

        If GridCount > 0 Then
            B_FEEDBACK.Visible = B_FEEDBACK.Visible
            B_ProcessClaimStatus.Visible = B_ProcessClaimStatus.Visible
            B_REVIEW.Visible = B_REVIEW.Visible
            btnUpdateClaims.Visible = btnUpdateClaims.Visible
            btnSelectionExecute.Visible = btnSelectionExecute.Visible
            lblSelectToProcess.Visible = True
            chkboxSelectToProcess.Visible = True
        Else
            B_FEEDBACK.Visible = False
            B_ProcessClaimStatus.Visible = False
            B_REVIEW.Visible = False
            btnUpdateClaims.Visible = False
            btnSelectionExecute.Visible = False
            lblSelectToProcess.Visible = False
            chkboxSelectToProcess.Visible = False
        End If
    End Sub
    Private Sub GetFilterCriteria()
        Dim dic As New Dictionary(Of String, String)
        dic.Add("LocationId", ddlDistrict.SelectedValue)
        dic.Add("HFID", ddlHFCode.SelectedValue)
        dic.Add("CHFNo", txtCHFID.Text)
        dic.Add("ClaimCode", txtClaimCode.Text)
        dic.Add("HFName", txtHFName.Text)
        dic.Add("ReviewStatus", ddlReviewStatus.SelectedValue)
        dic.Add("FeedbackStatus", ddlFBStatus.SelectedValue)
        dic.Add("ClaimStatus", ddlClaimStatus.SelectedValue)
        dic.Add("ICDID", txtICDCode.Text)
        dic.Add("BatchRun", ddlBatchRun.SelectedValue)
        dic.Add("VisitDateFrom", If(txtClaimFrom.Text = "", "", txtClaimFrom.Text))
        dic.Add("VisitDateTo", If(txtClaimTo.Text = "", "", txtClaimTo.Text))
        dic.Add("ClaimedDateFrom", If(txtClaimedDateFrom.Text = "", "", txtClaimedDateFrom.Text))
        dic.Add("ClaimedDateTo", If(txtClaimedDateTo.Text = "", "", txtClaimedDateTo.Text))
        dic.Add("ClaimAdminID", ddlClaimAdmin.SelectedValue)
        dic.Add("VisitType", ddlVisitType.SelectedValue)
        dic.Add("Min", txtMinAmount.Text)
        dic.Add("Max", txtMaxAmount.Text)
        dic.Add("Gender", ddlGender.SelectedValue)
        Session("ClaimOverviewCriteria") = dic
    End Sub
    Private Sub B_REVIEW_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_REVIEW.Click
        GetFilterCriteria()
        'If Not hfReview.Value = "" Then Session("ReviewPage") = hfReview.Value
        'Dim ClaimUUID As Guid = claimBI.GetClaimUUIDByID(hfClaimID.Value)
        Response.Redirect("ClaimReviewNew.aspx?c=" & hfClaimID.Value)
    End Sub
    Private Sub B_FEEDBACK_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_FEEDBACK.Click
        GetFilterCriteria()
        'Dim ClaimUUID As Guid = claimBI.GetClaimUUIDByID(hfClaimID.Value)
        'Response.Redirect("ClaimFeedback.aspx?c=" & ClaimUUID.ToString())
        Response.Redirect("ClaimFeedback.aspx?c=" & hfClaimID.Value)
    End Sub

    Public Function CheckDifferenceForUpdate(ByVal grid As GridView, ByVal RowIndex As Integer, ByRef ddl As DropDownList, ByVal ItemStatus As String) As Boolean

        If Not ddl.SelectedValue = grid.DataKeys(grid.Rows(RowIndex).RowIndex).Item(ItemStatus) Then
            Return True
        Else
            Return False
        End If
    End Function
    Private Sub btnUpdateClaims_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateClaims.Click
        RunPageSecurity(1)
        Try
            Dim chkFed, chkRev As Integer
            Dim flagChanges As Boolean = False
            eClaim.AuditUserID = imisgen.getUserId(Session("User"))
            For Each row In gvClaims.Rows
                'Dim ddlFedBack As DropDownList = CType(row.cells(3).controls(1), DropDownList)
                'Dim ddlReview As DropDownList = CType(row.cells(4).controls(1), DropDownList)
                Dim ddlFedBack As DropDownList = CType(row.cells(4).controls(1), DropDownList)
                Dim ddlReview As DropDownList = CType(row.cells(5).controls(1), DropDownList)
                If (ddlFedBack.SelectedValue = 2) Or (ddlFedBack.SelectedValue = 4) Then
                    If CheckDifferenceForUpdate(gvClaims, row.RowIndex, ddlFedBack, "FeedbackStatus") = True Then
                        eClaim.FeedbackStatus = ddlFedBack.SelectedValue
                        eClaim.ClaimID = CType(gvClaims.DataKeys(row.RowIndex).Item("ClaimID"), Integer)
                        chkFed = ClaimOverviews.ManualSelectionUpdate(eClaim, "FeedBack")
                        eClaim.FeedbackStatus = Nothing
                        flagChanges = True
                    End If
                End If
                If (ddlReview.SelectedValue = 2) Or (ddlReview.SelectedValue = 4) Then
                    If CheckDifferenceForUpdate(gvClaims, row.RowIndex, ddlReview, "ReviewStatus") = True Then
                        eClaim.ReviewStatus = ddlReview.SelectedValue
                        eClaim.ClaimID = CType(gvClaims.DataKeys(row.RowIndex).Item("ClaimID"), Integer)
                        chkRev = ClaimOverviews.ManualSelectionUpdate(eClaim, "Review")
                        eClaim.ReviewStatus = Nothing
                        flagChanges = True
                    End If
                End If
            Next
            GetFilterCriteria()
            loadGrid()
            If (chkFed = 1) And (chkRev = 2) Then
                lblMsg.Text = imisgen.getMessage("M_REVIEWFEEDBACKSTATUSUPDATED")
            ElseIf (chkFed = 1) And (chkRev = 0) Then
                lblMsg.Text = imisgen.getMessage("M_FEEDBACKSTATUSUPDATED")
            ElseIf (chkFed = 0) And (chkRev = 2) Then
                lblMsg.Text = imisgen.getMessage("M_REVIEWSTATUSUPDATED")
            ElseIf flagChanges = False Then
                lblMsg.Text = imisgen.getMessage("M_MANNUALNOUPDATE")
            End If

        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try

    End Sub

    Private Sub B_ProcessClaimStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_ProcessClaimStatus.Click
        lblMsg.Text = ""
        RunPageSecurity(2)
        Try
            Dim chkbox As CheckBox
            Dim dt As New DataTable
            Dim dr As DataRow
            Dim Processflag As Boolean
            dt.Columns.Add("ClaimID", System.Type.GetType("System.Int32"))
            dt.Columns.Add("RowID", System.Type.GetType("System.Byte[]"))

            For Each r As GridViewRow In gvClaims.Rows
                chkbox = CType(r.Cells(8).FindControl("chkbgridSelectToProcess"), CheckBox)
                If chkbox.Checked = True Then
                    dr = dt.NewRow
                    dr("ClaimID") = gvClaims.DataKeys(r.RowIndex).Values("ClaimID")
                    dr("RowID") = gvClaims.DataKeys(r.RowIndex).Values("RowID")
                    dt.Rows.Add(dr)
                    Processflag = True
                End If
            Next
            Dim Submitted, Processed, Valuated, Changed, Rejected, Failed, ReturnValue As Integer
            If Processflag = False Then Exit Sub
            ClaimOverviews.ProcessClaims(dt, imisgen.getUserId(Session("User")), Submitted, Processed, Valuated, Changed, Rejected, Failed, ReturnValue)
            GetFilterCriteria()
            loadGrid()
            chkboxSelectToProcess.Checked = False
            hfProcessClaims.Value = "<h4><u>" & imisgen.getMessage("M_SUBMITTEDTOPROCESS") & "</u></h4>" & "<br>" &
                                    "<table><tr><td>" & imisgen.getMessage("M_SUBMITTED") & "</td><td>" & Submitted & "</td></tr><tr><td>" &
                                    imisgen.getMessage("M_PROCESSED") & "</td><td>" & Processed & "</td></tr><tr><td>" & imisgen.getMessage("M_VALUATED") &
                                    "</td><td>" & Valuated & "</td></tr><tr><td>" & imisgen.getMessage("M_CHANGED") & "</td><td>" & Changed &
                                    "</td></tr><tr><td>" & imisgen.getMessage("M_REJECTED") & "</td><td>" & Rejected & "</td></tr><tr><td>" &
                                    imisgen.getMessage("M_FAILED") & "</td><td>" & Failed & "</td></tr></td></tr></table>"


        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
    End Sub

    Private Sub btnSelectionExecute_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSelectionExecute.Click
        RunPageSecurity(1)
        Try
            GetFilterCriteria()
            Dim Submitted, Selected, NotSelected As Integer
            ClaimOverviews.ReviewFeedbackSelection(ClaimIDDatatable(), getValue, ddlSelectionType.SelectedValue, getSelectionType(), GetSelectionValue(), Submitted, Selected, NotSelected)
            loadGrid()
            ddlSelectionType.SelectedValue = 0
            hfSelectionExecute.Value = "<h4><u>" & imisgen.getMessage("M_SUBMITTEDTOUPDATE") & "</u></h4>" & "<br>" &
                                    "<table><tr><td>" & imisgen.getMessage("M_SUBMITTED") & "</td><td>" & Submitted & "</td></tr><tr><td>" &
                                    imisgen.getMessage("M_SELECTED") & "</td><td>" & Selected & "</td></tr><tr><td>" & imisgen.getMessage("M_NOTSELECTED") &
                                    "</td><td>" & NotSelected & "</td></tr></table>"


        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
    End Sub

    Private Function getSelectionType() As Integer
        If chkRandom.Checked Then
            Return 1
        ElseIf chkVariance.Checked Then
            Return 2
        Else
            Return 0
        End If
    End Function
    Private Function getValue() As Decimal
        If chkValue.Checked = True Then
            Return If(txtValue.Text = "", 0, txtValue.Text)
        Else
            Return 0
        End If
    End Function
    Private Function GetSelectionValue() As Decimal
        If chkRandom.Checked Then
            Return If(txtRandom.Text = "", 100, txtRandom.Text)
        ElseIf chkVariance.Checked Then
            Return If(txtVariance.Text = "", 0, txtVariance.Text)
        Else
            Return 0
        End If
    End Function


    Private Sub ddlDistrict_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDistrict.SelectedIndexChanged, ddlRegion.SelectedIndexChanged
        HFCodeAndBatchRunBinding(imisgen.getUserId(Session("User")))
    End Sub


    Private Sub B_CANCEL_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_CANCEL.Click
        If Not HttpContext.Current.Request.QueryString("i") Is Nothing Then
            Response.Redirect("FindInsuree.aspx")
        Else
            Response.Redirect("Home.aspx")
        End If

    End Sub

    Protected Sub ddlSelectionType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlSelectionType.SelectedIndexChanged
        FilterGrid()
    End Sub

    Private Function ClaimIDDatatable() As DataTable
        Dim dt As New DataTable
        dt.Columns.Add("ClaimID")
        Dim dt2 As DataTable = CType(Session("dtTotable"), DataTable)

        For Each row In dt2.Rows
            dt.Rows.Add(row("ClaimID"))
        Next
        Return dt
    End Function

    Private Function FilterDataTable() As DataTable

        Dim filter As String = ""
        If ddlSelectionType.SelectedValue = 0 Then
            filter = ""
        ElseIf ddlSelectionType.SelectedValue = 1 Then
            filter = "ReviewStatus=1 and ClaimStatus <> '" & imisgen.getMessage("T_VALUATED") & "' and ClaimStatus <> '" &
                    imisgen.getMessage("T_PROCESSED") & "' and ClaimStatus <> '" & imisgen.getMessage("T_REJECTED") & "' "
        Else
            filter = "FeedbackStatus=1 and ClaimStatus <> '" & imisgen.getMessage("T_VALUATED") & "' and ClaimStatus <> '" &
                    imisgen.getMessage("T_PROCESSED") & "' and ClaimStatus <> '" & imisgen.getMessage("T_REJECTED") & "'"
        End If

        Dim dt As DataTable = CType(Session("dtGrid"), DataTable)
        dt.DefaultView.RowFilter = filter
        Session("dtTotable") = dt.DefaultView.ToTable

        'If chkValue.Checked Then
        '    If filter.Trim <> String.Empty Then
        '        filter = filter & " AND Claimed >= " & txtValue.Text
        '    Else
        '        filter = "Claimed >= " & txtValue.Text
        '    End If
        'End If

        dt.DefaultView.RowFilter = filter
        Return dt.DefaultView.ToTable

    End Function

    Protected Sub txtValue_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtValue.TextChanged
        FilterGrid()
    End Sub

    Private Sub FilterGrid()
        Try
            gvClaims.DataSource = FilterDataTable()
            gvClaims.DataBind()
            completeGridFill(gvClaims)
        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
            Return
        End Try
    End Sub

    Protected Sub chkValue_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs) Handles chkValue.CheckedChanged
        If chkValue.Checked Then
            FilterGrid()
        End If
    End Sub
    Private Sub ClaimCodeTxtControl()
        If ddlHFCode.SelectedValue = 0 Then
            txtClaimCode.Enabled = False
        Else
            txtClaimCode.Enabled = True
        End If
    End Sub
    Private Sub ddlHFCode_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlHFCode.SelectedIndexChanged
        ClaimCodeTxtControl()
        FillClaimAdminCodes()
    End Sub
    Private Sub ddlRegion_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRegion.SelectedIndexChanged
        FillDistrict()
    End Sub

    Private Function calcSamplePercent() As Double
        Dim min = txtMinAmount.Text
        Dim max = txtMaxAmount.Text
        Dim dal = New IMIS_DAL.SamplePercentDAL

        Dim sb = New IMIS_EN.tblSamplePercent
        sb.ClaimedMin = Convert.ToDouble(min)
        sb.ClaimedMax = Convert.ToDouble(max)
        Return dal.ObtainHFClaimSamplePercent(sb, Convert.ToInt32(ddlHFCode.SelectedValue))
    End Function
    Private Sub btnSampleSubmit_Click(sender As Object, e As EventArgs) Handles btnSampleSubmit.Click
        lblMessage.Text = ""
        Dim sb As IMIS_EN.tblClaimSampleBatch = New IMIS_EN.tblClaimSampleBatch
        If Not String.IsNullOrWhiteSpace(txtClaimSelectSamplePercent.Text) Then
            sb.ClaimSelectSamplePercent = Convert.ToDouble(txtClaimSelectSamplePercent.Text)
        Else
            sb.ClaimSelectSamplePercent = calcSamplePercent()
        End If
        txtClaimSelectSamplePercent.Text = sb.ClaimSelectSamplePercent.ToString()
        sb.ClaimedAssignedReviewerID = ddlClaimReviewers.Text
        'txtAssignedClaimReviewer.Text = sb.Cl
        If sb.ClaimSelectSamplePercent = 0 Then
            lblMessage.Text = "No sample percent."
            Return
        End If
        If gvClaims.Rows.Count = 0 Then
            lblMessage.Text = "No rows."
            Return
        End If

        Dim TotalClaimsCount = gvClaims.Rows.Count
        If Not String.IsNullOrWhiteSpace(txtBatchTotal.Text) Then
            TotalClaimsCount = Convert.ToInt32(txtBatchTotal.Text)
        End If

        Dim SampleCount = TotalClaimsCount * 0.01 * sb.ClaimSelectSamplePercent
        Dim random As New Random()
        Dim randweight = random.Next(0, SampleCount)
        Dim modBy = Math.Round(TotalClaimsCount / SampleCount)
        If modBy < 1 Then
            modBy = SampleCount
        End If

        Dim batchIndex = 0
        Dim strClaimIds As String = ""
        'todo: maybe ignore batch
        For Each r As GridViewRow In gvClaims.Rows
            Dim strClaimSampleBatchID = CType(r.FindControl("lblClaimSampleBatchID"), Label).Text
            strClaimIds += CType(r.FindControl("lblClaimID"), Label).Text + ","
            'todo: maybe send a single large query 
            If Not String.IsNullOrWhiteSpace(strClaimSampleBatchID) Then 'todo: use transaction, check on db if any id is already existing
                lblMessage.Text = "Some Claim already in batch."
                Return
            End If
            batchIndex += 1
            If batchIndex >= TotalClaimsCount Then
                Exit For
            End If
        Next

        strClaimIds = strClaimIds.Substring(0, strClaimIds.Length - 1) 'remove last comma
        If ClaimsDAL.HasBatchForClaims(strClaimIds) Then
            lblMessage.Text = " Some Claim already in batch. "
            Return
        End If


        Dim batchid = ClaimsDAL.SaveSampleBatch(sb, imisgen.getUserId(Session("User"))) 'all success gen batch
        Dim eClaim = New IMIS_EN.tblClaim
        batchIndex = 0
        For Each r As GridViewRow In gvClaims.Rows
            eClaim.IsBatchSampleForVerify = False 'dbg
            Dim modrem = (r.RowIndex + randweight) Mod modBy
            Try
                eClaim.ReviewStatus = Convert.ToInt32(CType(r.FindControl("ddlClaimReviewStatus"), DropDownList).Text)
            Catch err As Exception
            End Try

            If modrem = 0 Then
                eClaim.IsBatchSampleForVerify = True
                eClaim.ReviewStatus = 4 'SelectedForReview
            End If
            eClaim.ClaimID = CType(r.FindControl("lblClaimID"), Label).Text
            eClaim.ClaimSampleBatchID = batchid

            Try
                ClaimsDAL.UpdateClaimSample(eClaim)
            Catch err As Exception
                Throw (err)
            End Try

            batchIndex += 1
            If batchIndex >= TotalClaimsCount Then
                Exit For
            End If
        Next
        txtClaimSampleBatchID.Text = batchid.ToString()
        loadGrid()

    End Sub

    Private Sub btnFillBatchCalcFromSamples_Click1(sender As Object, e As EventArgs)
        Dim ClaimSamplePercent = Convert.ToDouble(txtClaimSelectSamplePercent.Text)
        'todo:
        '
        'step1
        ' create batch
        ' set batchid to submitted rows
        ' assign flag as IsBatchSampleVerify to each rows of tblClaims
        '
        'step2::
        'if all rows are ok: i.e. batchid + approved(flag:16)
        'set all batch rows in tblclaims by calcn: approved amt, approved flag
        '
        Dim total = 0.0
        Dim dineTotal = 0.0
        Dim count = gvClaims.Rows.Count
        Dim dt As New DataTable

        'do later on another btn press
        For Each r As GridViewRow In gvClaims.Rows
            Dim strSampleAmountDecrease = CType(r.FindControl("txtbSampleAmountDecrease"), TextBox).Text
            Dim strClaimed = CType(r.FindControl("lblClaimed"), Label).Text 'gvClaims.DataKeys(r.RowIndex).Values("Claimed")

            If Not String.IsNullOrWhiteSpace(strSampleAmountDecrease) Then
                Dim Claimed = Convert.ToDouble(strClaimed)
                Dim SampleAmountDecrease = Convert.ToDouble(strSampleAmountDecrease)
                Dim dineAmount = Claimed - SampleAmountDecrease

                total += Convert.ToDouble(strClaimed)
                dineTotal += dineAmount
            End If

        Next

        'do later on another btn press
        Dim long_percent = dineTotal / total
        Dim percent = Math.Round(long_percent * 100.0F) / 100.0F
        'batchid = insert into batch. get inserted last batchid'
        Dim batchid = ClaimsDAL.SaveSampleBatch(Nothing, imisgen.getLoginName(Session("User")))
        Dim eClaim = New IMIS_EN.tblClaim
        For Each r As GridViewRow In gvClaims.Rows
            Dim id = CType(r.FindControl("lblClaimID"), Label).Text
            Dim strClaimed = CType(r.FindControl("lblClaimed"), Label).Text
            Dim strSampleAmountDecrease = CType(r.FindControl("txtbSampleAmountDecrease"), TextBox).Text

            Dim claimAmount = Convert.ToDouble(strClaimed)
            Dim SampleAmountDecrease = Convert.ToDouble(0)
            If Not String.IsNullOrEmpty(strSampleAmountDecrease) Then
                SampleAmountDecrease = Convert.ToDouble(strSampleAmountDecrease)
            End If

            Dim givamount = claimAmount - (claimAmount * percent)

            'Update tblClaims set give_amount = givamount, batch_id = batchid where id = id'
            eClaim.ClaimID = id
            eClaim.ClaimAmountPayment = givamount
            eClaim.SampleAmountDecrease = SampleAmountDecrease
            eClaim.SampleAmountPercent = percent
            eClaim.ClaimSampleBatchID = batchid
            Try
                ClaimsDAL.UpdateClaimSample(eClaim)
            Catch err As Exception
                Throw (err)
            End Try

        Next
    End Sub

    Private Sub btnSampleDoCalc_Click(sender As Object, e As EventArgs) Handles btnSampleDoCalc.Click
        Dim batchid = Convert.ToInt32(ddlClaimSampleBatch.SelectedValue)
        If batchid = 0 Then
            batchid = Convert.ToInt32(txtClaimSampleBatchID.Text)
        End If
        If batchid = 0 Then
            lblMessage.Text = "Batch required."
            Return
        End If 'todo: check batchid exist , ClaimDone=True: return already  batch finished.
        Dim filterClaim = New IMIS_EN.tblClaim
        filterClaim.ClaimSampleBatchID = batchid
        Dim claims = ClaimsDAL.GetSampleBatchClaims(filterClaim)
        Dim claimRows = claims.Rows

        Dim SampleApprovedTotal = 0
        Dim SampleClaimedTotal = 0
        For Each r As DataRow In claimRows
            Dim ClaimID As Integer = r("ClaimID")
            Dim Claimed As Double = r("Claimed")
            Dim Approved As Double = r("Approved")
            Dim ReviewStatus As Integer = r("ReviewStatus")
            Dim IsBatchSampleForVerify As Boolean = r("IsBatchSampleForVerify")

            If IsBatchSampleForVerify Then
                'If Approved = 0 Then ' approved amount=claimed amount cha bhane , approved=null
                If ReviewStatus < 8 Then ' 8=Reviewed 
                    lblMessage.Text = $"All sample should be approved"
                    Return
                End If

                If Approved = 0 Then
                    Approved = Claimed
                End If

                SampleApprovedTotal += Approved
                SampleClaimedTotal += Claimed

            End If
        Next
        Dim long_percent = SampleApprovedTotal / SampleClaimedTotal
        Dim percent = Math.Round(long_percent * 100.0F) / 100.0F

        For Each r As DataRow In claimRows
            Dim ClaimID As Integer = r("ClaimID")
            Dim ClaimSampleBatchID As Integer = r("ClaimSampleBatchID")
            Dim Claimed As Double = r("Claimed")
            Dim Approved As Double = r("Approved")
            Dim IsBatchSampleForVerify As Boolean = r("IsBatchSampleForVerify")

            If Not IsBatchSampleForVerify Then
                Dim givamount = (Claimed * percent)
                eClaim.ClaimID = ClaimID
                eClaim.ReviewStatus = 8 'r("ReviewStatus")
                eClaim.ClaimSampleBatchID = ClaimSampleBatchID
                eClaim.IsBatchSampleForVerify = IsBatchSampleForVerify
                eClaim.ClaimAmountPayment = givamount
                'todo: set 16 flag, status verified maybe 
                ' approved amt cha bhane na chalaune teslai
                eClaim.SampleAmountPercent = percent

                Try
                    ClaimsDAL.UpdateClaimSample(eClaim)
                    ClaimsDAL.UpdateClaimItemsAndServices(eClaim)
                Catch err As Exception
                    Throw (err)
                End Try
            End If
        Next

        Dim sb = ClaimsDAL.GetClaimSampleBatchByIdUpdate(batchid)

        sb.IsCalcDone = True
        ClaimsDAL.SaveSampleBatch(sb, imisgen.getUserId(Session("User")))


    End Sub
End Class
