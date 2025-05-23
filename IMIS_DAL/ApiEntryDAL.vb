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

Imports System.Xml

Public Class ApiEntryDAL
    Dim data As New ExactSQL

    Public Function ApiEntryAction(Optional ByVal action As String = Nothing, Optional ByVal XML As String = Nothing) As DataTable
        Dim res As DataTable
        'If (action = "") Then
        '    res = ClaimsCopayRequired(XML)
        'ElseIf (action = "DepartmentList") Then
        '    res = DepartmentList(XML)
        'Else
        '    res = uspAction(action, XML)
        'End If
        res = uspAction(action, XML)

        Return res
    End Function

    'a generic func, which can call passed proc name based on action
    Public Function uspAction(Optional ByVal action As String = Nothing, Optional ByVal XML As String = Nothing) As DataTable
        Dim Query As String = "usp" + action + " @XML"

        data.setSQLCommand(Query, CommandType.Text)
        data.params("@XML", SqlDbType.Text, -1, XML)
        Dim dt As DataTable = data.Filldata()
        Return dt
    End Function

    Public Function DepartmentList(Optional ByVal XML As String = Nothing) As String
        Dim Query As String = "uspDepartmentList"

        data.setSQLCommand(Query, CommandType.Text)
        Dim dt As DataTable = data.Filldata()
        Dim response = "{}"

        'Return data.Filldata
        Return response
    End Function

    Public Function ClaimsCopayRequired(Optional ByVal XML As String = Nothing) As String
        Dim Query As String = "uspProcessClaimsCopayRequired @XML, @percent output, @reason output"

        data.setSQLCommand(Query, CommandType.Text)
        data.params("@XML", SqlDbType.Text, 2500, XML)
        data.params("@percent", SqlDbType.Float, 0, ParameterDirection.Output)
        data.params("@reason", SqlDbType.VarChar, 100, ParameterDirection.Output)
        Dim dr As DataRow = data.Filldata()(0)
        'data.ExecuteCommand()
        'Dim x = data.Filldata

        Dim percent As Single = data.sqlParameters("@percent")
        Dim reason As String = data.sqlParameters("@reason")
        'Dim response As String = $"{""percent"":{per}, ""reason"":""{reason}""}}"
        Dim response As String = String.Format("{{""percent"":{0}, ""reason"":""{1}""}}", dr("per"), dr("reason"))

        'Return data.Filldata
        Return response
    End Function
End Class
