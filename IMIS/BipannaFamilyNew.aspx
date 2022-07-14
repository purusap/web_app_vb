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
<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BipannaFamilyNew.aspx.vb" MasterPageFile="~/IMIS.Master" Inherits="IMIS.BipannaFamilyNew" Title='Bipanna Family' %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="cHead" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        #SelectPic {
            padding-top: 10%;
            width: 100%;
            margin: auto;
            text-align: center;
            vertical-align: bottom;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            z-index: 1001;
            background-color: Gray;
            opacity: 0.9;
            display: none;
        }
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
        .auto-style2 {
            height: 27px;
        }
        
        #Body_txtBirthDate,#Body_Button1 {
            visibility:hidden;
        }
        
    </style>
    <script type="text/javascript" language="javascript">


        function pageLoadExtend() {
            $(document).ready(function () {

                $('#<%=btnBrowse.ClientID %>').click(function (e) {

                    $("#SelectPic").show();

                    e.preventDefault();
                });

            });
        }

        $(document).ready(function () {

            $("#btnCancel").hide();
            $('#<%=btnBrowse.ClientID %>').click(function (e) {

            $("#SelectPic").show();
            $("#btnCancel").show();
            e.preventDefault();
        });



        $("#btnCancel").click(function () {
            //alert('called');
            $("#SelectPic").hide();
            $("#btnCancel").hide();
        });




    });


    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server">
    <div class="divBody" >
     <asp:Panel ID="Panel1" runat="server"  
             CssClass="panel" GroupingText='Bipanna Family' EnableTheming="True" >
            <asp:UpdatePanel ID="upDistrict" runat="server"  >                                
               <ContentTemplate>      
                  <table >
                      <tr>
                          <td class="auto-style1">
                              <asp:Label
                                  ID="L_REGION"
                                  runat="server"
                                  Text='<%$ Resources:Resource,L_REGION %>'></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:DropDownList ID="ddlRegion" runat="server" Width="150px" AutoPostBack="true" />
                          </td>
                          <td class="auto-style2">
                              <asp:RequiredFieldValidator ID="RequiredFieldRegion" runat="server"
                                  ControlToValidate="ddlRegion" InitialValue="0"
                                  SetFocusOnError="True"
                                  ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                          </td>
                          <td class="auto-style1">
                              <asp:Label ID="L_DISTRICT" runat="server" Text="<%$ Resources:Resource,L_DISTRICT %>"></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:DropDownList ID="ddlDistrict" runat="server" AutoPostBack="true" Width="150px" />
                          </td>
                          <td class="auto-style2">
                              <asp:RequiredFieldValidator ID="RequiredFieldDistrict" runat="server" ControlToValidate="ddlDistrict" InitialValue="0" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                          </td>
                          <td class="FormLabel">
                            <asp:Label 
                                ID="L_WARD"
                                runat="server" 
                                Text='<%$ Resources:Resource,L_WARD %>'>
                            </asp:Label>
                        </td>
                        <td class="DataEntry">
                            <asp:DropDownList ID="ddlWard" runat="server" Width="150px" AutoPostBack="true">
                            </asp:DropDownList>
                        </td>
                        <td> 
                            <asp:RequiredFieldValidator 
                                ID="RequiredFieldWard" 
                                runat="server" 
                                ControlToValidate="ddlWard" 
                                InitialValue="0"
                                ErrorMessage="Please select a Ward." 
                                SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                                 <asp:RequiredFieldValidator 
                                ID="RequiredFieldWard1" 
                                runat="server" 
                                ControlToValidate="ddlWard" 
                                 ErrorMessage="Please select a Ward." 
                                SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red"  Display="Dynamic"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>                          
                      </tr>
                      <tr> <td class="FormLabel">
                            <asp:Label 
                                ID="L_VILLAGE"
                                runat="server" 
                                Text='<%$ Resources:Resource,L_VILLAGE %>'>
                            </asp:Label>
                        </td>
                        <td class="DataEntry">
                            <asp:DropDownList 
                                ID="ddlVillage" 
                                runat="server" 
                                Width="150px">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:RequiredFieldValidator 
                                ID="RequiredFieldVillage" 
                                runat="server" 
                                ControlToValidate="ddlVillage" 
                                InitialValue="0" 
                                SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                             <asp:RequiredFieldValidator 
                                ID="RequiredFieldVillage1" 
                                runat="server" 
                                ControlToValidate="ddlVillage" 
                                 SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                Text="*"></asp:RequiredFieldValidator>
                           
                        </td>
                          <td class="auto-style1">
                              <asp:Label ID="L_ADDRESS" runat="server"
                                  Text="<%$ Resources:Resource, L_PARMANENTADDRESS %>" Style="direction: ltr"></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:TextBox ID="txtAddress" runat="server" Height="40px" MaxLength="25"
                                  TextMode="MultiLine" Width="150px" Style="resize: none;"></asp:TextBox>
                              <asp:RequiredFieldValidator ID="rfAddress" runat="server" ControlToValidate="txtAddress" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                          </td>
                          <td>&nbsp;</td>
                          <td class="auto-style1"><asp:Label runat="server" Text="Same Below"></asp:Label></td>
                          <td class="DataEntry"><asp:CheckBox ID="chkSameBelow" runat="server" AutoPostBack="True" /></td>
                      </tr>
                    <tr id="trPoverty" runat="server">
                     
                        <td class="FormLabel">
                            <asp:Label ID="lblConfirmationType0" runat="server" Text="<%$ Resources:Resource,L_POVERTY %>"></asp:Label>
                        </td>
                        <td class="DataEntry">
                            <asp:DropDownList ID="ddlPoverty" runat="server" Width="150px" AutoPostBack="True">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ID="rfPoverty" runat="server" ControlToValidate="ddlPoverty" Display="Dynamic" ForeColor="Red" InitialValue="" SetFocusOnError="True" Text="*" ValidationGroup="check"></asp:RequiredFieldValidator>
                        </td>
                          <td class="FormLabel">
                              <asp:Label ID="lblConfirmationType" runat="server" Text="<%$ Resources:Resource,L_CONFIRMATIONTYPE %>"></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:DropDownList ID="ddlConfirmationType" runat="server" Width="150px" AutoPostBack="True">
                              </asp:DropDownList>
                          </td>
                          <td><asp:RequiredFieldValidator 
                                ID="rfConfirmation" 
                                runat="server" 
                                ControlToValidate="ddlConfirmationType" 
                                InitialValue="" 
                                SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator></td>
                          <td class="FormLabel">
                              <asp:Label ID="L_CONFIRMATIONNO" runat="server" style="direction: ltr" Text="<%$ Resources:Resource, L_CONFIRMATIONNO %>"></asp:Label>
                          </td>
                          <td class="DataEntry">
                              <asp:TextBox ID="txtConfirmationNo" runat="server" MaxLength="12" style="direction: ltr" Width="150px"></asp:TextBox>
                              <asp:RequiredFieldValidator 
                                ID="rfConfirmationNo" 
                                runat="server" 
                                ControlToValidate="txtConfirmationNo" 
                                SetFocusOnError="True" 
                                ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                          </td>
                      </tr>
                      <tr id="trType" runat="server">
                          <%-- 
                                <td class="FormLabel">
                                    <asp:Label ID="L_TYPE" runat="server" Text="<%$ Resources:Resource, L_GROUPTYPE %>"></asp:Label>
                                </td>
                                <td class="DataEntry">
                                    <asp:DropDownList ID="ddlType" runat="server" Width="150px" >
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ID="rfType" runat="server" 
                                        ControlToValidate="ddlType" InitialValue="" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                                </td>
                          --%>
                        <td class="FormLabel"> <asp:Label ID="lblEthnicity" runat="server"  Text='<%$ Resources:Resource,L_ETHNICITY %>'> </asp:Label> </td>
                        <td class="DataEntry">
                            <asp:DropDownList 
                                ID="ddlEthnicity"
                                runat="server"
                                Width="150px" >
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlEthnicity" InitialValue="" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>    
                                           
               </ContentTemplate>      
            </asp:UpdatePanel>                      
         </asp:Panel>
        <asp:Panel ID="pnlBody" runat="server" Style="height: auto;" CssClass="panelBody" GroupingText='Bipanna Policy Holder'>
            <asp:UpdatePanel ID="upCHFID" runat="server">
                <ContentTemplate>
                    <table>
                        <tr>
                            <td class="FormLabel"  valign="bottom">
                                <asp:Label ID="L_CHFID" runat="server" Text="Bipanna Number">
                                </asp:Label>
                            </td>
                            <td class="DataEntry" valign="bottom">
                                <asp:TextBox ID="txtCHFID" runat="server" AutoPostBack="True" CssClass="numbersOnly" MaxLength="12" Width="150px"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldCHFID0" runat="server" ControlToValidate="txtCHFID" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'>
                                </asp:RequiredFieldValidator>
                            </td>  
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td  valign="bottom">
                                <asp:Button runat="server" ID="btnBrowse" Text='<%$ Resources:Resource,B_BROWSE%>' /></td>   
                            <td align="left">
                                <asp:UpdatePanel ID="upImage" runat="server">
                                    <ContentTemplate>
                                        <asp:Image ID="Image1" runat="server" Width="137px" Height="137px" ImageAlign="Middle" onerror="NoImage(this)" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>                         
                        </tr>
                        <tr>
                            <td class="FormLabel">
                                <asp:Label ID="L_OTHERNAMES0" runat="server" Text="<%$ Resources:Resource,L_OTHERNAMES %>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtOtherNames" runat="server"   MaxLength="100" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldOtherNames1" runat="server" ControlToValidate="txtOtherNames" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'>
                                </asp:RequiredFieldValidator>
                                 
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="L_LASTNAME0" runat="server" Text="<%$ Resources:Resource,L_LASTNAME %>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtLastName" runat="server"   MaxLength="100" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldLastName2" runat="server" ControlToValidate="txtLastName" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'>
                                </asp:RequiredFieldValidator>
                                 
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="L_BIRTHDATE" runat="server" Text="<%$ Resources:Resource,L_BIRTHDATE %>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtBirthDate" runat="server" Width="80px"></asp:TextBox>
                                <asp:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd/MM/yyyy" PopupButtonID="Button1" TargetControlID="txtBirthDate">
                                </asp:CalendarExtender>
                                <asp:Button ID="Button1" runat="server" Height="20px" Width="20px" />
                                <asp:RequiredFieldValidator ID="RequiredFieldBirthDate0" runat="server" ControlToValidate="txtBirthDate" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" ControlToValidate="txtBirthDate" ErrorMessage="*" SetFocusOnError="false" ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$" ValidationGroup="check" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>                                
                            </td>
                        </tr>
                        <tr>
                            <td class="FormLabel">
                                <asp:Label ID="L_GENDER" runat="server" Text="<%$ Resources:Resource,L_GENDER %>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlGender" runat="server" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldGender0" runat="server" ControlToValidate="ddlGender" InitialValue="" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                             <td class="FormLabel">
                                <asp:Label ID="L_PROFESSION0" runat="server" Text="<%$ Resources:Resource, L_PROFESSION %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlProfession" runat="server" Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="L_EDUCATION0" runat="server" Text="<%$ Resources:Resource, L_EDUCATION %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlEducation" runat="server" Width="150px">
                                </asp:DropDownList>                                
                            </td>
                        </tr>                     
                        

                        <tr>
                            <td class="FormLabel">
                                <asp:Label ID="L_PHONE" runat="server" Text="<%$ Resources:Resource,L_PHONE%>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtPhone" runat="server" MaxLength="10" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPhone" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'>
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1"
                                    ControlToValidate="txtPhone" runat="server"
                                    ErrorMessage="Phone Number Invalid"
                                    ValidationExpression="^\d{10}$">
                                </asp:RegularExpressionValidator>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="L_EMAIL0" runat="server" Text="<%$ Resources:Resource, L_EMAIL %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtEmail" runat="server" Width="150px"></asp:TextBox>                       
                                
                            </td>
                            <td>&nbsp;</td>
                            <td class="DataEntry">&nbsp;</td>
                        </tr>
                        <tr id="trIdentificationType" runat="server">
                            <td class="FormLabel">
                                <asp:Label ID="L_IDTYPE" runat="server" Text="<%$ Resources:Resource, L_IDTYPE %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlIdType" runat="server" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfIdType" runat="server" ControlToValidate="ddlIdType" InitialValue="" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="L_PASSPORT" runat="server" Text="<%$ Resources:Resource,L_PASSPORT%>">
                                </asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtPassport" runat="server" MaxLength="40" Width="150px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfIdNo1" runat="server" ControlToValidate="txtPassport" InitialValue="" SetFocusOnError="True" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                            <td></td>
                            <td class="DataEntry">&nbsp;</td>
                        </tr>
                        <tr id="trFSPRegion" runat="server">
                            <td class="FormLabel">
                                <asp:Label ID="lblFSPRegion" runat="server" Text="<%$ Resources:Resource, L_FSPREGION %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlFSPRegion" runat="server" AutoPostBack="True" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfRegionFSP" runat="server" ControlToValidate="ddlFSPRegion" InitialValue="0" SetFocusOnError="True" Style="direction: ltr" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="lblFSPDistrict" runat="server" Text="<%$ Resources:Resource, L_FSPDISTRICT %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlFSPDistrict" runat="server" AutoPostBack="True" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfDistrictFSP" runat="server" ControlToValidate="ddlFSPDistrict" InitialValue="0" SetFocusOnError="True" Style="direction: ltr" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="lblFSPCategory" runat="server" Text="<%$ Resources:Resource, L_FSPCATEGORY %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlFSPCateogory" runat="server" AutoPostBack="True" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfFSPCategory" runat="server" ControlToValidate="ddlFSPCateogory" InitialValue="0" SetFocusOnError="True" Style="direction: ltr" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr id="trFSP" runat="server">
                            <td class="FormLabel">
                                <asp:Label ID="lblFSP" runat="server" Text="<%$ Resources:Resource, L_FSP %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:DropDownList ID="ddlFSP" runat="server" Width="150px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfFSP" runat="server" ControlToValidate="ddlFSP" InitialValue="0" SetFocusOnError="True" Style="direction: ltr" ValidationGroup="check" ForeColor="Red" Display="Dynamic"
                                        Text='*'></asp:RequiredFieldValidator>
                            </td>
                            <td></td>
                            <td class="DataEntry"></td>
                        </tr>
                        <tr>
                            <td colspan="6"><hr /></td>
                        </tr>
                        <tr id="trCurrentRegion" runat="server">
                                        <td class="FormLabel">
                                            <asp:Label ID="lblCurrentRegion" runat="server" Text="<%$ Resources:Resource, L_CREGION %>"></asp:Label>
                                        </td>
                                        <td class="DataEntry">
                                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlCurrentRegion" Width="150px" runat="server" AutoPostBack="True">

                                                    </asp:DropDownList>                                                    
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                            <td class="FormLabel">
                                <asp:Label ID="lblCurrentDistrict0" runat="server" Text="<%$ Resources:Resource, L_CDISTRICT %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:UpdatePanel ID="upCurDistrict" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlCurDistrict" runat="server" Width="150px" AutoPostBack="True">
                                        </asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td class="FormLabel">
                                <asp:Label ID="lblCurrentVDC0" runat="server" Text="<%$ Resources:Resource, L_CVDC %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:UpdatePanel ID="upCurVDC" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlCurVDC" runat="server" Width="150px" AutoPostBack="True"></asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr id="trCurrentVillage" runat="server">
                            <td class="FormLabel">
                                <asp:Label ID="lblCurrentWard0" runat="server" Text="<%$ Resources:Resource, L_CWARD %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:UpdatePanel ID="upCurWard" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlCurWard" runat="server" Width="150px"></asp:DropDownList>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td class="FormLabel" style="vertical-align: top">
                                <asp:Label ID="lblCurrentAddress0" runat="server" Text="<%$ Resources:Resource, L_CURRENTADDRESS %>"></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtCurrentAddress" runat="server" Height="40px" MaxLength="25" Style="resize: none;" TextMode="MultiLine" Width="150px"></asp:TextBox>
                                
                            </td>
                            <td></td>
                            <td class="DataEntry">&nbsp;</td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
     <asp:UpdatePanel ID="upDL" runat="server">
        <ContentTemplate>
            <table id="SelectPic">
                <tr>
                    <td align="center">
                    <asp:Panel ID="pnlImages" runat="server" Width="500px" Height="450px" BackColor="White" ScrollBars="Auto">
                        <asp:DataList ID="dlImages" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" DataKeyField="ImagePath" OnSelectedIndexChanged="dlImages_SelectedIndexChanged"> 
                            <ItemTemplate>
                                <table width="100px" style="height:100px">
                                  
                                    <tr>
                                        <td align="center">
                                            On: <%#Eval("TakenDate")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <img alt="" width="100px" height="100px" src='Images\Submitted\<%#Eval("ImagePath") %>' />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <asp:LinkButton ID="lnkSelect" runat="server" CommandName="Select">Select</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate> 
                            </asp:DataList>                                                     
                    </asp:Panel>
                    <br />  
                    <input type="button" id="btnCancel" value="Cancel" />
                    </td>
                </tr>
            </table>    
        </ContentTemplate>
    </asp:UpdatePanel>
   </div>
   <asp:Panel ID="pnlButtons" runat="server"   CssClass="panelbuttons" >
                <table width="100%" cellpadding="10 10 10 10">
                 <tr>
                        
                         <td align="left" >
                        
                               <asp:Button 
                            
                            ID="B_SAVE" 
                            runat="server" 
                            Text='<%$ Resources:Resource,B_SAVE%>'
                            ValidationGroup="check"  />
                        </td>
                        
                        
                        <td  align="right">
                       <asp:Button 
                            
                            ID="B_CANCEL" 
                            runat="server" 
                            Text='<%$ Resources:Resource,B_CANCEL%>'
                              />
                        </td>
                        
                    </tr>
                </table>   
                 <asp:HiddenField ID="hfInsureeIsOffline" runat="server" Value="" />
               <asp:HiddenField ID="hfFamilyIsOffline" runat="server" Value="" />
                    </asp:Panel>


















