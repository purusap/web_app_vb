﻿<%-- Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)

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
<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" CodeBehind="Claim.aspx.vb"
    Inherits="IMIS.Claim" Title='<%$ Resources:Resource,L_CLAIMPAGETITLE%>' %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="Server">
     <script>
         function getRowDetails(thisRef) {
             var row = {}
             var tr = $(thisRef).parents('tr');
             var ItemServ = '';
             var code = tr.find('.txtItemCode')?.val() //'ctst1  CapTablet'
             if (code) {
                 ItemServ = 'Item'
             } else {
                 ItemServ='Service'
                 code = tr.find('txtServiceCode').val()
             }
             code=code.split(' ')[0]
             var Qty = tr.find('.ClaimQty').val();
             var details = {
                 "ItemSrv": ItemServ,
                 "ItemSrvCode": code,
                 "Qty": Qty,
                 "CHFID": $('#Body_txtCHFIDData').val(),
                 "DateClaimed": $('#Body_txtClaimDate').val().split('/').reverse().join('-'),
                 "VisitType": $('#Body_ddlVisitType').val(),
             }
             var j = {
                 "xml": details
             }
             return j;
         }
         function getClaimDetailsJson() {
             var j = {
                 "xml": {
                     "HFCode": `${$('#Body_txtHFCode').val()}`,
                     "CHFID": `${$('#Body_txtCHFIDData').val()}`,
                     "ClaimCode": `${$('#Body_txtCLAIMCODEData').val()}`,
                     "ICDCode0": `${$('#Body_txtICDCode0').val()}`,
                     "ClaimedDate": `${$('#Body_txtClaimDate').val()}`,
                     "VisitType": `${$('#Body_ddlVisitType').val()}`,
                 }
             };
             return j;
         }
         function fetchCopayDetails() {
             //ApiEntryHandler.ashx?json={"xml":{"HFID":35}}&action=ClaimCopayResponse
             var encJson = encodeURI(JSON.stringify(getClaimDetailsJson()));
             $.get('/FindClaims.aspx?action=ClaimCopayResponse&json=' + encJson, function (res) {
                 console.log(res);
                 $('#idCopayPercent').text(res.percent);
                 $('#idCopayReason').text(res.reason);
                 updateCopayPercent();
             });
         }
         function updateCopayPercent() {
             var totalAdjustedAmount = 0;
             $.each($('.txtCopay'), function (sn, el) {
                 var per = $('#idCopayPercent').text();
                 var jEl = $(el);
                 var tr = jEl.closest('tr');
                 var qty = tr.find('.ClaimQty').val()
                 var v = tr.find('.ClaimValue ').val()
                 var adjAmt = qty * v - qty * v * per;
                 jEl.val(adjAmt);
                 totalAdjustedAmount += adjAmt;
             });
             $('#idAdjustedAmount').text(totalAdjustedAmount);
         }
     </script>
      

    <script type="text/javascript">

        const QtyOneServices = ["OPD 2  OPD Hospital", "OPD 1  OPD PHC", "OPD 3  OPD Eye Hospital", "EMR 1  Emergency Hospital", "EMRPHC  Emergency PHC", "EMR 2  Emergency Eye Hospital", "OPD4  OPD TICKET", "EMRT  Emergency Ticket"];
        var canClearRow = "<%=canClearRow %>";
        function setCaller(flag) {
            document.getElementById('<%=hfCaller.ClientID %>').value = flag;
        }

        function BindEventsonRowAdd() {
            $(".delButton").unbind("click");
            $(".delButton").click(function () { ClearRow($(this)); });
        }

        $(document).ready(function () {

            $("a").each(function () {
                if ($(this).attr("href") == "#") {
                    $(this).attr("href", "javascript:void 0");
                }
            });
            function deleteAddedRow($source) {
                $row = $source.parent().parent();
                //if (showmodalPopup())
                if ($row.attr("class") == "addedRow")
                    $row.remove();

                return false;
            }

            function validateTextNumberOnly($txtbox, e) {
                if (e.which < 48 || e.which > 57)
                    return false;
            }
        });

        var $tr_id
        function ClearRow($source) {
            //Get the id of the record
            var record_id = $source.attr("id");
            //Get the gridview row reference        
            $tr_id = $source.parent().parent();

            var tdCode = $tr_id.find("td").eq(0).find("input[type=text]").val();
            var tdQuantity = $tr_id.find("td").eq(1).find("input[type=text]").val();
            var tdValue = $tr_id.find("td").eq(2).find("input[type=text]").val();
            var tdExplanation = $tr_id.find("td").eq(3).find("input[type=text]").val();
            if (tdCode == "" && tdQuantity == "" && tdValue == "" && tdExplanation == "") {
                return;
            } else {
                //ask for user's confirmation
                if (canClearRow.toLowerCase() == "true") {
                    var msgHTML = '<%= imisgen.getMessage("M_CONFIRMROWCLEARING", True ) %>';
                    popup.rejectBTN_Text = "CANCEL";
                    popup.confirm(msgHTML, SubmitHandle);
                }

            }
        }

        $(document).ready(function () {
            //fetchCopayDetails()
           
            $(".delButton").click(function () {
                ClearRow($(this));
            });

            $(".ClaimValue").ready(function () {
                CalculateClaimTotal($("#<%=gvService.ClientID %>"));
                $("#Body_txtServTotal").val(claimValue.toFixed(2));
                serviceValue = claimValue;
                CalculateClaimTotal($("#<%=gvItems.ClientID %>"));
                itemValue = claimValue - serviceValue;
                $("#Body_txtItemTotal").val(itemValue.toFixed(2));
                $("#<%=txtCLAIMTOTALData.ClientID %>").val(claimValue.toFixed(2));
                $("#<%=hfClaimTotalValue.ClientID %>").val(claimValue.toFixed(2));
                $("#<%=hfClaimTotalValue.ClientID %>").data("InitialCLMValue", claimValue.toFixed(2));
                claimValue = 0;
            });
            $("#<%#txtCHFIDData.ClientID %>").focus();

        });
        var ClaimedDate;
        var VisitDateFrom;
        var VisitDateTo;
        var flagCheckDateLogic = 0;
        //    var btnClicked = false
        //    $(".btnDate").click(function() {
        //       $txtbox = $(this).siblings("input[type=text]");

        //   });
        // alert($("#txtClaimDateCalendarExtender_daysBody").html());
        $(".ajax__calendar_days td").click(function () {
            $("#<%=txtClaimDate.ClientID %>").trigger("change");
        });
        $("#ctl00_Body_txtSTARTData_CalendarExtender_daysBody td").click(function () {
            $("#ctl00$Body$txtSTARTData").trigger("change");
        });
        $("#txtENDData_CalendarExtender_daysBody td").click(function () {
            $("#ctl00$Body$txtENData").trigger("change");
        });
        $("#txtClaimDateCalendarExtender_daysBody td").click(function () {
            $("#<%=txtClaimDate.ClientID %>").trigger("change");
        });

        function CheckClaimedDate() {
            ClaimedDateFill();
            if (isValidDate(new Date(ClaimedDate))) {
                var ServerDate = '<%= Format(Date.Today, "MM/dd/yyyy") %>';
                if (new Date(ClaimedDate) > new Date(ServerDate)) {
                    //$('#<%=txtClaimDate.ClientID %>').val("");
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_CLAIMDATENOTAFTERTODAY", True ) %>');
                    return 0;
                }
                return 1;
            } else {

                $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_INVALIDDATE", True ) %>');
                return 0;
            }
        }
        function CheckVisitDateFrom() {
            VisitDateFromFill();
            if (isValidDate(new Date(VisitDateFrom))) {
                var ServerDate = '<%= Format(Date.Today, "MM/dd/yyyy") %>';
                if (new Date(VisitDateFrom) > new Date(ServerDate)) {
                    //$('#<%=txtSTARTData.ClientID %>').val("");
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_VISITDATENOTAFTERTODAY", True ) %>');
                    return 0;
                }
                return 1;
            } else {
                $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_INVALIDDATE", True ) %>');
                return 0;
            }
        }


        function CheckVisitDateTo() {
            if ($('#<%=txtENDData.ClientID %>').val() != "") {
                VisitDateToFill();
            }
        }
        function ClaimedDateFill() {
            ClaimedDate = $('#<%=txtClaimDate.ClientID %>').val();
            var day = ClaimedDate.substr(0, 2);
            var Month = ClaimedDate.substr(3, 2);
            var Year = ClaimedDate.substr(6, 4);
            ClaimedDate = Month + "/" + day + "/" + Year;
        }
        function VisitDateFromFill() {
            VisitDateFrom = $('#<%=txtSTARTData.ClientID %>').val();
            var day = VisitDateFrom.substr(0, 2);
            var Month = VisitDateFrom.substr(3, 2);
            var Year = VisitDateFrom.substr(6, 4);
            VisitDateFrom = Month + "/" + day + "/" + Year;
        }
        function VisitDateToFill() {
            VisitDateTo = $('#<%=txtENDData.ClientID %>').val();
            var day = VisitDateTo.substr(0, 2);
            var Month = VisitDateTo.substr(3, 2);
            var Year = VisitDateTo.substr(6, 4);
            VisitDateTo = Month + "/" + day + "/" + Year;
        }
        function CheckDateLogic() {

            if (flagCheckDateLogic != 1) {
                if ($('#<%=txtClaimDate.ClientID %>').val() != "") {
                    ClaimedDateFill();
                }
            }
            if (flagCheckDateLogic != 2) {
                if ($('#<%=txtSTARTData.ClientID %>').val() != "") {
                    VisitDateFromFill();
                }
            }
            if (flagCheckDateLogic != 3) {
                if ($('#<%=txtENDData.ClientID %>').val() != "") {
                    VisitDateToFill();
                }
            }
            // checking on date isValid....added by ruzo 5 nov 2012....below
            if (CheckVisitDateFrom() == 0 || CheckClaimedDate() == 0) return 0;

            if (flagCheckDateLogic == 2) {
                if (!isValidDate(new Date(ClaimedDate)) || !isValidDate(new Date(VisitDateFrom))) {
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_INVALIDDATE", True ) %>');
                    return 0;
                }
                if (new Date(ClaimedDate) < new Date(VisitDateFrom)) {
                    $('#<%=txtSTARTData.ClientID %>').val("");
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_VISITDATENOTAFTERCLAIMDATE", True ) %>');
                    return 0; //...added by ruzo 2 nov 2012
                }
            }
            if (flagCheckDateLogic == 1) {
                if (!isValidDate(new Date(ClaimedDate)) || !isValidDate(new Date(VisitDateFrom))) {
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_INVALIDDATE", True ) %>');
                    return 0;
                }
                if (new Date(ClaimedDate) < new Date(VisitDateFrom)) {
                    $('#<%=txtClaimDate.ClientID %>').val("");
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_CLAIMDATENOTBEFOREVISITDATE", True ) %>');
                    return 0; //...added by ruzo 2 nov 2012
                }
            }
            if (flagCheckDateLogic == 3) {
                if (!isValidDate(new Date(VisitDateFrom))) {
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_INVALIDDATE", True ) %>');
                    return 0;
                }
                if (new Date(VisitDateTo) < new Date(VisitDateFrom)) {
                    $('#<%=txtENDData.ClientID %>').val("");
                    $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_VISITDATETONOTBEFOREVISITDATEFROM", True ) %>');
                    return 0; //...added by ruzo 2 nov 2012
                }
            }
            
            return 1; //...added by ruzo 2 nov 2012

        }

        $(document).ready(function () {
            
            $('#<%=B_SAVE.ClientID %>').click(function () {

                //var isGuaranteeNoRequired = $("#<%= txtGuaranteeId.ClientID %>").hasClass("requiedField");

                //if ($("#<%=txtCHFIDData.ClientID%>").val() == "" || $("#<%=txtCLAIMCODEData.ClientID%>").val() == "" || $("#<%=txtICDCode0.ClientID%>").val() == 0 || $("#<%=ddlVisitType.ClientID%>").val() == 0 || $("#<%=txtGuaranteeId.ClientID%>").val() == "") {
                if ($("#<%=txtCHFIDData.ClientID%>").val() == "" || $("#<%=txtCLAIMCODEData.ClientID%>").val() == "" || $("#<%=txtICDCode0.ClientID%>").val() == 0 || $("#<%=ddlVisitType.ClientID%>").val() == 0 || $("#<%=ddlOPDIPD.ClientID%>").val() == 0) {
                        $('#<%=lblMsg.ClientID%>').html('<%= imisgen.getMessage("V_SUMMARY", True ) %>');
                                               return false;
                }

                // new validation for HIB
                //var flagHIBValidation = true;
                //$("[id^='Body_gvService_txtQuantityS_']").each(function () {
                //    var ServCodeName = $(event.target).closest('td').prev().find("input[type=text]").val();
                //    var ServExplanation = $(event.target).closest('td').next(1).find("input[type=text]").val();
                //    if (QtyOneServices.includes(ServCodeName) == false) {
                //        if ($(this).val() != 1) {
                //            alert("Enter explanation for this service");
                //            ServExplanation.focus();
                //            flagHIBValidation = false;
                //        }
                //    }

                //});
              
                // date validation...added by ruzo 2 nov 2012
                var check = 0;
                ClaimedDateFill();
                VisitDateFromFill();
                VisitDateToFill();
                for (var i = 1; i <= 3; i++) {
                    flagCheckDateLogic = i;
                    check = CheckDateLogic();
                    if (check == 0) {
                        break;
                    }
                }

                // CheckClaimedDate(); CheckVisitDateFrom(); CheckVisitDateTo();

                // .... end of date validation...

                $("#<%=hfInitialCLMTotalValue.ClientID %>").val($("#<%=hfClaimTotalValue.ClientID %>").data("InitialCLMValue"));
                if (i == 4)
                    $("#<%=lblMsg.ClientID %>").html("");

                var flagSaveLabel = true;
                $("#<%=gvService.ClientID %> tr:not(:first)").each(function() {

                    var ServCodeNam = $(this).find("td").eq(0).find("input[type=text]").val();
                    var ServQty = $(this).find("td").eq(1).find("input[type=text]").val();
                    var ServValue = $(this).find("td").eq(2).find("input[type=text]").val();
                    var ServExplanation = $(this).find("td").eq(3).find("input[type=text]").val();
                    if (ServCodeNam != "" && ServQty == "") {
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_FILLSERVICEQUANTITY", True)%>');
                        flagSaveLabel = false;

                    } else if (ServCodeNam != "" && ServValue == "") {
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_FILLSERVICEVALUE", True)%>');
                        flagSaveLabel = false;

                    } else if (ServCodeNam == "" && ServValue != "") {
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_SELECTSERVICECODE", True)%>');
                        flagSaveLabel = false;

                    } else if (ServCodeNam == "" && ServQty != "") {
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_SELECTSERVICECODE", True ) %>');
                        flagSaveLabel = false;

                    }
                    if (QtyOneServices.includes(ServCodeNam) == false) {
                        if (ServCodeNam != "" && ServQty > 1 && ServExplanation=="") {
                            $("#<%=lblMsg.ClientID %>").html("Enter explanation for service: " + ServCodeNam);
                            flagSaveLabel = false;
                        }
                    }
                });
                    $("#<%=gvItems.ClientID %> tr:not(:first)").each(function() {
                        var ItemCodeNam = $(this).find("td").eq(0).find("input[type=text]").val();
                        var ItemQty = $(this).find("td").eq(1).find("input[type=text]").val();
                        var ItemValue = $(this).find("td").eq(2).find("input[type=text]").val();
                        if (ItemCodeNam != "" && ItemQty == "") {
                            $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_FILLITEMQUANTITY", True)%>');
                            flagSaveLabel = false;
                        } else if (ItemCodeNam != "" && ItemValue == "") {
                            $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_FILLITEMVALUE", True)%>');
                            flagSaveLabel = false;
                        } else if (ItemCodeNam == "" && ItemValue != "") {
                            $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_SELECTITEMCODE", True)%>');
                            flagSaveLabel = false;
                        } else if (ItemCodeNam == "" && ItemQty != "") {
                            $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_SELECTITEMCODE", True ) %>');
                            flagSaveLabel = false;
                        }
                    });
                    //alert("bottom: " + flagSaveLabel + "===" + i);
                    return (flagSaveLabel && i == 4);  // added by ruzo 2 nov 2012....

                });

                
        });


        function pageLoadExtend() {          
            
            
            $("[id*='Body_gvService_txtValue']").attr('readonly', true);
            $("[id*='Body_gvItems_txtValueI']").attr('readonly', true);

            dropdown.init($("#DropDownSugTable"), function() { $('.ClaimValue').eq(0).trigger("change"); });

            $(".disabled a").unbind("click").mouseover(function() {
                $(this).css("opacity", 0.2);
            });
            showInsureePopupSearchResult();
            $('#btnCancel').click(function() {
                $('#SelectPic').hide();
            });

            
                

            $("#<%=gvService.ClientID %>").find("input[type=text]").change(function() {

                $("#<%=txtAddServiceRows.ClientID %>").attr("disabled", true);
                $("#<%=txtAddItemRows.ClientID %>").attr("disabled", true);
            });

            window.fnClaimRowAction=function (rthis) {
                var row = getRowDetails(rthis); //row.xml.DateClaimed="2024-05-11";
                args=row.xml;
                if(args.VisitType=="E"){
                    console.log('Emergency visit');
                    return;
                }

                console.log('row',row);
                var encJson = encodeURI(JSON.stringify(row));
                $.get('/FindClaims.aspx?action=CapStatusApi&json=' + encJson, function (res) {
                    console.log(res);
                    if(res){//debugger
                        var res0=res[0];
                        if(res0 &&  res0?.QtyRemain && res0?.QtyRemain < parseFloat(row.xml.Qty) ){
                            if(!window.errCode){
                                window.errCode=res0.ItemCode; //todo: verify qty of item and code with api on submit
                            }
                            console.log('k ho yesto')
                            $('#Body_B_SAVE').hide()
                            alert( `Maximum allowed: ${res0?.QtyRemain} for  ${row.xml.ItemSrvCode}`);
                        }else{
                            if( window.errCode==res0.ItemCode ){//only if we handled our err
                                $('#Body_B_SAVE').show();
                                window.errCode=null;
                            } 
                            console.log('k ho yesto, qty thik cha')
                        } 
                    } 
                });

            }; // fnClaimRowAction( $('#Body_gvItems_txtQuantityI_0') )

            $(".ClaimQty").change(function() {
                $(".ClaimValue").trigger("change");
                console.log(this);
                fnClaimRowAction(this);
            });

            $('.ClaimQty').on("blur", function(){
                fnClaimRowAction(this);
            });

            $(".ClaimValue").change(function() {
                CalculateClaimTotal($("#<%=gvService.ClientID %>"));
                $("#Body_txtServTotal").val(claimValue.toFixed(2));
                serviceValue = claimValue;
                CalculateClaimTotal($("#<%=gvItems.ClientID %>"));
                itemValue = claimValue - serviceValue;
                $("#Body_txtItemTotal").val(itemValue.toFixed(2));
                $("#<%=txtCLAIMTOTALData.ClientID %>").val(claimValue.toFixed(2));
                $("#<%=hfClaimTotalValue.ClientID %>").val(claimValue.toFixed(2));
                claimValue = 0;
            });

            $("#<%=txtClaimDate.ClientID %>").change(function() {

                $("#<%=lblMsg.ClientID %>").html("");
                CheckClaimedDate();
                if ($("#<%=txtSTARTData.ClientID %>").val() != "") {
                    flagCheckDateLogic = 1;
                    CheckDateLogic();
                }
            });
            $("#<%=txtSTARTData.ClientID %>").change(function() {
                $("#<%=lblMsg.ClientID %>").html("");
                CheckVisitDateFrom();
                if ($("#<%=txtClaimDate.ClientID %>").val() != "") {
                    flagCheckDateLogic = 2;
                    CheckDateLogic();
                }
            });
            $('#<%=txtENDData.ClientID %>').change(function() {
                $("#<%=lblMsg.ClientID %>").html("");
                CheckVisitDateTo();
                if ($("#<%=txtSTARTData.ClientID %>").val() != "") {
                    flagCheckDateLogic = 3;
                    CheckDateLogic();
                }
            });

        }

        //    $.ajax({
        //        success: function() {
        //            alert(" success ajax function");
        //        }
        //    });

        function SubmitHandle(btn) {
            if (btn == "ok") {
                $tr_id.find("td").eq(0).find("input[type=text]").val("");
                $tr_id.find("td").eq(1).find("input[type=text]").val("");
                $tr_id.find("td").eq(2).find("input[type=text]").val("");
                $tr_id.find("td").eq(3).find("input[type=text]").val("");
                $('.ClaimValue').trigger("change");
            } else if (btn == "cancel") {
                $("#<%=lblMsg.ClientID %>").html("");

            }

        }

        var claimValue = 0;
        function CalculateClaimTotal($gv) {

            var $gvRows = $gv.find("tr:not(:first)");

            $gvRows.each(function() {
                var Qty = $(this).find("td").eq(1).find("input[type=text]").val();
                var Value = $(this).find("td").eq(2).find("input[type=text]").val();
                if (Value != "" && Qty != "") {

                    if (isNaN(Value)) {
                        //alert($(this).find("td").eq(2).find("input[type=text]").val());
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_ENTERVALIDPRICEVALUE", True)%>');
                        return;
                    } else if (isNaN(Qty)) {
                        $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_ENTERVALIDQUANTITY", True ) %>');
                        return;
                    }

                    claimValue += parseFloat(Qty) * parseFloat(Value);
                } else return;

            });
            updateCopayPercent();
        }
        //ICDCode Autocomplete textbox controls Start
        $(document).ready(function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_initializeRequest(InitializeRequest);
            prm.add_endRequest(EndRequest);

            InitAutoCompl();
        });
        function InitializeRequest(sender, args) {
        }

        function EndRequest(sender, args) {

            InitAutoCompl();
        }
        function InitAutoCompl() {
            $("#<%=txtICDCode0.ClientID %>").focus(function () {
                var datasource;
                $.ajax({
                    url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                    dataType: "json",
                    type: "GET",
                    async: false,
                    cache: false,
                    success: function (data) {
                        datasource = data;
                    }
                });
                var ds = new AutoCompletedataSource(datasource);
                $("#<%=txtICDCode0.ClientID %>").autocomplete({
                    source: function (request, response) {
                        var data = ds.filter(request);
                        response($.map(data, function (item, id) {

                            return {
                                label: item.ICDNames, value: item.ICDNames, value2: item.ICDCode, id: item.ICDID
                            };
                        }));
                    },
                    select: function (e, u) {
                        $('#<% = hfICDID0.ClientID%>').val(u.item.id);
                    }
                });
            });
            $("#<%=txtICDCode0.ClientID %>").change(function () {
                if ($(this).val() === "") {
                    $('#<% = hfICDID0.ClientID%>').val("")
                 }
             });
            
            $("#<%=txtICDCode1.ClientID %>").focus(function () {
                var datasource;
                $.ajax({
                    url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                    dataType: "json",
                    type: "GET",
                    async: false,
                    cache: false,
                    success: function (data) {
                        datasource = data;
                    }
                });
                var ds = new AutoCompletedataSource(datasource);
                $("#<%=txtICDCode1.ClientID %>").autocomplete({
                    source: function (request, response) {
                        var data = ds.filter(request);
                        response($.map(data, function (item, id) {
                            return {
                                label: item.ICDNames, value: item.ICDNames, value2: item.ICDCode, id: item.ICDID
                            };
                        }));
                    },
                    select: function (e, u) {
                        $('#<% = hfICDID1.ClientID%>').val(u.item.id);
                    }
                });
            });
            $("#<%=txtICDCode1.ClientID %>").change(function () {
                if ($(this).val() === "") {
                    $('#<% = hfICDID1.ClientID%>').val("")
                }
            });           

            $("[id^='Body_gvService_txtQuantityS_']").change(function () {
                var ServCodeNam = $(event.target).closest('td').prev().find("input[type=text]").val();                
                //if ((ServCodeNam == "OPD 2  OPD Hospital") || (ServCodeNam == "OPD 1  OPD PHC") || (ServCodeNam == "OPD 3  OPD Eye Hospital") || (ServCodeNam == "EMR 1  Emergency Hospital") || (ServCodeNam == "EMRPHC  Emergency PHC") || (ServCodeNam == "EMR 2  Emergency Eye Hospital")) {
                //    alert("Quantity is limited to 1 only!");
                //    $(this).val(1);
                //}
                if (QtyOneServices.includes(ServCodeNam)) {
                    alert("Quantity is limited to 1 only!");
                    $(this).val(1);
                }
            });
            <%--
            $("#<%=txtICDCode2.ClientID %>").focus(function () {
                var datasource;
                $.ajax({
                    url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                    dataType: "json",
                    type: "GET",
                    async: false,
                    cache: false,

                    success: function (data) {
                        datasource = data;
                    }
                });
                var ds = new AutoCompletedataSource(datasource);
                $("#<%=txtICDCode2.ClientID %>").autocomplete({
                    source: function (request, response) {
                        var data = ds.filter(request);
                        response($.map(data, function (item, id) {
                            return {
                                label: item.ICDNames, value: item.ICDNames, value2: item.ICDCode, id: item.ICDID
                            };
                        }));
                    },
                    select: function (e, u) {
                        $('#<% = hfICDID2.ClientID%>').val(u.item.id);
                    }
                });
            });
            $("#<%=txtICDCode2.ClientID %>").change(function () {
                if ($(this).val() === "") {
                    $('#<% = hfICDID2.ClientID%>').val("")
                }
            $("#<%=txtICDCode0.ClientID %>").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                        // data: JSON.stringify({ prefix: request.term }),
                        data: { ICDCode: $("#<%=txtICDCode0.ClientID %>").val() },

            dataType: "json",
            type: "POST",

            success: function (data) {
                response($.map(data, function (item, id) {
                    return { label: item.ICDNames, value: item.ICDNames, id: item.ICDID };
                }));
            },
            error: function (response) {
                alert(response.responseText);
            },
            failure: function (response) {
                alert(response.responseText);
            }
        });
                },
                select: function (e, u) {
                    $('#<% = hfICDID0.ClientID%>').val(u.item.id);

                },
                minLength: 1
            });

            $("#<%=txtICDCode1.ClientID %>").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                        // data: JSON.stringify({ prefix: request.term }),
                        data: { ICDCode: $("#<%=txtICDCode1.ClientID %>").val() },

            dataType: "json",
            type: "POST",

            success: function (data) {
                response($.map(data, function (item, id) {
                    return { label: item.ICDNames, value: item.ICDNames, id: item.ICDID };
                }));
            },
            error: function (response) {
                alert(response.responseText);
            },
            failure: function (response) {
                alert(response.responseText);
            }
        });
                },
                select: function (e, u) {
                    $('#<% = hfICDID1.ClientID%>').val(u.item.id);

                },
                minLength: 1
            });

            $("#<%=txtICDCode2.ClientID %>").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                        // data: JSON.stringify({ prefix: request.term }),
                        data: { ICDCode: $("#<%=txtICDCode2.ClientID %>").val() },

            dataType: "json",
            type: "POST",

            success: function (data) {
                response($.map(data, function (item, id) {
                    return { label: item.ICDNames, value: item.ICDNames, id: item.ICDID };
                }));
            },
            error: function (response) {
                alert(response.responseText);
            },
            failure: function (response) {
                alert(response.responseText);
            }
        });
                },
                select: function (e, u) {
                    $('#<% = hfICDID2.ClientID%>').val(u.item.id);

                },
                minLength: 1
            });

            $("#<%=txtICDCode3.ClientID %>").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                        // data: JSON.stringify({ prefix: request.term }),
                        data: { ICDCode: $("#<%=txtICDCode3.ClientID %>").val() },

            dataType: "json",
            type: "POST",

            success: function (data) {
                response($.map(data, function (item, id) {
                    return { label: item.ICDNames, value: item.ICDNames, id: item.ICDID };
                }));
            },
            error: function (response) {
                alert(response.responseText);
            },
            failure: function (response) {
                alert(response.responseText);
            }
        });
                },
                select: function (e, u) {
                    $('#<% = hfICDID3.ClientID%>').val(u.item.id);

                },
                minLength: 1
            });

            $("#<%=txtICDCode4.ClientID %>").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                        // data: JSON.stringify({ prefix: request.term }),
                        data: { ICDCode: $("#<%=txtICDCode4.ClientID %>").val() },

            dataType: "json",
            type: "POST",

            success: function (data) {
                response($.map(data, function (item, id) {
                    return { label: item.ICDNames, value: item.ICDNames, id: item.ICDID };
                }));
            },
            error: function (response) {
                alert(response.responseText);
            },
            failure: function (response) {
                alert(response.responseText);
            }
        });
                },
                select: function (e, u) {
                    $('#<% = hfICDID4.ClientID%>').val(u.item.id);

                },
                minLength: 1
            });
        --%>
        }
        
    </script>

    <style type="text/css">
        table#DropDownSugTable
        {
            border-width: 0px;
            border-collapse: collapse;
        }
        table#DropDownSugTable th
        {
            background: #CCC;
            color: #303030;
            border-width: 0px;
        }
        table#DropDownSugTable td
        {
            border-width: 0px;
        }
        .pnlHiddenServiceCodes, .pnlHiddenItemCodes
        {
            display: none;
            position: absolute;
            background: #CCCCCC;
            border: 1px solid #ccc;
            font-weight: normal;
            color: #000000;
            z-index: 100;
            padding: 3px;
            height: auto;
            cursor: pointer;
            width: auto;
        }
        .popup
        {
            width: 220px;
            height: 100px;
            background-color: White;
            z-index: 1002;
            font-size: 14px;
            text-align: center;
            border: solid 2px black;
            -webkit-border-radius: 12px;
            -moz-border-radius: 12px;
            position: absolute;
            top: 40%;
            left: 40%;
            padding-top: 8px;
        }
        .backentry
        {
            height: 690px;
        }
        .footer
        {
            top:auto;
        }
        .auto-style1 {
            height: 27px;
        }
        .auto-style2 {
            height: 27px;
            width: 150px;
            text-align: right;
            color: Blue;
            font-weight: normal;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            padding-right: 1px;
        }
        .auto-style3 {
            height: 27px;
            width: 600px;
            text-align: right;
            color: Blue;
            font-weight: normal;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            padding-right: 1px;
        }        
        #Body_ddlICDData1, #Body_ddlICDData{
         display:none;
        }
        .contentBox{
            min-height:631px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Body" runat="Server">
    <div class="divBody" style="height:650px;" >

        <asp:Panel ID="pnlBodyCLM" runat="server">
            <asp:HiddenField ID="hfICDID0" runat="server"/>
            <asp:HiddenField ID="hfICDID1" runat="server"/>
            <asp:HiddenField ID="hfICDID2" runat="server"/>
            <asp:HiddenField ID="hfICDID3" runat="server"/>
            <asp:HiddenField ID="hfICDID4" runat="server"/>
            <asp:HiddenField ID="hfCompareDate" runat="server"/>
            <table id="DropDownSugTable" border="0px" style="display: none; width: 100%; border-collapse: collapse;
                border: 0px solid #CCC;">
                <tr style="color: #303030; background: #C0C0C0;">
                    <th>
                        <%=imisgen.getMessage("L_CODE", True)%>
                    </th>
                    <th>
                        <%=imisgen.getMessage("L_NAME", True)%>
                    </th>
                    <th>
                        <%=imisgen.getMessage("L_PRICE", True) %>
                    </th>
                </tr>
            </table>
             <asp:UpdatePanel ID="UpClaims" runat="server"><ContentTemplate>
                    <asp:HiddenField ID="hfRowAddedFlag" runat="server" Value="0" />
                     <asp:HiddenField ID="hfGuaranteeId" runat="server" Value="0" />
                    
          <asp:Panel ID="pnlClaimDetails" runat="server" CssClass="panel" oncontextmenu="return false;"
                        GroupingText='<%$ Resources:Resource,L_CLAIMDETAILS %>'>
                        <asp:GridView ID="gvHiddenItemCodes1" runat="server">
                        </asp:GridView>
              
          <table>
             <tr>                                  
               <td class="auto-style2">
                   <asp:Label ID="lblHFCODE" runat="server" Text='<%$ Resources:Resource,L_HFCODE %>' ></asp:Label>
               </td>
               <td class ="DataEntry">
               <asp:Textbox ID="txtHFCode" size="10" runat="server" Enabled ="false" Width="135px"></asp:Textbox> 
               </td>
                <td class="auto-style2">
                   <asp:Label ID="lblHFName" runat="server" Text='<%$ Resources:Resource,L_HFNAME %>' ></asp:Label>
               </td>
               <td class ="auto-style1" colspan="3" >
               <asp:Textbox ID="txtHFName" runat="server" Enabled="false" width="135px" ></asp:Textbox> 
               </td>         
               
              
               <td class="auto-style3">
                   <asp:Label ID="lblSTART" runat="server" Text='<%$ Resources:Resource,L_VISITDATEFROM %>' ></asp:Label>
               </td>
               <td  class ="DataEntry">
                <asp:TextBox ID="txtSTARTData" runat="server" size="10" Width="100px" maxlength="10" CssClass="claimEntryFrom"> </asp:TextBox>
                   <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtSTARTData" ErrorMessage="*" SetFocusOnError="True" 
                    ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$" 
                    ValidationGroup="check" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="txtSTARTData_RequiredFieldValidator" 
                       runat="server" ErrorMessage="*" ControlToValidate="txtSTARTData" 
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
               <asp:Button ID="btnSTARTData" runat="server" Height="15px" padding-bottom="3px" 
                        Width="15px" class="btnDate" />
                    <ajax:CalendarExtender ID="txtSTARTData_CalendarExtender" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnSTARTData" TargetControlID="txtSTARTData">
                    </ajax:CalendarExtender>
                     
               </td>
            </tr>   
             <tr>
              <td class="FormLabel" style="width:600px;">
                   <asp:Label ID="lblCHFID" runat="server" Text='<%$ Resources:Resource,L_CHFID %>' ></asp:Label>               
               </td>
               <td class ="DataEntry">
                   <asp:Textbox ID="txtCHFIDData" runat="server" CssClass="check" size="11" MaxLength="12" 
                       AutoPostBack ="true" Width="125px" ></asp:Textbox>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                       runat="server" ErrorMessage="*" ControlToValidate="txtCHFIDData" 
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
               </td>
               <td class="FormLabel">
                   <asp:Label ID="lblNAME" runat="server" Text='<%$ Resources:Resource,L_PATIENTNAME %>' ></asp:Label>
               </td>
               <td class ="DataEntryWide">
                   <asp:TextBox ID="txtNAMEData" runat="server" Text="" Enabled="false" width="135px" ></asp:TextBox>
               </td>
                 <td class="FormLabel">
                    <asp:Label ID="lblVisitDays" runat="server" Text="Last Visit:" ></asp:Label>
                </td>
                 <td class ="DataEntryWide">
                     <asp:TextBox ID="txtVisitDays" runat="server" Enabled="false" Text="" style="text-align:right"></asp:TextBox>                    

                 </td>     
                 <td class="FormLabel" style="width:500px;" >
                   <asp:Label ID="lblEND" runat="server" Text='<%$ Resources:Resource,L_VISITDATETO %>' ></asp:Label>
               </td>
               <td class ="DataEntry">
                   <asp:TextBox ID="txtENDData" runat="server" Size="10" Width="100px" maxlength="10"></asp:TextBox>
                   <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtENDData" ErrorMessage="*" SetFocusOnError="True" 
                    ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$" 
                    ValidationGroup="check" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                   <asp:RequiredFieldValidator ID="txtENDData_RequiredFieldValidator" 
   runat="server" ErrorMessage="*" ControlToValidate="txtENDData" 
   ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
               <asp:Button ID="btnENDData" runat="server" Height="15px" padding-bottom="3px" 
                        Width="15px" style="margin-left:7px" class="btnDate" />
                    <ajax:CalendarExtender ID="txtENDData_CalendarExtender" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnENDData" TargetControlID="txtENDData">
                    </ajax:CalendarExtender>
                     
               </td> 
            </tr>  
               
             <tr>                         
            
               <td class="FormLabel">
                   <asp:Label ID="lblCLAIMCODE" runat="server" Text='<%$ Resources:Resource,L_CLAIMCODE %>' ></asp:Label>
               </td>
               <td class ="DataEntry">
                   <asp:TextBox ID="txtCLAIMCODEData" runat="server" size="10" MaxLength="10" Text="" Width="130px" ></asp:TextBox>
                   <asp:RegularExpressionValidator ID="RegexValidator" runat="server" ControlToValidate="txtCLAIMCODEData"
                       ValidationExpression="^([RST][0-9]{9})$|(^[0-9]{9,10})$" ErrorMessage="Invalid Claim Code"></asp:RegularExpressionValidator>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                       runat="server" ErrorMessage="*" ControlToValidate="txtCLAIMCODEData" 
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
               </td>
               <td class="FormLabel" style="width:600px;">
                  <asp:Label ID="lblCLAIMDATE" runat="server" Text='<%$ Resources:Resource,L_CLAIMDATE %>' ></asp:Label>
               </td>
               <td class ="DataEntry" style="width:800px;">
               <asp:TextBox ID="txtClaimDate" runat="server" Size="10" maxlength="10" Width="130px" ReadOnly="true" ></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtClaimDate" ErrorMessage="*" SetFocusOnError="True" 
                    ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\d\d$" 
                    ValidationGroup="check" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator4" 
                       runat="server" ErrorMessage="*" ControlToValidate="txtClaimDate" 
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
              <%-- <asp:Button ID="btnClaimDate" runat="server" Height="15px" padding-bottom="3px" 
                        Width="15px" class="btnDate"/>
                    <ajax:CalendarExtender ID="txtClaimDateCalendarExtender" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnClaimDate" TargetControlID="txtClaimDate">
                    </ajax:CalendarExtender>      --%>              
               </td> 
             <td class="FormLabel">
                   <asp:Label ID="lblRemBalance" runat="server" Text="Remaining Balance" ></asp:Label>
               </td>
               <td class ="DataEntry">
               <%--<asp:TextBox ID="txtICDCode" size="10" runat="server" MaxLength="6"></asp:TextBox>--%>
                    <asp:textbox ID="txtRemainingBalance" runat="server" Text="" BorderStyle="Solid" style="text-align:right" Enabled ="false"></asp:textbox>
               </td>
            
                           
             
                <td class="FormLabel">
                   <asp:Label ID="lblCLAIMTOTAL" runat="server" style="width:600px;" Text='<%$ Resources:Resource,L_CLAIMTOTAL %>' ></asp:Label>
               </td>
               <td class ="DataEntry">
                   <asp:textbox ID="txtCLAIMTOTALData" runat="server" Text="" BorderStyle="Solid" style="text-align:right" Enabled ="false" Width="135px" ></asp:textbox>
                   <ajax:MaskedEditExtender ID="txtAdultPremium_MaskedEditExtender" runat="server" 
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="TZS" 
                                CultureDateFormat="" CultureDatePlaceholder="" 
                                CultureThousandsPlaceholder="," CultureTimePlaceholder="" Enabled="True" 
                                Mask="999,999,999.99" MaskType="Number" TargetControlID="txtCLAIMTOTALData" 
                                InputDirection="RightToLeft" PromptCharacter=" ">
                            </ajax:MaskedEditExtender>
               </td>
            </tr>  
              <tr>
                  <td class="FormLabel">
                      <asp:Label ID="lblICD" runat="server" Text="<%$ Resources:Resource,L_ICD %>"  ></asp:Label>
                  </td>
                  <td class="DataEntry">                   
                   <%-- 
                      <asp:TextBox ID="txtICDCode0" runat="server" MaxLength="8" width="125px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="txtICDCode0"
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                       --%>
                       <asp:DropDownList ID="ddlICDData" runat="server" width="130px" Visible="False"></asp:DropDownList>
                     
                    <asp:TextBox ID="txtICDCode0" runat="server" MaxLength="12" Size="11"  width="125px"  class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator3" 
                       runat="server" ErrorMessage="*" ControlToValidate="txtICDCode0"
                       ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator> 
                  </td>
                  <td class="FormLabel">
                     <%--  <asp:Label ID="lblICD2" runat="server" Text="<%$ Resources:Resource,L_SECONDARYDG2 %>"></asp:Label> 
                       <asp:Label ID="lblICD1" runat="server" Text="<%$ Resources:Resource,L_SECONDARYDG1 %>"></asp:Label> --%>
                      <asp:Label ID="lblICD1" runat="server" Text="<%$ Resources:Resource,L_SECONDARYDG1 %>"  ></asp:Label>  
                  </td>
                  <td class="DataEntry">
                   <%--     <asp:TextBox ID="txtICDCode2" runat="server" MaxLength="8"   width="135px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                      <asp:TextBox ID="txtICDCode2" runat="server" MaxLength="8"   width="135px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                      <asp:DropDownList ID="ddlICDData2" runat="server" width="135px" Visible="false">
                      </asp:DropDownList> --%>
                      <asp:TextBox ID="txtICDCode1" runat="server" MaxLength="8"  width="135px"  class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                      <asp:DropDownList ID="ddlICDData1" runat="server" width="135px" Visible="false">
                      </asp:DropDownList>
                  </td>
                  <td class="FormLabel">
                      <%-- <asp:Label ID="lblICD3" runat="server" Text="<%$ Resources:Resource,L_SECONDARYDG3 %>"></asp:Label> --%>
                      <asp:Label ID="lblExpiryDate" runat="server" Text="Expiry Date"></asp:Label>
                  </td>
                  <td class="DataEntry">
                    <%--  <asp:TextBox ID="txtICDCode3" runat="server" MaxLength="8"   width="135px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="txtICDCode3" runat="server" MaxLength="8"   width="135px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                      <asp:DropDownList ID="ddlICDData3" runat="server" width="135px" Visible="false">
                      </asp:DropDownList> --%>
                      <asp:textbox ID="txtExpiry" runat="server" Text="" BorderStyle="Solid" style="text-align:right" Enabled ="false"></asp:textbox>
                  </td>
                  <td class="FormLabel">
                   <%--    <asp:Label ID="lblICD4" runat="server" Text="<%$ Resources:Resource,L_SECONDARYDG4 %>"></asp:Label> --%>
                       <asp:Label ID="lblServiceTotal" runat="server" Text="Service Total"></asp:Label>
                  </td>
                  <td class="DataEntry">
                  <%--     <asp:TextBox ID="txtICDCode4" runat="server" MaxLength="8"   width="135px" class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                      <asp:DropDownList ID="ddlICDData4" runat="server" width="135px" Visible="false"> 
                      </asp:DropDownList> --%>
                      <asp:textbox ID="txtServTotal" runat="server" Text="" BorderStyle="Solid" style="text-align:right" Enabled ="false" Width="135px"></asp:textbox>
                  </td>
              </tr>
              <tr>
                  <td class="FormLabel" style="width:400px;">
                      <asp:Label ID="lblClaimAdminCode" runat="server" 
                          Text="<%$ Resources:Resource,L_CLAIMADMIN%>"></asp:Label>
                  </td>
                  <td class="DataEntry">
                      <asp:TextBox ID="txtClaimAdminCode" runat="server" Enabled="false" 
                          width="135px"></asp:TextBox>
                      
                  </td>
                  <td class="FormLabel" style="width:400px;">
                   <%-- <asp:Label ID="lblGurantee" runat="server" 
                          Text="<%$ Resources:Resource,L_GUARANTEE %>"></asp:Label> --%>   
                       <asp:Label ID="lblVisitType" runat="server" Text="<%$ Resources:Resource,L_VISITTYPE %>"></asp:Label>                      
                  </td>
                  <td class="DataEntry">
                      <asp:DropDownList ID="ddlVisitType" runat="server" Width="135px" AutoPostBack="true">
                    </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                        ControlToValidate="ddlVisitType" ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                      
                  </td>
                  <td class="FormLabel">
                      <asp:Label ID="lblOPDIPD" runat="server" Text="OPD/IPD"></asp:Label>
                  <td class="DataEntry">                     
                      <asp:DropDownList ID="ddlOPDIPD" runat="server" Width="120px" AutoPostBack="true">
                         <asp:ListItem Selected="True" Value="0" Text="Select"></asp:ListItem>                         
                         <asp:ListItem Text="OPD" Value="O"></asp:ListItem>                       
                         <asp:ListItem Text="IPD" Value="I"></asp:ListItem>
                    </asp:DropDownList>
                           <asp:RequiredFieldValidator ID="rfddlOPDIPD" runat="server"
                        ControlToValidate="ddlOPDIPD" ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
           
                      </td>
                 
                  <td class="FormLabel" style="width:400px;">
                     <asp:Label ID="lblItemTotal" runat="server" Text="Item Total"></asp:Label></td></td>
                  <td class="DataEntry">
                      <asp:textbox ID="txtItemTotal" runat="server" Text="" BorderStyle="Solid" style="text-align:right" Enabled ="false" Width="135px"></asp:textbox>
                  </td>
                  <td class="FormLabel">
                      &nbsp;</td>
                  <td class="DataEntry">
                      &nbsp;</td>
              </tr>
                <tr>
                 <td class="FormLabel">                   
                      <asp:Label ID="lblGurantee" runat="server" 
                          Text="<%$ Resources:Resource,L_GUARANTEE %>"></asp:Label>
                  </td>
                  <td class="DataEntry">
                     
                         <asp:TextBox ID="txtGuaranteeId" runat="server" width="125px" 
                          MaxLength="50"></asp:TextBox>                  
                       <asp:RequiredFieldValidator ID="rfGuranteeiD" runat="server" ErrorMessage="*" ControlToValidate="txtGuaranteeId" Visible="true" ForeColor="Red" Display="Dynamic" ValidationGroup="check"></asp:RequiredFieldValidator>
                    
                        
                  </td>
                    <td class="FormLabel"><asp:CheckBox ID="chkRefering" Text="Refer To" runat="server" AutoPostBack="true" /></td>
                    <td class="DataEntry">
                        <asp:DropDownList runat="server" ID="ddlRefer"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfddlRefer" runat="server" ErrorMessage="*"
                        ControlToValidate="ddlRefer" ValidationGroup="check" Visible="True" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </td>
                </tr>
          </table>
          <div>
            <h2>
                <!-- <input type="button" value="fetch"> -->
                CopayPercent:<span id="idCopayPercent"  onclick="fetchCopayDetails()">0.1</span>
                Reason:<span id="idCopayReason">Normal</span>
                HibPay:<span id="idAdjustedAmount">0</span>
                <img src="/copayerr.trigger.png" style="display:none;" onerror="fetchCopayDetails()" />
            </h2>
          </div>
                    </asp:Panel>
                    <table class="catlabel" style="height: 10px !important;">
                        <tr>
                            <td>
                                <asp:Label ID="lblServiceDetails" runat="server" Text='<%$ Resources:Resource,L_SERVICES %>'></asp:Label>
                            </td>
                            <td align="right" style="padding-left: 10px; vertical-align: bottom">
                                <%--                   <asp:ImageButton OnClientClick=" return function(){return false;}" class="ImageButton addRowButton" ImageUrl="~/Images/Add.gif" ID="imgBtnAddService" runat="server" ></asp:ImageButton>
--%>
                                <asp:TextBox ID="txtAddServiceRows" runat="server" MaxLength="2" Width="20px" Style="text-align: right"
                                    CssClass="numbersOnly" AutoPostBack="true"></asp:TextBox>
                            </td>
                            <td>
                                <%--<asp:ImageButton ImageUrl="~/Images/Erase.png" ID="imgBtnDelService" 
                    runat="server" CssClass="ImageButton" OnClientClick="setCaller(this);return showmodalPopup();"> </asp:ImageButton>--%>
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="pnlServiceDetails" runat="server" CssClass="panel" Height="140" ScrollBars="Vertical">
                        <asp:GridView ID="gvService" runat="server" AutoGenerateColumns="False" CssClass="mGrid"
                            DataKeyNames="ServiceID,ServCode,PriceAsked,ClaimServiceId,QtyProvided,Explanation"
                            EmptyDataText='<%$ Resources:Resource, M_NOSERVICES %>' GridLines="None" PagerStyle-CssClass="pgr"
                            ShowSelectButton="True">
                            <Columns>
                                <asp:TemplateField ItemStyle-Width="160px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtServiceCode" runat="server" Width="100%" Text='<%# Bind("ServCode") %>'
                                            class="cmb txtServiceCode" autocomplete="off" TagServiceID=""></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblServiceCode" runat="server" Text='<%$ Resources:Resource, L_SERVICECODE %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="70px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtQuantityS" runat="server" MaxLength="20" Style="text-align: right;
                                            padding-right: 2px" Width="100%" Text='<%# Bind("QtyProvided") %>' class="cmb numbersOnly ClaimQty"></asp:TextBox>
                                        <%--<asp:RegularExpressionValidator ID="ValidateQty" ControlToValidate="txtQuantityS" runat="server" SetFocusOnError="true" 
                                Text="*" ValidationGroup="check" ValidationExpression="^[0-9]*[\.\d]*"></asp:RegularExpressionValidator>--%>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblQuantityS" runat="server" Text='<%$ Resources:Resource,L_QUANTITY %>' ></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="100px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtValue" runat="server" MaxLength="20" Style="text-align: right;
                                            padding-right: 2px" Width="100%" Text='<%# Bind("PriceAsked") %>' class="cmb ClaimValue numbersOnly"></asp:TextBox>
                                        <%--<asp:RegularExpressionValidator ID="ValidateValue" ControlToValidate="txtValue" runat="server" SetFocusOnError="true" 
                                Text="*" ValidationGroup="check" ValidationExpression="^[0-9]*[\.,\d]*"></asp:RegularExpressionValidator>--%>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblValue" runat="server" Text='<%$ Resources:Resource,L_PRICE %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <input type="text" class="txtCopay" disabled style="width:20%"/>
                                        <asp:TextBox ID="txtExplanationService" runat="server" Width="77%" Text='<%# Bind("Explanation") %>'
                                            class="cmb"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        Paid By HiB|<asp:Label ID="lblExplanationService" runat="server" Text='<%$ Resources:Resource,L_EXPLANATION %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="lblJustificationService" Width="100%" BackColor="#f7f7e9" ReadOnly="true" runat="server" Text='<%# Bind("Justification") %>'></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lvlJustificationHead" runat="server" Text='<%$ Resources:Resource,L_JUSTIFICATION%>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="20px">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton ImageUrl="~/Images/Erase.png" ID="btnDeleteService"
                    runat="server" CssClass="ImageButton"  OnClientClick="setCaller('service');return showmodalPopup();"> </asp:ImageButton>--%>
                                        <a href="#" id='<%# Eval("ClaimServiceID") %>' class="delButton DeleteCross">
                                            <img border="0" src="Images/Erase.png" alt="Delete" /></a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                            <AlternatingRowStyle CssClass="alt" />
                            <SelectedRowStyle CssClass="srs" />
                        </asp:GridView>
                    </asp:Panel>
                    <table class="catlabel">
                        <tr>
                            <td class="auto-style1">
                                <asp:Label ID="lblItems" runat="server" Text='<%$ Resources:Resource,L_ITEMS %>'></asp:Label>
                            </td>
                            <td align="right" style="padding-left: 10px; vertical-align: bottom" class="auto-style1">
                                <%--<asp:ImageButton  class="ImageButton addRowButton" ImageUrl="~/Images/Add.gif" 
                     ID="imgBtnAddItem" runat="server" Height="16px" Width="16px"></asp:ImageButton>--%>
                                <asp:TextBox ID="txtAddItemRows" runat="server" MaxLength="2" Width="20px" Style="text-align: right"
                                    CssClass="numbersOnly" AutoPostBack="true"></asp:TextBox>
                            </td>
                            <td class="auto-style1">
                                <%--<asp:ImageButton ImageUrl="~/Images/Erase.png" ID="imgBtnDelItem" 
                    runat="server" CssClass="ImageButton" OnClientClick="setCaller(this);return showmodalPopup();"> </asp:ImageButton>--%>
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="pnlItemsDetails" runat="server" CssClass="panel" Height="140" ScrollBars="Vertical">
                        <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="mGrid"
                            DataKeyNames="ItemID,ItemCode,PriceAsked,ClaimItemId,QtyProvided,Explanation"
                            EmptyDataText='<%$ Resources:Resource, M_NOITEMS %>' GridLines="None" PagerStyle-CssClass="pgr"
                            ShowSelectButton="True">
                            <Columns>
                                <asp:TemplateField HeaderStyle-Width="160px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtItemCode" runat="server" Width="100%" Text='<%# Bind("ItemCode") %>'
                                            class="cmb txtItemCode" autocomplete="off"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblItemCode" runat="server" Text='<%$ Resources:Resource, L_ITEMCODE %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="70px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtQuantityI" runat="server" Width="100%" MaxLength="20" Style="text-align: right;
                                            padding-right: 2px" Text='<%# Bind("QtyProvided") %>' class="cmb numbersOnly ClaimQty"></asp:TextBox>
                                        <%--<asp:RegularExpressionValidator ID="ValidateQtyItem" ControlToValidate="txtQuantityI" runat="server" SetFocusOnError="true" 
                                Text="*" ValidationGroup="check" ValidationExpression="^[0-9]*[\.\d]*"></asp:RegularExpressionValidator>--%>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblQuantityI" runat="server" Text='<%$ Resources:Resource,L_QUANTITY %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="100px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtValueI" runat="server" Width="100%" MaxLength="20" Style="text-align: right;
                                            padding-right: 2px" Text='<%# Bind("PriceAsked") %>' class="cmb ClaimValue numbersOnly"></asp:TextBox>
                                        <%-- <asp:RegularExpressionValidator ID="ValidateValueItem" ControlToValidate="txtValueI" runat="server" SetFocusOnError="true" 
                                Text="*" ValidationGroup="check" ValidationExpression="^[0-9]*[\.,\d]*"></asp:RegularExpressionValidator>--%>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:Label ID="lblValueI" runat="server" Text='<%$ Resources:Resource,L_PRICE %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <input type="text" class="txtCopay" disabled style="width:20%"/>
                                        <asp:TextBox ID="txtExplanationItem" runat="server" Width="77%" Text='<%# Bind("Explanation") %>'
                                            class="cmb"></asp:TextBox>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        Paid By HiB|<asp:Label ID="lblExplanationItem" runat="server" Text='<%$ Resources:Resource,L_EXPLANATION %>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="lblJustificationItem" BackColor="#f7f7e9" runat="server" Width="100%" ReadOnly="true" Text='<%# Bind("Justification") %>'></asp:TextBox>
                                    </ItemTemplate>
                                     <HeaderTemplate>
                                        <asp:Label ID="lvlJustificationHead" runat="server" Text='<%$ Resources:Resource,L_JUSTIFICATION%>'></asp:Label>
                                    </HeaderTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="20px">
                                    <ItemTemplate>
                                        <%--<asp:ImageButton  ImageUrl="~/Images/Erase.png" ID="btnDeleteItem"
                    runat="server"  class="ImageButton deleteRowButton" OnClientClick="setCaller('item');return showmodalPopup();"> </asp:ImageButton>--%>
                                        <a href="#" id='<%# Eval("ClaimItemId") %>' class="delButton DeleteCross">
                                            <img border="0" src="Images/Erase.png" alt="Delete" />
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pgr" />
                            <AlternatingRowStyle CssClass="alt" />
                            <SelectedRowStyle CssClass="srs" />
                        </asp:GridView>
                    </asp:Panel>
                    <table>
                        <tr>
                            <td class="FormLabel" style="text-align: left">
                                <asp:Label ID="lblEXPLANATION" runat="server" Text='<%$ Resources:Resource,L_EXPLANATION %>'></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtEXPLANATION" runat="server" Width="450px" Text=""></asp:TextBox>
                            </td>
                            <td class="FormLabel" style="text-align: left">
                                <asp:Label ID="lblJUSTIFICATION" runat="server" Text='<%$ Resources:Resource,L_ADJUSTMENT %>'></asp:Label>
                            </td>
                            <td class="DataEntry">
                                <asp:TextBox ID="txtJUSTIFICATION" runat="server" ReadOnly="true" Width="400px" Text=""></asp:TextBox>
                            </td>
                        </tr>
                        <caption>
                            <tr>
                                <td colspan="4" style="color:red;"><asp:Literal runat="server" Text="<%$ Resources:Resource,X_CLAIM_NOTICE%>" />  <asp:DynamicHyperLink id="lnkUploadDocument" runat="server" target="_blank" Text="Upload Documents"></asp:DynamicHyperLink></td>
                            </tr>
                        </caption>
                    </table>
                     </ContentTemplate> </asp:UpdatePanel>
                     </asp:Panel>
    </div>
    <asp:Panel ID="pnlButtons" runat="server" CssClass="panelbuttons">
        <table width="100%" cellpadding="10 10 10 10" align="center">
            <tr align="center">
                <td align="left">
                    <asp:Button ID="B_SAVE" runat="server" Text='<%$ Resources:Resource,B_SAVE%>' ValidationGroup="check" />
                </td>
                <td align="center">
                    <asp:Button ID="B_ADD" runat="server" Text='<%$ Resources:Resource,B_ADD%>' />
                </td>
                   <td align="right" id="td1" runat="server" visible="false">
                    <asp:Button ID="btnRestore" runat="server" Text='<%$ Resources:Resource,B_RESTORE%>' Visible="false" />
                </td>
                <td align="right" id="tdPrintW" runat="server" visible="false">
                    <asp:Button ID="btnPrint" runat="server" Text='<%$ Resources:Resource,B_PRINT%>' />
                </td>
              
                <td align="right">
                    <asp:Button ID="B_CANCEL" runat="server" Text='<%$ Resources:Resource,B_CANCEL%>' />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:HiddenField ID="hfHFID" runat="server" />
    <asp:HiddenField ID="hfClaimID" runat="server" />
    <asp:HiddenField ID="hfBatchId" runat="server" />
    <asp:HiddenField ID="hfClaimTotalValue" runat="server" />
    <asp:HiddenField ID="hfCaller" runat="server" />
    <asp:UpdatePanel ID="upHF" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hfInsureeId" runat="server" />
            <asp:HiddenField ID="hfPrevServiceRows" runat="server" />
            <asp:HiddenField ID="hfPrevItemRows" runat="server" />
            <asp:HiddenField ID="hfInitialCLMTotalValue" runat="server" />
            <asp:HiddenField ID="hfClaimAdminId" runat="server" Value="0" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hfClaimItemID" runat="server" />
    <asp:HiddenField ID="hfClaimServiceID" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Footer" runat="Server" Visible="true">
    <asp:ValidationSummary ID="validationSummary" runat="server" HeaderText='<%$ Resources:Resource,V_SUMMARY%>'  />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Label Text="" runat="server" ID="lblMsg" > </asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="HiddenContainer" runat="Server">
    <%--style="display:none;position:absolute;" --%>
    <asp:Panel ID="pnlHiddenServiceCodes" class="pnlHiddenServiceCodes" runat="server">
        <asp:Panel ID="Panel2" class="innerPanel" runat="server" Height="130px" ScrollBars="Vertical">
            <asp:GridView ID="gvHiddenServiceCodes" runat="server" AutoGenerateColumns="false"
                GridLines="None" PagerStyle-CssClass="pgr" ShowSelectButton="false" DataKeyNames="ServiceID,ServCode">
                <Columns>
                    <%--<asp:BoundField DataField="ServiceID" HeaderText=''></asp:BoundField >--%>
                    <asp:BoundField DataField="ServCode" HeaderText='<%$ Resources:Resource,L_SERVICECODE%>'>
                    </asp:BoundField>
                    <asp:BoundField DataField="ServName" HeaderText='<%$ Resources:Resource,L_NAME%>'>
                    </asp:BoundField>
                    <asp:BoundField DataField="Price" HeaderText='<%$ Resources:Resource,L_PRICE%>'>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </asp:Panel>
        <a href="javascript:void" class="hiddenPanelCloseButton">cancel</a></asp:Panel>
    <asp:Panel ID="pnlHiddenItemCodes" class="pnlHiddenItemCodes" runat="server">
        <asp:Panel ID="Panel1" class="innerPanel" runat="server" Height="130px" ScrollBars="Vertical">
            <asp:GridView ID="gvHiddenItemCodes" runat="server" AutoGenerateColumns="false" DataKeyNames="ItemID,ItemCode"
                GridLines="None" PagerStyle-CssClass="pgr" ShowSelectButton="false">
                <Columns>
                    <%-- <asp:BoundField DataField="ItemID" HeaderText='' ></asp:BoundField >--%>
                    <asp:BoundField DataField="ItemCode" HeaderText='<%$ Resources:Resource,L_ITEMCODE%>'>
                    </asp:BoundField>
                    <asp:BoundField DataField="ItemName" HeaderText='<%$ Resources:Resource,L_NAME%>'>
                    </asp:BoundField>
                    <asp:BoundField DataField="price" HeaderText='<%$ Resources:Resource,L_PRICE%>'>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </asp:Panel>
        <a href="javascript:void" class="hiddenPanelCloseButton">cancel</a></asp:Panel>


    </asp:Content>