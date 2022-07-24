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

Public Class PremiumDAL1
    Inherits PremiumDAL

    Public Function InsertPremiumBipanna(ByRef ePremium As IMIS_EN.tblPremium) As Boolean
        Dim data As New ExactSQL
        Dim sSQL As String = "INSERT INTO tblPremium (PolicyID, PayerID, Amount, Receipt, PayDate, PayType,isOffline, AuditUserID,isPhotoFee)" &
                    " VALUES (@PolicyID, @PayerID, @Amount, @Receipt, @PayDate, @PayType,@isOffline, @AuditUserID,@isPhotoFee);SET @PremiumID = SCOPE_IDENTITY()"
        data.setSQLCommand(sSQL, CommandType.Text)

        data.params("PolicyID", SqlDbType.Int, ePremium.tblPolicy.PolicyID)
        data.params("PayerID", SqlDbType.Int, If(ePremium.tblPayer.PayerID = 0, DBNull.Value, ePremium.tblPayer.PayerID))
        data.params("Amount", SqlDbType.Decimal, ePremium.Amount)
        data.params("Receipt", SqlDbType.NVarChar, 50, ePremium.Receipt)
        data.params("PayDate", SqlDbType.SmallDateTime, ePremium.PayDate)
        data.params("PayType", SqlDbType.NVarChar, 1, ePremium.PayType)
        data.params("isOffline", SqlDbType.Bit, ePremium.isOffline)
        data.params("AuditUserID", SqlDbType.Int, ePremium.AuditUserID)
        data.params("@PremiumID", SqlDbType.Int, 0, ParameterDirection.Output)
        data.params("@isPhotoFee", SqlDbType.Bit, ePremium.isPhotoFee)

        data.ExecuteCommand()

        ePremium.PremiumId = data.sqlParameters("@PremiumID")

        Return True
    End Function

End Class

