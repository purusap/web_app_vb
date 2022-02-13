<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" CodeBehind="ClaimOverviewSampling.aspx.vb" Inherits="IMIS.ClaimOverviewSampling" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajax" %>

<asp:Content ID="content4" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
#popup-div table
{
    margin:auto;
}
        #popup-div table tr > td
        {
           text-align:right
            }
  #popup-div-body table
{
    margin:auto;
        }
        #popup-div-body table tr > td
        {
           text-align:right
            }

</style>
<script type="text/javascript">
        DEFAULT_REVIEW_RANDOM = "5";
        DEFAULT_REVIEW_VALUE = "40000";
        DEFAULT_REVIEW_VARIANCE = "50";

 var ClaimStatus;
 var clearflag = false;
 
 /** Ruzo Grid Row Selection 29 Aug 2014 >> Start **/
 function bindRowSelection() {
         var $trs = $('#<%=gvClaims.ClientID%> tr')
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
     }
    function fillSelectedRowData($row) {
        //var claimId = $row.find("td").eq(9).html();
        var claimId = $row.find("td").eq(10).html();
        $("#<%=hfClaimID.ClientID%>").val(claimId);
    }
    /** Ruzo Grid Row Selection 29 Aug 2014 >> End **/

 function toggleCheck(target) {
     if (target.checked) {
         $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function(i) {
             $row = $(this); // current selected row reference.
             $cell7 = $row.find("td").eq(8); //   cell7 in the current row.
             $cell8 = $row.find("td").eq(9); //   cell8 in the current row.
             $cell3 = $row.find("td").eq(4); //   cell3 in the current row.
             $cell4 = $row.find("td").eq(5); //   cell4 in the current row.
             ClaimStatus = $.trim($cell7.html()).replace("&nbsp;", "");
             var $checkbx = $cell8.find("input[type=checkbox]").eq(0);
             var $ddlFeedbackStatus = $cell3.find("Select").eq(0);
             var $ddlReviewStatus = $cell4.find("Select").eq(0);
             var FeedbackStatus = $ddlFeedbackStatus.val();
             var ReviewStatus = $ddlReviewStatus.val();
             if (ClaimStatus == '<%=imisgen.getMessage("T_CHECKED", True)%>' && FeedbackStatus != 1 && ReviewStatus != 1) {
                 $checkbx.attr("checked", true);
                 $('.ConditionCheck').trigger("change");
             }
         });
          } else {
     $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function(i) {
         $row = $(this); // current selected row reference.
         $cell7 = $row.find("td").eq(8); //   cell7 in the current row.
         $cell8 = $row.find("td").eq(9); //   cell8 in the current row.
         $cell3 = $row.find("td").eq(4); //   cell3 in the current row.
         $cell4 = $row.find("td").eq(5); //   cell4 in the current row.
         ClaimStatus = $.trim($cell7.html()).replace("&nbsp;", "");
         var $checkbx = $cell8.find("input[type=checkbox]").eq(0);
         var $ddlFeedbackStatus = $cell3.find("Select").eq(0);
         var $ddlReviewStatus = $cell4.find("Select").eq(0);
         
         var FeedbackStatus = $ddlFeedbackStatus.val();
         var ReviewStatus = $ddlReviewStatus.val();
         if (ClaimStatus == '<%=imisgen.getMessage("T_CHECKED", True)%>' && FeedbackStatus != 1 && ReviewStatus != 1) {
             $checkbx.attr("checked", false);
             $('.ConditionCheck').trigger("change");
         }
     });
    
     }

    }

