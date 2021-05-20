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
Partial Public Class User
    Inherits System.Web.UI.Page
    Private Users As New IMIS_BI.UserBI
    Private eUsers As New IMIS_EN.tblUsers
    Private imisgen As New IMIS_Gen
    Private userBI As New IMIS_BI.UserBI

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RunPageSecurity()

        Try
            lblMsg.Text = ""

            If HttpContext.Current.Request.QueryString("u") IsNot Nothing Then
                eUsers.UserUUID = Guid.Parse(HttpContext.Current.Request.QueryString("u"))
                eUsers.UserID = Users.GetUserIdByUUID(eUsers.UserUUID)
            End If

            If HttpContext.Current.Request.QueryString("r") = 1 Then
                Panel2.Enabled = False
                B_SAVE.Visible = False
            End If

            If IsPostBack = True Then Return
            Dim load As New IMIS_BI.UserBI
            ddlLanguage.DataSource = Users.GetLanguage
            ddlLanguage.DataValueField = "LanguageCode"
            ddlLanguage.DataTextField = "LanguageName"
            ddlLanguage.DataBind()
            ddlHFNAME.DataSource = Users.GetHFCodes(imisgen.getUserId(Session("User")), 0)
            ddlHFNAME.DataValueField = "Hfid"
            ddlHFNAME.DataTextField = "HFCode"
            ddlHFNAME.DataBind()
            txtGeneratedPassword.Visible = False
            lblGeneratedPassword.Visible = False
            Dim dtRegion As DataTable = Users.getRegions(eUsers.UserID, imisgen.getUserId(Session("User")))
            gvRegion.DataSource = dtRegion
            gvRegion.DataBind()

            Assign(gvRegion)

            If IMIS_Gen.offlineHF Then
                gvDistrict.DataSource = Users.GetDistrictForHF(IMIS_Gen.HFID, eUsers.UserID)
            Else
                gvDistrict.DataSource = Users.GetDistricts(eUsers.UserID, imisgen.getUserId(Session("User")))
            End If
            gvDistrict.DataBind()
            Assign(gvDistrict)

            Dim LoggedInUser As Integer = imisgen.getUserId(Session("User"))
            If Not eUsers.UserID = 0 Then

                Users.LoadUsers(eUsers)

                ddlLanguage.SelectedValue = eUsers.LanguageID
                txtLastName.Text = eUsers.LastName
                txtOtherNames.Text = eUsers.OtherNames
                txtPhone.Text = eUsers.Phone
                txtEmail.Text = eUsers.EmailId
                txtLoginName.Text = eUsers.LoginName
                ' txtPassword.Attributes.Add("value", eUsers.DummyPwd)
                ' txtConfirmPassword.Attributes.Add("value", eUsers.DummyPwd)
                If HttpContext.Current.Request.QueryString("r") = 1 Or eUsers.ValidityTo.HasValue Then
                    Panel2.Enabled = False
                    B_SAVE.Visible = False
                End If

                Dim CurrentUserID As Integer = imisgen.getUserId(Session("User"))
                Dim result = Users.GetUserDistricts(LoggedInUser, eUsers.UserID)
                If result = 1 Then
                    imisgen.Alert(imisgen.getMessage("M_USERCANNOTBEEDITED"), pnlDistrict, alertPopupTitle:="IMIS")
                    Panel2.Enabled = False
                    B_SAVE.Visible = False
                End If

                ddlHFNAME.SelectedValue = eUsers.HFID.ToString
                RequiredFieldPassword.Visible = False

                RequiredFieldConfirmPassword.Visible = False
            End If 'Added

            Dim RoleId As Integer = imisgen.getRoleId(Session("User"))
            Dim dtRoles As New DataTable
            dtRoles = Users.getRolesForUser(eUsers.UserID, IMIS_Gen.offlineHF Or IMIS_Gen.OfflineCHF, LoggedInUser)
            gvRoles.DataSource = dtRoles
            gvRoles.DataBind()
            If eUsers.IsAssociated IsNot Nothing AndAlso eUsers.IsAssociated = True Then
                toggleModifingIfUsersClaimOrEnrolment(False)
                B_SAVE.Enabled = False
            End If

            If IMIS_Gen.offlineHF Then
                ddlHFNAME.SelectedValue = IMIS_Gen.HFID
                ddlHFNAME.Enabled = False
            End If
        Catch ex As Exception
            'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
            imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlDistrict, alertPopupTitle:="IMIS")
            imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
            'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
        End Try
    End Sub

    Private Sub toggleModifingIfUsersClaimOrEnrolment(enabled As Boolean)
        txtOtherNames.Enabled = enabled
        txtLastName.Enabled = enabled
        txtEmail.Enabled = enabled
        txtLoginName.Enabled = enabled
        ddlHFNAME.Enabled = enabled
        pnlRole.Enabled = enabled
        Checkbox1.Enabled = enabled
        chkCheckAllR.Enabled = enabled
        pnlRegion.Enabled = enabled
        CheckBox2.Enabled = enabled
        pnlDistrict.Enabled = enabled
        txtPhone.Enabled = enabled
        txtPassword.Enabled = enabled
        txtConfirmPassword.Enabled = enabled
    End Sub

    Private Sub RunPageSecurity()
        Dim RefUrl = Request.Headers("Referer")
        Dim UserID As Integer = imisgen.getUserId(Session("User"))
        If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.User, Page) Then
            Dim Add As Boolean = userBI.checkRights(IMIS_EN.Enums.Rights.UsersAdd, UserID)
            Dim Edit As Boolean = userBI.checkRights(IMIS_EN.Enums.Rights.UsersEdit, UserID)

            If Not Add And Not Edit Then
                B_SAVE.Visible = False
                Panel2.Enabled = False
            End If
        Else
            Server.Transfer("Redirect.aspx?perm=0&page=" & IMIS_EN.Enums.Pages.User.ToString & "&retUrl=" & RefUrl)
        End If
    End Sub


    Public Sub Assign(ByVal grid As GridView)
        Dim _checkedRole As Boolean = True
        Dim _checkedDistrict As Boolean = True
        Dim _checkedRegion As Boolean = True

        For Each row In grid.Rows
            Dim chkSelect As CheckBox = CType(row.Cells(0).Controls(1), CheckBox)
            If grid.ID = gvRoles.ID Then
                chkSelect.Checked = (eUsers.RoleID And CInt(grid.DataKeys(row.RowIndex)("Code")))
                If chkSelect.Checked <> True Then
                    _checkedRole = False
                End If
            ElseIf grid.ID = gvDistrict.ID Then
                chkSelect.Checked = gvDistrict.DataKeys(row.RowIndex).Value
                If chkSelect.Checked <> True Then
                    _checkedDistrict = False
                End If
            ElseIf grid.ID = gvRegion.ID Then
                chkSelect.Checked = gvRegion.DataKeys(row.RowIndex).Value
                If chkSelect.Checked <> True Then
                    _checkedRegion = False
                End If
            End If
        Next

        If grid.ID = gvRoles.ID Then
            Checkbox1.Checked = _checkedRole
        ElseIf grid.ID = gvDistrict.ID Then
            CheckBox2.Checked = _checkedDistrict
        ElseIf grid.ID = gvRegion.ID Then
            chkCheckAllR.Checked = _checkedRegion
        End If

    End Sub
    Public Function CheckDifferenceandSave(ByVal grid As GridView, ByVal RowIndex As Integer) As Boolean

        Dim chkSelect As CheckBox = CType(grid.Rows(RowIndex).Cells(0).Controls(1), CheckBox)
        If chkSelect.Checked <> CBool(grid.DataKeys(grid.Rows(RowIndex).RowIndex).Value) Then
            Return True
        Else
            Return False
        End If


    End Function

    Private Function checkChecked(ByVal gv As GridView) As Boolean
        Dim checked As Boolean = False
        If gv.ID = gvRoles.ID Then
            If txtLoginName.Text = "Admin" Then Return True
        End If
        For Each row In gv.Rows
            Dim chkSelect As CheckBox = CType(row.Cells(0).Controls(1), CheckBox)
            If chkSelect.Checked Then
                checked = True
                Exit For
            End If
        Next
        Return checked
    End Function

    Private Sub B_SAVE_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_SAVE.Click
        If txtPassword.Text <> String.Empty Then
            If Not General.isValidPassword(txtPassword.Text) Then
                lblMsg.Text = General.getInvalidPasswordMessage()
                Exit Sub
            End If
            If txtPassword.Text <> txtConfirmPassword.Text Then
                lblMsg.Text = imisgen.getMessage("V_CONFIRMPASSWORD")
                Exit Sub
            End If
            eUsers.DummyPwd = txtPassword.Text
        End If

        If CType(Me.Master.FindControl("hfDirty"), HiddenField).Value = True Then
            Try
                If Not checkChecked(gvDistrict) Then
                    lblMsg.Text = imisgen.getMessage("V_SELECTDISTRICT")
                    Return
                End If
                If Not checkChecked(gvRoles) Then
                    lblMsg.Text = imisgen.getMessage("V_SELECTROLE")
                    Return
                End If
                eUsers.LastName = txtLastName.Text
                eUsers.OtherNames = txtOtherNames.Text
                eUsers.DummyPwd = txtPassword.Text
                eUsers.Phone = txtPhone.Text
                eUsers.EmailId = txtEmail.Text
                eUsers.LoginName = txtLoginName.Text
                eUsers.LanguageID = ddlLanguage.SelectedValue
                'eUsers.RoleID = GetRoles(gvRoles)
                eUsers.AuditUserID = imisgen.getUserId(Session("User"))
                If ddlHFNAME.SelectedIndex >= 0 Then
                    eUsers.HFID = ddlHFNAME.SelectedValue
                End If

                Dim dt As New DataTable
                dt.Columns.Add("UserRoleID", GetType(Integer))
                dt.Columns.Add("UserID", GetType(Integer))
                dt.Columns.Add("RoleID", GetType(Integer))
                dt.Columns.Add("ValidityFrom", GetType(Date))
                dt.Columns.Add("ValidityTo", GetType(Date))
                dt.Columns.Add("AuditUserID", GetType(Integer))
                dt.Columns.Add("LegacyID", GetType(Integer))
                dt.Columns.Add("Assign", GetType(Integer))




                Dim dr As DataRow
                Dim UserRoleID As New Object
                For Each row As GridViewRow In gvRoles.Rows
                    dr = dt.NewRow
                    UserRoleID = CType(row.Cells(4).Controls(1), HiddenField).Value

                    If UserRoleID = "" Then UserRoleID = 0
                    dr("UserID") = eUsers.UserID
                    dr("UserRoleID") = UserRoleID
                    dr("Assign") = 0
                    If CType(row.Cells(0).Controls(1), CheckBox).Checked = True Then
                        dr("RoleID") = gvRoles.DataKeys(row.RowIndex).Value
                        dr("Assign") = 1
                    End If
                    If CType(row.Cells(2).Controls(1), CheckBox).Checked = True Then
                        dr("RoleID") = gvRoles.DataKeys(row.RowIndex).Value
                        dr("Assign") = dr("Assign") + 2
                    End If
                    If dr("RoleID") IsNot DBNull.Value Then
                        dt.Rows.Add(dr)
                    End If
                Next
                Dim chk As Integer = Users.SaveUser(eUsers, dt)
                If Not chk = 1 Then
                    For Each row In gvDistrict.Rows
                        If CheckDifferenceandSave(gvDistrict, row.RowIndex) = True Then
                            Dim eUsersDistricts As New IMIS_EN.tblUsersDistricts
                            Dim eLocations As New IMIS_EN.tblLocations
                            eLocations.LocationId = gvDistrict.DataKeys(row.RowIndex)("DistrictId")
                            eUsersDistricts.tblUsers = eUsers
                            eUsersDistricts.UserDistrictID = If(gvDistrict.DataKeys(row.RowIndex)("UserDistrictId") Is System.DBNull.Value, 0, gvDistrict.DataKeys(row.RowIndex)("UserDistrictId"))
                            eUsersDistricts.AuditUserID = imisgen.getUserId(Session("User"))
                            eUsersDistricts.tblLocations = eLocations
                            Users.SaveUserDistricts(eUsersDistricts)
                        End If
                    Next
                End If

                If chk = 0 Then
                    Session("msg") = eUsers.LoginName & imisgen.getMessage("M_Inserted")
                ElseIf chk = 1 Then
                    imisgen.Alert(eUsers.LoginName & imisgen.getMessage("M_Exists"), pnlButtons, alertPopupTitle:="IMIS")
                    txtLoginName.Text = ""
                    Return
                Else
                    Session("msg") = eUsers.LoginName & imisgen.getMessage("M_Updated")
                End If
            Catch ex As Exception
                'lblMsg.Text = imisgen.getMessage("M_ERRORMESSAGE")
                imisgen.Alert(imisgen.getMessage("M_ERRORMESSAGE"), pnlDistrict, alertPopupTitle:="IMIS")
                imisgen.Log(Page.Title & " : " & imisgen.getLoginName(Session("User")), ex)
                'EventLog.WriteEntry("IMIS", Page.Title & " : " & imisgen.getLoginName(Session("User")) & " : " & ex.Message, EventLogEntryType.Error, 999)
                Return
            End Try
        End If


        Response.Redirect("FindUser.aspx?u=" & txtLoginName.Text)
    End Sub

    Private Sub B_CANCEL_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles B_CANCEL.Click
        Response.Redirect("FindUser.aspx?u=" & txtLoginName.Text)
    End Sub
    Public Function getPassword(ByVal passLength As Integer, Optional ByVal Reset As Boolean = False) As String
        Dim pNum As New Random(100)
        Dim pLowerCase As New Random(500)
        Dim pUpperCase As New Random(50)
        Dim password As String
        Dim RandomSelect As New Random(50)


        Dim i As Integer
        Dim ctr(2) As Integer
        Dim charSelect(2) As String
        Dim iSel As Integer
        'clear old passwords

        For i = 1 To passLength
            'create random numbers that will represent
            'each : upercase,lowercase,numbers

            ctr(0) = pNum.Next(48, 57) 'Numbers  1 to 9 
            ctr(1) = pLowerCase.Next(65, 90) ' Lowercase Characters
            ctr(2) = pUpperCase.Next(97, 122) ' Uppercase Characters
            'put characters in strings
            charSelect(0) = System.Convert.ToChar(ctr(0)).ToString
            charSelect(1) = System.Convert.ToChar(ctr(1)).ToString
            charSelect(2) = System.Convert.ToChar(ctr(2)).ToString

            'pick one of the three above for a character At Random
            iSel = RandomSelect.Next(0, 3)
            'colect all characters generated through the loop
            password &= charSelect(iSel)

            ' reset  with new password
            If Reset = True Then
                password.Replace(password, charSelect(iSel))
            End If

        Next
        Return password

    End Function
    Public Function GeneratePassword(Optional ByVal Len As Integer = 8)

        If Len < 6 Then
            MsgBox("Minimum password length is 6 characters", MsgBoxStyle.OkOnly, "Minimum Length Reset")
            Len = 6
        End If

        Dim pass As String = String.Empty

        Dim nums As String() = "2 3 4 5 6 7 8 9".Split(" ") 'Omit 1 & 0
        Dim lettU As String() = "A B C D E F G H J K L M N P Q R S T U V W X Y Z".Split(" ") 'Omit i,I,o & O
        Dim lettL As String() = "A B C D E F G H J K M N P Q R S T U V W X Y Z".ToLower.Split(" ") 'Omit i,I,l, L,o & O
        Dim chars As String() = "(-) @ # $ % * {-} [-] - _ ^ < > + = ~ /\".Split(" ") 'omit ? / \ ( ) ' " . , ; : &

        Dim passRan() As Array = {nums, lettU, lettL, chars}

        Dim min As Integer = 0
        Dim max As Integer = passRan.Length 'this will include the length
        Dim rnd As Integer = 0

        Dim sb As New List(Of String)

        For l As Integer = 0 To Len - passRan.Length - 1
            'select the set to pick from ensuring you have a character from each set
            If l = 0 Then
                For p As Integer = 0 To passRan.Length - 1
                    'pick a random position in the selected set
                    max = passRan(p).Length
                    rnd = GetRandom(min, max)
                    sb.Add(passRan(p)(rnd))
                Next
            End If

            'select the set to pick from by random
            max = passRan.Length
            rnd = GetRandom(min, max)
            For p As Integer = 0 To passRan.Length - 1
                'pick a random position in the selected set
                If p = rnd Then
                    max = passRan(p).Length
                    rnd = GetRandom(min, max)
                    sb.Add(passRan(p)(rnd))
                    Exit For
                End If
            Next
        Next

        'shuffle the result
        Dim R As New List(Of String)
        R = sb.ToList
        For Int As Integer = 0 To Len - 1
            Dim curr As Integer = GetRandom(min, R.Count)
            pass &= R(curr)
            R.RemoveAt(curr)
        Next

        Return pass

    End Function

    Public Function GetRandom(ByVal Min As Integer, ByVal Max As Integer) As Integer
        Static Generator As System.Random = New System.Random()
        Return Generator.Next(Min, Max)
    End Function

    Protected Sub B_GENERATE_CLICK(sender As Object, e As EventArgs) Handles btnGeneratePassword.Click

        Dim GeneratedPassword As String = GeneratePassword(8)
            txtPassword.Attributes.Add("value", GeneratedPassword)
        txtConfirmPassword.Attributes.Add("value", GeneratedPassword)
        lblGeneratedPassword.Visible = True
        txtGeneratedPassword.Visible = True
        txtGeneratedPassword.Text = GeneratedPassword
        txtGeneratedPassword.Enabled = False
    End Sub
End Class
