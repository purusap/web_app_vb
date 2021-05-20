<%-- Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)

The program users must agree to the following terms:

Copyright notices
This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
Free Software Foundation, version 3 of the License.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.

Disclaimer of Warranty
There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.

Limitation of Liability 
In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
advised of the possibility of such damages.

In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.--%>
<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" CodeBehind="FindUser.aspx.vb" Inherits="IMIS.FindUser" 
 Title='<%$ Resources:Resource,P_FINDUSERS %>' %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" language="javascript">
    $(document).ready(function () {
        bindRowSelection();
    });

    /** Ruzo Grid Row Selection 29 Aug 2014 >> Start **/
    function bindRowSelection() {
        var $trs = $('#<%=gvUsers.ClientID%> tr')
        $trs.unbind("hover").hover(function () {
            if ($(this).index() < 1 || $(this).is(".pgr")) return;
            $trs.removeClass("alt");
            $(this).addClass("alt");
        }, function () {
            if ($(this).index() < 1 || $(this).is(".pgr")) return;
            $(this).removeClass("alt");
        });
        $trs.unbind("click").click(function () {
            if ($(this).index() < 1 || $(this).is(".pgr")) return;
            $trs.removeClass("srs");
            $(this).addClass("srs");
            fillSelectedRowData($(this))
        });
        if ($trs.filter(".srs").length > 0) {
            $trs.filter(".srs").eq(0).trigger("click");
        } else {
            $trs.eq(1).trigger("click");
        }
        $trs.unbind("dblclick").dblclick(function () {
            if ($(this).index() < 1 || $(this).is(".pgr")) return;
            fillSelectedRowData($(this));
            customDoPostback("<%=B_EDIT.UniqueID%>", "");
        });
    }
    function fillSelectedRowData($row) {
        var $anchor = $row.find("td").eq(0).find("a");
        var dataNavStringParts = $anchor.attr("href").split("=")
        $("#<%=hfUserId.ClientID%>").val(dataNavStringParts[1]);
        $("#<%=hfUserName.ClientID%>").val($anchor.html());

        var $IsAssoc = $row.find("td").eq(1).html()
        $("#<%=hfAssociatedUser.ClientID%>").val($IsAssoc);
    }
    /** Ruzo Grid Row Selection 29 Aug 2014 >> End **/
 </script>
 </asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server">

    <div class="divBody" >
     <asp:HiddenField ID="hfUserId" runat="server" />
      <asp:HiddenField ID="hfUserName" runat="server" />
      <asp:HiddenField ID="hfAssociatedUser" runat="server" />
        <table class="catlabel">
             <tr>
                <td >
                       <asp:Label  ID="Label8" runat="server" Text='<%$ Resources:Resource,L_SELECTCRITERIA %>'></asp:Label>   
               </td>
               
                </tr>
            
            </table>
        
       <asp:Panel ID="Panel1"  runat="server" CssClass="panelTop" GroupingText='<%$ Resources:Resource,G_USER %>'> 
        <table>
            <tr>
                <td>
                    <table>
                        <tr>
            <td class="FormLabel">
                            <asp:Label 
                            ID="L_OTHERNAMES"
                            runat="server" 
                            Text='<%$ Resources:Resource,L_OTHERNAMES %>'>
                            </asp:Label>
                        </td>
                <td class ="DataEntry">
                    <asp:TextBox ID="txtOtherNames" runat="server">
                    </asp:TextBox>
                    </td>
               <td class="FormLabel">
                            <asp:Label 
                            ID="L_LASTNAME"
                            runat="server" 
                            Text='<%$ Resources:Resource,L_LASTNAME %>'>
                            </asp:Label>
                        </td>
                <td class ="DataEntry">
                    <asp:TextBox ID="txtLastName" runat="server">
                    </asp:TextBox></td>
                
                 <td class ="FormLabel">
                     <asp:Label ID="L_REGION" runat="server" Text="<%$ Resources:Resource,L_REGION %>"></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:UpdatePanel runat="server" ID="UpRegion">
                         <ContentTemplate>
 <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="True">
                     </asp:DropDownList>
                         </ContentTemplate>
                     </asp:UpdatePanel>
                    
                 </td>
            </tr>
                        <tr>
                <td class ="FormLabel">
                    <asp:Label 
                        ID="L_USERNAME"
                        runat="server" 
                        Text='<%$ Resources:Resource,L_USERNAME %>'>
                       </asp:Label>
                     </td>
                <td class ="DataEntry">
                   <asp:TextBox 
                        ID="txtUsername" 
                        runat="server">
                    </asp:TextBox></td>
                <td class ="FormLabel">
                     <asp:Label                     
                     ID="L_ROLES" 
                     runat="server" 
                     Text='<%$ Resources:Resource,L_ROLES %>'>
                     </asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlRole" runat="server">
                     </asp:DropDownList>
                 </td>
               <td class ="FormLabel">
                     <asp:Label ID="L_District0" runat="server" Text="<%$ Resources:Resource,L_DISTRICT %>">
                     </asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:UpdatePanel runat="server" ID="UpDistrict">
                         <ContentTemplate>
                             <asp:DropDownList ID="ddlDistrict" runat="server">
                     </asp:DropDownList>
                         </ContentTemplate>
                     </asp:UpdatePanel>
                     
                 </td>
            </tr>
                        <tr>
                 <td class="FormLabel">
                    <asp:Label 
                        ID="Label1" 
                        runat="server" 
                        Text='<%$ Resources:Resource,L_PHONE %>'>
                    </asp:Label>
                 </td>
                <td>
                    <asp:TextBox 
                        ID="txtPhone" 
                        runat="server">
                    </asp:TextBox>
                </td>
               <td class ="FormLabel">
                     <asp:Label                     
                     ID="L_HFNAME" 
                     runat="server" 
                     Text='<%$ Resources:Resource,L_HF %>'>
                     </asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlHFName" runat="server">
                     </asp:DropDownList>
                 </td>
                <td class="FormLabel">
                 
                    <asp:Label ID="L_LANGUAGE0" runat="server" Text="<%$ Resources:Resource,L_LANGUAGE %>">
                     </asp:Label>
                 
                </td>
                <td>
                  
                    <asp:DropDownList ID="ddlLanguage" runat="server">
                    </asp:DropDownList>
                  
                </td>
            </tr>
                          <tr>
            
