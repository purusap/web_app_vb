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

Partial Public Class PolicyNewQR
    Inherits System.Web.UI.Page
    Private efamily As New IMIS_EN.tblFamilies
    Private ePolicy As New IMIS_EN.tblPolicy
    Private eProduct As New IMIS_EN.tblProduct
    Private eOfficer As New IMIS_EN.tblOfficer
    Dim ePayer As New IMIS_EN.tblPayer
    Dim ePremium As New IMIS_EN.tblPremium
    Protected imisgen As New IMIS_Gen
    Private Policy As New IMIS_BI.PolicyBI
    Private mode As Integer = 0 'if mode  = 0 then inserting, else modifying
    Private userBI As New IMIS_BI.UserBI
    Private familyBI As New IMIS_BI.FamilyBI
    Private productBI As New IMIS_BI.ProductBI
    Dim Premium As New IMIS_BI.PremiumBI


    Private Sub FormatForm()

        Dim Adjustibility As String = ""


        'Confirmation
        Adjustibility = General.getControlSetting("Confirmation")
        L_CONFIRMATIONNO0.Visible = Not (Adjustibility = "N")
        txtConfirmationType.Visible = Not (Adjustibility = "N")

        Adjustibility = General.getControlSetting("ConfirmationNo")
        L_CONFIRMATIONNO.Visible = Not (Adjustibility = "N")
        txtConfirmationNo1.Visible = Not (Adjustibility = "N")



        'Permanent Address
        Adjustibility = General.getControlSetting("PermanentAddress")
        L_ADDRESS0.Visible = Not (Adjustibility = "N")
        txtPermanentAddress.Visible = Not (Adjustibility = "N")

        'Poverty
        Adjustibility = General.getControlSetting("Poverty")
        lblPoverty.Visible = Not (Adjustibility = "N")
        txtPoverty.Visible = Not (Adjustibility = "N")


    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        CalendarExtender2.EndDate = DateTime.Now

        efamily.FamilyID = HttpContext.Current.Request.QueryString("f")
        ePolicy.PolicyID = HttpContext.Current.Request.QueryString("po")
        ePolicy.tblFamilies = efamily
        If IsPostBack = True Then Return

        FormatForm()


        eProduct.ProdID = Request.QueryString("pd")
        ePolicy.tblProduct = eProduct
        hfPolicyStage.Value = Request.QueryString("stage")
        If hfPolicyStage.Value = "N" Then
            lblPolicyStage.Text = "QR Enabled New Policy"
        ElseIf hfPolicyStage.Value = "R" Then
            lblPolicyStage.Text = "QR Enabled Renew Policy"
        End If
        RunPageSecurity()
        Try
            hfFamilyID.Value = efamily.FamilyID
            Policy.GetFamilyHeadInfo(efamily)
            txtRegion.Text = efamily.RegionName
            txtDistrict.Text = efamily.DistrictName
            hfLocationId.Value = efamily.LocationId
            hfDistrictID.Value = efamily.DistrictId
            hfRegionId.Value = efamily.RegionId
            txtVillage.Text = efamily.VillageName
            txtWard.Text = efamily.WardName
            txtPoverty.Text = If(efamily.Poverty Is Nothing, "", If(efamily.Poverty = True, "Yes", "No"))
            txtHeadCHFID.Text = efamily.tblInsuree.CHFID
            txtHeadLastName.Text = efamily.tblInsuree.LastName
            txtHeadOtherNames.Text = efamily.tblInsuree.OtherNames
            txtConfirmationType.Text = efamily.ConfirmationType
            txtConfirmationNo1.Text = efamily.ConfirmationNo
            'txt.Text = efamily.tblInsuree.Phone
            FillDropDown()
            Dim premiumPaid As Decimal = 0
            Dim receiptDetails As DataTable
            'receiptDetails = Policy.GetQRReceiptNumber(txtHeadCHFID.Text)
            receiptDetails = Policy.GetQRReceiptNumberByFamilyID(efamily.FamilyID)
            If receiptDetails.Rows.Count > 0 Then
                hfReceiptId.Value = receiptDetails.Rows(0)("ReceiptId")
                txtEnrollmentDate.Text = receiptDetails.Rows(0)("EnrolledDate")
                ddlProduct.SelectedValue = 49
                ddlEnrolementOfficer.SelectedValue = receiptDetails.Rows(0)("OfficerID")
                If txtConfirmationType.Text = "Normal" Or txtConfirmationType.Text = "FCHV" Then
                    ddlPayer.SelectedValue = 1
                Else
                    ddlPayer.SelectedValue = 2
                End If
                txtPremium.Text = receiptDetails.Rows(0)("Amount")
                txtReceiptNumber.Text = receiptDetails.Rows(0)("ReceiptNum")
                getPolicyValue(49)
            Else
                imisgen.Alert("QR Receipt not found, Enter Data from Old Page!", pnlBody, alertPopupTitle:="IMIS")
                'imisgen.Alert("QR Receipt not uploaded, Please contact EA!", pnlBody, alertPopupTitle:="IMIS")
                B_SAVE.Enabled = False
            End If

            txtEnrollmentDate.ReadOnly = True
            ddlProduct.Enabled = False
            ddlEnrolementOfficer.Enabled = False
            ddlPayer.Enabled = False
            txtPremium.Enabled = False
            txtReceiptNumber.Enabled = False

            txtEffectiveDate.Enabled = False
            txtExpiryDate.Enabled = False
            txtStartDate.Enabled = False
            txtEnrollmentDate.Enabled = ePolicy.PolicyID = 0
            btnEnrollmentDate.Enabled = txtEnrollmentDate.Enabled

        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
            EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 1)
            Return
        End Try

    End Sub
    Private Sub RunPageSecurity()
        Dim RoleID As Integer = imisgen.getRoleId(Session("User"))
        Dim UserID As Integer = imisgen.getUserId(Session("User"))
        If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.Policy, Page) Then
            B_SAVE.Visible = userBI.checkRights(IMIS_EN.Enums.Rights.PolicyEdit, UserID) Or userBI.checkRights(IMIS_EN.Enums.Rights.PolicyAdd, UserID)
            If Not B_SAVE.Visible Then
                pnlBody.Enabled = False
                L_FAMILYPANEL.Enabled = False
            End If
        Else
            Dim RefUrl = Request.Headers("Referer")
            Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.Policy.ToString & "&retUrl=" & RefUrl)
        End If
    End Sub
    Private Sub FillDropDown()
        FillOfficers()
        FillProductsd()
        FillPayers()
    End Sub

    Public Sub getPolicyValue(ByVal productID As Integer)
        If IsDate(txtEnrollmentDate.Text) Then

            Dim dEnrolDate As Date = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)

            ePolicy.EnrollDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)

            Dim PreviousPolicyId As Integer = 0

            'FillProductsd()
            'Addition for Nepal >> Start
            'If hfPolicyStage.Value <> "R" Then
            '    FillProductsd()
            '    ddlProduct.SelectedValue = 0
            '    txtStartDate.Text = ""
            '    txtExpiryDate.Text = ""
            '    txtEffectiveDate.Text = ""
            '    txtPolicyValue.Text = ""

            'End If
            'Addition for Nepal >> End

            If hfPolicyStage.Value = "R" Or hfPolicyStage.Value = "N" Then

            End If

            If ddlProduct.SelectedValue > 0 Then
                ePolicy.PolicyStage = hfPolicyStage.Value
                eProduct.ProdID = ddlProduct.SelectedValue
                ePolicy.tblProduct = eProduct
                Policy.getPolicyValue(ePolicy, PreviousPolicyId)
                'need to change
                'ddlPremium.DataSource = Policy.GetPremimumAmount(eProduct.ProdID, FormatNumber(ePolicy.PolicyValue))
                'ddlPremium.DataValueField = "AmountID"
                'ddlPremium.DataTextField = "Amount"
                'ddlPremium.DataBind()
                'need to change
                txtPolicyValue.Text = FormatNumber(ePolicy.PolicyValue)
                If CInt(txtPolicyValue.Text) <> CInt(txtPremium.Text) Then
                    imisgen.Alert("Premium Amount and Policy Amount Not Matched!", pnlButtons, alertPopupTitle:="IMIS")
                    B_SAVE.Enabled = False
                    Return
                End If

                'Addition for Nepal >> Start
                Dim AdminPeriod As Integer = Policy.GetProductAdministrationPeriod(ePolicy.tblProduct.ProdID)
                Dim CalcEffectiveDate As Date = ePolicy.EnrollDate.AddMonths(AdminPeriod)
                'Addition for Nepal >> End

                'Check if the selected product has cycle, if yes then lock the start date unlock it otherwise
                Policy.GetProductDetails(eProduct)

                If eProduct.StartCycle1 Is Nothing OrElse eProduct.StartCycle1.Trim.Length = 0 Then
                    txtStartDate.Enabled = True
                Else
                    txtStartDate.Enabled = False
                End If
                hfInsurancePeriod.Value = eProduct.InsurancePeriod

                'Get the start and end date 
                Dim dt As New DataTable
                Dim HasCycle As Boolean

                If hfPolicyStage.Value = "R" Then
                    '     If dEnrolDate < Date.ParseExact(Request.QueryString("ed"), "dd/MM/yyyy", Nothing) Then
                    '    dEnrolDate = Date.ParseExact(Request.QueryString("ed"), "dd/MM/yyyy", Nothing)
                    'End If

                End If

                dt = Policy.GetPeriodForPolicy(eProduct.ProdID, dEnrolDate, HasCycle, "N")
                'If (dt.Rows.Count > 0 And HasCycle = True) Or (Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing) <= dt(0)("StartDate") And hfPolicyStage.Value = "N") Then
                If (dt.Rows.Count > 0 And HasCycle = True) Or (Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing) <= dt(0)("StartDate") And hfPolicyStage.Value = "N") Then
                    If IsDate(dt(0)("StartDate")) Then
                        txtStartDate.Text = dt(0)("StartDate")
                    End If
                    If IsDate(dt(0)("StartDate")) Then
                        txtEffectiveDate.Text = dt(0)("StartDate")
                    End If
                    If IsDate(dt(0)("ExpiryDate")) Then
                        txtExpiryDate.Text = dt(0)("ExpiryDate")
                    End If

                    'If CalcEffectiveDate < dt(0)("StartDate") Then
                    '    txtEffectiveDate.Text = dt(0)("StartDate")
                    'Else
                    '    txtEffectiveDate.Text = CalcEffectiveDate
                    'End If
                Else
                    Dim dStartDate As Date
                    If hfPolicyStage.Value = "N" Or hfPolicyStage.Value = "R" Then
                        txtStartDate.Text = txtEnrollmentDate.Text
                        txtEffectiveDate.Text = txtEnrollmentDate.Text
                        dStartDate = Date.ParseExact(txtStartDate.Text, "dd/MM/yyyy", Nothing)
                        txtExpiryDate.Text = DateAdd(DateInterval.Day, -1, DateAdd(DateInterval.Month, CDbl(hfInsurancePeriod.Value), dStartDate))
                    Else

                        Dim EnrollAdmin As Date = DateAdd(DateInterval.Month, CInt(eProduct.AdministrationPeriod), dEnrolDate)
                        Dim ExpiryAndDay As Date = DateAdd(DateInterval.Day, 1, Date.ParseExact(Request.QueryString("ed"), "dd/MM/yyyy", Nothing))

                        If EnrollAdmin < ExpiryAndDay Then
                            dStartDate = ExpiryAndDay
                        Else
                            dStartDate = EnrollAdmin
                        End If

                        txtStartDate.Text = dStartDate
                        txtEffectiveDate.Text = dStartDate
                        txtExpiryDate.Text = DateAdd(DateInterval.Day, -1, DateAdd(DateInterval.Month, CDbl(hfInsurancePeriod.Value), dStartDate))

                    End If
                End If
            End If

            FillOfficers()
        End If

    End Sub

    Private Sub FillOfficers()
        Dim EnrolmentDate As Date?
        If IsDate(txtEnrollmentDate.Text) Then EnrolmentDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
        ddlEnrolementOfficer.DataSource = Policy.GetOfficers(hfDistrictID.Value, True, hfLocationId.Value, EnrolmentDate)
        ddlEnrolementOfficer.DataValueField = "OfficerID"
        ddlEnrolementOfficer.DataTextField = "Code"
        ddlEnrolementOfficer.DataBind()

    End Sub
    Private Sub FillProductsd()
        Dim dt As New DataTable
        Dim EnrollDate As Date?
        If IsDate(txtEnrollmentDate.Text.Trim) Then
            EnrollDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
        End If
        dt = Policy.GetProducts(imisgen.getUserId(Session("User")), True, hfRegionId.Value, hfDistrictID.Value, EnrollDate)
        ddlProduct.DataSource = dt
        ddlProduct.DataValueField = "ProdID"
        ddlProduct.DataTextField = "ProductCode"
        ddlProduct.DataBind()

    End Sub
    Private Function DateCheck() As Integer
        If ePolicy.EnrollDate > ePolicy.ExpiryDate Then
            Return 3
        ElseIf ePolicy.ExpiryDate < ePolicy.EnrollDate Then
            Return 4
        ElseIf ePolicy.ExpiryDate < ePolicy.EffectiveDate Then
            Return 5
        ElseIf ePolicy.ExpiryDate < ePolicy.StartDate Then
            Return 6
        End If
        Return 0
    End Function

    Protected Sub B_SAVE_Click(ByVal sender As Object, ByVal e As EventArgs) Handles B_SAVE.Click
        If CType(Me.Master.FindControl("hfDirty"), HiddenField).Value = True Then
            Try
                Dim dt As New DataTable
                dt = DirectCast(Session("User"), DataTable)
                efamily.FamilyID = hfFamilyID.Value
                efamily.isOffline = IMIS_Gen.offlineHF Or IMIS_Gen.OfflineCHF
                'ePolicy.PolicyID = Request.QueryString("p")
                ePolicy.EnrollDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
                Dim days As Integer = (Date.ParseExact(Now.Date(), "dd/MM/yyyy", Nothing) - Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)).Days
                If days < 1 Then
                    imisgen.Alert("Enroll Day should be less than today!", pnlButtons, alertPopupTitle:="IMIS")
                    Return
                End If
                Dim Calculatedays As Integer = (Date.ParseExact(txtStartDate.Text, "dd/MM/yyyy", Nothing) - Date.ParseExact(DateTime.Today.Date, "dd/MM/yyyy", Nothing)).Days
                If Calculatedays < 1 Then
                    imisgen.Alert("Enroll Date should be in running cycle!" & Calculatedays, pnlButtons, alertPopupTitle:="IMIS")
                    Return
                End If
                If Not ePolicy.PolicyID = 0 Then

                    If IsDate(txtEffectiveDate.Text) Then
                        ePolicy.EffectiveDate = Date.ParseExact(txtEffectiveDate.Text, "dd/MM/yyyy", Nothing)
                        'ePolicy.ExpiryDate = Date.ParseExact(txtExpiryDate.Text, "dd/MM/yyyy", Nothing)
                    End If

                    'If IsDate(txtExpiryDate.Text) Then
                    '    ePolicy.ExpiryDate = Date.Parse(txtExpiryDate.Text) 'Date.ParseExact(txtExpiryDate.Text, "dd/MM/yyyy", Nothing)
                    'End If

                End If
                'Addition for Nepal >> Start
                If IsDate(txtEffectiveDate.Text) Then
                    ePolicy.EffectiveDate = Date.ParseExact(txtEffectiveDate.Text, "dd/MM/yyyy", Nothing)
                End If
                'Addition for Nepal >> End
                ePolicy.ExpiryDate = Date.ParseExact(txtExpiryDate.Text, "dd/MM/yyyy", Nothing)
                ePolicy.isOffline = IMIS_Gen.offlineHF Or IMIS_Gen.OfflineCHF
                ePolicy.StartDate = Date.ParseExact(txtStartDate.Text, "dd/MM/yyyy", Nothing)

                Dim dtchk As Integer = DateCheck()
                If dtchk = 1 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR1")
                    Return
                ElseIf dtchk = 2 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR2")
                    Return
                ElseIf dtchk = 3 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR3")
                    Return
                ElseIf dtchk = 4 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR4")
                    Return
                ElseIf dtchk = 5 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR5")
                    Return
                ElseIf dtchk = 6 Then
                    lblMsg.Text = imisgen.getMessage("M_DATEERROR6")
                    Return
                End If
                eProduct.ProdID = ddlProduct.SelectedValue
                eOfficer.OfficerID = ddlEnrolementOfficer.SelectedValue
                ePolicy.PolicyStage = hfPolicyStage.Value
                ePolicy.AuditUserID = dt.Rows(0)("UserID")
                ePolicy.tblFamilies = efamily
                ePolicy.tblOfficer = eOfficer
                ePolicy.tblProduct = eProduct

                Dim PreviousPolicyId As Integer = 0
                Dim OrderNumberRenewal As Integer = 0
                OrderNumberRenewal = Policy.GetRenewalCount(eProduct.ProdID, efamily.FamilyID)
                If hfPolicyStage.Value = "R" Then
                    If Request.QueryString("rpo") IsNot Nothing Then
                        'Dim UUID As Guid = Guid.Parse(Request.QueryString("rpo"))
                        'PreviousPolicyId = If(UUID.Equals(Guid.Empty), 0, Policy.GetPolicyIdByUUID(UUID))
                        PreviousPolicyId = Request.QueryString("rpo")
                        If PreviousPolicyId > 0 Then
                            ePolicy.RenewalOrder = OrderNumberRenewal + 1
                        Else
                            ePolicy.RenewalOrder = 0
                        End If
                    End If
                End If

                Policy.getPolicyValue(ePolicy, PreviousPolicyId)
                If ePolicy.PolicyID > 0 Then ePolicy.PolicyStatus = Nothing


                If IsNumeric(Request.QueryString("rpo")) Then
                    If hfIsRenewalLate.Value = 1 Then
                        Dim chk1 As Boolean = Policy.IsRenewalLate(Request.QueryString("rpo"), Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing))
                        If chk1 = True Then
                            Dim Msg As String = imisgen.getMessage("M_LATEPOLICYRENEWAL", True)
                            imisgen.Confirm(Msg, pnlButtons, "promptPolicyRenewal", "", AcceptButtonText:=imisgen.getMessage("L_YES", True), RejectButtonText:=imisgen.getMessage("L_NO", True))
                            Exit Sub
                        End If
                    End If
                End If

                hfIsRenewalLate.Value = 0

                'Check if any of the policies exceed the max number of adherents
                If hfCheckMaxInsureeCount.Value = 1 And ePolicy.PolicyID = 0 Then
                    If Policy.isExceededAdherents(ePolicy.tblProduct.ProdID, ePolicy.tblFamilies.FamilyID) Then
                        'Give the popup with YES and NO 
                        'IF the ans is YES then continue with saving else Return to the Overview page
                        Dim Msg As String = imisgen.getMessage("M_PROMPTPOLICYADD", True)
                        imisgen.Confirm(Msg, pnlButtons, "promptPolicyAdd", "", AcceptButtonText:=imisgen.getMessage("L_YES", True), RejectButtonText:=imisgen.getMessage("L_NO", True))
                        Exit Sub
                    End If
                End If

                'Check if policy with same start/enroll date already exists
                Dim allowMultiplePolicy As Integer = System.Configuration.ConfigurationManager.AppSettings("AllowMultiplePolicy")
                If allowMultiplePolicy = 0 Then
                    If Policy.GetPolicyByDate(txtStartDate.Text, ePolicy.tblProduct.ProdID, ePolicy.tblFamilies.FamilyID) = 1 Then
                        imisgen.Alert("Policy With Same Start Date Already Exists!", pnlButtons, alertPopupTitle:="IMIS")
                        Return
                    End If
                End If

                'Check if policy is allowed to be renewd
                Dim policyRenewDays As Integer = System.Configuration.ConfigurationManager.AppSettings("PolicyRenewDays")
                If policyRenewDays > 0 Then
                    If Policy.GetPolicyByEnrollDate(txtEnrollmentDate.Text, ePolicy.tblProduct.ProdID, ePolicy.tblFamilies.FamilyID) > policyRenewDays Then
                        imisgen.Alert("Policy Cannot be Renewed in This Cycle!", pnlButtons, alertPopupTitle:="IMIS")
                        Return
                    End If
                End If

                hfCheckMaxInsureeCount.Value = 0
                Dim policyID As Integer = Policy.SavePolicyNew(ePolicy, IMIS_Gen.OfflineCHF)

                ePolicy.PolicyID = CInt(policyID)
                ePolicy.isOffline = IMIS_Gen.offlineHF Or IMIS_Gen.OfflineCHF
                ePolicy.StartDate = txtStartDate.Text

                ePayer.PayerID = ddlPayer.SelectedValue
                ePremium.Amount = CInt(txtPremium.Text)
                ePremium.Receipt = txtReceiptNumber.Text
                ePremium.PayDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
                ePremium.PayType = "C"
                ePremium.isOffline = IMIS_Gen.offlineHF Or IMIS_Gen.OfflineCHF
                ePremium.AuditUserID = imisgen.getUserId(Session("User"))
                ePolicy.AuditUserID = ePremium.AuditUserID
                ePremium.tblPolicy = ePolicy
                ePremium.tblPayer = ePayer
                Dim Category As String = "C"
                ePremium.isPhotoFee = 0

                Dim PayDate As Date = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
                Dim StartDate As Date = Date.ParseExact(txtStartDate.Text, "dd/MM/yyyy", Nothing)
                Dim EffectiveDate As Date = If(PayDate < StartDate, StartDate, PayDate)

                If CInt(txtPolicyValue.Text) = txtPremium.Text Then
                    ePolicy.PolicyStatus = 2
                    ePolicy.EffectiveDate = EffectiveDate
                Else
                    'ePolicy.PolicyStatus = 4
                    ePolicy.EffectiveDate = EffectiveDate
                End If

                ePolicy.isOffline = False
                ePremium.tblPolicy = ePolicy
                'removing Policy check for now
                'If Premium.isUniqueReceipt(ePremium) = False Then
                '    imisgen.Alert(imisgen.getMessage("M_DUPLICATERECEIPT"), pnlBody, alertPopupTitle:="IMIS")
                '    Return
                'End If

                Dim chk As Integer = Premium.SavePremium(ePremium, IMIS_Gen.offlineHF)
                Premium.UpdateReceipt(CInt(hfReceiptId.Value))
                If chk = 0 Then
                    Session("Msg") = imisgen.getMessage("M_POLICYENROLEDATE") & " " & ePolicy.EnrollDate & " " & imisgen.getMessage("M_Inserted")
                Else
                    Session("Msg") = imisgen.getMessage("M_POLICYENROLEDATE") & " " & ePolicy.EnrollDate & " " & imisgen.getMessage("M_Updated")
                End If

            Catch ex As Exception
                imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlBody, alertPopupTitle:="IMIS")
                EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 2)
                Return
            End Try
        End If

        'Dim PolicyUUID As Guid
        'PolicyUUID = Policy.GetPolicyUUIDByID(ePolicy.PolicyID)

        If HttpContext.Current.Request.QueryString("f") = Nothing Then
            'Response.Redirect("FindPolicy.aspx?po=" & PolicyUUID.ToString())
            Response.Redirect("FindPolicy.aspx?po=" & ePolicy.PolicyID)

        Else
            Response.Redirect("OverviewFamily.aspx?f=" & hfFamilyID.Value & "&po=" & ePolicy.PolicyID)
        End If
    End Sub

    Private Sub B_CANCEL_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_CANCEL.Click
        'Response.Redirect("OverviewFamily.aspx?f=" & efamily.FamilyUUID.ToString())
        Response.Redirect("OverviewFamily.aspx?f=" & efamily.FamilyID)
    End Sub

    Private Sub B_SAVE_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles B_SAVE.Command

    End Sub

    Private Sub txtStartDate_TextChanged(sender As Object, e As EventArgs) Handles txtStartDate.TextChanged
        Dim EnStart As Date = txtStartDate.Text
        Dim ExDate As Date = DateAdd(DateInterval.Day, -1, DateAdd(DateInterval.Month, Val(hfInsurancePeriod.Value), EnStart))
        txtExpiryDate.Text = ExDate
    End Sub
    Private Sub SetProductForRenewal()
        Dim EnrollDate As Date
        Dim eProd As New IMIS_EN.tblProduct
        If IsDate(txtEnrollmentDate.Text) = False Then
            EnrollDate = "1900-01-01"
        Else
            EnrollDate = Date.ParseExact(txtEnrollmentDate.Text, "dd/MM/yyyy", Nothing)
        End If

        eProd = Policy.GetProductForRenewal(CInt(eProduct.ProdID), EnrollDate)

        ddlProduct.SelectedValue = eProd.ProdID

        If ddlProduct.SelectedValue = 0 Then
            ddlProduct.Items.Add(New ListItem(eProd.ProductCode, eProd.ProdID))
            ddlProduct.SelectedValue = eProd.ProdID
        End If

    End Sub
    Private Sub FillPayers()
        ddlPayer.DataSource = Premium.GetPayers(efamily.RegionId, efamily.DistrictId, imisgen.getUserId(Session("User")), True)
        ddlPayer.DataValueField = "PayerID"
        ddlPayer.DataTextField = "PayerName"
        ddlPayer.DataBind()
    End Sub


End Class
