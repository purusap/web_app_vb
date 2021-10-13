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

Imports IMIS_EN

Public Class ClaimsDAL
    Dim data As New ExactSQL

    Public Sub LoadClaim(ByRef eClaim As IMIS_EN.tblClaim, Optional ByRef eExtra As Dictionary(Of String, Object) = Nothing)
        Dim dt As New DataTable
        Dim sSQLClaim As String

        'sSQLClaim = "SELECT H.HFID,H.HFCode, H.HFName,H.HFCareType,C.ICDID,C.InsureeId,I.CHFID" &
        '       ",I.LastName,I.OtherNames,C.DateFrom,C.DateTo,C.ClaimCode,C.DateClaimed,C.DateProcessed" &
        '       ",IC.ICDCode,C.Claimed,C.Approved,C.Explanation,C.Valuated,C.Explanation,C.Adjustment" &
        '       ",C.ClaimStatus,C.ReviewStatus,C.FeedbackStatus,FB.FeedbackID,FB.FeedbackDate,FB.CareRendered" &
        '       ",FB.DrugPrescribed,FB.DrugReceived,FB.PaymentAsked,FB.Asessment,FB.CHFOfficerCode" &
        '       ",Cadm.ClaimAdminID,Cadm.ClaimAdminCode,Cadm.LastName CadminLastName,Cadm.OtherNames CadminOtherNames" &
        '       " ,C.ICDID1, C.ICDID2, C.ICDID3, C.ICDID4, C.VisitType,IC1.ICDCode ICDCode1,IC2.ICDCode ICDCode2,IC3.ICDCode ICDCode3,IC4.ICDCode ICDCode4,GuaranteeId" &
        '        ",ISNULL(CS.RejectionReason,NULL) ServiceRejectionReason,ISNULL(CI.RejectionReason,NULL) ItemRejectionReason, Attachment " &
        '       " FROM tblClaim C" &
        '       " INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID INNER JOIN tblHF H ON C.HfID = H.HfID" &
        '       " INNER JOIN tblICDCodes IC ON C.ICDID = IC.ICDID" &
        '       " LEFT JOIN tblICDCodes IC1 ON C.ICDID1 = IC1.ICDID" &
        '       " LEFT JOIN tblICDCodes IC2 ON C.ICDID2 = IC2.ICDID" &
        '       " LEFT JOIN tblICDCodes IC3 ON C.ICDID3 = IC3.ICDID" &
        '       " LEFT JOIN tblICDCodes IC4 ON C.ICDID4 = IC4.ICDID" &
        '       " LEFT JOIN tblFeedback FB ON C.ClaimID = FB.ClaimID" &
        '       " LEFT JOIN tblClaimAdmin Cadm ON Cadm.ClaimAdminId = C.ClaimAdminId" &
        '       " LEFT OUTER JOIN tblClaimServices CS ON CS.ClaimID = C.ClaimID" &
        '       " LEFT OUTER JOIN tblClaimItems CI ON CI.ClaimID = C.ClaimID" &
        '       " WHERE C.ClaimID = @ClaimID"

#If HIB Then
        sSQLClaim = "SELECT H.HFID,H.HFCode, H.HFName,H.HFCareType,C.ICDID,C.InsureeId,I.CHFID" &
               ",I.LastName,I.OtherNames,C.DateFrom,C.DateTo,C.ClaimCode,C.DateClaimed,C.DateProcessed" &
               ",IC.ICDCode,C.Claimed,C.Approved,C.Explanation,C.Valuated,C.Explanation,C.Adjustment" &
               ",C.ClaimStatus,C.ReviewStatus,C.FeedbackStatus,FB.FeedbackID,FB.FeedbackDate,FB.CareRendered" &
               ",FB.DrugPrescribed,FB.DrugReceived,FB.PaymentAsked,FB.Asessment,FB.CHFOfficerCode" &
               ",Cadm.ClaimAdminID,Cadm.ClaimAdminCode,Cadm.LastName CadminLastName,Cadm.OtherNames CadminOtherNames" &
               " ,C.ICDID1,  C.VisitType,IC1.ICDCode ICDCode1,GuaranteeId" &
                ",ISNULL(CS.RejectionReason,NULL) ServiceRejectionReason,ISNULL(CI.RejectionReason,NULL) ItemRejectionReason, Attachment " &
                 ",IC.ICDName, IC1.ICDName ICDName1, HFF.HFName ReferF, HFT.HFName ReferT, C.CareType, C.referFrom, C.referTo  " &
               " FROM tblClaim C" &
               " INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID INNER JOIN tblHF H ON C.HfID = H.HfID" &
               " INNER JOIN tblICDCodes IC ON C.ICDID = IC.ICDID" &
               " LEFT JOIN tblHF HFF ON C.referFrom = HFF.HfID" &
               " LEFT JOIN tblHF HFT ON C.referTo = HFT.HfID" &
                " LEFT JOIN tblICDCodes IC1 ON C.ICDID1 = IC1.ICDID" &
               " LEFT JOIN tblFeedback FB ON C.ClaimID = FB.ClaimID" &
               " LEFT JOIN tblClaimAdmin Cadm ON Cadm.ClaimAdminId = C.ClaimAdminId" &
               " LEFT OUTER JOIN tblClaimServices CS ON CS.ClaimID = C.ClaimID" &
               " LEFT OUTER JOIN tblClaimItems CI ON CI.ClaimID = C.ClaimID" &
               " WHERE C.ClaimID = @ClaimID"

