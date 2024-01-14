Imports Newtonsoft.Json

Public Class ApiEntryHandler1
    Inherits System.Web.UI.Page
    Private ApiEntry As New IMIS_BI.ApiEntryBI

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim xml = HttpContext.Current.Request.QueryString("xml") 'dangerous Request.QueryString value was detected
        Dim action = HttpContext.Current.Request.QueryString("action")

        If action = "ClaimCopayResponse" Then
            '/ApiEntryHandler.ashx?xml=<xml></xml>&action=ClaimCopayResponse
            '/ApiEntryHandler.ashx?xml=<xml><HFID>35</HFID></xml>&action=ClaimCopayResponse
            Dim xml = HttpContext.Current.Request.Unvalidated("xml")

            If xml = Nothing Then
                '/ApiEntryHandler.ashx?json={"xml":{"HFID":35}}&action=ClaimCopayResponse
                Dim json = HttpContext.Current.Request.Unvalidated("json")
                Dim doc = JsonConvert.DeserializeXmlNode(json)
                xml = doc.InnerXml
            End If
            Dim response = ApiEntry.ClaimsCopayRequired(xml)
            Context.Response.ContentType = "text/json"
            Context.Response.Write(response)
            Context.Response.Flush()
            Context.Response.End()
            Return
        End If
    End Sub

End Class