<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master"   title='<%$ Resources:Resource,L_CLAIMREVIEWPAGETITLE%>' %>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server"> 
    <style>
        /* All CSS styles are self-contained here */
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background-color: #f4f4f9; color: #333; }
        .divBody { max-width: 900px; margin: 40px auto; }
        .panel { border: 1px solid #ddd; padding: 20px; margin: 20px 0; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .FormLabel { font-weight: bold; padding-right: 10px; }
        .DataEntry input[type="text"], .DataEntry input[type="file"], .DataEntry select { width: 250px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; }
        #btnAddPolicy { background-color: #007bff; color: white; }
        #btnAddPolicy:disabled { background-color: #6c757d; color: #ccc; cursor: not-allowed; opacity: 0.6; }
        #btnCancel { background-color: #6c757d; color: white; }
        #btnCheckEligibility { background-color: #17a2b8; color: white; margin-left: 10px; }
        legend { font-size: 1.2em; font-weight: bold; color: #0056b3; }
        .search-area { display: flex; gap: 10px; margin-bottom: 20px; }
        .results-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .results-table th, .results-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .results-table th { background-color: #343a40; color: white; }
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
        .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; border-radius: 8px; width: 80%; max-width: 600px; position: relative; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .eligibility-info { margin: 15px 0; }
        .eligibility-info .info-row { display: flex; margin: 8px 0; }
        .eligibility-info .info-label { font-weight: bold; min-width: 140px; }
        .status-active { color: #28a745; font-weight: bold; }
        .status-expired { color: #dc3545; font-weight: bold; }
        .eligibility-header { text-align: center; margin-bottom: 20px; color: #0056b3; }
    </style>
    
    <!-- Only required libraries are Font-Awesome (optional) and jQuery (required) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
    <div class="divBody">
        <div class="panel">
            <fieldset>
                <legend>Create Serious Illness Policy</legend>
                <table>
                    <tr>
                        <td class="FormLabel">Insurance No (CHFID)</td>
                        <td class="DataEntry">
                            <input type="text" id="txtInsuranceNo" maxlength="50" />
                            <button id="btnCheckEligibility">Check Eligibility Status</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="FormLabel">Select Disease</td>
                        <td class="">
                            <select id="selectDisease">
                                <option value="">-- Loading Diseases --</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="FormLabel">Upload Document</td>
                        <td class="DataEntry"><input type="file" id="fileUpload" /></td>
                    </tr>
                </table>
            </fieldset>
             <div class="panelbuttons">
                <table style="width: 100%;">
                    <tr><td align="left"><button id="btnAddPolicy" disabled>Add Policy</button></td><td align="right"><button id="btnCancel">Cancel</button></td></tr>
                </table>
            </div>
            <div id="footer"><label id="lblStatus" style="font-weight: bold;"></label></div>
        </div>

        <div id="policyListContainer">
            <div style="text-align:center; padding: 40px;">Loading policy list...</div>
        </div>
    </div>

    <!-- Eligibility Status Modal -->
    <div id="eligibilityModal" class="modal">
        <div class="modal-content">
            <span class="close">×</span>
            <h2 class="eligibility-header">Insurance Eligibility Status</h2>
            <div id="eligibilityContent"></div>
        </div>
    </div>

    <script type="text/javascript">
        // This script block contains all the necessary logic and does NOT use Select2.
        // It uses jQuery's $(document).ready() for initialization.
        
        // --- FUNCTION TO FETCH AND POPULATE DISEASE DROPDOWN ---
        function populateDiseaseDropdown() {
            var apiUrl = '/FindClaims.aspx?action=GetCriticalIllnessBenefits&json={"xml":{}}';
            var dropdown = $('#selectDisease');
            
            $.get(apiUrl, function (data) {
                dropdown.empty().append('<option value="">-- Select a Disease --</option>');
                if (data && Array.isArray(data)) {
                    $.each(data, function (index, item) {
                        var optionValue = item.disease_name_english.toUpperCase().replace(/ /g, '_');
                        var optionText = `${item.disease_name_nepali} (${item.disease_name_english})`;
                        dropdown.append($('<option>', { value: optionValue, text: optionText }));
                    });
                }
            }).fail(function() {
                console.error("Failed to load disease list.");
                dropdown.empty().append('<option value="">-- Error loading diseases --</option>');
            });
        }

        // --- FUNCTION TO CHECK IF DATE IS EXPIRED ---
        function isDateExpired(dateString) {
            if (!dateString || dateString === 'N/A') return true;
            try {
                var parts = dateString.split('/');
                if (parts.length !== 3) return true;
                var expiryDate = new Date(parts[2], parts[1] - 1, parts[0]);
                var today = new Date();
                today.setHours(0, 0, 0, 0);
                return expiryDate < today;
            } catch (e) { return true; }
        }

        // --- FUNCTION TO CHECK ELIGIBILITY STATUS ---
        function checkEligibilityStatus(chfId) {
            if (!chfId) {
                $('#lblStatus').css('color', 'red').text('Please enter Insurance No. (CHFID) first.');
                return;
            }
            var requestData = { "xml": { "CHFID": chfId } };
            var encodedJson = encodeURIComponent(JSON.stringify(requestData));
            var apiUrl = `/FindClaims.aspx?action=PolicyInquiryApi&json=${encodedJson}`;
            
            $('#lblStatus').css('color', 'orange').text('Checking eligibility...');
            $.get(apiUrl, function (response) {
                $('#lblStatus').text('');
                if (response && response.length > 0) {
                    displayEligibilityInfo(response[0]);
                } else {
                    $('#lblStatus').css('color', 'red').text('No eligibility information found for this CHFID.');
                }
            }).fail(function (xhr) {
                $('#lblStatus').css('color', 'red').text('Error checking eligibility: ' + xhr.responseText);
            });
        }

        // --- FUNCTION TO DISPLAY ELIGIBILITY INFO IN MODAL ---
        function displayEligibilityInfo(data) {
            var isExpired = isDateExpired(data.ExpiryDate);
            var isInactive = data.Status === 'निष्कृय';
            var canAddPolicy = !isExpired && !isInactive;
            
            $('#btnAddPolicy').prop('disabled', !canAddPolicy);
            
            var statusText = isInactive ? 'Expired/Inactive' : 'Active';
            var expiryText = isExpired ? ' (EXPIRED)' : ' (Valid)';
            
            var content = `
                <div class="eligibility-info">
                    <div class="info-row"><span class="info-label">CHFID:</span><span>${data.CHFID || 'N/A'}</span></div>
                    <div class="info-row"><span class="info-label">Insuree Name:</span><span>${data.InsureeName || 'N/A'}</span></div>
                    <div class="info-row"><span class="info-label">Expiry Date:</span><span class="${isExpired ? 'status-expired' : 'status-active'}">${data.ExpiryDate || 'N/A'}${expiryText}</span></div>
                    <div class="info-row"><span class="info-label">Status:</span><span class="${isInactive ? 'status-expired' : 'status-active'}">${data.Status || 'N/A'} (${statusText})</span></div>
                </div>`;
            
            if (!canAddPolicy) {
                content += `<div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px; text-align: center;"><b>Cannot create policy:</b> The insurance is inactive or expired.</div>`;
            } else {
                content += `<div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px; text-align: center;"><b>Eligible for policy creation.</b></div>`;
            }
            
            $('#eligibilityContent').html(content);
            $('#eligibilityModal').show();
        }

        // --- FUNCTION TO SEND DATA TO THE SERVER ---
        function sendPolicyDataToServer(chfId, disease, documentData_base64, fileName, mimeType) {
            var requestData = { "xml": { "CHFID": chfId, "Disease": disease, "DocumentData": documentData_base64, "FileName": fileName, "MimeType": mimeType } };
            $('#lblStatus').css('color', 'orange').text('Processing...');
            $.ajax({
                url: "/FindClaims.aspx?action=SeriousIllnessApi",
                type: "POST",
                data: { json: JSON.stringify(requestData) },
                success: function (response) {
                    if (response && response.length > 0 && response[0].Message) {
                        $('#lblStatus').css('color', response[0].Message.includes('successfully') ? 'green' : 'blue').text(response[0].Message);
                        if (response[0].Message.includes('successfully')) {
                            $('#btnCancel').click();
                            fetchPolicyList(1);
                        }
                    }
                },
                error: function (xhr) { $('#lblStatus').css('color', 'red').text('An error occurred: ' + xhr.responseText); }
            });
        }

        // --- FUNCTION TO FETCH THE POLICY LIST ---
        function fetchPolicyList(page) {
            var searchChfid = $('#policyListContainer #txtSearchChfid').val() || '';
            var requestData = { "xml": { "CHFID": searchChfid, "PageNumber": page } };
            var encodedJson = encodeURIComponent(JSON.stringify(requestData));
            var apiUrl = `/FindClaims.aspx?action=SeriousIllnessAPIList&json=${encodedJson}`;
            $.get(apiUrl, function (response) {
                if (response && response.length > 0 && response[0].HtmlFragment) {
                    $('#policyListContainer').html(response[0].HtmlFragment);
                } else {
                    $('#policyListContainer').html('<div style="text-align:center; color:red;"><b>Error:</b> Could not retrieve policy list.</div>');
                }
            }).fail(function () {
                $('#policyListContainer').html(`<div style="text-align:center; color:red;"><b>Error:</b> Could not load policy list.</div>`);
            });
        }

        // --- DOCUMENT READY AND EVENT HANDLERS ---
        $(document).ready(function () {
            // Initial Load
            populateDiseaseDropdown();
            fetchPolicyList(1);

            // Event Handlers
            $('#btnCheckEligibility').click(function (e) {
                e.preventDefault();
                checkEligibilityStatus($('#txtInsuranceNo').val().trim());
            });

            $('#btnAddPolicy').click(function (e) {
                e.preventDefault();
                var chfId = $('#txtInsuranceNo').val().trim();
                var selectedDisease = $('#selectDisease').val();
                if (!chfId || !selectedDisease) {
                    $('#lblStatus').css('color', 'red').text('Insurance No. and a selected disease are required.');
                    return;
                }
                if (!confirm('Create a new policy for CHFID: ' + chfId + '?')) return;

                var fileInput = $('#fileUpload')[0];
                if (fileInput.files.length > 0) {
                    var reader = new FileReader();
                    reader.onload = function (event) {
                        sendPolicyDataToServer(chfId, selectedDisease, event.target.result.split(',')[1], fileInput.files[0].name, fileInput.files[0].type);
                    };
                    reader.onerror = function() { $('#lblStatus').css('color', 'red').text('Error reading the file.'); };
                    reader.readAsDataURL(fileInput.files[0]);
                } else {
                    sendPolicyDataToServer(chfId, selectedDisease, null, null, null);
                }
            });

            $('#btnCancel').click(function(e) { 
                e.preventDefault(); 
                $('#txtInsuranceNo, #fileUpload, #selectDisease').val('');
                $('#lblStatus').text(''); 
                $('#btnAddPolicy').prop('disabled', true);
            });

            $('.close').click(function() { $('#eligibilityModal').hide(); });
            $(window).click(function(event) {
                if ($(event.target).is('#eligibilityModal')) $('#eligibilityModal').hide();
            });
            
            $('#policyListContainer').on('click', '#btnSearch', () => fetchPolicyList(1));
            $('#policyListContainer').on('keypress', '#txtSearchChfid', e => { if (e.which === 13) fetchPolicyList(1); });
            $('#policyListContainer').on('click', '.page-link:not(.disabled):not(.active)', function() {
                fetchPolicyList($(this).data('page'));
            });
        });
    </script>
</asp:Content>