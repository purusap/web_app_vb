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

Public Class ClaimOverviewSamplingBatch
    Inherits System.Web.UI.Page
    Private userBI As New IMIS_BI.UserBI
    Protected imisgen As New IMIS_Gen

    Dim ClaimsDAL As New IMIS_DAL.ClaimsDAL
    Dim tblClaimSampleBatchFilter As New IMIS_EN.tblClaimSampleBatchFilter

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsPostBack = False And False Then
            'Dim dt As DataTable = loadSampleData.LoadSamplePercentSetting()
            Dim dt As DataTable = ClaimsDAL.GetDataTableClaimSampleBatches(tblClaimSampleBatchFilter)
            GridView1.DataSource = dt
            GridView1.DataBind()

            If dt.Rows.Count > 0 And False Then

            End If
        End If

    End Sub


    Private Sub RunPageSecurity()
        Dim RoleID As Integer = imisgen.getRoleId(Session("User"))
        Dim UserID As Integer = imisgen.getUserId(Session("User"))
        If userBI.RunPageSecurity(IMIS_EN.Enums.Pages.Funding, Page) Then

        Else
            Server.Transfer("Home.aspx")
        End If
    End Sub

    Protected Sub B_SEARCH_Click(sender As Object, e As EventArgs) Handles B_SEARCH.Click
        tblClaimSampleBatchFilter.UserLoginName = txtUserLoginName.Text
        tblClaimSampleBatchFilter.CreateDateTimeStart = txtCreateDateTimeStart.Text
        tblClaimSampleBatchFilter.CreateDateTimeEnd = txtCreateDateTimeEnd.Text
        Dim dt As DataTable = ClaimsDAL.GetDataTableClaimSampleBatches(tblClaimSampleBatchFilter)
        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub
End Class