<div id="bipannas">
    <span align="right" class="preeti">Occupation <span class="red">*</span></span>
    <select>
													<option value="" data-select2-id="select2-data-2-toia"></option>
																											<option value="Business" data-select2-id="select2-data-27-tn6n"> Business </option>
																												<option value="Driver" data-select2-id="select2-data-28-covx"> Driver </option>
																												<option value="Farmer" data-select2-id="select2-data-29-z4kd"> Farmer </option>
																												<option value="Retired Army" data-select2-id="select2-data-30-3lqj"> Retired Army </option>
																												<option value="Service" data-select2-id="select2-data-31-cpa1"> Service </option>
																												<option value="Housewife" data-select2-id="select2-data-32-1tar"> Housewife </option>
																												<option value="Student" data-select2-id="select2-data-33-sof2"> Student </option>
																												<option value="Agriculture" data-select2-id="select2-data-34-0syl"> Agriculture </option>
																												<option value="Shopkeeper" data-select2-id="select2-data-35-l6ob"> Shopkeeper </option>
																												<option value="Tailor" data-select2-id="select2-data-36-qciu"> Tailor </option>
																												<option value="Construction" data-select2-id="select2-data-37-q40p"> Construction </option>
																												<option value="Retired" data-select2-id="select2-data-38-adom"> Retired </option>
																												<option value="Teacher" data-select2-id="select2-data-39-w5m7"> Teacher </option>
																												<option value="Farming" data-select2-id="select2-data-40-ysm0"> Farming </option>
																												<option value="Health Worker" data-select2-id="select2-data-41-gq0x"> Health Worker </option>
																												<option value="Retired From Job" data-select2-id="select2-data-42-lgo9"> Retired From Job </option>
																												<option value="Labour" data-select2-id="select2-data-43-a1dt"> Labour </option>
																												<option value="Unemployeed" data-select2-id="select2-data-44-8py1"> Unemployeed </option>
																										</select>


      <span align="right" class="preeti">Permanent Address <span class="red">*</span></span>
    <select>
														<option value="" data-select2-id="select2-data-4-l7li"></option>
																													<option value="1"> Taplejung </option>
																														<option value="2"> Panchthar </option>
																														<option value="3"> Ilam </option>
																														<option value="4"> Jhapa </option>
																														<option value="5"> Sankhuwashabha </option>
																														<option value="6"> Terhathum </option>
																														<option value="7"> Bhojpur </option>
																														<option value="8"> Dhankuta </option>
																														<option value="9"> Sunsari </option>
																														<option value="10"> Morang </option>
																														<option value="11"> Solukhumbu </option>
																														<option value="12"> Khotang </option>
																														<option value="13"> Udayapur </option>
																														<option value="14"> Okhaldhunga </option>
																														<option value="15"> Saptari </option>
																														<option value="16"> Siraha </option>
																														<option value="17"> Dhanusha </option>
																														<option value="18"> Mahottari </option>
																														<option value="19"> Sarlahi </option>
																														<option value="20"> Sindhuli </option>
																														<option value="21"> Ramechhap </option>
																														<option value="22"> Dolakha </option>
																														<option value="23"> Sindhupalchowk </option>
																														<option value="24"> Rasuwa </option>
																														<option value="25"> Dhading </option>
																														<option value="26"> Nuwakot </option>
																														<option value="27"> Kathmandu </option>
																														<option value="28"> Lalitpur </option>
																														<option value="29"> Bhaktapur </option>
																														<option value="30"> Kavrepalanchowk </option>
																														<option value="31"> Makawanpur </option>
																														<option value="32"> Rautahat </option>
																														<option value="33"> Bara </option>
																														<option value="34"> Parsa </option>
																														<option value="35"> Chitwan </option>
																														<option value="36"> Nawalparasi </option>
																														<option value="37"> Rupandehi </option>
																														<option value="38"> Kapilbastu </option>
																														<option value="39"> Arghakhanchi </option>
																														<option value="40"> Palpa </option>
																														<option value="41"> Gulmi </option>
																														<option value="42"> Syangja </option>
																														<option value="43"> Tanahun </option>
																														<option value="44"> Gorkha </option>
																														<option value="45"> Manang </option>
																														<option value="46"> Lamjung </option>
																														<option value="47"> Kaski </option>
																														<option value="48"> Parbat </option>
																														<option value="49"> Baglung </option>
																														<option value="50"> Myagdi </option>
																														<option value="51"> Mustang </option>
																														<option value="52"> Mugu </option>
																														<option value="53"> Dolpa </option>
																														<option value="54"> Humla </option>
																														<option value="55"> Jumla </option>
																														<option value="56"> Kalikot </option>
																														<option value="57"> Rukum </option>
																														<option value="58"> Rolpa </option>
																														<option value="59"> Pyuthan </option>
																														<option value="60"> Dang </option>
																														<option value="61"> Salyan </option>
																														<option value="62"> Banke </option>
																														<option value="63"> Bardiya </option>
																														<option value="64"> Surkhet </option>
																														<option value="65"> Jajarkot </option>
																														<option value="66"> Dailekh </option>
																														<option value="67"> Kailali </option>
																														<option value="68"> Doti </option>
																														<option value="69"> Achham </option>
																														<option value="70"> Bajura </option>
																														<option value="71"> Bajhang </option>
																														<option value="72"> Darchula </option>
																														<option value="73"> Baitadi </option>
																														<option value="74"> Dadeldhura </option>
																														<option value="75"> Kanchanpur </option>
																														<option value="76"> Rukum East </option>
																														<option value="77"> Nawalparashi West </option>
																												</select>


          <span align="right" class="preeti">Temporary Address <span class="red">*</span></span>
    <select>
														<option value="" data-select2-id="select2-data-4-l7li"></option>
																													<option value="1"> Taplejung </option>
																														<option value="2"> Panchthar </option>
																														<option value="3"> Ilam </option>
																														<option value="4"> Jhapa </option>
																														<option value="5"> Sankhuwashabha </option>
																														<option value="6"> Terhathum </option>
																														<option value="7"> Bhojpur </option>
																														<option value="8"> Dhankuta </option>
																														<option value="9"> Sunsari </option>
																														<option value="10"> Morang </option>
																														<option value="11"> Solukhumbu </option>
																														<option value="12"> Khotang </option>
																														<option value="13"> Udayapur </option>
																														<option value="14"> Okhaldhunga </option>
																														<option value="15"> Saptari </option>
																														<option value="16"> Siraha </option>
																														<option value="17"> Dhanusha </option>
																														<option value="18"> Mahottari </option>
																														<option value="19"> Sarlahi </option>
																														<option value="20"> Sindhuli </option>
																														<option value="21"> Ramechhap </option>
																														<option value="22"> Dolakha </option>
																														<option value="23"> Sindhupalchowk </option>
																														<option value="24"> Rasuwa </option>
																														<option value="25"> Dhading </option>
																														<option value="26"> Nuwakot </option>
																														<option value="27"> Kathmandu </option>
																														<option value="28"> Lalitpur </option>
																														<option value="29"> Bhaktapur </option>
																														<option value="30"> Kavrepalanchowk </option>
																														<option value="31"> Makawanpur </option>
																														<option value="32"> Rautahat </option>
																														<option value="33"> Bara </option>
																														<option value="34"> Parsa </option>
																														<option value="35"> Chitwan </option>
																														<option value="36"> Nawalparasi </option>
																														<option value="37"> Rupandehi </option>
																														<option value="38"> Kapilbastu </option>
																														<option value="39"> Arghakhanchi </option>
																														<option value="40"> Palpa </option>
																														<option value="41"> Gulmi </option>
																														<option value="42"> Syangja </option>
																														<option value="43"> Tanahun </option>
																														<option value="44"> Gorkha </option>
																														<option value="45"> Manang </option>
																														<option value="46"> Lamjung </option>
																														<option value="47"> Kaski </option>
																														<option value="48"> Parbat </option>
																														<option value="49"> Baglung </option>
																														<option value="50"> Myagdi </option>
																														<option value="51"> Mustang </option>
																														<option value="52"> Mugu </option>
																														<option value="53"> Dolpa </option>
																														<option value="54"> Humla </option>
																														<option value="55"> Jumla </option>
																														<option value="56"> Kalikot </option>
																														<option value="57"> Rukum </option>
																														<option value="58"> Rolpa </option>
																														<option value="59"> Pyuthan </option>
																														<option value="60"> Dang </option>
																														<option value="61"> Salyan </option>
																														<option value="62"> Banke </option>
																														<option value="63"> Bardiya </option>
																														<option value="64"> Surkhet </option>
																														<option value="65"> Jajarkot </option>
																														<option value="66"> Dailekh </option>
																														<option value="67"> Kailali </option>
																														<option value="68"> Doti </option>
																														<option value="69"> Achham </option>
																														<option value="70"> Bajura </option>
																														<option value="71"> Bajhang </option>
																														<option value="72"> Darchula </option>
																														<option value="73"> Baitadi </option>
																														<option value="74"> Dadeldhura </option>
																														<option value="75"> Kanchanpur </option>
																														<option value="76"> Rukum East </option>
																														<option value="77"> Nawalparashi West </option>
																												</select>





												<p>Relative's Name <span class="red">*</span></p>
											
										
												<p>
													<input type="text" size="30" maxlength="300" name="txtfather" required="" class=" english_words">
												</p>
									

										
												<p>Relation <span class="red">*</span></p>
								
									
												<p>
													<input type="text" size="30" maxlength="50" name="txtmother" required="" class=" english_words">
												</p>
										



											<p align="right" class="preeti">Identity Type <span class="red">*</span></p>
											
												<p>
													<select name="txtidentitytype" id="txtidentitytype" required="">
														<option value=""></option>
														<option value="1">Citizenship</option>
														<option value="2">Birth Certificate</option>
													</select>
												</p>
											

										
									

									

											
												<p>Citizenship No. <span class="red">*</span></p>
										
											
												<p>
													<input type="text" size="30" maxlength="50" name="txtcitizenshipno" id="txtcitizenshipno" onblur="return checkcitizen()">
												</p>
										

											
												<p>Birth Certificate No. <span class="red">*</span></p>
											
											
												<p>
													<input type="text" class="span1" name="txtjanmadartano" id="txtjanmadartano" placeholder="Reg. No.">
													<input type="text" class="span2" name="txtvdc" id="txtvdc" placeholder="Municipality / V.D.C." onblur="return checkjanma()">
												</p>
											






												<p>Ethnic Group <span class="red">*</span></p>
											</p>
											
												<select name="txtethnicgroupid" required="">
																											<option value="5">Khas/Arya(Bramin,Chhetri)</option>
																												<option value="7">Dalit</option>
																												<option value="8">Janajati</option>
																												<option value="10">Muslim</option>
																												<option value="12">Dalit Terai</option>
																												<option value="13">Non-Dalit Terai</option>
																												<option value="14">Others(Specify) .....</option>
																										</select>
										

									
									
											
												<p>Religion <span class="red">*</span></p>
											
										
												<select name="txtreligionid" required="">
																											<option value="5">Hindu</option>
																												<option value="6">Buddhist</option>
																												<option value="7">Islam</option>
																												<option value="8">Christian</option>
																												<option value="9">Kirat</option>
																												<option value="10">Other(Specify)...</option>
																										</select>
											
											
												<p>marital status <span class="red">*</span></p>
										
											
												<p>
													<select name="txtmaritialstatus" required="">
														<option value="">----</option>
														<option value="1">Single</option>
														<option value="2">Married</option>
														<option value="3">Divorced</option>
														<option value="4">Widowed</option>
													</select>
												</p>
											
									


						
												<p>District Public Health Office/Palika Letter No <span class="red">*</span></p>
										
										
												<p>
													<input type="text" size="30" maxlength="50" name="txtdphletterno" required="">
												</p>
											
											
												<p>District Public Health Office/Palika Letter Date (B.S.)<span class="red">*</span></p>
											
												<p>
													<input type="text" size="30" maxlength="10" name="txtdphletterdate" id="txtdphletterdate" class="nepali-calendar preeti ndp-nepali-calendar" autocomplete="off" required="" onfocus="showNdpCalendarBox('txtdphletterdate')" placeholder="____-__-__">
												</p>
										
											
												<p>Hospital OPD/IPD No/Year <span class="red">*</span></p>
											
										
												<p>
													<input type="text" size="30" maxlength="50" name="txthospitalopdno" required="">
												</p>
											
											
												<p>Hospital Bipanna No <span class="red">*</span></p>
										
										
												<p>
													<input type="text" size="30" maxlength="50" name="txthospitalbipid" id="txthospitalbipid" class="preeti" required="">
												</p>
										

										
										
												<p>Disease <span class="red">*</span></p>
											
												<p>
																										<select name="txtdiseaseid" id="txtdiseaseid" required="">
														<option value=""></option>
																											</select>
													<span id="cancerType">
														<input type="text" name="txtCancerType" id="txtCancerType" class="form-control" placeholder="Cancer Type">
													</span>
												</p>
										
											
												<p>Maximum Amount</p>
										
												<p>
													<input type="text" size="30" maxlength="50" name="txttotalamount" id="txttotalamount" readonly="">
												</p>
										
										
									
										
												<p>Patient's Photo</p>
										
											
												<p><input type="file" name="txtpatientimage" onchange="readURL(this);"></p>
										

											
												<p>Referred By (Palika) <span class="red">*</span></p>
									