// ICDCode AutoComplete TextBox Control Start
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
        $("#<%=txtICDCode.ClientID %>").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: 'AutoCompleteHandlers/AutoCompleteHandler.ashx',
                    // data: JSON.stringify({ prefix: request.term }),
                    data: { ICDCode: $("#<%=txtICDCode.ClientID %>").val() },

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
                $('#<% = hfICDID.ClientID%>').val(u.item.id);

            },
            minLength: 1
        });
    }

 $(document).ready(function() {
    
    if( $("#<%=hfSelectionExecute.ClientID %>").val() == ""){
        $("#<%=hfSelectionExecute.ClientID %>").val(0);
    }
     if ($("#<%=hfProcessClaims.ClientID %>").val() == "") {
         $("#<%=hfProcessClaims.ClientID %>").val(0);
     }
     
     var flagSelectedRow = false;

     $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function(i) {
         if ($(this).find("td").eq(9).html() == $("#<%=hfClaimID.ClientID %>").val()) {
             //ChangeClass($(this).attr("id"), i, true);
             var yposTR = $(this).offset().top;
             var ypos = $('#<%=gvClaims.ClientID  %>').offset().top;
             $('#<%=gvClaims.ClientID  %>').parent().parent().scrollTop(yposTR - ypos - 200);
             flagSelectedRow = true;
             return false;
         }
     });

 });
 function SelectionUpdateCriteria() {
         if ($("#<%=chkRandom.ClientID %>").is(":checked")) {
             $("#<%=chkValue.ClientID %>").attr("disabled", true);
             $("#<%=chkVariance.ClientID %>").attr("disabled", true);
         } else {
             $("#<%=chkValue.ClientID %>").attr("disabled", false);
             $("#<%=chkVariance.ClientID %>").attr("disabled", false);
                 }
         if ($("#<%=chkValue.ClientID %>").is(":checked") || $("#<%=chkVariance.ClientID %>").is(":checked")) {
             $("#<%=chkRandom.ClientID %>").attr("disabled", true);
         } else {
            $("#<%=chkRandom.ClientID %>").attr("disabled", false);
         }
     }
     function ClaimCriteriaDetails() {
         var $ddlSelect = document.getElementById('<%=ddlSelectionType.ClientID %>');
         if ($ddlSelect.options[$ddlSelect.selectedIndex].value == 0) {
             EmptyAndDisableCriteria();
         } else {
             $("#<%=chkRandom.ClientID %>").attr("disabled", false);
             $("#<%=chkValue.ClientID %>").attr("disabled", false);
             $("#<%=chkVariance.ClientID %>").attr("disabled", false);
         }
     }

     function EmptyAndDisableCriteria() {
         $("#<%=chkRandom.ClientID %>").attr("checked", false);
         $("#<%=chkValue.ClientID %>").attr("checked", false);
         $("#<%=chkVariance.ClientID %>").attr("checked", false);
         $("#<%=chkRandom.ClientID %>").attr("disabled", true);
         $("#<%=chkValue.ClientID %>").attr("disabled", true);
         $("#<%=chkVariance.ClientID %>").attr("disabled", true);
         $("#<%=txtVariance.ClientID %>").val("");
         $("#<%=txtValue.ClientID %>").val("");
         $("#<%=txtRandom.ClientID %>").val("");
     }

     function ProcessClaimStatusFn(btn) {
         if (btn == "ok") {
             __doPostBack('<%=B_ProcessClaimStatus.ClientID %>', "");
         } else if (btn == "cancel") {
         return false;
         } 
     }

    function pageLoadExtend() {

        bindRowSelection();

         SelectionUpdateCriteria();
         
         showInsureePopupSearchResult();
         $('#btnCancel').click(function() {
             $('#SelectPic').hide();
         });
         if (clearflag == true) {
             $("#<%=lblMsg.ClientID %>").html("");
             clearflag = false;
         }
         if ($('#<%=gvClaims.ClientID  %> tr:not(:first)').length != 0 && $("#<%=hfClaimID.ClientID %>").val() == "") {
             //ChangeClass($('#<%=gvClaims.ClientID  %> tr:not(:first)').eq(0).attr("id"), 1, true);
            // $("#<%=lblMsg.ClientID %>").html("");
         }
         
         if ($("#<%=hfSelectionExecute.ClientID %>").val() != 0) {
             popup.acceptBTN_Text = '<%=imisgen.getMessage("L_OK", True)%>';
             popup.alert($("#<%=hfSelectionExecute.ClientID %>").val());
             $("#<%=hfSelectionExecute.ClientID %>").val("");
             
         }
         if ($("#<%=hfProcessClaims.ClientID %>").val() != 0) {
             popup.acceptBTN_Text = '<%=imisgen.getMessage("L_OK", True)%>';
             popup.alert($("#<%=hfProcessClaims.ClientID %>").val());
             $("#<%=hfProcessClaims.ClientID %>").val("");
         }
         $("#<%=B_ProcessClaimStatus.ClientID %>").click(function() {
             $("#<%=lblMsg.ClientID %>").html("");
             var flagProcessClaim = false;
             var RevBoolean = false;
             var FedBoolean = false;
             $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function() {
                 if ($(this).find("td").eq(9).find("input[type=checkbox]").is(":checked")) {
                     flagProcessClaim = true;
                     return;
                 }
             });
             var htmlMsgProcess = "";
             var htmlMsgProcess1 = "";
             var htmlMsgProcess2 = "";
             var htmlMsgProcess3 = "";
             if (flagProcessClaim == true) {
                 $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function() {
                     if ($(this).find("td").eq(9).find("input[type=checkbox]").is(":checked")) {
                         if ($(this).find("td").eq(4).find("select").data("currenctStatusFed") == 4) {
                             FedBoolean = true;
                         }
                         if ($(this).find("td").eq(5).find("select").data("currenstatusRev") == 4) {
                             RevBoolean = true;
                         }
                     }
                 });

                 if (FedBoolean == true && RevBoolean == false) {
                     htmlMsgProcess1 = '<%=imisgen.getMessage("M_ONEMORECLMFDPENDING", True)%>';
                 } else if (FedBoolean == false && RevBoolean == true) {
                 htmlMsgProcess2 = '<%=imisgen.getMessage("M_ONEMORECLMNOTREVIEWED", True)%>';
                 } else if (FedBoolean == true && RevBoolean == true) {
                 htmlMsgProcess3 = '<%=imisgen.getMessage("M_ONEMORENOTREVIEWEDFDPENDS", True)%>';
                 }
                 htmlMsgProcess = htmlMsgProcess1 + htmlMsgProcess2 + htmlMsgProcess3 + '<%=imisgen.getMessage("M_WLDLIKETOPROCESSCLAIMS", True)%>';

                 popup.acceptBTN_Text = '<%=imisgen.getMessage("L_YES", True)%>';
                 popup.rejectBTN_Text = '<%=imisgen.getMessage("L_NO", True)%>';
                 popup.confirm(htmlMsgProcess, ProcessClaimStatusFn);
                 return false;

             } else {
             $("#<%=lblMsg.ClientID %>").html('<%=imisgen.getMessage("M_NOCLMTOBEPROCESSED", True ) %>');
                 return false;
             }
         }); 
        var $ddlSelect = document.getElementById('<%=ddlSelectionType.ClientID %>');
        if ($('#<%=gvClaims.ClientID  %> tr:not(:first)').length == 0 && $ddlSelect.options[$ddlSelect.selectedIndex].value == 0) {
            EmptyAndDisableCriteria();
             $('#<%=ddlSelectionType.ClientID %>').attr("disabled", true);
         } else {

         
         if ($ddlSelect.options[$ddlSelect.selectedIndex].value != 0) {
             $("#<%=B_FEEDBACK.ClientID %>").hide();
             $("#<%=B_REVIEW.ClientID %>").hide();
             $(".ddlFeedBck").attr("disabled", true);
             $(".ddlReview").attr("disabled", true);
             $("#<%=B_ProcessClaimStatus.ClientID %>").hide();
             $("#<%=btnUpdateClaims.ClientID %>").hide();
             $(".ConditionCheck").attr("disabled", true);
             $("#<%=chkboxSelectToProcess.ClientID %>").hide();
             $("#<%=lblSelectToProcess.ClientID %>").hide();
             $('#<%=ddlSelectionType.ClientID %>').attr("disabled", false);    
         } else {
         EmptyAndDisableCriteria();
         $('#<%=ddlSelectionType.ClientID %>').attr("disabled", false);
             $("#<%=B_FEEDBACK.ClientID %>").show();
             $("#<%=B_REVIEW.ClientID %>").show();
             $(".ddlFeedBck").attr("disabled", false);
             $(".ddlReview").attr("disabled", false);
             $("#<%=B_ProcessClaimStatus.ClientID %>").show();
             $("#<%=btnUpdateClaims.ClientID %>").show();
             $(".ConditionCheck").attr("disabled", false);
             $("#<%=chkboxSelectToProcess.ClientID %>").show();
             $("#<%=lblSelectToProcess.ClientID %>").show();
         } 
         }

         $('#<%=btnSearch.ClientID %>').click(function() {
             $("#<%=hfClaimID.ClientID %>").val("");
             EmptyAndDisableCriteria();
             $('#<%=ddlSelectionType.ClientID %>').val(0);
             $('#<%=chkboxSelectToProcess.ClientID %>').attr("checked", false);
             toggleCheck($('#<%=chkboxSelectToProcess.ClientID %>'));
             //ChangeClass($('#<%=gvClaims.ClientID  %> tr:not(:first)').eq(0).attr("id"), 1);

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

	 
	
        $('.aHrefClaimId').click(function (e) { //todo: maybe unverified claims of batch first, reviewed claims to bottom
         //e.target.href=
	 	//e.preventDefault();

        console.log(e);

		var jSender = $(this);
		var href=this.href;
		console.log(href);
		var url = new URL(href);
		var search = url.search;
		console.log(search);

		var batchId=$('#<%=ddlClaimSampleBatch.ClientID %>').val();
		batchId=batchId && batchId != "0"
			? batchId 
			: $('#<%=txtClaimSampleBatchID.ClientID %>').val(); 
		//alert('todo: use onclick, not req: last / in url caused problem.==== no jquery bind, because nginx is not loading jquery on redir or bind, maybe');
            if (href.indexOf("ClaimSampleBatchId=") > -1) {
                return true;
            }
            var newHref = href + '&ClaimSampleBatchId=' + batchId;
            e.target.href = newHref;
            return true;

         if (e.ctrlKey) {
             //if ctrl key is pressed
             //window.open(newHref, '_blank').focus();//
            /* Object.assign(document.createElement('a'), {
                 target: '_blank',
                 href: href,
             }).click();*/
             var a = document.createElement("a");
             a.href = newHref;// window.location.pathname;
             var evt = document.createEvent("MouseEvents");
             //the tenth parameter of initMouseEvent sets ctrl key
             evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0,
                 true, false, false, false, 0, null);
             a.dispatchEvent(evt);
         }
         else {
             // if ctrl key is not pressed
             window.location = newHref
         }
		
		//alert('todo: redir on Review btn click on this page');
	 });
	 $(document).ready(function(){
	 	clientCalcApprovedPercent();
	 	var claimId=window.location.href.split('c=')[1].split('&')[0];
         $('#ClaimID' + claimId).attr('tabindex', -1).focus()
             .parent() //td
             .parent() //tr
             .addClass('srs');
             //.css('background', '#0080ff');
	 });
         $('#<%=btnUpdateClaims.ClientID %>').click(function() {
             $("#<%=hfClaimID.ClientID %>").val("");
         });
         $('#<%=ddlSelectionType.ClientID %>').change(function() {
             ClaimCriteriaDetails();
             clearflag = true;
         });
     $(".numbersOnly").unbind("keypress");
     $(".numbersOnly").keypress(function(event) {
         var e = String.fromCharCode(event.which);
         if (e.match('[^0-9.]')) {
             return false;
         }
     });
     $(".ddlFeedBck").each(function() {
         $(this).data("currenctStatusFed", $(this).val());
     });

     $(".ddlReview").each(function() {
         $(this).data("currenstatusRev", $(this).val());
     });

     $('.ddlFeedBck').change(function() {

         if ($(this).data("currenctStatusFed") == 1) {
             if ($(this).val() == 8 || $(this).val() == 16) {
                 $(this).val(1);
                 return;
             }
         } else if ($(this).data("currenctStatusFed") == 2) {
                 if ($(this).val() == 8 || $(this).val() == 16) {
                     $(this).val(2);
                     return;
                   }
             }else if ($(this).data("currenctStatusFed") == 4) {
                 if ($(this).val() == 8 || $(this).val() == 16) {
                     $(this).val(4);
                     return;
                   }
             }else if ($(this).data("currenctStatusFed") == 8) {
                 if ($(this).val() == 16) {
                     $(this).val(8);
                     return;
             }
         }

     });

     $('.ddlReview').change(function() {
         if ($(this).data("currenstatusRev") == 1) {
             if ($(this).val() == 8 || $(this).val() == 16) {
                 $(this).val(1);
                 return;
             }
         } else if ($(this).data("currenstatusRev") == 2) {
             if ($(this).val() == 8 || $(this).val() == 16) {
                 $(this).val(2);
                 return;
             }
         } else if ($(this).data("currenstatusRev") == 4) {
             if ($(this).val() == 8 || $(this).val() == 16) {
                 $(this).val(4);
                 return;
             }
         } else if ($(this).data("currenstatusRev") == 8) {
             if ($(this).val() == 16) {
                 $(this).val(8);
                 return;
             }

         }
     });
     
     $("#<%=B_FEEDBACK.ClientID %>").click(function() {
         var flagFeedBack = true;
        
         $('#<%=gvClaims.ClientID  %> tr').each(function(i) {
             if ($(this).is(".srs")) {                                            
                 // alert($(this).prop("tagName"));
                 var $ddlFeedbck = $(this).find("td").eq(3).find("select");
                 var SelectedVal = $ddlFeedbck.find("option").eq($ddlFeedbck[0].selectedIndex).html();
                 //alert($ddlFeedbck.find("option").eq($ddlFeedbck[0].selectedIndex).html());
                 if (!(SelectedVal == '<%= imisgen.getMessage("T_DELIVERED", True)%>' || SelectedVal == '<%= imisgen.getMessage("T_SELECTEDFORFEEDBACK", True)%>')) {
                     $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_CLAIMNOTFORFEEDBACKPROCESS", True ) %>');                   
                     flagFeedBack = false;
                 }
             }
         });
         return flagFeedBack;
     });

     $("#<%=B_REVIEW.ClientID %>").click(function() {
         var flagReview = true;
         $("#<%=hfReview.ClientID %>").val('<%= imisgen.getMessage("M_REVIEW", True)%>');
         $('#<%=gvClaims.ClientID  %> tr').each(function(i) {
             if ($(this).is(".srs")) {
                 var $ddlReview = $(this).find("td").eq(4).find("select");                 
                 var SelectedVal = $ddlReview.find("option").eq($ddlReview[0].selectedIndex).html();
                 //alert(SelectedVal);
                 //if (SelectedVal == '<%= imisgen.getMessage("T_IDLE", True ) %>') {
                     //$("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_CLAIMNOTFORREVIEWPROCESS", True ) %>');
                     //flagReview = false;
                 //} else 
                 if (SelectedVal == '<%= imisgen.getMessage("T_REVIEWED", True)%>') {
                    $("#<%=hfReview.ClientID %>").val('<%= imisgen.getMessage("T_REVIEWED", True)%>');
             } else if (SelectedVal != '<%= imisgen.getMessage("T_SELECTEDFORREVIEW", True)%>') {
                    $("#<%=hfReview.ClientID %>").val('<%= imisgen.getMessage("T_REVIEWNOT", True ) %>');
                 }
             }
         });
         return flagReview;
     });


     $("#<%=btnSelectionExecute.ClientID %>").click(function() {
         //alert("click");
         $("#<%=lblMsg.ClientID %>").html("");
         var flagUpdateSelect = true;
         var $ddlSelectType = document.getElementById("<%=ddlSelectionType.ClientID %>");
         var SelectedType = $ddlSelectType.options[$ddlSelectType.selectedIndex].value;
         //alert(SelectedType);
         if (SelectedType == 0) {
             $("#<%=lblMsg.ClientID %>").html('<%= imisgen.getMessage("M_SELECTREVIEWFEEDBACK", True)%>');
             flagUpdateSelect = false;
         } else {
             if ($('#<%=gvClaims.ClientID  %> tr:not(:first)').length == 0) {
                 // alert($('#<%=gvClaims.ClientID  %> tr:not(:first)').length);
                 return false;
             }
             var Statuslbl;
             var htmlMsg;
             var htmlMsg1;

             if (SelectedType == 1) {
                 htmlMsg = '<%= imisgen.getMessage("M_WLDLIKEREVIEWSELECTION", True)%>';

                 //For random selection
                 if ($('#<%=chkRandom.ClientID %>').is(":checked")) {
                     htmlMsg = '<%= imisgen.getMessage("M_REVIEWSELECTION", True)%>' + '<%=imisgen.getMessage("L_RANDOM", True ) %>' + ' : ' + $("#<%=txtRandom.ClientID %>").val() + '%';
                 }

                 //Value is selected and Variance is not
                 if ($('#<%=chkValue.ClientID %>').is(":checked") && $('#<%=chkVariance.ClientID %>').prop("checked") == false) {
                     htmlMsg = '<%= imisgen.getMessage("M_REVIEWSELECTION", True)%>' + '<%=imisgen.getMessage("L_VALUE", True)%>' + ' : ' + $("#<%=txtValue.ClientID %>").val();
                 }

                 //Only variance is selected
                 if ($('#<%=chkValue.ClientID %>').prop("checked") == false && $('#<%=chkVariance.ClientID %>').prop("checked") == true) {
                     htmlMsg = '<%= imisgen.getMessage("M_REVIEWSELECTION", True)%>' + '<%=imisgen.getMessage("L_VARIANCE", True)%>' + " : " + $("#<%=txtVariance.ClientID %>").val() + "%";
                 }
                 //Value and Variance both are selected
                 if ($('#<%=chkValue.ClientID %>').is(":checked") && $('#<%=chkVariance.ClientID %>').prop("checked") == true) {
                     htmlMsg = '<%= imisgen.getMessage("M_REVIEWSELECTION", True)%>' + '<%=imisgen.getMessage("L_VALUE", True)%>' + ' : ' + $("#<%=txtValue.ClientID %>").val() + "<br>" + '<%=imisgen.getMessage("L_VARIANCE", True)%>' + " : " + $("#<%=txtVariance.ClientID %>").val() + "%";
                 }

             } else {
                 htmlMsg = '<%= imisgen.getMessage("M_WLDLIKEFEEDBACKELECTION", True)%>'

                 //For random selection
                 if ($('#<%=chkRandom.ClientID %>').is(":checked")) {
                     htmlMsg = '<%= imisgen.getMessage("M_FEEDBACKSELECTION", True)%>' + '<%=imisgen.getMessage("L_RANDOM", True ) %>' + ' : ' + $("#<%=txtRandom.ClientID %>").val() + '%';
                 }

                 //Value is selected and Variance is not
                 if ($('#<%=chkValue.ClientID %>').is(":checked") && $('#<%=chkVariance.ClientID %>').prop("checked") == false) {
                     htmlMsg = '<%= imisgen.getMessage("M_FEEDBACKSELECTION", True)%>' + '<%=imisgen.getMessage("L_VALUE", True)%>' + ' : ' + $("#<%=txtValue.ClientID %>").val();
                 }

                 //Only variance is selected
                 if ($('#<%=chkValue.ClientID %>').prop("checked") == false && $('#<%=chkVariance.ClientID %>').prop("checked") == true) {
                     htmlMsg = '<%= imisgen.getMessage("M_FEEDBACKSELECTION", True)%>' + '<%=imisgen.getMessage("L_VARIANCE", True)%>' + " : " + $("#<%=txtVariance.ClientID %>").val() + "%";
                     }
                 //Value and Variance both are selected
                     if ($('#<%=chkValue.ClientID %>').is(":checked") && $('#<%=chkVariance.ClientID %>').prop("checked") == true) {
                     htmlMsg = '<%= imisgen.getMessage("M_FEEDBACKSELECTION", True)%>' + '<%=imisgen.getMessage("L_VALUE", True)%>' + ' : ' + $("#<%=txtValue.ClientID %>").val() + "<br>" + '<%=imisgen.getMessage("L_VARIANCE", True)%>' + " : " + $("#<%=txtVariance.ClientID %>").val() + "%";
                 }

             }


             popup.acceptBTN_Text = '<%=imisgen.getMessage("L_YES", True)%>';
             popup.rejectBTN_Text = '<%=imisgen.getMessage("L_NO", True ) %>';
             popup.confirm(htmlMsg, UpdateSelectTypeFN);
             return false;
         }
         return flagUpdateSelect;
     }); 

      $("#Body_Button2").click(function (e) {
            e.preventDefault();
            alert('jpt');
            //$('.cmb').change(function () {
            //    $('.cmb').val = 4;
            //})

            $('.mGrid tr').hide();
            var rand10 = [];
            var sample_percent = $('#Body_TextBox4').val()
            console.log('sa', sample_percent);
            var count = $('.mGrid tr').length
            console.log('count', count);
            var no_of_sample = sample_percent * 0.01 * count;
            console.log('no_of_sample', no_of_sample);
            for (i = 0; i < no_of_sample; i++) { rand10.push(Math.floor((Math.random() * 10000) % count)); }
            $('.mGrid tr').each(function (i, v) { if (rand10.includes(i)) { $(v).show() } });
            $('.cmb').val('4');
        });
     
     $("#<%=chkRandom.ClientID %>").change(function() {

         var $txtboxRandom = $(this).parent().next().find("input[type=text]");
         if ($(this).is(":checked")) {
             if ($txtboxRandom.prop("disabled")) {

                 $txtboxRandom.attr("disabled", false);
                 $txtboxRandom.val(DEFAULT_REVIEW_RANDOM);
                 
             }
         } else {
             $txtboxRandom.attr("disabled", true);
             $txtboxRandom.val("");
            
         }
         SelectionUpdateCriteria();
     });

     $("#<%=chkValue.ClientID %>").change(function() {
         var $txtboxValue = $(this).parent().next().find("input[type=text]");
         if ($(this).is(":checked")) {
             if ($txtboxValue.prop("disabled")) {
                 $txtboxValue.attr("disabled", false);
                 $txtboxValue.val(DEFAULT_REVIEW_VALUE);
             }
         } else {
             $txtboxValue.attr("disabled", true);
             $txtboxValue.val("");
         }
         SelectionUpdateCriteria();
     });
     if ($("#<%=chkValue.ClientID %>").is(":checked")) {
         $("#<%=chkRandom.ClientID %>").attr("disabled", true);
    }
    
     $("#<%=chkVariance.ClientID %>").change(function() {
         var $txtboxVariance = $(this).parent().next().find("input[type=text]");
         if ($(this).is(":checked")) {
             if ($txtboxVariance.prop("disabled")) {
                 $txtboxVariance.attr("disabled", false);
                 $txtboxVariance.val(DEFAULT_REVIEW_VARIANCE);
             }
         } else {
             $txtboxVariance.attr("disabled", true);
             $txtboxVariance.val("");
         }
         SelectionUpdateCriteria();
     });
    
     var $element = $('.ConditionCheck');
     $element.change(function() {
         $StatusCell = $(this).parent().prev(); //Finds the ClaimStatus boundField
         $ReviewStat = $(this).parent().prev().prev().prev().prev().find("select"); //Finds the ReviewStatus dropdownlist control
         $FeedbackStat = $(this).parent().prev().prev().prev().prev().prev().find("select"); //Finds the FeedbackStatus dropdownlist control

         if ($FeedbackStat.data("currenctStatusFed") == 1 || $ReviewStat.data("currenstatusRev") == 1 || $StatusCell.html() != '<%=imisgen.getMessage("T_CHECKED", True ) %>') {
             $(this).find("input[type=checkbox]").attr("checked", false);
         }
        
     });

     if ($('#<%=gvClaims.ClientID  %> tr:not(:first)').length != 0) {
         $('#<%=gvClaims.ClientID  %> tr:not(:first)').each(function() {
             var ClmStatus = $(this).find("td").eq(7).html();
             if (ClmStatus == '<%= imisgen.getMessage("T_VALUATED", True)%>' || ClmStatus == '<%= imisgen.getMessage("T_PROCESSED", True)%>' || ClmStatus == '<%= imisgen.getMessage("T_REJECTED", True ) %>') {
                 $(this).find("td").eq(3).find("select").prop("disabled", true);
                 $(this).find("td").eq(4).find("select").attr("disabled", true);
             }
         });
     }
 }
 function UpdateSelectTypeFN(btn) {
     if (btn == "ok") {
         __doPostBack('<%=btnSelectionExecute.ClientID %>', "");
        
     } else if (btn == "cancel") {
        
     } 
 }