<td class="FormLabel">

        </td>
<td class ="DataEntry">
     
    </td>
<td class="FormLabel">
          
        </td>
<td class ="DataEntry">
   
    
    </td>
 <td class ="FormLabel">
    
     <asp:Label ID="L_Email0" runat="server" style="direction: ltr" Text="<%$ Resources:Resource,L_EMAIL %>"></asp:Label>
    
 </td>
 <td class="DataEntry">
    
     <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
    
 </td>
            </tr>
                    </table>
                </td>
                <td>
                    <br />
                     <asp:CheckBox class="checkbox" AutoPostBack="True" ID="chkLegacy" runat="server" Text='<%$ Resources:Resource,L_ALL %>' />
                      <br />
                      <br />
                   <asp:Button class="button" ID="B_SEARCH" runat="server" 
                          Text='<%$ Resources:Resource,B_SEARCH %>' >
                  </asp:Button>
                  <br />
                  
                </td>
            </tr>
        </table>
          
           
        </asp:Panel>
        <table class="catlabel">
             <tr>
                <td >
                       <asp:label  
                           ID="L_FOUNDUSERS"  
                           runat="server" 
                           Text='<%$ Resources:Resource,L_FOUNDUSERS %>'> </asp:label>   
               </td>
               
                </tr>
            
            </table>

