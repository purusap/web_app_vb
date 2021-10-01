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

Public Class AddSamplePercentBI
    'Public Function GetDistricts(ByVal userID As Integer, Optional ByVal showSelect As Boolean = False, Optional RegionId As Integer = 0) As DataTable
    '    Dim getDataTable As New IMIS_BL.LocationsBL
    '    Return getDataTable.GetDistricts(userID, showSelect, RegionId)
    'End Function
    'Public Function GetProducts(ByVal LocationId As Integer, ByVal userID As Integer, ByVal ShowSelect As Boolean) As DataTable
    '    Dim getDataTable As New IMIS_BL.ProductsBL
    '    Return getDataTable.GetProductsStict(LocationId, userID, ShowSelect)
    'End Function
    'Public Function GetPayers(ByVal RegionId As Integer, ByVal Districtid As Integer, ByVal userId As Integer, ByVal showSelect As Boolean) As DataTable
    '    Dim Premimum As New IMIS_BL.PayersBL
    '    Return Premimum.GetPayers(RegionId, Districtid, userId, True)
    'End Function
    Public Function AddUpdateSamplePercentSetting(eSamplePercent As IMIS_EN.tblSamplePercent, ID As Integer) As Integer
        Dim SamplePercent As New IMIS_BL.SamplePercentBL
        Return 5
        'Return SamplePercent. (eSamplePercent, ID)
    End Function
    'Public Function GetRegions(UserId As Integer, Optional ShowSelect As Boolean = True) As DataTable
    '    Dim BL As New IMIS_BL.LocationsBL
    '    Return BL.GetRegions(UserId, ShowSelect)
    'End Function
End Class
