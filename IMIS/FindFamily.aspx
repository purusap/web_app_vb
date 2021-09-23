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
<%@ Page Language="vb" AutoEventWireup="false"  MasterPageFile="~/IMIS.Master" CodeBehind="FindFamily.aspx.vb" Inherits="IMIS.FindFamily" 
title='<%$ Resources:Resource,L_Family%>'%>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server">
     <script type="text/javascript">
         $(document).ready(function () {
             $('#<%= btnSearch.ClientID %>').click(function (e) {
                var passed = true;
                $DateControls = $('.dateCheck');
                $DateControls.each(function () {
                    if ($(this).val().length > 0 && !isValidJSDate($(this).val())) {
                        $('#<%=lblMsg.ClientID%>').html('<%= imisgen.getMessage("M_INVALIDDATE", True)%>');
                        $(this).focus();
                        passed = false;
                        return false;
                    }
                });
                if (passed == false) {
                    return false;
                }
            });
        });
    </script>
  <div class="divBody" >
        <table class="catlabel">
            <tr>
                <td >
                    <asp:Label  ID="Label8" runat="server" Text='<%$ Resources:Resource,L_SELECTCRITERIA %>'></asp:Label>   
                </td>
            </tr>
        </table>
        
      <asp:UpdatePanel ID="upDistrict" runat="server"  > 
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSearch" />
            <asp:PostBackTrigger ControlID="chkLegacy" />
             <asp:PostBackTrigger ControlID="chkOffline" />
        </Triggers>                               
        <ContentTemplate>       
           <asp:Panel ID="pnlTop" runat="server"  CssClass="panelTop" GroupingText='<%$ Resources:Resource,L_POLICYHOLDER %>'>
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
                    <asp:TextBox ID="txtOtherNames" runat="server"></asp:TextBox></td>
               <td class="FormLabel">
                            <asp:Label 
                            ID="L_LASTNAME"
                            runat="server" 
                            Text='<%$ Resources:Resource,L_LASTNAME %>'>
                            </asp:Label>
                        </td>
                <td class ="DataEntry">
                    <asp:TextBox ID="txtLastName" runat="server" style="direction: ltr"></asp:TextBox></td>                
                 <td class ="FormLabel">
                     <asp:Label ID="L_REGION" runat="server" Text="<%$ Resources:Resource,L_REGION %>"></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="true" Width="150px">
                     </asp:DropDownList>
                 </td>
            </tr>
            <tr>
                <td class ="FormLabel">
                    <asp:Label 
                        ID="L_CHFID"
                        runat="server" 
                        Text='<%$ Resources:Resource,L_CHFID %>'>
                       </asp:Label>
                     </td>
                <td class ="DataEntry">
                   <asp:TextBox 
                        ID="txtCHFID" 
                        runat="server" maxlength="12">
                    </asp:TextBox>
                    </td>
                <td class="FormLabel">
                    <asp:Label 
                        ID="L_BIRTHDATEFROM"
                        runat="server" 
                        Text='Enroll Date From'>
                    </asp:Label>
                </td>
                <td class ="DataEntry">
                    <asp:TextBox 
                        ID="txtBirthDateFrom" 
                        runat="server" 
                        Width="120px"
                        CssClass="dateCheck FindFamilyFrom"  >
                    </asp:TextBox >
                    <asp:Button  
                        ID="btnDate" 
                        runat="server" 
                         Class="dateButton"
                        padding-bottom="3px" />
                        
                    <ajax:CalendarExtender 
                        ID="CalendarExtender2" 
                        runat="server" 
                        TargetControlID="txtBirthDateFrom" 
                        Format="dd/MM/yyyy" 
                        PopupButtonID="btnDate" >
                    </ajax:CalendarExtender>
                </td>
              <td class="FormLabel">
                    <asp:Label ID="L_DISTRICT" runat="server" Text="<%$ Resources:Resource,L_DISTRICT %>">
                     </asp:Label>
                </td>
                <td class ="DataEntry">
                    <asp:DropDownList ID="ddlDistrict" runat="server" AutoPostBack="true" Width="150px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
            
                <td class="FormLabel">
                    <asp:Label ID="L_PHONE" runat="server" Text="<%$ Resources:Resource,L_PHONE %>"></asp:Label>
                    <asp:Label 
                        ID="L_MARITAL"
                        runat="server" 
                        Text='<%$ Resources:Resource,L_MARITAL %>' Visible="False"></asp:Label>
                </td>
                <td class ="DataEntry">
                   <asp:DropDownList ID="ddlMarital" runat="server" Visible="False" Width="150px">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtPhone" runat="server" Width="150px"  ></asp:TextBox>
                </td>
                 <td class="FormLabel">
                    <asp:Label 
                        ID="L_BIRTHDATETO"
                        runat="server" 
                        Text='Enroll Date To'>
                    </asp:Label>
                </td>
                <td class ="DataEntry">
                    <asp:TextBox 
                        ID="txtBirthDateTo" 
                        runat="server" 
                        Width="120px"
                        CssClass="dateCheck">
                    </asp:TextBox >
                    <asp:Button  
                        ID="btnDateTo" 
                        runat="server" 
                         Class="dateButton"
                        padding-bottom="3px" />
                        
                    <ajax:CalendarExtender 
                        ID="CalendarExtender1" 
                        runat="server" 
                        TargetControlID="txtBirthDateTo" 
                        Format="dd/MM/yyyy" 
                        PopupButtonID="btnDateTo" >
                    </ajax:CalendarExtender>
                </td>
                  <td class="FormLabel">
                      <asp:Label ID="L_WARD" runat="server" Text="<%$ Resources:Resource,L_WARD %>">
                    </asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:DropDownList ID="ddlWard" runat="server" AutoPostBack="true" Width="150px">
                    </asp:DropDownList>
                </td>
                
            </tr>
            <tr>
             <%--  ---************------%>
                <td class="auto-style1">
                    <asp:Label 
                        ID="L_GENDER"
                        runat="server" 
                        Text='<%$ Resources:Resource,L_GENDER %>'>
                    </asp:Label>
                </td>
                <td class ="DataEntry">
                   <asp:DropDownList ID="ddlGender" runat="server" Width="150px">
                    </asp:DropDownList>
                </td>
                <td id="tdTogglePosition" colspan="2" runat="server" visible="false"></td>
                <td class="auto-style1" id="tdPovertyLBL" runat="server">
                    <asp:Label ID="lblPoverty" runat="server" Text="<%$ Resources:Resource,L_POVERTY %>"></asp:Label>
                </td>
                <td class ="DataEntry" id="tdPovertyDD" runat="server">
                    <asp:DropDownList ID="ddlPoverty" runat="server" Width="150px">
                    </asp:DropDownList>
                </td>
                 <td class="auto-style1" runat="server">
                           <asp:Label ID="L_VILLAGE" runat="server" Text="<%$ Resources:Resource,L_VILLAGE %>">
                    </asp:Label>
                        </td>
                        <td class ="DataEntry"  runat="server">
                            <asp:DropDownList ID="ddlVillage" runat="server" Width="150px">
                            </asp:DropDownList>
                        </td>
             
            </tr>
                       <tr>
                           <td class="auto-style1" id="tdEmailLBL" runat="server">&nbsp;
                    <asp:Label ID="L_EMAIL" runat="server" Text="<%$ Resources:Resource, L_EMAIL %>"></asp:Label>
                           </td>
                           <td class="DataEntry" id="tdEmailTXT" runat="server">

                               <asp:TextBox ID="txtEmail" runat="server" Width="150px"></asp:TextBox>
                           </td>
                           <td class="auto-style1"  id="tdConfirmationNoLBL"  runat="server">
                               <asp:Label ID="L_CONFIRMATIONNO" runat="server" style="direction: ltr" Text="<%$ Resources:Resource, L_CONFIRMATIONNO %>"></asp:Label>
                           </td>
                           <td id="tdConfirmationNoTXT" runat="server">
                               <asp:TextBox ID="txtConfirmationNo" runat="server" MaxLength="12" Width="150px"></asp:TextBox>
                           </td>
                           <td class="FormLabel">
                              <asp:Label ID="lblConfirmationType" runat="server" Text="<%$ Resources:Resource,L_CONFIRMATIONTYPE %>"></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:DropDownList ID="ddlConfirmationType" runat="server" Width="150px">
                              </asp:DropDownList>
                          </td>
                       </tr>
        </table>
                </td>
                <td>
                 <asp:CheckBox class="checkbox" ID="chkOffline" runat="server" Text='<%$ Resources:Resource,L_OFFLINE %>' AutoPostBack="True" />
                    <br />
                    <br />
                     <asp:CheckBox class="checkbox" ID="chkLegacy" runat="server" Text='<%$ Resources:Resource,L_ALL %>' AutoPostBack="True" />
                      <br />
                      <br />
                   <asp:Button class="button" ID="btnSearch" runat="server" 
                          Text='<%$ Resources:Resource,B_SEARCH %>' >
                  </asp:Button>
                  <br />
                  
                </td>
            </tr>
        </table>

        </asp:Panel>
        </ContentTemplate>      
     </asp:UpdatePanel> 
        
        <table class="catlabel">
             <tr>
                <td >
                       <asp:label  
                           ID="L_FOUNDFAMILY"  
                           runat="server" 
                           Text='<%$ Resources:Resource,L_FOUNDFAMILY %>'>
                       </asp:label>   
               </td>
               
                </tr>
            
            </table>
        <asp:Panel ID="pnlBody" runat="server"  CssClass="panelBody" >
            <asp:GridView ID="gvFamilies" runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                AllowPaging="true" PagerSettings-FirstPageText = "First Page" PagerSettings-LastPageText = "Last Page" PagerSettings-Mode ="NumericFirstLast" 
                CssClass="mGrid"
                EmptyDataText='<%$ Resources:Resource,M_NOFAMILIES %>'
                PagerStyle-CssClass="pgr" 
                DataKeyNames="FamilyID"
                
                AlternatingRowStyle-CssClass="alt"
                SelectedRowStyle-CssClass="srs" PageSize="15" >
                <Columns>
                    <asp:CommandField  SelectText ="Select" ShowSelectButton="true" 
                        ItemStyle-CssClass = "HideButton" HeaderStyle-CssClass ="HideButton" >
                        <HeaderStyle CssClass="HideButton" />
                        <ItemStyle CssClass="HideButton" />
                    </asp:CommandField>
                  <%--   <asp:HyperLinkField DataNavigateUrlFields = "FamilyUUID" DataTextField="CHFID" DataNavigateUrlFormatString = "OverviewFamily.aspx?f={0}" HeaderText='<%$ Resources:Resource,L_CHFID %>' HeaderStyle-Width ="100px" >

                        <HeaderStyle Width="100px" />

                    </asp:HyperLinkField>   
                      --%>
                    <asp:HyperLinkField DataNavigateUrlFields = "FamilyId" DataTextField="CHFID" DataNavigateUrlFormatString = "OverviewFamily.aspx?f={0}" HeaderText='<%$ Resources:Resource,L_CHFID %>' HeaderStyle-Width ="100px" >

                        <HeaderStyle Width="100px" />

                    </asp:HyperLinkField> 
                    <asp:BoundField DataField="OtherNames"  HeaderText='<%$ Resources:Resource,L_OTHERNAMES %>'     SortExpression="OtherNames" ><HeaderStyle Width="130px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="LastName"  HeaderText='<%$ Resources:Resource,L_LASTNAME %>' SortExpression="LastName" ><HeaderStyle Width="130px"></HeaderStyle>
                    </asp:BoundField>                     
                     <asp:BoundField DataField="RegionName"  HeaderText='<%$ Resources:Resource,L_REGION %>'     SortExpression="RegionName" ><HeaderStyle Width="80px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="DistrictName"  HeaderText='<%$ Resources:Resource,L_DISTRICT %>'     SortExpression="DistrictName" ><HeaderStyle Width="80px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="WardName"  HeaderText='<%$ Resources:Resource,L_WARD %>'     SortExpression="WardName" ><HeaderStyle Width="80px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="VillageName"  HeaderText='<%$ Resources:Resource,L_VILLAGE %>'     SortExpression="VillageName" ><HeaderStyle Width="80px"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="PovertyDisplay"  HeaderText='<%$ Resources:Resource,L_POVERTY_ %>' SortExpression="Poverty" ><HeaderStyle Width="30px"></HeaderStyle>
                    </asp:BoundField>
                    <%--  <asp:BoundField DataField="Gender" HeaderText="GENDER" SortExpression="Gender" />
                    <asp:BoundField DataField="DOB" DataFormatString="{0:d}" HeaderText="DATE OF BIRTH" SortExpression="DOB" />
                    <asp:CheckBoxField DataField="CardIssued" HeaderText="CARD" SortExpression="CardIssued" />--%>
                <asp:BoundField DataField="ValidityFrom" DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_VALIDFROM %>' SortExpression="ValidityFrom" HeaderStyle-Width="70px">  
                    <HeaderStyle Width="70px" />
                    </asp:BoundField>
                <asp:BoundField DataField="ValidityTo" DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_VALIDTO %>' SortExpression="DOB" HeaderStyle-Width="70px">  
                    <HeaderStyle Width="70px" />
                    </asp:BoundField>


                </Columns>
                <PagerStyle CssClass="pgr" />
                <SelectedRowStyle CssClass="srs" />
                <AlternatingRowStyle CssClass="alt" />
                <RowStyle CssClass="normal" Wrap="False" />
            </asp:GridView>
        </asp:Panel>
        </div>
       <asp:Panel ID="pnlButtons" runat="server"   CssClass="panelbuttons" >
        <table width="100%" cellpadding="10 10 10 10">
             <tr>
                    
                     <td  align="left">
                    <%--<asp:Button 
                        ID="B_ADD" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_ADD%>'
                          />--%>
                    </td>
                    
                    
                    <td align="center">
                      <asp:Button 
                    
                    ID="B_VIEW" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_VIEW %>'
                    visible="False" />
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
    <asp:label id="lblMsg" runat="server"></asp:label>
</asp:Content>





<asp:Content ID="Content3" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            height: 27px;
            width: 150px;
            text-align: right;
            color: Blue;
            font-weight: normal;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            padding-right: 1px;
        }
    </style>
</asp:Content>