<asp:Panel ID="pnlGrid" runat="server"  ScrollBars="Auto" CssClass="panelBody">
    <asp:GridView  ID="gvUsers" runat="server"  AutoGenerateColumns="False" GridLines="None" AllowPaging="true" 
        PagerSettings-FirstPageText = "First Page" PagerSettings-LastPageText = "Last Page" PagerSettings-Mode ="NumericFirstLast" 
        CssClass="mGrid" PageSize="15" DataKeyNames="UserID,LoginName,IsAssociated" EmptyDataText='<%$ Resources:Resource,L_NORECORDS %>'>
        <Columns>        
            <asp:HyperLinkField DataNavigateUrlFields="UserUUID" 
                DataNavigateUrlFormatString="User.aspx?u={0}" DataTextField="LoginName"  
                HeaderText='<%$ Resources:Resource,L_USERNAME %>' HeaderStyle-Width ="60px">
                <HeaderStyle Width="60px" />
            </asp:HyperLinkField>
            <asp:BoundField DataField="IsAssociated" HeaderText="IsAssociated" HeaderStyle-Width ="110px"> <ItemStyle CssClass="hidecol"/><HeaderStyle CssClass="hidecol" />
                <HeaderStyle Width="110px" />
            </asp:BoundField> 
            <asp:BoundField DataField="OtherNames"  HeaderText='<%$ Resources:Resource,L_OTHERNAMES %>'     SortExpression="OtherNames" HeaderStyle-Width ="110px"> 
                <HeaderStyle Width="110px" />
            </asp:BoundField> 
            <asp:BoundField DataField="LastName"  HeaderText='<%$ Resources:Resource,L_LASTNAME %>' SortExpression="LastName" HeaderStyle-Width ="110px"> 
                <HeaderStyle Width="110px" />
            </asp:BoundField>             
            <asp:BoundField DataField="Phone" HeaderText='<%$ Resources:Resource,L_PHONE %>' SortExpression="Phone" HeaderStyle-Width="100px">  
                <HeaderStyle Width="100px" />
            </asp:BoundField>
            <asp:BoundField DataField="ValidityFrom" DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_VALIDFROM %>' SortExpression="ValidityFrom" HeaderStyle-Width="70px">  
                <HeaderStyle Width="70px" />
            </asp:BoundField>
            <asp:BoundField DataField="ValidityTo" DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_VALIDTO %>' SortExpression="ValidityTo" HeaderStyle-Width="70px">  
                <HeaderStyle Width="70px" />
            </asp:BoundField>
            <asp:BoundField DataField="EmailId" DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_EMAIL %>' SortExpression="EmailId" HeaderStyle-Width="70px">  
                <HeaderStyle Width="70px" />
            </asp:BoundField>
            <asp:BoundField DataField="UserId" ><ItemStyle CssClass="hidecol"/><HeaderStyle CssClass="hidecol" />  </asp:BoundField>
        </Columns>
        <PagerStyle CssClass="pgr" />
        <AlternatingRowStyle CssClass="alt" /> 
        <SelectedRowStyle CssClass="srs" />
        <RowStyle CssClass="normal" Wrap="False" />
    </asp:GridView>
 </asp:Panel>

 </div>
  <asp:Panel ID="pnlButtons" runat="server"   CssClass="panelbuttons" >
                <table width="100%" cellpadding="10 10 10 10">
         <tr>
                
                 <td  align="left">
                <asp:Button 
                    ID="B_ADD" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_ADD%>'
                      />
                </td>
                
                
                <td align="center">
                <asp:Button 
                    
                    ID="B_EDIT" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_EDIT%>'
                    ValidationGroup="check"  />
                </td>
                  <td align="left" >
                <%--<asp:Button 
                     Visible ="false"
                    ID="B_VIEW" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_VIEW%>'
                      />--%>
                </td>
                   <td align="center">
                <asp:Button 
                    
                    ID="B_DELETE" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_DELETE%>'
                    OnClientClick="return showmodalPopup();"
                      />
                </td>
                
                 <td align="right">
                    <asp:Button 
                    
                    ID="B_CANCEL" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_CANCEL%>'
                    
                      />
                    </td>
                    
                
            </tr>
        </table>        
         </asp:Panel> 
                  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer" Runat="Server">
    <asp:label id="lblMsg" runat="server"></asp:label><asp:ValidationSummary ID="validationSummary" runat="server" HeaderText='<%$ Resources:Resource,V_SUMMARY%>' ValidationGroup="check" />
</asp:Content>