</script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server">
    <asp:UpdatePanel ID="upClaimDetail" runat="server" RenderMode="Inline">
 <Triggers>
 
 <asp:PostBackTrigger ControlID="B_ProcessClaimStatus" />
 <asp:PostBackTrigger ControlID="btnSelectionExecute" />
 <%--<asp:PostBackTrigger ControlID="btnSearch" />--%>
 <asp:PostBackTrigger ControlID="btnUpdateClaims" />
 </Triggers>
 <ContentTemplate>
 
  <div class="divBody" >
        <asp:HiddenField ID="hfICDID" runat="server"/>
        <asp:HiddenField ID="hfICDCode" runat="server"/>
        
        <%--Claim Selection Criteria--%>
        <table class="catlabel">
            <tr>
                <td >
                   <asp:label  
                           ID="L_SELECTCRITERIA"  
                           runat="server" 
                           Text='<%$ Resources:Resource,L_SELECTCRITERIA %>'> </asp:label>   
                    
                </td>
            </tr>
        </table>
       
        <asp:Panel ID="pnlTop" runat="server"  CssClass="panelTop" Height="250px"  GroupingText='<%$ Resources:Resource,L_CLAIMDETAILS%>' oncontextmenu="return false;">
       <table >
            <tr>
            <td class ="FormLabel">
                     <asp:Label ID="L_REGION" runat="server" Text="<%$ Resources:Resource,L_REGION %>"></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlRegion" runat="server" AutoPostBack="true">
                     </asp:DropDownList>
                 </td>
               
                <td class ="FormLabel">
                     <asp:Label ID="lblHFName" runat="server" Text='<%$ Resources:Resource,L_HFNAME%>'></asp:Label>                    
                </td>
                <td class ="DataEntry">
                <asp:TextBox ID="txtHFName" runat="server" Text="" MaxLength="100"></asp:TextBox> 
                    
                 </td>
                <td class="FormLabel">
                     <asp:Label ID="lblVisitDateFrom" runat="server" Text='<%$ Resources:Resource,L_VISITDATEFROM%>'></asp:Label>
                </td>
                <td class ="DataEntry">
                <asp:TextBox ID="txtClaimFrom" runat="server" Text="" width="100px" CssClass="dateCheck claimPageFrom"></asp:TextBox>
                  <asp:Button ID="btnClaimFrom" runat="server"   Class="dateButton" padding-bottom="3px" 
                         />
                    <ajax:CalendarExtender ID="CalendarExtender1" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnClaimFrom" TargetControlID="txtClaimFrom">
                    </ajax:CalendarExtender>
                   
                    <asp:Label ID="lblVisitDateTo" runat="server" Text='<%$ Resources:Resource,L_TO%>' class ="FormLabel" style="margin-left:5px"></asp:Label>
                  </td>
                  <td >
                  <asp:TextBox ID="txtClaimTo" runat="server" Text="" width="100px" CssClass="dateCheck claimPageTo" ></asp:TextBox>
                  
                 <asp:Button ID="btnClaimTo" runat="server"  padding-bottom="3px" 
                        Class="dateButton" />
                    <ajax:CalendarExtender ID="txtClaimDate_CalendarExtender" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnClaimTo" TargetControlID="txtClaimTo">
                    </ajax:CalendarExtender>
                 </td>  
            </tr>
            <tr>
            <td class="FormLabel">
                   <asp:Label ID="L_District" runat="server" Text="<%$ Resources:Resource,L_DISTRICT %>"> </asp:Label>
                </td>
                <td class ="DataEntry">
                    <asp:DropDownList ID="ddlDistrict" runat="server" AutoPostBack="true">
                    </asp:DropDownList>
                    
                </td>
                <td class ="FormLabel">
                    <asp:Label ID="lblReviewStatus" runat="server" 
                        Text='<%$ Resources:Resource,L_REVIEWSTATUS%>'></asp:Label>
                </td>
                <td class="DataEntry">
                     <asp:DropDownList ID="ddlReviewStatus" runat="server" >
                     </asp:DropDownList>
                 </td>
            
                  
               <td class="FormLabel">
             <asp:Label ID="lblClaimedDateFrom" runat="server" Text='<%$ Resources:Resource,L_CLAIMDATEFROM%>'></asp:Label>

               </td>
               <td class="DataEntry">
               <asp:TextBox ID="txtClaimedDateFrom" runat="server" Text="" width="100px" CssClass="dateCheck claimPageFrom" ></asp:TextBox>
               <asp:Button ID="btnClaimedDateFrom" runat="server"  padding-bottom="3px" 
                         Class="dateButton"  />
                    <ajax:CalendarExtender ID="CalendarExtender2" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnClaimedDateFrom" TargetControlID="txtClaimedDateFrom">
                    </ajax:CalendarExtender>
                     <asp:Label ID="lblClaimedDateTo" runat="server" Text='<%$ Resources:Resource,L_TO%>' class ="FormLabel" style="margin:5px"></asp:Label>
               </td>
               <td >
                  <asp:TextBox ID="txtClaimedDateTo" runat="server" Text="" width="100px" CssClass="dateCheck claimPageTo"></asp:TextBox>
                  
                 <asp:Button ID="btnClaimedDateTo" runat="server"  Class="dateButton" padding-bottom="3px" 
                          />
                    <ajax:CalendarExtender ID="CalendarExtender3" runat="server" 
                        Format="dd/MM/yyyy" PopupButtonID="btnClaimedDateTo" TargetControlID="txtClaimedDateTo">
                    </ajax:CalendarExtender>
                 </td>
              
           </tr>
            <tr>
                  <td class ="FormLabel">
                      <asp:Label ID="lblHFCode" runat="server" Text="<%$ Resources:Resource,L_HFCODE %>"></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlHFCode" runat="server" autopostback="true">
                     </asp:DropDownList>
                 </td>
            <td class ="FormLabel">
                     <asp:Label ID="lblFBStatus" runat="server" 
                        Text='<%$ Resources:Resource,L_FBSTATUS%>'></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlFBStatus" runat="server" >
                     </asp:DropDownList>
                 </td>
             <td class ="FormLabel">
                     <asp:Label ID="lblICD" runat="server" 
                        Text='<%$ Resources:Resource,L_ICD%>'></asp:Label>
                 </td>
                 <td class="DataEntry">
                 <asp:TextBox ID="txtICDCode" runat="server" MaxLength="8"  class="cmb txtICDCode" autocomplete="off"></asp:TextBox>
                 </td>            
                  
              
                <td class="FormLabel">
                
                 </td>  
             </tr>
            <tr>
                 <td class="FormLabel">
                     <asp:Label ID="lblClaimAdmin0" runat="server" class="FormLabel" Text="<%$ Resources:Resource,L_CLAIMADMIN%>"></asp:Label>
                 </td>
                 <td class ="DataEntry">
                     <asp:DropDownList ID="ddlClaimAdmin" runat="server">
                     </asp:DropDownList>
                 </td>
                 <td class="FormLabel">
                      <asp:Label ID="lblClaimStatus" runat="server" 
                        Text='<%$ Resources:Resource,L_CLAIMSTATUS%>'></asp:Label>
                  </td>
                 <td class="DataEntry">
                    <asp:DropDownList ID="ddlClaimStatus" runat="server" >
                     </asp:DropDownList>
                </td>
                 <td class ="FormLabel">
                     <asp:Label ID="lblBatchRun" runat="server" 
                        Text='<%$ Resources:Resource,L_BATCHRUN%>'></asp:Label>
                 </td>
                 <td class="DataEntry">
                     <asp:DropDownList ID="ddlBatchRun" runat="server" >
                     </asp:DropDownList>
                 </td>                 
                 <td class="FormLabel">
                
                  <%-- <asp:Button class="button" ID="btnSearch" runat="server" 
                          Text='<%$ Resources:Resource,B_SEARCH %>' >
                    </asp:Button>--%>
                
                </td>  
             </tr>         
            <tr>
                <td class="FormLabel">
                    <asp:Label ID="lblCHFID0" runat="server" Text="<%$ Resources:Resource,L_CHFID%>"></asp:Label>
                </td>
                <td class="DataEntry">
                  <%--<asp:DropDownList ID="ddlClaimCode" runat="server" ></asp:DropDownList>--%>
                    <asp:TextBox ID="txtCHFID" runat="server" maxlength="12"></asp:TextBox>
                </td>
                <td class="FormLabel">
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource,L_CLAIMCODE%>"></asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:TextBox ID="txtClaimCode" runat="server" MaxLength="10"></asp:TextBox>
                </td>
                <td class="FormLabel">
                    <asp:Label ID="lblVisitType0" runat="server" Text="<%$ Resources:Resource,L_VISITTYPE %>"></asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:DropDownList ID="ddlVisitType" runat="server" width="150px">
                    </asp:DropDownList>
                </td>
                <td class="FormLabel">
                  
                </td>
            </tr> 
           <tr>
              <td class="FormLabel">
                    
                    <asp:Label ID="lblMinAmount" runat="server" Text="Amount"></asp:Label>
                    
                 </td>
              <td class="DataEntry">
                  <asp:TextBox ID="txtMinAmount" runat="server" MaxLength="7" Width="60px">
                  </asp:TextBox> To <asp:TextBox ID="txtMaxAmount" runat="server" MaxLength="7" Width="60px"></asp:TextBox> 

              </td>
                <td class="FormLabel">
                   <asp:Label ID="L_GENDER" runat="server" Text="<%$ Resources:Resource,L_GENDER %>">
                                </asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:DropDownList ID="ddlGender" runat="server" Width="150px">
                                </asp:DropDownList>
                </td>

                <td class="FormLabel">
                    &nbsp;</td>
               <%--<td class="DataEntry"></td>--%>
                

                <td class="FormLabel">
                    <asp:Label ID="lblAttachment" runat="server" Text="Attachment"></asp:Label>  <asp:CheckBox ID="chkAttachment" runat="server" />
                </td>
                <td class="FormLabel">
                   <asp:Button class="button" ID="btnSearch" runat="server" 
                          Text='<%$ Resources:Resource,B_SEARCH %>' >
                    </asp:Button>
                </td>
          </tr>           
            <tr>
                <td class="FormLabel">
                    <asp:Label ID="lblBatchNo0" runat="server" Text="Batch No"></asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:TextBox ID="txtClaimSampleBatchID" runat="server" MaxLength="12" Width="60px"></asp:TextBox>
                </td>
                <td class="FormLabel">&nbsp;</td>
                <td class="DataEntry">&nbsp;</td>
                <td class="FormLabel">
                    <asp:Label ID="lblBatchNo" runat="server" Text="Remain Batch"></asp:Label>
                </td>
                <td class="FormLabel">
                    <asp:DropDownList ID="ddlClaimSampleBatch" runat="server">
                    </asp:DropDownList>
                </td>
                <td class="FormLabel">&nbsp;</td>


            </tr>

            <%--<tr>
                <td class="FormLabel">
                    <asp:Label ID="Label3" runat="server" Text="Batch No"></asp:Label>
                </td>
                <td class="DataEntry">
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="12" Width="60px"></asp:TextBox>
                </td>
                <td class="FormLabel">&nbsp;</td>
                <td class="DataEntry">&nbsp;</td>
                <td class="FormLabel">
                    <asp:Label ID="Label5" runat="server" Text="Assign Batch"></asp:Label>
                </td>
                <td class="FormLabel">
                    <asp:DropDownList ID="DropDownList1" runat="server">
                    </asp:DropDownList>
                </td>
                <td class="FormLabel">&nbsp;</td>


            </tr>--%>
       </table>               
        </asp:Panel>
        <%--Claim Selection Criteria--%>
        
        <%--Claim Selection Update--%>
        <table class="catlabel" style="display:none">
            <tr>
                <td >
                   <asp:label  
                           id="l_claimselectionupdate"  
                           runat="server" 
                           text='<%$ resources:resource,l_claimselectionupdate %>'> </asp:label>                     
                </td>
                
            </tr>
        </table>
        <asp:panel id="pnlmiddle" runat="server"  cssclass="panel1" height="0px" groupingtext=''>
           <table align="center" style="display:none">
            <tr align="center">
                <td>
                   <table align="center">
         
            <tr align="center">
            <td class="dataentry">
                     <asp:dropdownlist id="ddlselectiontype" runat="server" 
                         style="text-align:center" autopostback="true">
                     </asp:dropdownlist>
                 </td>
               <td class="formlabel">
                    <asp:label id="lblrandom" runat="server" 
                        text='<%$ resources:resource,l_random%>'></asp:label>
                </td>
                <td class ="dataentry">
                    <asp:checkbox id="chkrandom" runat="server" />
                </td>
                <td class ="dataentry" style="width:150px">
                    <asp:textbox id="txtrandom" runat="server" size="3" maxlength="3"  style="text-align:right" enabled="false" cssclass="numbersonly" width ="100px"></asp:textbox>
                    <asp:label id="lblrandompercentagemark" runat="server" 
                        text='%'></asp:label>
                </td>
                <td class="formlabel">
                     <asp:label id="lblvalue" runat="server" text='<%$ resources:resource,l_value%>'></asp:label>
                </td>
                <td class ="dataentry">
                    <asp:checkbox id="chkvalue" runat="server"  />
                </td>
                <td class ="dataentry">
                    <asp:textbox id="txtvalue" runat="server" maxlength="20" size="10" style="text-align:right" 
                         cssclass="numbersonly" ></asp:textbox>
                    
                </td>
                 <td class ="formlabel">
                     <asp:label id="lblvariance" runat="server" 
                        text='<%$ resources:resource,l_variance%>'></asp:label>
                 </td>
                 <td class="dataentry">
                     <asp:checkbox id="chkvariance" runat="server" />
                 </td>
                 <td class ="dataentry" style="width:150px">
                    <asp:textbox id="txtvariance" runat="server" size="3" maxlength="3" style="text-align:right" enabled="false" cssclass="numbersonly" width="100px"></asp:textbox>
                    <asp:label id="lblvariancepercentagemark" runat="server" 
                        text='%'></asp:label>
                </td>
                
                 <td align="right">
                     <asp:button id="btnselectionexecute" runat="server" text='<%$ resources:resource,b_update%>' />
                 </td>
                <button>jpt</button>
                <td class="FormLabel">
                    <asp:DropDownList ID="DropDownList1" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            
        </table>
                </td>
            </tr>

        </table>
        </asp:panel>
        <%--Claim Selection Update--%>


        
        <%--Random Claim Sampling--%>
        <table class="catlabel">
            <tr>
                <td>       
                    <asp:Button ID="IdRandomSampleAdmin" 
                        runat="server" Text="Random Sampling" />
                    <asp:TextBox ID="RandomSamplePassword" Visible="false" Type="Password" runat="server" maxlength="12"></asp:TextBox>
                </td>
                <td align="right">
                                 <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
                            </td>
            </tr>
        </table>
        <asp:Panel ID="Panel2" runat="server"  CssClass="panel" height="60px">
            <table>
                <tr>
                    <td>
                        <table align="center">
                            <tr align="center">
                                <td class="GridHeader">
                                    <asp:Label ID="lblRandom0" runat="server" Text="Sample Percent"></asp:Label>
                                </td>
                                <td class="DataEntry">
                                    <asp:TextBox ID="txtClaimSelectSamplePercent" runat="server" maxlength="12"></asp:TextBox>
                                </td>

                                <td class="GridHeader">
                                    <asp:Label ID="Label1" runat="server" Text="Batch Total"></asp:Label>
                                </td>
                                <td class="DataEntry">
                                    <asp:TextBox ID="txtBatchTotal" runat="server" maxlength="12"></asp:TextBox>
                                </td>
                                <td>
                                <asp:DropDownList ID="ddlClaimReviewers" runat="server">
                                </asp:DropDownList>
                                </td>
                                <td class="DataEntry"> 
                                    <asp:Button ID="btnSampleSubmit" runat="server" class="button" Text="Select Batch Samples"  Width="150px" />
                                </td>
                                <td class="DataEntry">
                                    <asp:Button ID="btnSampleDoCalc" runat="server" class="button" Text="Approve Batch Amount" Width="150px" />
                                </td>
                                
                    <td class="DataEntry">
                        <asp:Button ID="btnSampleCancel" runat="server" class="button" Text="Cancel" Width="79px" />
                    </td>
                               

                            </tr>