#End If
        data.setSQLCommand(sSQLClaim, CommandType.Text)

        data.params("@ClaimID", eClaim.ClaimID)

        Dim dr As DataRow = data.Filldata()(0)
        If Not dr Is Nothing Then

            Dim eHF As New IMIS_EN.tblHF
            Dim eInsuree As New IMIS_EN.tblInsuree
            Dim eCD As New IMIS_EN.tblICDCodes
            Dim eFeedback As New IMIS_EN.tblFeedback
            Dim eClaimAdmin As New IMIS_EN.tblClaimAdmin
            Dim eClaimServices As New IMIS_EN.tblClaimServices
            Dim eClaimItems As New IMIS_EN.tblClaimItems
            eHF.HfID = dr("HFID")
            eHF.HFCode = dr("HFCode")
            eHF.HFCareType = dr("HFCareType")
            eHF.HFName = dr("HFName")

            eInsuree.InsureeID = dr("InsureeId")
            eInsuree.CHFID = dr("CHFID")
            eInsuree.LastName = If(("LastName") Is Nothing, String.Empty, dr("LastName"))
            eInsuree.OtherNames = dr("OtherNames")

            eCD.ICDCode = dr("ICDCode")
            eCD.ICDID = dr("ICDID")
            eCD.ICDName = dr("ICDName")

            eClaim.DateFrom = dr("DateFrom")
            eClaim.DateTo = If(dr("DateTo") Is DBNull.Value, Nothing, dr("DateTo"))
            eClaim.ClaimCode = dr("ClaimCode")
            eClaim.DateClaimed = If(dr("DateClaimed") Is DBNull.Value, Nothing, dr("DateClaimed"))
            eClaim.DateProcessed = If(dr("DateProcessed") Is DBNull.Value, Nothing, dr("DateProcessed"))
            eClaim.Claimed = If(dr("Claimed") Is DBNull.Value, Nothing, dr("Claimed"))
            eClaim.Approved = If(dr("Approved") Is DBNull.Value, Nothing, dr("Approved"))
            eClaim.Valuated = If(dr("Valuated") Is DBNull.Value, Nothing, dr("Valuated"))
            eClaim.Explanation = If(dr("Explanation") Is DBNull.Value, String.Empty, dr("Explanation"))
            eClaim.Adjustment = If(dr("Adjustment") Is DBNull.Value, String.Empty, dr("Adjustment"))
            eClaim.ClaimStatus = dr("ClaimStatus")
            eClaim.FeedbackStatus = If(dr("FeedbackStatus") Is DBNull.Value, Nothing, dr("FeedbackStatus"))
            eClaim.ReviewStatus = If(dr("ReviewStatus") Is DBNull.Value, Nothing, dr("ReviewStatus"))
            eClaimItems.RejectionReason = If(dr("ItemRejectionReason") Is DBNull.Value, Nothing, dr("ItemRejectionReason"))
            eClaimServices.RejectionReason = If(dr("ServiceRejectionReason") Is DBNull.Value, Nothing, dr("ServiceRejectionReason"))
            eFeedback.FeedbackID = If(dr("FeedbackID") Is DBNull.Value, Nothing, dr("FeedbackID"))
            eFeedback.FeedbackDate = If(dr("FeedbackDate") Is DBNull.Value, Nothing, dr("FeedbackDate"))
            eFeedback.CareRendered = If(dr("CareRendered") Is DBNull.Value, Nothing, dr("CareRendered"))
            eFeedback.DrugPrescribed = If(dr("DrugPrescribed") Is DBNull.Value, Nothing, dr("DrugPrescribed"))
            eFeedback.DrugReceived = If(dr("DrugReceived") Is DBNull.Value, Nothing, dr("DrugReceived"))
            eFeedback.PaymentAsked = If(dr("PaymentAsked") Is DBNull.Value, Nothing, dr("PaymentAsked"))
            eFeedback.Asessment = If(dr("Asessment") Is DBNull.Value, Nothing, dr("Asessment"))
            eFeedback.CHFOfficerCode = If(dr("CHFOfficerCode") Is DBNull.Value, Nothing, dr("CHFOfficerCode"))
            If dr("ClaimAdminId") IsNot DBNull.Value Then eClaimAdmin.ClaimAdminId = dr("ClaimAdminId")
            If dr("ClaimAdminCode") IsNot DBNull.Value Then eClaimAdmin.ClaimAdminCode = dr("ClaimAdminCode")
            If dr("CadminLastName") IsNot DBNull.Value Then eClaimAdmin.LastName = dr("CadminLastName")
            If dr("CadminOtherNames") IsNot DBNull.Value Then eClaimAdmin.OtherNames = dr("CadminOtherNames")
            eClaim.ICDID1 = If(dr("ICDID1") Is DBNull.Value, Nothing, dr("ICDID1"))
            'eClaim.ICDID2 = if(dr("ICDID2") Is DBNull.Value, Nothing, dr("ICDID2"))
            'eClaim.ICDID3 = if(dr("ICDID3") Is DBNull.Value, Nothing, dr("ICDID3"))
            'eClaim.ICDID4 = if(dr("ICDID4") Is DBNull.Value, Nothing, dr("ICDID4"))
            If eExtra IsNot Nothing Then
                eExtra.Add("ICDCode1", If(dr("ICDCode1") Is DBNull.Value, Nothing, dr("ICDCode1")))
                'eExtra.Add("ICDCode2", if(dr("ICDCode2") Is DBNull.Value, Nothing, dr("ICDCode2")))
                'eExtra.Add("ICDCode3", if(dr("ICDCode3") Is DBNull.Value, Nothing, dr("ICDCode3")))
                'eExtra.Add("ICDCode4", If(dr("ICDCode4") Is DBNull.Value, Nothing, dr("ICDCode4")))
                eExtra.Add("ICDName1", If(dr("ICDName1") Is DBNull.Value, Nothing, dr("ICDName1")))
                'eExtra.Add("ICDName2", If(dr("ICDName2") Is DBNull.Value, Nothing, dr("ICDName2")))
                'eExtra.Add("ICDName3", If(dr("ICDName3") Is DBNull.Value, Nothing, dr("ICDName3")))
                'eExtra.Add("ICDName4", If(dr("ICDName4") Is DBNull.Value, Nothing, dr("ICDName4")))
            End If
            eClaim.VisitType = If(dr("VisitType") Is DBNull.Value, Nothing, dr("VisitType"))
            If dr("GuaranteeId") IsNot DBNull.Value Then eClaim.GuaranteeId = dr("GuaranteeId")

            eClaim.tblHF = eHF
            eClaim.tblInsuree = eInsuree
            eClaim.tblICDCodes = eCD
            eClaim.tblFeedback = eFeedback
            eClaim.tblClaimAdmin = eClaimAdmin
            eClaim.ClaimItems = eClaimItems
            eClaim.ClaimServices = eClaimServices
            eClaim.Attachment = dr("Attachment")
            eClaim.ReferFrom = dr("ReferFrom")
            eClaim.ReferTo = dr("ReferTo")
            eClaim.ReferFromData = If(dr("ReferF") Is DBNull.Value, Nothing, dr("ReferF"))
            eClaim.ReferToData = If(dr("ReferT") Is DBNull.Value, Nothing, dr("ReferT"))
            eClaim.CareType = If(dr("CareType") Is DBNull.Value, Nothing, dr("CareType"))


        End If
    End Sub

    Public Function ReviewClaim(ByVal ClaimID As Integer) As DataSet
        data = New ExactSQL
        Dim ds As New DataSet
        Dim dtClaimedItems As New DataTable("ClaimedItems")
        Dim dtClaimedServices As New DataTable("ClaimedServices")

        'Get Claimed Services
        Dim sSQLClaimedServices As String = ""
        sSQLClaimedServices = "SELECT CS.PriceValuated,CS.RejectionReason, CS.ClaimServiceID,S.ServiceID,S.ServCode + '  '  + S.ServName as ServCode," &
            " CS.QtyProvided,CS.PriceAsked,CS.QtyApproved,CS.PriceApproved,CS.Explanation,CS.Justification,CS.ClaimServiceStatus,S.ServCode Code," &
            " S.ServName,CASE WHEN S.ServPrice - PLD.PriceOverule > 0 AND ISNULL(PLD.PriceOverule,0) = 0 THEN S.ServPrice ELSE 0 END FreeServicePrice" &
            " FROM tblClaim C INNER JOIN tblClaimServices CS ON C.ClaimID = CS.ClaimID and cs.validityto is null" &
            " INNER JOIN tblServices S ON CS.ServiceID = S.ServiceID" &
            " INNER JOIN tblHF HF ON C.HFID = HF.HfID" &
            " INNER JOIN tblPLServices PL ON HF.PLServiceID = PL.PLServiceID" &
            " LEFT OUTER JOIN tblPLServicesDetail PLD ON PL.PLServiceID = PLD.PLServiceID AND S.ServiceId = PLD.ServiceID" &
            " WHERE C.ClaimID = @ClaimID AND CS.LegacyID IS NULL AND CS.ValidityTo IS NULL AND PL.ValidityTo IS NULL AND PLD.ValidityTo IS NULL"


        data.setSQLCommand(sSQLClaimedServices, CommandType.Text)

        data.params("@ClaimID", ClaimID)

        dtClaimedServices = data.Filldata()
        dtClaimedServices.TableName = "ClaimedServices"
        'Get Claimed Items
        Dim sSQLClaimedItems As String = ""
        sSQLClaimedItems = "SELECT CI.PriceValuated, CI.ClaimItemID,CI.RejectionReason,I.ItemID,I.ItemCode + '  ' + I.ItemName as ItemCode ,CI.QtyProvided," &
            " CI.PriceAsked,CI.QtyApproved,CI.PriceApproved,CI.Explanation,CI.Justification,CI.ClaimItemStatus ,I.ItemCode Code,I.ItemName," &
            " CASE WHEN I.ItemPrice - PLD.PriceOverule > 0 AND ISNULL(PLD.PriceOverule,0) = 0 THEN I.ItemPrice ELSE 0 END FreeItemPrice" &
            " FROM tblClaim C INNER JOIN tblClaimItems CI ON C.ClaimID = CI.ClaimID and cI.validityto is null" &
            " INNER JOIN tblItems I ON CI.ItemID = I.ItemID " &
            " INNER JOIN tblHF HF ON C.HFID = HF.HfID" &
            " INNER JOIN tblPLItems PL ON HF.PLItemID = PL.PLItemID" &
            " LEFT OUTER JOIN tblPLItemsDetail PLD ON PL.PLItemID = PLD.PLItemID AND I.ItemID = PLD.ItemID" &
            " WHERE C.ClaimID = @ClaimID and CI.LegacyID IS NULL AND CI.ValidityTo IS NULL AND PL.ValidityTo IS NULL AND PLD.ValidityTo IS NULL"


        data.setSQLCommand(sSQLClaimedItems, CommandType.Text)

        data.params("@ClaimID", ClaimID)

        dtClaimedItems = data.Filldata()
        dtClaimedItems.TableName = "ClaimedItems"

        ds.Tables.Add(dtClaimedItems)
        ds.Tables.Add(dtClaimedServices)

        Return ds
    End Function
    Public Sub InsertClaim(ByRef eClaim As IMIS_EN.tblClaim)

        data.setSQLCommand("Insert Into tblClaim ([InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID],[Explanation],[Claimed]," _
                           & "[DateClaimed],[ValidityFrom],[AuditUserID],ClaimAdminID,ICDID1,ICDID2,ICDID3,ICDID4,VisitType,GuaranteeId,CareType,ReferFrom,ReferTo)" _
                           & "VALUES(@InsureeID, @HFID, @ClaimCode, @DateFrom, @DateTo, @ICDID, @Explanation,@Claimed, @DateClaimed, getdate(), @AuditUserID,@ClaimAdminID,@ICDID1,@ICDID2,@ICDID3,@ICDID4,@VisitType,@GuaranteeId,@CareType, @ReferFrom, @ReferTo);select @claimID = scope_identity()", CommandType.Text)
        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID, ParameterDirection.Output)
        data.params("@InsureeID", SqlDbType.Int, eClaim.tblInsuree.InsureeID)
        data.params("@HFID", SqlDbType.Int, eClaim.tblHF.HfID)
        data.params("@ICDID", SqlDbType.Int, eClaim.tblICDCodes.ICDID)
        data.params("@ClaimCode", SqlDbType.NVarChar, 10, eClaim.ClaimCode)
        data.params("@DateFrom", SqlDbType.SmallDateTime, eClaim.DateFrom)
        data.params("@DateTo", SqlDbType.SmallDateTime, If(eClaim.DateTo Is Nothing, SqlTypes.SqlDateTime.Null, eClaim.DateTo))
        data.params("@Explanation", SqlDbType.NText, 100, eClaim.Explanation)
        data.params("@Claimed", SqlDbType.Decimal, eClaim.Claimed)
        data.params("@DateClaimed", SqlDbType.SmallDateTime, eClaim.DateClaimed)
        data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)
        data.params("@ClaimAdminID", SqlDbType.Int, If(eClaim.tblClaimAdmin.ClaimAdminId = 0, Nothing, eClaim.tblClaimAdmin.ClaimAdminId))
        data.params("@ICDID1", SqlDbType.Int, eClaim.ICDID1)
        data.params("@ICDID2", SqlDbType.Int, eClaim.ICDID2)
        data.params("@ICDID3", SqlDbType.Int, eClaim.ICDID3)
        data.params("@ICDID4", SqlDbType.Int, eClaim.ICDID4)
        data.params("@VisitType", SqlDbType.Char, 1, eClaim.VisitType)
        data.params("@GuaranteeId", SqlDbType.NVarChar, 50, eClaim.GuaranteeId)
        data.params("@CareType", SqlDbType.Char, 1, eClaim.CareType)
        data.params("@ReferFrom", SqlDbType.Int, eClaim.ReferFrom)
        data.params("@ReferTo", SqlDbType.Int, eClaim.ReferTo)

        data.ExecuteCommand()
        eClaim.ClaimID = data.sqlParameters("@claimID")
    End Sub
    Public Sub UpdateClaim(ByRef eClaim As IMIS_EN.tblClaim)

        data.setSQLCommand("Insert Into tblClaim ([InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID],[ClaimStatus],[Adjuster],[Adjustment],[Claimed]" _
                           & ",[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus]" _
                           & ",[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],[RunID],[CLaimAdminId],[ICDID1],[ICDID2],[ICDID3],[ICDID4],[VisitType],GuaranteeId,CareType)" _
                           & "SELECT [InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID],[ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured]" _
                           & ",[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus]," _
                           & "[RejectionReason],[ValidityFrom],getdate(),[ClaimID],[AuditUserID],[RunID],[ClaimAdminId],[ICDID1],[ICDID2],[ICDID3],[ICDID4],[VisitType],GuaranteeId,CareType FROM tblClaim WHERE ClaimID=@ClaimID;" _
                           & " UPDATE [tblClaim] SET [ClaimCode]= @ClaimCode,[InsureeId]= @InsureeId,[ICDID]= @ICDId,[DateFrom]= @DateFrom,[DateTo]= @DateTo,[DateClaimed]= @DateClaimed,[Explanation]= @Explanation," _
                           & "[Claimed] = @Claimed,[ValidityFrom] = Getdate(),[AuditUserID] = @AuditUserID,ClaimAdminID = @ClaimAdminID " &
                           " ,ICDID1 = @ICDID1,ICDID2 = @ICDID2,ICDID3 = @ICDID3,ICDID4 = @ICDID4,VisitType = @VisitType,GuaranteeId = @GuaranteeId, CareType=@CareType " &
                           " WHERE claimID = @claimID", CommandType.Text)

        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@InsureeId", SqlDbType.Int, eClaim.tblInsuree.InsureeID)
        data.params("@ICDID", SqlDbType.Int, eClaim.tblICDCodes.ICDID)
        data.params("@ClaimCode", SqlDbType.NVarChar, 10, eClaim.ClaimCode)
        data.params("@DateFrom", SqlDbType.SmallDateTime, eClaim.DateFrom)
        data.params("@DateTo", SqlDbType.SmallDateTime, If(eClaim.DateTo Is Nothing, SqlTypes.SqlDateTime.Null, eClaim.DateTo))
        data.params("@Claimed", SqlDbType.Decimal, eClaim.Claimed)
        data.params("@DateClaimed", SqlDbType.Date, eClaim.DateClaimed)
        data.params("@Explanation", SqlDbType.NText, 100, eClaim.Explanation)
        data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)
        data.params("@ClaimAdminID", SqlDbType.Int, If(eClaim.tblClaimAdmin.ClaimAdminId = 0, Nothing, eClaim.tblClaimAdmin.ClaimAdminId))
        data.params("@ICDID1", SqlDbType.Int, eClaim.ICDID1)
        data.params("@ICDID2", SqlDbType.Int, eClaim.ICDID2)
        data.params("@ICDID3", SqlDbType.Int, eClaim.ICDID3)
        data.params("@ICDID4", SqlDbType.Int, eClaim.ICDID4)
        data.params("@VisitType", SqlDbType.Char, 1, eClaim.VisitType)
        data.params("@GuaranteeId", SqlDbType.NVarChar, 50, eClaim.GuaranteeId)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaim.ClaimStatus)
        data.params("@CareType", SqlDbType.Char, 1, eClaim.CareType)

        data.ExecuteCommand()
    End Sub
    Public Function IsClaimStatusChanged(ByRef eClaim As IMIS_EN.tblClaim) As DataTable
        Dim str As String = "SELECT ClaimStatus from tblClaim inner join tblHF on tblHF.HfID = tblClaim.HFID " &
                            " WHERE ClaimID = @claimID and tblClaim.ValidityTo is null " 'and tblClaim.HFID = @HFID