</div>








<script>
    gval = "";
    lsel = "";
    function dformfill(){ /* debug form fill toggle*/
        var fill=localStorage.getItem("dformfill");
        localStorage.setItem("dformfill", !(fill==='true'));
    }
    function tt(sel, v) {
        lsel = sel;
        gval = null;
        //sel = "select[name='ctl00$Body$ddlRegion']";
        //console.log('tt'); //debugger;

        var el = $(sel);
        var elval = el.val(); //console.log('elval', elval);

        if (elval == "0") {}
        else if (elval) { return; }

        el.val(v);
        el.trigger('change');
        gval = "-_-";
        console.log(sel, v);
        setTimeout(function () { tt(sel,v) }, 1000); //run untill we have a value
        return v;
    }
    function ttselect(sel, v) {
        //tt(`select[name='ctl00$Body$${sel}']`, v);
        tt(`select[name='${sel}']`, v);
    }
    function ttname(sel, v) {
        tt(`[name='${sel}']`, v);
    }
    function jq(sel){
        return $(`[name='ctl00$Body$${sel}']`);
    }

    $(document).ready(function () {
        //alert(1);
        window.ss = function () {
            var fill=localStorage.getItem("dformfill"); console.log('dformfill()', fill);
            if(!(fill==='true')){ return; }
            
            tt("select[name='ctl00$Body$ddlPoverty']", 1);
            tt("#Body_txtConfirmationNo", Math.random());
            ttname("ctl00$Body$ddlEthnicity", 1);
            tt("#Body_ddlProfession", 1);
            tt("#Body_ddlEducation", 1);
            tt("#Body_ddlIdType", "B");
            tt("#Body_txtPhone", (Math.random() + "").substr(2, 11));
            tt("#Body_ddlFSPRegion", 1);
            tt("#Body_ddlFSPDistrict", 10);

            tt("select[name='ctl00$Body$ddlRegion']", 1);
            tt("select[name='ctl00$Body$ddlDistrict']", 47);
            tt("select[name='ctl00$Body$ddlWard']", 741);
            tt("#Body_txtAddress", Math.random())
            tt("select[name='ctl00$Body$ddlVillage']", 6992);
            $("#Body_txtCHFID").val("1111"+(Math.random()+"").substr(2,5));
            $("#Body_txtOtherNames").val(Math.random());
            $("#Body_txtLastName").val(Math.random());
            
            tt("#Body_ddlGender", "M");
            $("#Body_txtPassport").val(Math.random());
            

            //tt("#Body_txtBirthDate", '2079/03/23');
            //ttselect("ddlConfirmationType", 1);

            if ($(lsel).val() > 0) {
                //jq("chkSameBelow").prop("checked", true);
                //jq("chkSameBelow").trigger('click');
                return;
            }
            //setTimeout(ss, 1000);

             $("#bipannas").text("abcd");
        };       
        ss();
    });
</script>
</asp:Content>