<tr>
        
         

                                <td class="DataEntry"> 
                                    New batch samples: <asp:CheckBox ID="chkIncreaseBatchSamples" runat="server" />
                                    <asp:TextBox ID="txtClaimReSelectSamplePercent" Visible="false" runat="server" maxlength="12"></asp:TextBox>
                                </td>
        <td class="DataEntry">All Batch Claims:  <asp:CheckBox ID="chkLoadAllBatchClaims" runat="server" /> </td>
    <td><a id="viewAllBatches" href="/ClaimOverviewSamplingBatch.aspx">Batches</a> <div id="displayAllBatches"></div> </td>
        <td align="right" >
            <table align="center">
                <tr>
                    <td>
                       
                    </td>
                </tr>
                <tr>
                    <%--<td class="FormLabel">
                                <asp:Button ID="Button7" runat="server" class="button" Text="sample" />
                            </td>--%>
                    <td class="DataEntry">
                        &nbsp;</td>
                    <%--<td class="DataEntry">
                                <asp:Label ID="lblBatchNo" runat="server" Text='Batch No'></asp:Label> 
                                <asp:TextBox ID="TextBox12" runat="server" maxlength="12"></asp:TextBox>
                            </td>--%><%--<td class="DataEntry">
                                <asp:Button ID="Button9" runat="server" class="button" Text="loadbatch" />
                            </td>--%>
                </tr>
            </table>
        </td>
