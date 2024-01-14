Imports System.Web
Imports System.Web.Services
Imports Newtonsoft.Json

Public Class ApiEntryHandler
    Implements System.Web.IHttpHandler
    Private ApiEntry As New IMIS_BI.ApiEntryBI
    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
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
            context.Response.ContentType = "text/json"
            context.Response.Write(response)
            Return
        End If

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class