#If HIB Then
        str = "SELECT ClaimStatus from tblClaim inner join tblHF on tblHF.HfID = tblClaim.HFID " &
                            " WHERE ClaimID = @claimID and tblClaim.ValidityTo is null " 'and tblClaim.HFID = @HFID

#End If
        data.setSQLCommand(str, CommandType.Text)

        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        ' data.params("@HFID", SqlDbType.Int, eClaim.tblHF.HfID)

        Return data.Filldata

    End Function
    Public Sub UpdateClaimTotalValue(ByRef eClaim As IMIS_EN.tblClaim)
        Dim str As String = "Update tblClaim set [Claimed] = @Claimed where claimID = @claimID"

        data.setSQLCommand(str, CommandType.Text)

        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@Claimed", SqlDbType.Decimal, eClaim.Claimed)

        data.ExecuteCommand()
    End Sub

    Public Function IsClaimReviewStatusChanged(ByVal eClaim As IMIS_EN.tblClaim) As DataTable
        Dim str As String = "select ReviewStatus from tblClaim where ClaimID = @ClaimID and ValidityTo is null"

        data.setSQLCommand(str, CommandType.Text)

        data.params("@ClaimID", SqlDbType.Int, eClaim.ClaimID)

        Return data.Filldata
    End Function
    Public Sub UpdateClaimApprovedValue(ByRef eClaim As IMIS_EN.tblClaim)
        Dim str As String = "Update tblClaim set [Approved] = @Approved where claimID = @claimID"

        data.setSQLCommand(str, CommandType.Text)

        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@Approved", SqlDbType.Decimal, eClaim.Approved)

        data.ExecuteCommand()
    End Sub


    Public Function ManualSelectionUpdate(ByVal eClaim As IMIS_EN.tblClaim) As Boolean

        Dim str As String = "INSERT INTO tblClaim ([InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID],[ClaimStatus],[Adjuster],[Adjustment],[Claimed]" _
                           & ",[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus]" _
                           & ",[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],[ValidityTo],[LegacyID],[AuditUserID],[RunID],ClaimAdminID" _
                           & " ,GuaranteeId,[ICDID1],[ICDID2],[ICDID3],[ICDID4],[VisitType])" _
                           & "SELECT [InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID],[ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured]" _
                           & ",[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus]," _
                           & "[RejectionReason],[ValidityFrom],getdate(),[ClaimID],[AuditUserID],[RunID],ClaimAdminID,GuaranteeId,[ICDID1],[ICDID2],[ICDID3],[ICDID4],[VisitType] FROM tblClaim WHERE ClaimID=@ClaimID;" _
                           & " UPDATE [tblClaim] SET [ValidityFrom] = Getdate(),[AuditUserID] = @AuditUserID "


        If Not eClaim.ReviewStatus Is Nothing Then
            str += " ,[ReviewStatus] = @ReviewStatus"
        End If
        If Not eClaim.FeedbackStatus Is Nothing Then
            str += " ,[FeedbackStatus] = @FeedbackStatus"
        End If

        str += " WHERE claimID = @claimID"
        data.setSQLCommand(str, CommandType.Text)

        data.params("@ClaimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)
        If Not eClaim.ReviewStatus Is Nothing Then
            data.params("@ReviewStatus", SqlDbType.TinyInt, eClaim.ReviewStatus)
        End If
        If Not eClaim.FeedbackStatus Is Nothing Then
            data.params("@FeedbackStatus", SqlDbType.TinyInt, eClaim.FeedbackStatus)
        End If

        data.ExecuteCommand()

        Return True
    End Function
    Public Function checkClaimCode(ByVal eClaim As IMIS_EN.tblClaim) As DataTable
        Dim str As String
        If CInt(System.Configuration.ConfigurationManager.AppSettings("UniqueClaimCode")) = 0 Then
            str = "SELECT top 1 ClaimCode from tblClaim inner join tblHF on tblHF.HfID = tblClaim.HFID" &
                               " where ClaimCode = @ClaimCode and tblClaim.ValidityTo is null and tblClaim.HfID = @HfID"
            data.setSQLCommand(str, CommandType.Text)

            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaim.ClaimCode)
            data.params("@HfID", SqlDbType.Int, eClaim.tblHF.HfID)
        End If
        If CInt(System.Configuration.ConfigurationManager.AppSettings("UniqueClaimCode")) = 1 Then
            str = "SELECT top 1 ClaimCode from tblClaim" &
                            " where ClaimCode = @ClaimCode and tblClaim.ValidityTo is null"

            data.setSQLCommand(str, CommandType.Text)
            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaim.ClaimCode)
        End If

        Return data.Filldata
    End Function
    Public Sub UpdateClaimReview(ByRef eClaim As IMIS_EN.tblClaim)

        Dim strSQL As String = "select top 1 ClaimID from tblClaim where validityFromReview is null and ClaimID = @ClaimID;if @@rowcount > 0 begin UPDATE tblClaim SET  [Adjustment] = @Adjustment, [ValidityFromReview] = getdate(), [AudituserIdReview] = @AuditUserID "
        If Not eClaim.Approved Is Nothing Then
            strSQL += ", [Approved] = @Approved"
        End If
        If Not eClaim.ReviewStatus Is Nothing Then
            strSQL += " ,[ReviewStatus] = @ReviewStatus"
        End If

        strSQL += " WHERE ClaimID = @ClaimID; end else begin Insert Into tblClaim ([InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID], [ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],[ValidityTo],[LegacyID], [AuditUserID],[ValidityFromReview],[ValidityToReview],[AuditUserIDReview]) SELECT [InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID], [ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed], [Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],getdate(),[ClaimID], [AuditUserID],[ValidityFromReview],[ValidityToReview],[AuditUserIDReview] FROM tblClaim WHERE ClaimID = @ClaimID; UPDATE tblClaim SET  [Adjustment] = @Adjustment ,[ValidityFromReview] = getdate(), [AudituserIdReview] = @AuditUserID"

        If Not eClaim.Approved Is Nothing Then
            strSQL += ", [Approved] = @Approved"
        End If
        If Not eClaim.ReviewStatus Is Nothing Then
            strSQL += ",[ReviewStatus] = @ReviewStatus"
        End If

        strSQL += " Where ClaimID = @ClaimID; End"
        data.setSQLCommand(strSQL, CommandType.Text)

        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@Adjustment", SqlDbType.NText, eClaim.Adjustment, ParameterDirection.Input)
        data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)

        If Not eClaim.Approved Is Nothing Then
            data.params("@Approved", SqlDbType.Decimal, eClaim.Approved)
        End If
        If Not eClaim.ReviewStatus Is Nothing Then
            data.params("@ReviewStatus", SqlDbType.TinyInt, eClaim.ReviewStatus)
        End If

        data.ExecuteCommand()
    End Sub

    Public Function GetSampleBatchClaims(ByRef eClaims As IMIS_EN.tblClaim) As DataTable

        Dim sSQL As String
        sSQL = "SELECT " + UtilitiesDAL.GetEnvMaxRows()

        sSQL += " tblClaim.ClaimID, Claimed, ISNULL(Approved, 0) as Approved, "
        sSQL += " ClaimSampleBatchID, IsBatchSampleForVerify, ReviewStatus "
        sSQL += " from tblClaim where 1=1"
        If eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " and tblClaim.ClaimSampleBatchID=@ClaimSampleBatchID "
        End If

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, eClaims.ClaimSampleBatchID)

        Return data.Filldata
    End Function

    Public Function IsClaimStatusChecked(ByVal eClaim As IMIS_EN.tblClaim) As DataTable
        Dim str As String = "select ClaimStatus from tblClaim where ClaimID = @ClaimID and ValidityTo is null"
        data.setSQLCommand(str, CommandType.Text)

        data.params("@ClaimID", SqlDbType.Int, eClaim.ClaimID)

        Return data.Filldata
    End Function

    Public Function SelectClaims() As String
        Dim sSQL As String

        sSQL = "SELECT " + UtilitiesDAL.GetEnvMaxRows()

        sSQL += " tblClaim.ClaimID,claimcode,DateClaimed,Claimed,ISNULL(Approved, Claimed)Approved, ClaimSt.name as ClaimStatus,"
        sSQL += " FeedbackStatus,ReviewStatus,tblClaim.RowID,tblHF.HFCode,HFName,tblClaim.HfID,tblClaim.ClaimAdminID,"
        sSQL += " Cadm.ClaimAdminID,Cadm.ClaimAdminCode,Cadm.LastName CadminLastName,Cadm.OtherNames CadminOtherNames,tblInsuree.CHFID, Attachment, "
        sSQL += " ClaimSampleBatchID, IsBatchSampleForVerify, 4 as terobau "
        sSQL += " from tblClaim"
        sSQL += " INNER JOIN tblICDCodes ON tblICDCodes.ICDID = tblClaim.ICDID"
        sSQL += " INNER JOIN tblInsuree ON tblInsuree.InsureeID = tblClaim.InsureeID"
        sSQL += " INNER JOIN tblFamilies ON tblFamilies.FamilyID = tblInsuree.FamilyID"
        sSQL += " INNER JOIN tblHF ON tblClaim.HfID = tblHF.HfID"

        ' sSQL += " INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblHF.LocationId"
        'sSQL += " INNER JOIN tblVillages V ON V.VillageId = tblFamilies.LocationId"
        'sSQL += " INNER JOIN tblWards W ON W.WardId =V.WardId"
        'sSQL += " INNER JOIN tblDistricts FMD ON FMD.DistrictId= W.DistrictId"
        'sSQL += " INNER JOIN tblRegions FMR ON FMR.RegionId = FMD.Region"
        sSQL += "  inner join tbllocations v on v.LocationId=tblFamilies.LocationId"
        sSQL += "  inner join tbllocations w on w.LocationId=v.ParentLocationId"
        sSQL += "  inner join tbllocations FMD on FMD.LocationId=w.ParentLocationId"
        sSQL += " inner join tbllocations FMR on FMR.LocationId=FMD.ParentLocationId"
        'sSQL += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId = FMD.DistrictId"
        sSQL += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId = FMD.locationid"
        sSQL += " AND tblUsersDistricts.UserID = @UserID"
        sSQL += " AND tblUsersDistricts.ValidityTo IS NULL"
        sSQL += " INNER JOIN @ClaimSt ClaimSt ON ClaimSt.ID = tblClaim.ClaimStatus"
        sSQL += " LEFT JOIN tblClaimAdmin Cadm ON Cadm.ClaimAdminId = tblClaim.ClaimAdminId"
        Return sSQL

    End Function

    'Corrected by Rogers
    Public Function GetReviewClaims(ByRef eClaims As IMIS_EN.tblClaim, ByVal claimStatus As DataTable, ByVal UserID As Integer) As DataTable

        'Dim sSQL As String = ""
        Dim sSQL As String = SelectClaims()


        sSQL += " WHERE tblClaim.ValidityTo IS NULL AND @FeedbackStatus & tblClaim.FeedbackStatus > 0"
        sSQL += " AND @ReviewStatus & tblClaim.ReviewStatus > 0 AND @ClaimStatus & tblClaim.ClaimStatus  > 0"
        sSQL += " AND (CASE WHEN @ICDID = 0 THEN 0 ELSE tblICDCodes.ICDID END) = @ICDID"

        If eClaims.ClaimSampleBatchID = -1 Then
            sSQL += " AND tblClaim.ClaimSampleBatchID is null "
        ElseIf eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " AND tblClaim.ClaimSampleBatchID=@ClaimSampleBatchID"
        End If
        If eClaims.Attachment = 1 Then
            sSQL += " AND tblClaim.Attachment= 1"
        End If

        If Not IsNothing(eClaims.tblHF) Then
            If eClaims.tblHF.RegionId <> 0 Then
                sSQL += " AND FMR.locationid = @RegionId"
            End If
            If eClaims.tblHF.DistrictId <> 0 Then
                sSQL += " AND FMD.LocationId = @DistrictId"
            End If
            If eClaims.tblBatchRun.RunID <> 0 Then
                sSQL += " AND tblClaim.RunID = @RunID"
            End If
            If eClaims.tblHF.HfID <> 0 Then
                sSQL += " AND tblHF.HfID = @HFID"
            End If
            'If Not eClaims.tblHF.HFName = Nothing Then
            '    sSQL += " and tblHF.HFName like @HFName + '%'"
            'End If
            If Not eClaims.tblHF.HFName = Nothing Then
                sSQL += " and tblHF.HFName= @HFName"
            End If
        End If
        'If Not eClaims.tblInsuree.CHFID = Nothing Then
        '    sSQL += " and tblInsuree.CHFID like @CHFID + '%'"
        'End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            sSQL += " and tblInsuree.CHFID =@CHFID"
        End If
        'If Not eClaims.ClaimCode = Nothing Then
        '    sSQL += " and tblClaim.ClaimCode like @ClaimCode + '%'"
        'End If
        If Not eClaims.ClaimCode = Nothing Then
            sSQL += " and tblClaim.ClaimCode = @ClaimCode"
        End If

        If Not eClaims.DateFrom = Nothing Then
            sSQL += " and tblClaim.DateTo >= @DateFrom"
        End If
        If Not eClaims.DateTo Is Nothing Then
            sSQL += " and tblClaim.DateTo <= @DateTo"
        End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> start..
        If Not eClaims.DateClaimed = Nothing Then
            sSQL += " and tblClaim.DateClaimed >= @DateClaimedFrom"
        End If
        If eClaims.DateProcessed IsNot Nothing Then
            sSQL += " and tblClaim.DateClaimed <= @DateClaimedTo"
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range
        '    sSQL += " and tblClaim.DateClaimed between @DateClaimedFrom and @DateClaimedTo"
        'End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> end
        'If eClaims.tblClaimAdmin.ClaimAdminId <> 0 Then
        '    sSQL += " AND tblClaimAdmin.ClaimAdminID = @ClaimAdminID"
        'End If
        If eClaims.VisitType IsNot Nothing AndAlso eClaims.VisitType <> "" Then
            sSQL += " AND tblClaim.VisitType = @VisitType"
        End If
        ' Change By Purushottam Starts
        'If eClaims.Claimed Is Nothing AndAlso eClaims.Adjuster Is Nothing Then
        sSQL += " AND tblClaim.Claimed >= @Claimed AND tblClaim.Claimed <= @Adjuster"
        'End If
        If eClaims.ClaimCategory IsNot Nothing Then
            sSQL += " and tblInsuree.Gender = @ClaimCategory" 'used for carrier for gender
        End If
        'If eClaims.Attachment = 1 Then
        'sSQL += " AND tblClaim.ClaimID in (select claim_id from claim_ClaimAttachmentsCountView where attachments_count>=1)"
        'End If

        ' Change By Purushottam Ends
        If eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " order by  tblClaim.ClaimSampleBatchID desc"
        Else
            sSQL += " order by  ClaimID desc"
        End If

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, eClaims.ClaimSampleBatchID)
        data.params("@UserID", SqlDbType.Int, UserID)
        data.params("@FeedbackStatus", SqlDbType.TinyInt, eClaims.FeedbackStatus)
        data.params("@ReviewStatus", SqlDbType.TinyInt, eClaims.ReviewStatus)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaims.ClaimStatus)
        data.params("@ClaimSt", claimStatus, "xAttribute")
        data.params("@ICDID", SqlDbType.Int, eClaims.tblICDCodes.ICDID)
        data.params("@VisitType", SqlDbType.Char, 1, eClaims.VisitType)
        ' Change By Purushottam Starts
        data.params("@Claimed", SqlDbType.Int, eClaims.Claimed)
        data.params("@Adjuster", SqlDbType.Int, eClaims.Adjuster)
        data.params("@Attachment", SqlDbType.Bit, eClaims.Attachment)

        If eClaims.VisitType = "O" Or eClaims.VisitType = "R" And eClaims.GuaranteeId IsNot "0" Then
            data.params("@OpdIpd", SqlDbType.Char, 3, eClaims.GuaranteeId)
        End If
        If Not eClaims.ClaimCategory = Nothing Then
            data.params("@ClaimCategory", SqlDbType.Char, 1, eClaims.ClaimCategory)
        End If
        ' Change By Purushottam Ends
        If eClaims.tblHF.RegionId <> 0 Then
            data.params("@RegionId", SqlDbType.Int, eClaims.tblHF.RegionId)
        End If

        If eClaims.tblHF.DistrictId <> 0 Then
            data.params("@DistrictId", SqlDbType.Int, eClaims.tblHF.DistrictId)
        End If
        If eClaims.tblBatchRun.RunID <> 0 Then
            data.params("@RunID", SqlDbType.Int, eClaims.tblBatchRun.RunID)
        End If
        If eClaims.tblHF.HfID <> 0 Then
            data.params("@HFID", SqlDbType.Int, eClaims.tblHF.HfID)
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            data.params("@CHFID", SqlDbType.NVarChar, 12, eClaims.tblInsuree.CHFID)
        End If
        If Not eClaims.tblHF.HFName = Nothing Then
            data.params("@HFName", SqlDbType.NVarChar, 100, eClaims.tblHF.HFName)
        End If
        If Not eClaims.ClaimCode = Nothing Then
            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaims.ClaimCode)
        End If
        If Not eClaims.DateFrom = Nothing Then
            data.params("@DateFrom", SqlDbType.SmallDateTime, eClaims.DateFrom)
        End If
        If Not eClaims.DateTo Is Nothing Then
            data.params("@DateTo", SqlDbType.SmallDateTime, eClaims.DateTo)
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range
        data.params("@DateClaimedFrom", SqlDbType.Date, eClaims.DateClaimed)
        data.params("@DateClaimedTo", SqlDbType.Date, eClaims.DateProcessed) 'Used as a carrier for ClaimedDate to range
        'End If
        If eClaims.tblClaimAdmin.ClaimAdminId <> 0 Then
            data.params("@ClaimAdminID", SqlDbType.Int, eClaims.tblClaimAdmin.ClaimAdminId)
        End If
        Return data.Filldata
    End Function

    Public Function GetBatchClaims(ByRef eClaims As IMIS_EN.tblClaim, ByVal claimStatus As DataTable, ByVal UserID As Integer) As DataTable

        'Dim sSQL As String = ""
        Dim sSQL As String = SelectClaims()
        sSQL += " WHERE 1=1"
        sSQL += " AND tblUsersDistricts.UserID = @UserID"
        If eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " AND tblClaim.ClaimSampleBatchID=@ClaimSampleBatchID"
        End If


        ' Change By Purushottam Ends
        If eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " order by  IsBatchSampleForVerify desc"
        Else
            sSQL += " order by  ClaimID desc"
        End If

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, eClaims.ClaimSampleBatchID)
        data.params("@UserID", SqlDbType.Int, UserID)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaims.ClaimStatus)
        data.params("@ClaimSt", claimStatus, "xAttribute")

        Return data.Filldata
    End Function

    'Corrected By Rogersa
    Public Function GetReviewClaimsCount(ByRef eClaims As IMIS_EN.tblClaim, ByVal claimStatus As DataTable, ByVal UserID As Integer) As DataTable

        Dim sSQL As String = ""
        sSQL += " SELECT COUNT(tblClaim.ClaimID)[Count]  FROM tblClaim"
        sSQL += " INNER JOIN tblICDCodes ON tblICDCodes.ICDID = tblClaim.ICDID"
        sSQL += " LEFT JOIN tblInsuree ON tblInsuree.InsureeID = tblClaim.InsureeID"
        sSQL += " INNER JOIN tblFamilies ON tblFamilies.FamilyID = tblInsuree.FamilyID"
        'sSQL += " INNER JOIN tblVillages V ON V.VillageId=tblFamilies.LocationId"
        'sSQL += " INNER JOIN tblWards W ON W.WardId=V.WardId"
        'sSQL += " INNER JOIN tblDistricts ON tblDistricts.DistrictID = W.DistrictId"
        sSQL += "  inner join tbllocations v on v.LocationId=tblFamilies.LocationId"
        sSQL += " inner join tbllocations w on w.LocationId=v.ParentLocationId"
        sSQL += " inner join tbllocations d on d.LocationId=w.ParentLocationId"
        sSQL += " INNER JOIN tblHF ON tblClaim.HfID = tblHF.HfID"
        'sSQL += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId =  tblDistricts.DistrictID"
        sSQL += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId =  d.LocationId"
        sSQL += " AND tblUsersDistricts.UserID = @UserID"
        sSQL += " AND tblUsersDistricts.ValidityTo IS NULL"
        sSQL += " INNER JOIN @ClaimSt ClaimSt ON ClaimSt.ID = tblClaim.ClaimStatus"
        sSQL += " WHERE tblClaim.ValidityTo IS NULL AND  @FeedbackStatus & tblClaim.FeedbackStatus > 0"
        sSQL += " AND  @ReviewStatus & tblClaim.ReviewStatus > 0"
        sSQL += " AND  @ClaimStatus & tblClaim.ClaimStatus  > 0"
        sSQL += " AND (CASE WHEN @ICDID = 0 THEN 0 ELSE tblClaim.ICDID END) = @ICDID"

        If eClaims.Attachment = 1 Then
            sSQL += " AND tblClaim.Attachment= 1"
        End If

        If Not eClaims.LegacyID = 0 Then
            sSQL += " AND tblHF.LocationId = @LocationId"
        End If

        If Not eClaims.tblBatchRun.RunID = Nothing Then
            sSQL += " and tblClaim.RunID = @RunID"
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            sSQL += " and tblClaim.HfID = @HFID"
        End If
        'If Not eClaims.tblHF.HFName = Nothing Then
        '    sSQL += " and tblHF.HFName like @HFName + '%'"
        'End If
        'If Not eClaims.tblInsuree.CHFID = Nothing Then
        '    sSQL += " and tblInsuree.CHFID like @CHFID + '%'"
        'End If
        'If Not eClaims.ClaimCode = Nothing Then
        '    sSQL += " and tblClaim.ClaimCode like @ClaimCode + '%'"
        'End If
        If Not eClaims.tblHF.HFName = Nothing Then
            sSQL += " and tblHF.HFName = @HFName"
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            sSQL += " and tblInsuree.CHFID = @CHFID"
        End If
        If Not eClaims.ClaimCode = Nothing Then
            sSQL += " and tblClaim.ClaimCode = @ClaimCode"
        End If

        If Not eClaims.DateFrom = Nothing Then
            sSQL += " and tblClaim.DateTo >= @DateFrom"
        End If
        If Not eClaims.DateTo Is Nothing Then
            sSQL += " and tblClaim.DateTo <= @DateTo"
        End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> start..
        If Not eClaims.DateClaimed = Nothing Then
            sSQL += " and tblClaim.DateClaimed >= @DateClaimedFrom"
        End If
        If eClaims.DateProcessed IsNot Nothing Then
            sSQL += " and tblClaim.DateClaimed <= @DateClaimedTo"
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range 
        '    sSQL += " and tblClaim.DateClaimed between @DateClaimedFrom and @DateClaimedTo"
        'End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> end
        If eClaims.VisitType IsNot Nothing AndAlso eClaims.VisitType <> "" Then
            sSQL += " AND tblClaim.VisitType = @VisitType"
        End If
        ' Change By Purushottam Starts
        'If eClaims.Claimed Is Nothing AndAlso eClaims.Adjuster Is Nothing Then
        sSQL += " AND tblClaim.Claimed >= @Claimed AND tblClaim.Claimed <= @Adjuster"
        'End If
        If eClaims.ClaimCategory IsNot Nothing Then
            sSQL += " and tblInsuree.Gender = @ClaimCategory" 'used for carrier for gender
        End If
        If eClaims.ClaimSampleBatchID <> 0 Then
            sSQL += " and tblClaim.ClaimSampleBatchID = @ClaimSampleBatchID"

        End If

        ' Change By Purushottam Ends

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, eClaims.ClaimSampleBatchID)
        data.params("@UserID", SqlDbType.Int, UserID)
        data.params("@LocationId", SqlDbType.Int, eClaims.LegacyID) 'Used as a carrier for DistrictID 
        data.params("@FeedbackStatus", SqlDbType.TinyInt, eClaims.FeedbackStatus)
        data.params("@ReviewStatus", SqlDbType.TinyInt, eClaims.ReviewStatus)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaims.ClaimStatus)
        data.params("@ClaimSt", claimStatus, "xAttribute")
        data.params("@ICDID", SqlDbType.Int, eClaims.tblICDCodes.ICDID)
        data.params("@VisitType", SqlDbType.Char, 1, eClaims.VisitType)
        ' Change By Purushottam Starts
        data.params("@Claimed", SqlDbType.Int, eClaims.Claimed)
        data.params("@Adjuster", SqlDbType.Int, eClaims.Adjuster)
        'data.params("@Attachment", SqlDbType.Bit, eClaims.Attachment)
        If Not eClaims.ClaimCategory = Nothing Then
            data.params("@ClaimCategory", SqlDbType.Char, 1, eClaims.ClaimCategory)
        End If
        ' Change By Purushottam Ends
        If Not eClaims.tblBatchRun.RunID = Nothing Then
            data.params("@RunID", SqlDbType.Int, eClaims.tblBatchRun.RunID)
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            data.params("@HFID", SqlDbType.Int, eClaims.tblHF.HfID)
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            data.params("@CHFID", SqlDbType.NVarChar, 12, eClaims.tblInsuree.CHFID)
        End If
        If Not eClaims.tblHF.HFName = Nothing Then
            data.params("@HFName", SqlDbType.NVarChar, 100, eClaims.tblHF.HFName)
        End If
        If Not eClaims.ClaimCode = Nothing Then
            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaims.ClaimCode)
        End If
        If Not eClaims.DateFrom = Nothing Then
            data.params("@DateFrom", SqlDbType.DateTime, eClaims.DateFrom)
        End If
        If Not eClaims.DateTo Is Nothing Then
            data.params("@DateTo", SqlDbType.SmallDateTime, eClaims.DateTo)
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range
        data.params("@DateClaimedFrom", SqlDbType.Date, eClaims.DateClaimed)
        data.params("@DateClaimedTo", SqlDbType.Date, eClaims.DateProcessed) 'Used as a carrier for ClaimedDate to range
        'End If
        Return data.Filldata
    End Function

    Public Function GetClaims(ByRef eClaims As IMIS_EN.tblClaim, ByVal claimStatus As DataTable, ByVal FeedbackStatus As DataTable, ByVal ReviewStatus As DataTable, ByVal UserID As Integer) As DataTable

        'Dim sSQL As String = ""
        Dim sSQL As String
        sSQL = "SELECT " + UtilitiesDAL.GetEnvMaxRows()

        sSQL += "  tblClaim.ClaimID,tblClaim.ClaimUUID,claimcode,DateClaimed,Claimed,CASE WHEN ClaimStatus = 2 THEN Approved                                             ELSE ISNULL(Approved, Claimed) END Approved,"
        sSQL += " tblClaim.HfID,ClaimSt.name AS ClaimStatus,FeedbackSt.name AS FeedbackStatus, ReviewSt.name AS ReviewStatus ,tblClaim.RowID,"
        sSQL += " tblHF.HFCode,HFName,tblClaim.HfID,Cadm.ClaimAdminID,Cadm.ClaimAdminCode,Cadm.LastName CadminLastName,Cadm.OtherNames CadminOtherNames,  VisitType, Attachment "
        sSQL += ",tblClaim.ClaimAmountPayment, tblClaim.SampleAmountDecrease, tblClaim.SampleAmountPercent,tblClaim.ClaimSampleBatchID"
        sSQL += " FROM tblClaim"
        sSQL += " INNER JOIN tblICDCodes ON tblICDCodes.ICDID = tblClaim.ICDID"
        sSQL += " INNER JOIN tblInsuree ON tblInsuree.InsureeID = tblClaim.InsureeID"
        sSQL += " INNER JOIN TblFamilies ON tblFamilies.FamilyID = tblInsuree.FamilyID"
        sSQL += " INNER JOIN tblHF ON tblClaim.HfID = tblHF.HfID"
        'sSQL += " INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblHF.LocationId"
        'sSQL += " INNER JOIN tblRegions ON tblRegions.RegionId = tblDistricts.Region"
        sSQL += " INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblHF.LocationId"
        sSQL += " INNER JOIN tblRegions ON tblRegions.RegionId = tblDistricts.Region"
        sSQL += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId =  tblHF.LocationId"
        sSQL += " AND tblUsersDistricts.UserID = @UserID AND tblUsersDistricts.ValidityTo IS NULL"
        sSQL += " INNER JOIN @ClaimSt ClaimSt ON ClaimSt.ID = tblClaim.ClaimStatus"
        sSQL += " INNER JOIN @FeedbackSt FeedbackSt ON FeedbackSt.ID = tblClaim.FeedbackStatus"
        sSQL += " INNER JOIN @ReviewSt ReviewSt ON ReviewSt.ID = tblClaim.ReviewStatus"
        sSQL += " LEFT JOIN tblClaimAdmin Cadm ON Cadm.ClaimAdminId = tblClaim.ClaimAdminId"
        sSQL += " WHERE tblClaim.ValidityTo IS NULL"
        sSQL += " AND tblHF.ValidityTo IS NULL"
        sSQL += " AND (tblRegions.RegionId = @RegionId OR @RegionId = 0)"
        sSQL += " AND (tblDistricts.DistrictId = @DistrictId OR @DistrictId = 0)"
        sSQL += " AND  @FeedbackStatus & tblClaim.FeedbackStatus > 0  AND  @ReviewStatus & tblClaim.ReviewStatus > 0 AND  @ClaimStatus & tblClaim.ClaimStatus  > 0"
        sSQL += " AND (CASE WHEN @ICDID = 0 THEN 0 ELSE tblClaim.ICDID END) = @ICDID "

        If Not eClaims.tblBatchRun.RunID = Nothing Then
            sSQL += " and tblClaim.RunID = @RunID"
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            sSQL += " and tblClaim.HfID = @HFID"
        End If
        'If Not eClaims.tblHF.HFName = Nothing Then
        '    sSQL += " and tblHF.HFName like @HFName + '%'"
        'End If
        'If Not eClaims.tblInsuree.CHFID = Nothing Then
        '    sSQL += " and tblInsuree.CHFID like @CHFID + '%'"
        'End If
        'If Not eClaims.ClaimCode = Nothing Then
        '    sSQL += " and tblClaim.ClaimCode like @ClaimCode + '%'"
        'End If
        If Not eClaims.tblHF.HFName = Nothing Then
            sSQL += " and tblHF.HFName = @HFName"
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            sSQL += " and tblInsuree.CHFID = @CHFID"
        End If
        If Not eClaims.ClaimCode = Nothing Then
            sSQL += " and tblClaim.ClaimCode = @ClaimCode"
        End If
        If Not eClaims.DateFrom = Nothing Then
            sSQL += " and tblClaim.DateFrom >= @DateFrom"
        End If
        If Not eClaims.DateTo Is Nothing Then
            sSQL += " and tblClaim.DateTo <= @DateTo"
        End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> start..
        If Not eClaims.DateClaimed = Nothing Then
            sSQL += " and tblClaim.DateClaimed >= @DateClaimedFrom"
        End If
        If eClaims.DateProcessed IsNot Nothing Then
            sSQL += " and tblClaim.DateClaimed <= @DateClaimedTo"
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range 
        '    sSQL += " and tblClaim.DateClaimed between @DateClaimedFrom and @DateClaimedTo"
        'End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> end
        If eClaims.tblClaimAdmin.ClaimAdminId <> 0 Then
            sSQL += " AND tblClaim.ClaimAdminID = @ClaimAdminID"
        End If
        If eClaims.VisitType IsNot Nothing AndAlso eClaims.VisitType <> "" Then
            sSQL += " AND tbLClaim.VisitType = @VisitType"
        End If
        If eClaims.Attachment = 1 Then
            sSQL += " AND tblClaim.Attachment= 1"
        End If

        sSQL += " ORDER BY ClaimID DESC"
        data.setSQLCommand(sSQL, CommandType.Text)

        data.params("@UserID", SqlDbType.Int, UserID)
        data.params("@RegionId", SqlDbType.Int, eClaims.tblHF.RegionId)
        data.params("@DistrictId", SqlDbType.Int, eClaims.tblHF.DistrictId)
        data.params("@FeedbackStatus", SqlDbType.TinyInt, eClaims.FeedbackStatus)
        data.params("@ReviewStatus", SqlDbType.TinyInt, eClaims.ReviewStatus)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaims.ClaimStatus)
        data.params("@ClaimSt", claimStatus, "xAttribute")
        data.params("@FeedbackSt", FeedbackStatus, "xAttribute")
        data.params("@ReviewSt", ReviewStatus, "xAttribute")
        data.params("@ICDID", SqlDbType.Int, eClaims.tblICDCodes.ICDID)
        data.params("@VisitType", SqlDbType.Char, 1, eClaims.VisitType)
        'data.params("@Attachment", SqlDbType.Bit, eClaims.Attachment)
        If Not eClaims.tblBatchRun.RunID = Nothing Then
            data.params("@RunID", SqlDbType.Int, eClaims.tblBatchRun.RunID)
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            data.params("@HFID", SqlDbType.Int, eClaims.tblHF.HfID)
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            data.params("@CHFID", SqlDbType.NVarChar, 12, eClaims.tblInsuree.CHFID)
        End If
        If Not eClaims.tblHF.HFName = Nothing Then
            data.params("@HFName", SqlDbType.NVarChar, 100, eClaims.tblHF.HFName)
        End If
        If Not eClaims.ClaimCode = Nothing Then
            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaims.ClaimCode)
        End If
        If Not eClaims.DateFrom = Nothing Then
            data.params("@DateFrom", SqlDbType.SmallDateTime, eClaims.DateFrom)
        End If
        If Not eClaims.DateTo Is Nothing Then
            data.params("@DateTo", SqlDbType.SmallDateTime, eClaims.DateTo)
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range 
        data.params("@DateClaimedFrom", SqlDbType.Date, eClaims.DateClaimed)
        data.params("@DateClaimedTo", SqlDbType.Date, eClaims.DateProcessed)
        'End If
        If eClaims.tblClaimAdmin.ClaimAdminId <> 0 Then
            data.params("@ClaimAdminID", SqlDbType.Int, eClaims.tblClaimAdmin.ClaimAdminId)
        End If

        Return data.Filldata
    End Function
    'Corrected By Rogers
    Public Function GetClaimsCount(ByRef eClaims As IMIS_EN.tblClaim, ByVal claimStatus As DataTable, ByVal FeedbackStatus As DataTable, ByVal ReviewStatus As DataTable, ByVal UserID As Integer) As DataTable
        Dim ssql As String = ""

        ssql += " SELECT COUNT(tblClaim.ClaimID)[Count] FROM tblClaim"
        ssql += " INNER JOIN tblICDCodes ON tblICDCodes.ICDID = tblClaim.ICDID"
        ssql += " LEFT JOIN tblInsuree ON tblInsuree.InsureeID = tblClaim.InsureeID"
        ssql += " INNER JOIN tblFamilies ON tblFamilies.FamilyID = tblInsuree.FamilyID"
        ssql += " INNER JOIN tblHF ON tblClaim.HfID = tblHF.HfID"
        ssql += " INNER JOIN tblDistricts ON tblDistricts.DistrictID = tblHF.LocationId"
        ssql += " INNER JOIN tblusersdistricts ON tblusersdistricts.LocationId =  tblHF.LocationId"
        ssql += " AND tblUsersDistricts.UserID = @UserID"
        ssql += " AND tblUsersDistricts.ValidityTo IS NULL"
        ssql += " INNER JOIN @ClaimSt ClaimSt ON ClaimSt.ID = tblClaim.ClaimStatus"
        ssql += " INNER JOIN @FeedbackSt FeedbackSt ON FeedbackSt.ID = tblClaim.FeedbackStatus"
        ssql += " INNER JOIN @ReviewSt ReviewSt ON ReviewSt.ID = tblClaim.ReviewStatus"
        ssql += " WHERE(tblClaim.ValidityTo Is null  And (CASE @LocationId WHEN 0 THEN @LocationId ELSE tblDistricts.DistrictID END) = @LocationId  And tblHF.ValidityTo Is null)"
        ssql += " AND  @FeedbackStatus & tblClaim.FeedbackStatus > 0"
        ssql += " AND  @ReviewStatus & tblClaim.ReviewStatus > 0"
        ssql += " AND  @ClaimStatus & tblClaim.ClaimStatus  > 0"
        ssql += " AND (CASE WHEN @ICDID = 0 THEN 0 ELSE tblClaim.ICDID END) = @ICDID "

        'ssql += " AND tblClaim.Attachment= @Attachment"
        If eClaims.Attachment = 1 Then
            ssql += " AND tblClaim.Attachment= 1"
        End If
        If Not eClaims.tblBatchRun.RunID = Nothing Then
            ssql += " and tblClaim.RunID = @RunID"
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            ssql += " and tblClaim.HfID = @HFID"
        End If
        'If Not eClaims.tblHF.HFName = Nothing Then
        '    sSQL += " and tblHF.HFName like @HFName + '%'"
        'End If
        'If Not eClaims.tblInsuree.CHFID = Nothing Then
        '    sSQL += " and tblInsuree.CHFID like @CHFID + '%'"
        'End If
        'If Not eClaims.ClaimCode = Nothing Then
        '    sSQL += " and tblClaim.ClaimCode like @ClaimCode + '%'"
        'End If
        If Not eClaims.tblHF.HFName = Nothing Then
            ssql += " and tblHF.HFName = @HFName"
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            ssql += " and tblInsuree.CHFID = @CHFID"
        End If
        If Not eClaims.ClaimCode = Nothing Then
            ssql += " and tblClaim.ClaimCode = @ClaimCode"
        End If
        If Not eClaims.DateFrom = Nothing Then
            ssql += " and tblClaim.DateFrom >= @DateFrom"
        End If
        If Not eClaims.DateTo Is Nothing Then
            ssql += " and tblClaim.DateTo <= @DateTo"
        End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> start..
        If Not eClaims.DateClaimed = Nothing Then
            ssql += " and tblClaim.DateClaimed >= @DateClaimedFrom"
        End If
        If eClaims.DateProcessed IsNot Nothing Then
            ssql += " and tblClaim.DateClaimed <= @DateClaimedTo"
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range 
        '    sSQL += " and tblClaim.DateClaimed between @DateClaimedFrom and @DateClaimedTo"
        'End If
        'Claim date criteria changed by Ruzo ( 11 Jan 2014 ) >> end
        If eClaims.VisitType IsNot Nothing AndAlso eClaims.VisitType <> "" Then
            ssql += " AND tblClaim.VisitType = @VisitType"
        End If
        'If eClaims.Attachment = 1 Then
        'ssql += " AND tblClaim.ClaimID in (select claim_id from claim_ClaimAttachmentsCountView where attachments_count>=1)"
        'End If


        data.setSQLCommand(ssql, CommandType.Text)

        data.params("@UserID", SqlDbType.Int, UserID)
        data.params("@LocationId", SqlDbType.Int, eClaims.LegacyID) 'Used as a carrier for DistrictID
        data.params("@FeedbackStatus", SqlDbType.TinyInt, eClaims.FeedbackStatus)
        data.params("@ReviewStatus", SqlDbType.TinyInt, eClaims.ReviewStatus)
        data.params("@ClaimStatus", SqlDbType.TinyInt, eClaims.ClaimStatus)
        data.params("@ClaimSt", claimStatus, "xAttribute")
        data.params("@FeedbackSt", FeedbackStatus, "xAttribute")
        data.params("@ReviewSt", ReviewStatus, "xAttribute")
        data.params("@ICDID", SqlDbType.Int, eClaims.tblICDCodes.ICDID)
        data.params("@VisitType", SqlDbType.Char, 1, eClaims.VisitType)
        data.params("@Attachment", SqlDbType.Bit, eClaims.Attachment)

        If Not eClaims.tblBatchRun.RunID = Nothing Then
            data.params("@RunID", SqlDbType.Int, eClaims.tblBatchRun.RunID)
        End If
        If Not eClaims.tblHF.HfID = Nothing Then
            data.params("@HFID", SqlDbType.Int, eClaims.tblHF.HfID)
        End If
        If Not eClaims.tblInsuree.CHFID = Nothing Then
            data.params("@CHFID", SqlDbType.NVarChar, 12, eClaims.tblInsuree.CHFID)
        End If
        If Not eClaims.tblHF.HFName = Nothing Then
            data.params("@HFName", SqlDbType.NVarChar, 100, eClaims.tblHF.HFName)
        End If
        If Not eClaims.ClaimCode = Nothing Then
            data.params("@ClaimCode", SqlDbType.NVarChar, 11, eClaims.ClaimCode)
        End If
        If Not eClaims.DateFrom = Nothing Then
            data.params("@DateFrom", SqlDbType.SmallDateTime, eClaims.DateFrom)
        End If
        If Not eClaims.DateTo Is Nothing Then
            data.params("@DateTo", SqlDbType.SmallDateTime, eClaims.DateTo)
        End If
        'If Not (eClaims.DateClaimed = Nothing) And Not (eClaims.DateProcessed = Nothing) Then 'Used as a carrier for ClaimedDate to range 
        data.params("@DateClaimedFrom", SqlDbType.Date, eClaims.DateClaimed)
        data.params("@DateClaimedTo", SqlDbType.Date, eClaims.DateProcessed)
        'End If
        Return data.Filldata
    End Function


    Public Sub ReviewFeedbackSelection(ByVal dt As DataTable, ByVal Value As Decimal, ByVal ReviewType As Int16, ByVal SelectionType As Int16, ByVal SelectionValue As Decimal, ByRef Submitted As Integer, ByRef Selected As Integer, ByRef NotSelected As Integer)
        Dim sSQL As String = "uspClaimSelection"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)

        data.params("@ReviewType", SqlDbType.TinyInt, ReviewType)
        data.params("@Claims", dt)
        data.params("@SelectionType", SqlDbType.TinyInt, SelectionType)
        data.params("@SelectionValue", SqlDbType.Decimal, SelectionValue)
        data.params("@Value", SqlDbType.Decimal, Value)

        data.params("@Submitted", SqlDbType.Int, 2, ParameterDirection.Output)
        data.params("@Selected", SqlDbType.Int, 2, ParameterDirection.Output)
        data.params("@NotSelected", SqlDbType.Int, 2, ParameterDirection.Output)

        data.ExecuteCommand()

        Submitted = data.sqlParameters("@Submitted")
        Selected = data.sqlParameters("@Selected")
        NotSelected = data.sqlParameters("@NotSelected")
    End Sub
    Public Sub ProcessClaims(ByVal dt As DataTable, ByVal UserID As Integer, ByRef Submitted As Integer, ByRef Processed As Integer, ByRef Valuated As Integer, ByRef Changed As Integer, ByRef Rejected As Integer, ByRef Failed As Integer, ByRef ReturnValue As Integer)
        Dim sSQL As String = "uspProcessClaims"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)

        data.params("@AuditUser", SqlDbType.Int, UserID)
        data.params("@xtClaimSubmit", dt)

        data.params("@Submitted", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Processed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Valuated", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Changed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Rejected", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Failed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@oReturnValue", SqlDbType.Int, 1, ParameterDirection.Output)

        data.ExecuteCommand()

        Submitted = data.sqlParameters("@Submitted")
        Processed = data.sqlParameters("@Processed")
        Valuated = data.sqlParameters("@Valuated")
        Changed = data.sqlParameters("@Changed")
        Rejected = data.sqlParameters("@Rejected")
        Failed = data.sqlParameters("@Failed")
        ReturnValue = data.sqlParameters("@oReturnValue")


    End Sub
    Public Sub SubmitClaims(ByVal dt As DataTable, ByVal UserID As Integer, ByRef Submitted As Integer, ByRef Checked As Integer, ByRef Rejected As Integer, ByRef Changed As Integer, ByRef Failed As Integer, ByRef ItemsPassed As Integer, ByRef ServicesPassed As Integer, ByRef ItemsRejected As Integer, ByRef ServicesRejected As Integer)
        Dim sSQL As String = "uspSubmitClaims"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)

        data.params("@AuditUser", SqlDbType.Int, UserID)
        data.params("@xtClaimSubmit", dt)

        data.params("@Submitted", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Checked", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Rejected", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Changed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@Failed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@ItemsPassed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@ServicesPassed", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@ItemsRejected", SqlDbType.Int, 1, ParameterDirection.Output)
        data.params("@ServicesRejected", SqlDbType.Int, 1, ParameterDirection.Output)

        data.ExecuteCommand()

        Submitted = data.sqlParameters("@Submitted")
        Checked = data.sqlParameters("@Checked")
        Rejected = data.sqlParameters("@Rejected")
        Changed = data.sqlParameters("@Changed")
        Failed = data.sqlParameters("@Failed")
        ItemsPassed = data.sqlParameters("@ItemsPassed")
        ServicesPassed = data.sqlParameters("@ServicesPassed")
        ItemsRejected = data.sqlParameters("@ItemsRejected")
        ServicesRejected = data.sqlParameters("@ServicesRejected")


    End Sub
    Public Sub InsertFeedback(ByVal efeedback As IMIS_EN.tblFeedback)

        Dim str As String
        str = "INSERT INTO tblFeedback([ClaimID],[CareRendered],[PaymentAsked]" &
              ",[DrugPrescribed],[DrugReceived],[Asessment],[CHFOfficerCode],[FeedbackDate],[AuditUserID])" &
              " VALUES(@ClaimID,@CareRendered,@PaymentAsked,@DrugPrescribed,@DrugReceived,@Asessment,@CHFOfficerCode,@FeedbackDate,@AuditUserID);" &
              "update tblClaim set FeedbackStatus = 8 where ClaimID = @ClaimID and ValidityTo is null"

        data.setSQLCommand(str, CommandType.Text)
        data.params("@ClaimID", SqlDbType.Int, efeedback.tblClaim1.ClaimID)
        data.params("@CareRendered", SqlDbType.Bit, efeedback.CareRendered)
        data.params("@PaymentAsked", SqlDbType.Bit, efeedback.PaymentAsked)
        data.params("@DrugPrescribed", SqlDbType.Bit, efeedback.DrugPrescribed)
        data.params("@DrugReceived", SqlDbType.Bit, efeedback.DrugReceived)
        data.params("@Asessment", SqlDbType.TinyInt, efeedback.Asessment)
        data.params("@CHFOfficerCode", SqlDbType.Int, efeedback.CHFOfficerCode)
        data.params("@FeedbackDate", SqlDbType.DateTime, efeedback.FeedbackDate)
        data.params("@AuditUserID", SqlDbType.Int, efeedback.AuditUserID)

        data.ExecuteCommand()
    End Sub
    Public Sub UpdateFeedback(ByVal efeedback As IMIS_EN.tblFeedback)
        Dim str As String
        str = "INSERT INTO tblFeedback([ClaimID],[CareRendered],[PaymentAsked]" &
              ",[DrugPrescribed],[DrugReceived],[Asessment],[CHFOfficerCode],[FeedbackDate],[ValidityFrom]" &
              ",[ValidityTo],[LegacyID],[AuditUserID])" &
              " SELECT [ClaimID],[CareRendered],[PaymentAsked]" &
              ",[DrugPrescribed],[DrugReceived],[Asessment],[CHFOfficerCode],[FeedbackDate],[ValidityFrom]" &
              ",getdate(),[FeedbackID],[AuditUserID] FROM tblFeedback WHERE [FeedbackID]=@FeedbackID;" &
              " UPDATE tblFeedback SET [CareRendered]=@CareRendered,[PaymentAsked]=@PaymentAsked,[DrugPrescribed]=@DrugPrescribed" &
              ",[DrugReceived]=@DrugReceived,[Asessment]=@Asessment,[CHFOfficerCode]=@CHFOfficerCode,[FeedbackDate]=@FeedbackDate,[AuditUserID]=@AuditUserID" &
              ",[ValidityFrom]=getdate() WHERE [FeedbackID]=@FeedbackID"

        data.setSQLCommand(str, CommandType.Text)

        data.params("@FeedbackID", SqlDbType.Int, efeedback.FeedbackID)
        data.params("@ClaimID", SqlDbType.Int, efeedback.tblClaim1.ClaimID)
        data.params("@CareRendered", SqlDbType.Bit, efeedback.CareRendered)
        data.params("@PaymentAsked", SqlDbType.Bit, efeedback.PaymentAsked)
        data.params("@DrugPrescribed", SqlDbType.Bit, efeedback.DrugPrescribed)
        data.params("@DrugReceived", SqlDbType.Bit, efeedback.DrugReceived)
        data.params("@Asessment", SqlDbType.TinyInt, efeedback.Asessment)
        data.params("@CHFOfficerCode", SqlDbType.Int, efeedback.CHFOfficerCode)
        data.params("@FeedbackDate", SqlDbType.DateTime, efeedback.FeedbackDate)
        data.params("@AuditUserID", SqlDbType.Int, efeedback.AuditUserID)

        data.ExecuteCommand()

    End Sub
    Public Function GetXML(ByVal ClaimID As Integer) As DataTable
        Dim sSQL As String = "uspCreateClaimXML"
        data.setSQLCommand(sSQL, CommandType.StoredProcedure)
        data.params("@ClaimID", ClaimID)

        Return data.Filldata

    End Function

    'Corrected By Rogers
    Public Function GetBatchRunDate(ByVal LocationId As Integer) As DataTable
        Dim sSQL As String = ""
        sSQL += " DECLARE @MaxDate DATE SET @MaxDate = ("
        sSQL += " SELECT DATEADD(MONTH,1,MAX(CONVERT(DATE,(CAST(runyear AS NVARCHAR(4)) + '-' + CAST(runmonth AS NVARCHAR(2)) + '-01'))))"
        sSQL += " FROM tblbatchrun"
        sSQL += " WHERE LocationId = @LocationId AND ValidityTo IS NULL)"
        sSQL += " SELECT YEAR(@MaxDate) [Year],MONTH(@MaxDate) [Month]"


        data.setSQLCommand(sSQL, CommandType.Text)

        data.params("@LocationId", SqlDbType.Int, LocationId)
        Return data.Filldata
    End Function
    Public Function getFeedbackSMSData(ByVal DateFrom As Date, ByVal DateTo As Date) As DataTable
        Dim strSQL As String = "uspFeedbackPromptSMS"
        data.setSQLCommand(strSQL, CommandType.StoredProcedure)
        data.params("@RangeFrom", SqlDbType.DateTime, DateFrom)
        data.params("@RangeTo", SqlDbType.DateTime, DateTo)
        Return data.Filldata
    End Function
    Public Function GetClaim(ByVal ClaimID As Integer) As DataTable
        Dim Query As String = "SELECT C.ClaimID,C.ClaimUUID,H.HFID,H.HFCode, H.HFName,H.HFCareType,C.ICDID,C.InsureeId,I.CHFID" &
              ",I.LastName,I.OtherNames,C.DateFrom,C.DateTo,C.ClaimCode,C.DateClaimed,C.DateProcessed" &
              ",IC.ICDCode,C.Claimed,C.Approved,C.Explanation,C.Valuated,C.Explanation,C.Adjustment" &
              ",C.ClaimStatus,C.ReviewStatus,C.FeedbackStatus,FB.FeedbackID,FB.FeedbackDate,FB.CareRendered" &
              ",FB.DrugPrescribed,FB.DrugReceived,FB.PaymentAsked,FB.Asessment,FB.CHFOfficerCode" &
              ",Cadm.ClaimAdminID,Cadm.ClaimAdminCode,Cadm.LastName CadminLastName,Cadm.OtherNames CadminOtherNames" &
              " ,C.ICDID1, C.ICDID2, C.ICDID3, C.ICDID4, C.VisitType,IC1.ICDCode ICDCode1,IC2.ICDCode ICDCode2,IC3.ICDCode ICDCode3,IC4.ICDCode ICDCode4,GuaranteeId" &
              " FROM tblClaim C" &
              " INNER JOIN tblInsuree I ON C.InsureeID = I.InsureeID INNER JOIN tblHF H ON C.HfID = H.HfID" &
              " INNER JOIN tblICDCodes IC ON C.ICDID = IC.ICDID" &
              " LEFT JOIN tblICDCodes IC1 ON C.ICDID1 = IC1.ICDID" &
              " LEFT JOIN tblICDCodes IC2 ON C.ICDID2 = IC2.ICDID" &
              " LEFT JOIN tblICDCodes IC3 ON C.ICDID3 = IC3.ICDID" &
              " LEFT JOIN tblICDCodes IC4 ON C.ICDID4 = IC4.ICDID" &
              " LEFT JOIN tblFeedback FB ON C.ClaimID = FB.ClaimID" &
              " LEFT JOIN tblClaimAdmin Cadm ON Cadm.ClaimAdminId = C.ClaimAdminId" &
              " WHERE C.ClaimID = @ClaimID"

        data.setSQLCommand(Query, CommandType.Text)
        data.params("@ClaimID", SqlDbType.Int, ClaimID)
        Return data.Filldata
    End Function

    Public Sub DeleteClaim(ByRef eClaim As IMIS_EN.tblClaim)

        Dim sSQL As String = ""
        sSQL = "INSERT INTO tblClaim(InsureeID, ClaimCode, DateFrom, DateTo, ICDID, ClaimStatus, Adjuster, Adjustment, Claimed, Approved, Reinsured,"
        sSQL += " Valuated, DateClaimed, DateProcessed, Feedback, FeedbackID, Explanation, FeedbackStatus, ReviewStatus, ApprovalStatus, RejectionReason,"
        sSQL += " ValidityFrom, ValidityTo, LegacyID, AuditUserID, ValidityFromReview, ValidityToReview, AuditUserIDReview, HFID, RunID,"
        sSQL += " AuditUserIDSubmit, AuditUserIDProcess, SubmitStamp, ProcessStamp, Remunerated, GuaranteeId, ClaimAdminId, ICDID1, ICDID2, ICDID3,"
        sSQL += " ICDID4, VisitType, ClaimCategory)"
        sSQL += " SELECT InsureeID, ClaimCode, DateFrom, DateTo, ICDID, ClaimStatus, Adjuster, Adjustment, Claimed, Approved, Reinsured,"
        sSQL += " Valuated, DateClaimed, DateProcessed, Feedback, FeedbackID, Explanation, FeedbackStatus, ReviewStatus, ApprovalStatus, RejectionReason,"
        sSQL += " ValidityFrom, GETDATE() ValidityTo, ClaimId LegacyID, AuditUserID, ValidityFromReview, ValidityToReview, AuditUserIDReview, HFID, RunID,"
        sSQL += " AuditUserIDSubmit, AuditUserIDProcess, SubmitStamp, ProcessStamp, Remunerated, GuaranteeId, ClaimAdminId, ICDID1, ICDID2, ICDID3,"
        sSQL += " ICDID4, VisitType, ClaimCategory"
        sSQL += " FROM tblClaim"
        sSQL += " WHERE ClaimID=@ClaimID;"
        sSQL += " UPDATE [tblClaim] SET [ValidityFrom] = GetDate(),[ValidityTo] = Getdate(),[AuditUserID] = @AuditUserID WHERE claimID = @claimID"

        data.setSQLCommand(sSQL, CommandType.Text)


        data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)

        data.ExecuteCommand()
    End Sub

    Public Sub UpdateClaimSample(ByRef eClaim As IMIS_EN.tblClaim)
        ' todo fix approvedAmount'
        Dim sSQL = "
            Update tblClaim Set 
                ClaimAmountPayment = @ClaimAmountPayment,
                Approved = @ClaimAmountPayment, 
                SampleAmountDecrease = @SampleAmountDecrease, 
                IsBatchSampleForVerify = @IsBatchSampleForVerify,
                ClaimSampleBatchID=@ClaimSampleBatchID,
                ReviewStatus=@ReviewStatus
            where ClaimID = @ClaimID"

        data.setSQLCommand(sSQL, CommandType.Text)

        data.params("@ClaimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@ClaimAmountPayment", SqlDbType.Float, eClaim.ClaimAmountPayment)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, eClaim.ClaimSampleBatchID)
        data.params("@SampleAmountDecrease", SqlDbType.Float, eClaim.SampleAmountDecrease)
        data.params("@IsBatchSampleForVerify", SqlDbType.Float, eClaim.IsBatchSampleForVerify)
        data.params("@SampleAmountPercent", SqlDbType.Float, eClaim.SampleAmountPercent)
        data.params("@ReviewStatus", SqlDbType.Int, eClaim.ReviewStatus)
        data.ExecuteCommand()
    End Sub
    Public Sub UpdateClaimItemsAndServices(ByRef eClaim As IMIS_EN.tblClaim)
        Dim sSQL = "
            Update tblClaimItems Set 
                -- PriceApproved = QtyProvided*(PriceAsked- PriceAsked*@SampleAmountPercent)
                PriceApproved = PriceAsked- PriceAsked*@SampleAmountPercent
            where ClaimID = @ClaimID; 
            Update tblClaimServices Set 
                -- PriceApproved = QtyProvided*(PriceAsked- PriceAsked*@SampleAmountPercent)
                PriceApproved = PriceAsked- PriceAsked*@SampleAmountPercent
            where ClaimID = @ClaimID; 

            "
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimID", SqlDbType.Int, eClaim.ClaimID)
        data.params("@SampleAmountPercent", SqlDbType.Float, eClaim.SampleAmountPercent)
        data.ExecuteCommand()
    End Sub
    Public Function GetDataTableClaimSampleBatchById(ByVal id As Integer) As DataTable
        Dim sSQL As String = "Select 
            *
        from tblClaimSampleBatch where ClaimSampleBatchID=@ClaimSampleBatchID "
        Dim data As New ExactSQL

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, id)

        Return data.Filldata
    End Function

    Public Function GetClaimSampleBatchByIdUpdate(ByVal id As Integer) As tblClaimSampleBatch
        Dim x As IMIS_EN.tblClaimSampleBatch = New tblClaimSampleBatch
        Dim dt = GetDataTableClaimSampleBatchById(id)
        x._updateClone(dt.Rows(0))
        Return x
    End Function


    Public Function SaveSampleBatch(ByRef mdl As IMIS_EN.tblClaimSampleBatch, UserID As Integer) As Integer
        'ClaimSelectSamplePercent ClaimDeltaPercent
        Dim sSQL = "insert into tblClaimSampleBatch (ClaimSelectSamplePercent, CreatedByUserID)
            values (@ClaimSelectSamplePercent, @CreatedByUserID)"

        If mdl.__UPDATE__ Then
            sSQL = "
                Update tblClaimSampleBatch Set 
                    ClaimSelectSamplePercent=@ClaimSelectSamplePercent,
                    ClaimDeltaPercent=@ClaimDeltaPercent,
                    IsCalcDone=@IsCalcDone
                WHERE ClaimSampleBatchID=@ClaimSampleBatchID
            "
        End If
        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimSampleBatchID", SqlDbType.Int, mdl.ClaimSampleBatchID)
        data.params("@ClaimSelectSamplePercent", SqlDbType.Float, mdl.ClaimSelectSamplePercent)
        data.params("@ClaimDeltaPercent", SqlDbType.Float, mdl.ClaimDeltaPercent)
        data.params("@IsCalcDone", SqlDbType.Bit, mdl.IsCalcDone)
        data.params("@CreatedByUserID", SqlDbType.Int, UserID)
        data.ExecuteCommand()

        If mdl.__UPDATE__ Then
            Return mdl.ClaimSampleBatchID
        End If

        sSQL = "select MAX(ClaimSampleBatchID) from tblClaimSampleBatch"
        data.setSQLCommand(sSQL, CommandType.Text)
        data.ExecuteCommand()
        Dim maxID = data.Filldata
        Return maxID(0)(0)
    End Function
    Public Function GetClaimIdByUUID(ByVal uuid As Guid) As DataTable
        Dim sSQL As String = ""
        Dim data As New ExactSQL

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimUUID", SqlDbType.UniqueIdentifier, uuid)

        Return data.Filldata
    End Function
    Public Function GetClaimUUIDByID(ByVal id As Integer) As DataTable
        Dim sSQL As String = ""
        Dim data As New ExactSQL

        sSQL = "select ClaimUUID from tblClaim where ClaimID = @ClaimID"

        data.setSQLCommand(sSQL, CommandType.Text)
        data.params("@ClaimID", SqlDbType.Int, id)

        Return data.Filldata
    End Function


    Public Sub AddUpdateClaimPercentSetting(ByRef eClaim As IMIS_EN.tblClaim)

        'Dim strSQL As String = "select top 1 ClaimID from tblClaim where validityFromReview is null and ClaimID = @ClaimID;if @@rowcount > 0 begin UPDATE tblClaim SET  [Adjustment] = @Adjustment, [ValidityFromReview] = getdate(), [AudituserIdReview] = @AuditUserID "
        'If Not eClaim.Approved Is Nothing Then
        '    strSQL += ", [Approved] = @Approved"
        'End If
        'If Not eClaim.ReviewStatus Is Nothing Then
        '    strSQL += " ,[ReviewStatus] = @ReviewStatus"
        'End If

        'strSQL += " WHERE ClaimID = @ClaimID; end else begin Insert Into tblClaim ([InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID], [ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed],[Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],[ValidityTo],[LegacyID], [AuditUserID],[ValidityFromReview],[ValidityToReview],[AuditUserIDReview]) SELECT [InsureeID],[HFID],[ClaimCode],[DateFrom],[DateTo],[ICDID], [ClaimStatus],[Adjuster],[Adjustment],[Claimed],[Approved],[Reinsured],[Valuated],[DateClaimed],[DateProcessed], [Feedback],[FeedbackID],[Explanation],[FeedbackStatus],[ReviewStatus],[ApprovalStatus],[RejectionReason],[ValidityFrom],getdate(),[ClaimID], [AuditUserID],[ValidityFromReview],[ValidityToReview],[AuditUserIDReview] FROM tblClaim WHERE ClaimID = @ClaimID; UPDATE tblClaim SET  [Adjustment] = @Adjustment ,[ValidityFromReview] = getdate(), [AudituserIdReview] = @AuditUserID"

        'If Not eClaim.Approved Is Nothing Then
        '    strSQL += ", [Approved] = @Approved"
        'End If
        'If Not eClaim.ReviewStatus Is Nothing Then
        '    strSQL += ",[ReviewStatus] = @ReviewStatus"
        'End If

        'strSQL += " Where ClaimID = @ClaimID; End"
        'data.setSQLCommand(strSQL, CommandType.Text)

        'data.params("@claimID", SqlDbType.Int, eClaim.ClaimID)
        'data.params("@Adjustment", SqlDbType.NText, eClaim.Adjustment, ParameterDirection.Input)
        'data.params("@AuditUserID", SqlDbType.Int, eClaim.AuditUserID)

        'If Not eClaim.Approved Is Nothing Then
        '    data.params("@Approved", SqlDbType.Decimal, eClaim.Approved)
        'End If
        'If Not eClaim.ReviewStatus Is Nothing Then
        '    data.params("@ReviewStatus", SqlDbType.TinyInt, eClaim.ReviewStatus)
        'End If

        'data.ExecuteCommand()
    End Sub
End Class