</tr>





                        </table>
                    </td>
                </tr>
            </table>
            
        </asp:Panel>
        <%--Random Claim Sampling--%>


        <%--Claim Selection--%>
        <table>

            <tr>
                <td>
                    <table class="catlabel" style="display:none;">
                        <tr>
                            <td>
                                
                                
                               
                               
                            </td>
                            
                        </tr>
                    </table>
                    <asp:Label ID="L_CLAIMSSELECTED" runat="server" Text="<%$ Resources:Resource,L_CLAIMSSELECTED %>"></asp:Label>
                </td>
                <td> <span id="spanBatchPercent"></span></td>
                <td> <span id="spanSampleClaimed"></span></td>
                <td> <span id="spanSampleApproved"></span></td>
                <td> <span id="spanClaimTotal"></span></td>
                <td>  <span id="spanApproveTotal"></span></td>
                <td> <span id="spanVisiblePercent"></span></td>
                <td align="right">
                    <asp:Label ID="lblSelectToProcess" runat="server" CssClass="FormLabel" style="margin-left:573px" Text="<%$ Resources:Resource,L_SELECTTOPROCESS %>"></asp:Label>
                    <asp:CheckBox ID="chkboxSelectToProcess" runat="server" onClick="toggleCheck(this);" />
                </td>
            </tr>
        </table>
        <%--Claim Selection--%>
        <script type="text/javascript">
            //alert('tero bau ko script')
            //someone is clearing the page, scripts declared above
            //after gridview is reloaded by another btnSearch press
            //
            function parseNum(strNum) { // remove comma
                if (!strNum) { return 0; }
                var val = parseFloat(strNum.replace(/,/g, '')); return val;
            }
            function clientCalcApprovedPercent() {
                console.log('f');
                var clmBatchTotal = 0;
                var aprBatchTotal = 0;
                var claimTotal = 0;
                var approveTotal = 0;
                $('#Body_gvClaims tr').each(function (idx, val) { //todo: use clientIds on this func
                    //console.log(val);
                    var tr = $(val);
                    var rvwStatus = tr.find('.ddlReview').val();
                    var stReviewed = 8;
                    var IsBatchSampleForVerifyTxt = tr.find('.IsBatchSampleForVerify').text();
                    var clm = tr.find('.Claimed').text();
                    var apr = tr.find('.Approved').text();

                    var claimValue = parseNum(clm);
                    var approveValue = parseNum(apr);
                    if (rvwStatus == stReviewed && IsBatchSampleForVerifyTxt == 'True') {
                        console.log(rvwStatus, idx, val);
                        clmBatchTotal += claimValue;
                        aprBatchTotal += approveValue;
                    }
                    claimTotal += claimValue;
                    approveTotal += approveValue;

                });

                var percent = aprBatchTotal / clmBatchTotal * 100;
                var rndPercent = Math.round(percent * 100) / 100;

                
                if (rndPercent >=0 || true) {
                    $('#spanBatchPercent').text(' Approved Amt= ' + rndPercent + '%');
                    $('#spanSampleClaimed').text(' Sample Claimed= ' + Math.round(clmBatchTotal * 100) / 100);
                    $('#spanSampleApproved').text(' Sample Approved= ' + Math.round(aprBatchTotal * 100) / 100);
                    $('#spanClaimTotal').text('Visible Claimed= ' + Math.round(claimTotal * 100) / 100);
                    $('#spanApproveTotal').text('Visible Approved= ' + Math.round(approveTotal * 100) / 100);
                    $('#spanVisiblePercent').text('Visible= ' + (Math.round(approveTotal/claimTotal * 10000) / 10000)*100  + '%');
                }
                console.log(rndPercent);
            }
        </script>
        <asp:Panel ID="pnlBody" runat="server"  CssClass="panelBody" Height="200px"  ScrollBars ="Vertical">
            <asp:GridView ID="gvClaims" runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                AllowPaging="false"
                CssClass="mGrid"
                EmptyDataText='<%$ Resources:Resource,M_NOCLAIMS %>'
                PagerStyle-CssClass="pgr"                                
                AlternatingRowStyle-CssClass="alt"
                SelectedRowStyle-CssClass="srs" PageSize="8" DataKeyNames="ClaimID,ReviewStatus,FeedbackStatus,RowID" >
                <Columns>

                    <%--<asp:HyperLinkField DataNavigateUrlFields = "ClaimID" DataTextField="ClaimCode" DataNavigateUrlFormatString = "ClaimReview.aspx?c={0}" HeaderText='<%$ Resources:Resource,L_CLAIMCODE %>' HeaderStyle-Width ="30px"> 
                    <HeaderStyle Width="30px" />
		    <ControlStyle CssClass="WhiteLink"/>
                    </asp:HyperLinkField>--%>
                    <asp:HyperLinkField DataTextField="ClaimCode" DataNavigateUrlFields="ClaimID" DataNavigateUrlFormatString = "ClaimReviewNew.aspx?c={0}&referer=/ClaimOverviewSampling.aspx"  HeaderText='<%$ Resources:Resource,L_CLAIMCODE %>' SortExpression="ClaimCode" HeaderStyle-Width="30px">  
                       <HeaderStyle Width="30px" />
		    <ControlStyle CssClass="aHrefClaimId"/>   
		    <%-- ClaimSampleBatchID = {} value of either dropdown or maybe jpt --%>
                    </asp:HyperLinkField>
                         <asp:BoundField DataField="CHFID"   HeaderText='NSHI Number' SortExpression="CHFID" HeaderStyle-Width="30px" >  
                       <HeaderStyle Width="30px" /> 
                    </asp:BoundField>                    
                     <asp:BoundField DataField="HFName"   HeaderText='<%$ Resources:Resource,L_HFNAME %>' SortExpression="HFName" HeaderStyle-Width="70px">  
                       <HeaderStyle Width="95px" />
                    </asp:BoundField>                   
                    
                   <asp:BoundField DataField="DateClaimed"  DataFormatString="{0:d}" HeaderText='<%$ Resources:Resource,L_DATECLAIMED %>' SortExpression="DateClaimed" >  
                       <HeaderStyle Width="30px" />
                    </asp:BoundField>
                   <%-- <asp:BoundField DataField="FeedbackStatus"  HeaderText='<%$ Resources:Resource,L_CLAIMFEEDBACK %>' SortExpression="Feedback" HeaderStyle-Width="70px">  
                        <HeaderStyle Width="70px" />
                    </asp:BoundField>--%>  
                        <asp:TemplateField  >
                                    <ItemTemplate >
                                        <asp:DropDownList ID="ddlClaimFeedback" runat="server" CssClass="cmb ddlFeedBck"  ></asp:DropDownList>
                                    </ItemTemplate>
                                    <HeaderTemplate >
                                     <asp:Label ID="lblClaimFeedbackStatus" runat="server" Text='<%$ Resources:Resource, L_CLAIMFEEDBACK %>' ></asp:Label> 
                                    </HeaderTemplate>
                                    <ItemStyle Width="105px" />
                     </asp:TemplateField>           
                   <asp:TemplateField  >
                                    <ItemTemplate >
                                        <asp:DropDownList ID="ddlClaimReviewStatus" runat="server" CssClass="cmb ddlReview"  ></asp:DropDownList>
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                     <asp:Label ID="lblReviewStatus" runat="server" Text='<%$ Resources:Resource, L_CLAIMREVIEW %>' ></asp:Label> 
                                    </HeaderTemplate>
                                    <ItemStyle Width="95px" />
                     </asp:TemplateField> 
                  
                    <asp:BoundField DataField="Claimed"  DataFormatString="{0:n2}" HeaderText='<%$ Resources:Resource,L_CLAIMED %>' SortExpression="Claimed"  ItemStyle-HorizontalAlign="Right">  
                         <HeaderStyle Width="20px" />
                        <ItemStyle  Width="20px" CssClass="Claimed"/>
                    </asp:BoundField>
                    <asp:BoundField DataField="Approved"  DataFormatString="{0:n2}" HeaderText='<%$ Resources:Resource,L_APPROVED %>' SortExpression="Approved" HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Right">  
                        <HeaderStyle Width="30px" />
                        <ItemStyle CssClass="Approved" HorizontalAlign="Right" Width="30px" />
                    </asp:BoundField>
                     <asp:BoundField DataField="ClaimStatus"  HeaderText='<%$ Resources:Resource,L_CLAIMSTATUS %>' SortExpression="ClaimStatus" > 
                         <HeaderStyle Width="55px" />
                    </asp:BoundField>
                    <asp:TemplateField  >
                                    <ItemTemplate >
                                    <asp:CheckBox ID="chkbgridSelectToProcess" runat="server" CssClass="ConditionCheck" /> 
                                       
                                    </ItemTemplate>
                                
                                    <ItemStyle Width="15px"  />
                     </asp:TemplateField> 
                <asp:BoundField DataField="ClaimID" > <ItemStyle CssClass="hidecol" /><HeaderStyle CssClass="hidecol"  /></asp:BoundField >
                <asp:BoundField DataField="RowID" > <ItemStyle CssClass="hidecol" /><HeaderStyle CssClass="hidecol"  /></asp:BoundField >
                    <asp:TemplateField  >
                                    <ItemTemplate >
                                   <asp:Image runat="server" CssClass="attachment" />
                                       
                                    </ItemTemplate>
                       <ItemStyle Width="15px"   />
                     </asp:TemplateField>
                    <asp:BoundField DataField="Attachment" > <ItemStyle CssClass="hidecol" /><HeaderStyle CssClass="hidecol"  /></asp:BoundField >
                    <asp:TemplateField  >
                        <ItemTemplate >
                            <asp:Label CssClass="IsBatchSampleForVerify"   runat="server" Text='<%# Eval("IsBatchSampleForVerify") %>' />,
                            <asp:Label ID="lblClaimSampleBatchID"   runat="server" Text='<%# Eval("ClaimSampleBatchID") %>' />

                            <asp:Label ID="lblClaimID"  Visible="false" runat="server" Text='<%# Eval("ClaimID") %>' />
			  
                            <div ID='ClaimID<%# Eval("ClaimID") %>' /></div>
			   
                        </ItemTemplate>
                       <ItemStyle Width="15px"   />
                        <FooterTemplate>
                            
                        </FooterTemplate>
                        <HeaderTemplate>
                            <img src="/favicon.icos" type="checkbox" onload="console.log('o callback'); clientCalcApprovedPercent()" onerror="console.log('e callaback'); clientCalcApprovedPercent()"/>                            
                        </HeaderTemplate>
                     </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="pgr" />
                <SelectedRowStyle CssClass="srs" />
                <AlternatingRowStyle CssClass="alt" />
                <RowStyle CssClass="normal" />
            </asp:GridView>
            <asp:HiddenField ID="hfDistrictID" runat="server" /> 
            <asp:HiddenField ID="hfClaimID" runat="server" /> 
            <asp:HiddenField ID="hfReview" runat="server" /> 
            <asp:HiddenField ID="hfReviewddlValue" runat="server" /> 
            <asp:HiddenField ID="hfFeedBackddlValue" runat="server" /> 
            <asp:HiddenField ID="hfSelectionExecute" runat="server" />
            <asp:HiddenField ID="hfProcessClaims" runat="server" />
            
        </asp:Panel>
        </div>
       <asp:Panel ID="pnlButtons" runat="server"   CssClass="panelbuttons" >
        <table width="100%" cellpadding="10 10 10 10" align="center">
             <tr align="center">
                    
                    <td  align="left">
                       <asp:Button 
                        ID="B_REVIEW" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_REVIEW%>'
                          />
                    </td>
                    <td  align="left">
                       <asp:Button 
                        ID="B_FEEDBACK" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_FEEDBACK%>'
                          />
                    </td>
                    <td align="center">
                       <asp:Button 
                        ID="btnUpdateClaims" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_UPDATE%>'
                         ValidationGroup="check"  />
                  
                    </td>
                    <td>
                    <asp:Button ID="B_ProcessClaimStatus" runat="server" style="color:Red; font-weight:bold" 
                         Text='<%$ Resources:Resource,B_PROCESS%>' />
                         </td>
                    <td align="right">
                          <asp:Button 
                            
                            ID="B_CANCEL" 
                            runat="server" 
                            Text='<%$ Resources:Resource,B_CANCEL%>' />
                              
                    </td>                 
                </tr>
            </table>             
        </asp:Panel> 
   </ContentTemplate> </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer" Runat="Server">
    <asp:UpdatePanel ID="uplblMsg" runat="server"><ContentTemplate>
    <asp:Label text="" runat="server" ID="lblMsg"> </asp:Label>
    </ContentTemplate></asp:UpdatePanel>
</asp:Content>

