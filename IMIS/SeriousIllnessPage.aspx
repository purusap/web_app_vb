<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" Title="Critical Illness Policy Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" runat="Server">
<style>
    /* --- RESET & LAYOUT --- */
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background-color: #f4f4f9; color: #333; }
    .divBody { max-width: 1200px; margin: 20px auto; padding: 0 15px; box-sizing: border-box; }

    /* --- TAB STYLES (Fixed Layout) --- */
    .tab-container { margin-top: 20px; }
    
    .tab-nav { 
        display: flex; 
        border-bottom: 1px solid #ccc; 
        background: transparent; 
        padding-left: 0; 
        margin-bottom: 0;
        list-style: none;
    }
    
    .tab-link { 
        background-color: #e9ecef; 
        border: 1px solid transparent; 
        border-bottom: none;
        border-radius: 6px 6px 0 0;
        cursor: pointer; 
        padding: 12px 25px; 
        margin-right: 5px;
        font-size: 16px; 
        font-weight: 600; 
        color: #495057; 
        outline: none;
        position: relative;
        bottom: -1px; /* Pushes it down to cover the line */
        transition: all 0.2s ease-in-out;
    }

    .tab-link:hover { 
        background-color: #dbe0e5; 
        color: #0056b3;
    }

    .tab-link.active { 
        background-color: #fff; 
        color: #007bff; 
        border-color: #ccc;
        border-bottom-color: #fff; /* Merges with content */
        z-index: 2;
    }

    .tab-content { 
        display: none; 
        padding: 25px; 
        border: 1px solid #ccc; 
        border-top: none; /* Top is handled by nav */
        background-color: #fff; 
        border-radius: 0 0 8px 8px; 
        box-shadow: 0 4px 6px rgba(0,0,0,0.04); 
        animation: fadeEffect 0.3s;
    }

    /* --- FORM & PANEL STYLES --- */
    .panel { /* Kept for legacy if needed */ }
    .list-panel { border: 1px solid #ddd; padding: 20px; margin: 20px 0; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    
    .FormLabel { font-weight: bold; padding-right: 15px; vertical-align: top; padding-top: 12px; width: 180px; }
    .DataEntry { padding-bottom: 10px; }
    .DataEntry input[type="text"], .DataEntry select, .doc-type-select { width: 280px; padding: 0px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    
    /* BUTTONS */
    button, .button { padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; text-align: center; }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-primary:disabled { background-color: #6c757d; cursor: not-allowed; opacity: 0.6; }
    .btn-cancel { background-color: #6c757d; color: white; }
    .btn-check { background-color: #17a2b8; color: white; margin-left: 10px; }
    .btn-add-row { background-color: #28a745; color: white; margin-top: 10px; }
    .btn-remove-doc { background-color: #dc3545; color: white; padding: 5px 10px; font-size: 12px; }
    
    legend { font-size: 1.2em; font-weight: bold; color: #0056b3; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; width: 100%; display: block;}
    
    /* TABLE STYLES */
    .results-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .results-table th { background-color: #343a40; color: white; padding: 12px; text-align: left; }
    .results-table td { padding: 12px; border: 1px solid #dee2e6; }
    .results-table tr:nth-child(even) { background-color: #f8f9fa; }
    .pagination { display: flex; justify-content: center; gap: 5px; margin-top: 15px; }
    .page-link { padding: 8px 12px; text-decoration: none; border: 1px solid #007bff; color: #007bff; border-radius: 4px; cursor: pointer; }
    .page-link.active { background-color: #007bff; color: white; }
    
    /* MODAL */
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
    .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; border-radius: 8px; width: 80%; max-width: 600px; position: relative; }
    .close { float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
    .status-active { color: #28a745; font-weight: bold; }
    .status-expired { color: #dc3545; font-weight: bold; }
    
    @keyframes fadeEffect { from {opacity: 0;} to {opacity: 1;} }
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<div class="divBody">
    
    <!-- TABS NAVIGATION (Added type="button" to prevent reload) -->
    <div class="tab-container">
        <div class="tab-nav">
            <button type="button" class="tab-link active" onclick="openTab(event, 'tab-add')">
                <i class="fa fa-plus-circle"></i> Add Policy
            </button>
            <button type="button" class="tab-link" onclick="openTab(event, 'tab-renew')">
                <i class="fa fa-sync-alt"></i> Renew Policy
            </button>
        </div>

        <!-- TAB 1: ADD POLICY -->
        <div id="tab-add" class="tab-content" style="display: block;">
            <fieldset style="border:none;">
                <legend>Create Serious Illness Policy</legend>
                <div id="welcomeMessage" style="margin-bottom:15px; font-style:italic; color:#666;"></div>
                <table style="width: 100%;">
                    <tr>
                        <td class="FormLabel">Insurance No (CHFID)</td>
                        <td class="DataEntry">
                            <input type="text" id="txtInsuranceNo" maxlength="50" class="input-chfid" data-suffix="" />
                            <button type="button" id="btnCheckEligibility" class="btn-check" data-suffix="">Check Status</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="FormLabel">Select Disease</td>
                        <td class="DataEntry">
                            <select id="selectDisease" class="disease-dropdown">
                                <option value="">-- Loading Diseases --</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="FormLabel">Add Documents</td>
                        <td class="DataEntry">
                            <table id="documentList" style="width: 100%;">
                                <tbody id="documentListBody"></tbody>
                            </table>
                            <button type="button" id="btnAddDocumentRow" class="btn-add-row" data-suffix="">+ Add Document</button>
                            <div id="fileError" style="color: red; font-size: 12px; margin-top: 5px;"></div>
                        </td>
                    </tr>
                </table>
            </fieldset>
             <div class="panelbuttons" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                <table style="width: 100%;">
                    <tr>
                        <td align="left"><button type="button" id="btnAddPolicy" class="btn-primary action-btn" data-suffix="" disabled>Add Policy</button></td>
                        <td align="right"><button type="button" id="btnCancel" class="btn-cancel cancel-btn" data-suffix="">Cancel</button></td>
                    </tr>
                </table>
            </div>
            <div id="footer"><label id="lblStatus" style="font-weight: bold; margin-top:10px; display:block;"></label></div>
        </div>

        <!-- TAB 2: RENEW POLICY -->
        <div id="tab-renew" class="tab-content">
            <fieldset style="border:none;">
                <legend>Renew Serious Illness Policy</legend>
                <div style="margin-bottom:15px; font-style:italic; color:#666;">Existing Policy Renewal</div>
                <table style="width: 100%;">
                    <tr>
                        <td class="FormLabel">Insurance No (CHFID)</td>
                        <td class="DataEntry">
                            <input type="text" id="txtInsuranceNo_renew" maxlength="50" class="input-chfid" data-suffix="_renew" />
                            <button type="button" id="btnCheckEligibility_renew" class="btn-check" data-suffix="_renew">Check Status</button>
                        </td>
                    </tr>
                    <!-- Disease Selection kept commented out as per user request/code -->
<%--                    <tr>
                        <td class="FormLabel">Select Disease</td>
                        <td class="DataEntry">
                            <select id="selectDisease_renew" class="disease-dropdown">
                                <option value="">-- Loading Diseases --</option>
                            </select>
                        </td>
                    </tr>--%>
                    <tr>
                        <td class="FormLabel">Add Documents</td>
                        <td class="DataEntry">
                            <table id="documentList_renew" style="width: 100%;">
                                <tbody id="documentListBody_renew"></tbody>
                            </table>
                            <button type="button" id="btnAddDocumentRow_renew" class="btn-add-row" data-suffix="_renew">+ Add Document</button>
                            <div id="fileError_renew" style="color: red; font-size: 12px; margin-top: 5px;"></div>
                        </td>
                    </tr>
                </table>
            </fieldset>
             <div class="panelbuttons" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                <table style="width: 100%;">
                    <tr>
                        <td align="left"><button type="button" id="btnAddPolicy_renew" class="btn-primary action-btn" data-suffix="_renew" disabled>Renew Policy</button></td>
                        <td align="right"><button type="button" id="btnCancel_renew" class="btn-cancel cancel-btn" data-suffix="_renew">Cancel</button></td>
                    </tr>
                </table>
            </div>
            <div id="footer"><label id="lblStatus_renew" style="font-weight: bold; margin-top:10px; display:block;"></label></div>
        </div>
    </div>

    <!-- GLOBAL POLICY LIST CONTAINER -->
    <div id="policyListContainer" class="list-panel" style="display: block;">
        <!-- Populated via JS -->
    </div>
</div>

<!-- MODAL -->
<div id="eligibilityModal" class="modal">
    <div class="modal-content">
        <span class="close">X</span>
        <h2 style="text-align:center; color:#0056b3;">Insurance Eligibility Status</h2>
        <div id="eligibilityContent"></div>
    </div>
</div>

<script type="text/javascript">
    const loggedInUserName = '<%: User.Identity.Name %>';

    // --- TABS LOGIC ---
    function openTab(evt, tabName) {
        if(evt) evt.preventDefault();
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) { tabcontent[i].style.display = "none"; }
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) { tablinks[i].className = tablinks[i].className.replace(" active", ""); }
        document.getElementById(tabName).style.display = "block";
        if(evt) evt.currentTarget.className += " active";
    }
</script>

<script type="text/javascript">
    // --- GLOBAL CONFIGURATION ---
    const DOCUMENT_TYPES_HARDCODED = ["Medical Report", "Citizenship Certificate", "Photo", "Hospital Discharge Summary", "Claim Form", "Other"];

    // ADD TAB REQUIREMENTS: Needs 1, 2, and 3
    const MANDATORY_DOC_IDS_ADD = ['1', '2', '3'];
    // RENEW TAB REQUIREMENTS: Needs ONLY 1
    const MANDATORY_DOC_IDS_RENEW = ['1'];

    // Store separate HTML for dropdowns
    let documentTypeOptionsHtml_Add = '<option value="">-- Loading Types... --</option>';
    let documentTypeOptionsHtml_Renew = '<option value="">-- Loading Types... --</option>';

    let formState = {
        "": { isEligible: false },       // Add Tab
        "_renew": { isEligible: false }  // Renew Tab
    };

    // --- UTILITY FUNCTIONS ---
    function escapeHtml(str) {
        if (str === null || typeof str === 'undefined') return '';
        const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
        return str.toString().replace(/[&<>"']/g, m => map[m]);
    }

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

    // --- UPDATED BUTTON STATE LOGIC ---
    function updateAddPolicyButtonState(suffix) {
        const container = suffix === "" ? "#tab-add" : "#tab-renew";
        const btnId = "#btnAddPolicy" + suffix;

        const selectedDocIds = $(container + ' .doc-type-select1').map(function () {
            return $(this).val();
        }).get();

        const eligible = formState[suffix].isEligible;
        let hasMandatoryDocs = false;

        // Check which tab calls this function
        if (suffix === "_renew") {
            // RENEW TAB: Logic = Eligible + Has Document ID '1'
            hasMandatoryDocs = MANDATORY_DOC_IDS_RENEW.every(id => selectedDocIds.includes(id));
        } else {
            // ADD TAB: Logic = Eligible + Has Documents 1, 2, 3 (Existing Logic)
            hasMandatoryDocs = MANDATORY_DOC_IDS_ADD.every(id => selectedDocIds.includes(id));
        }

        $(btnId).prop('disabled', !(eligible && hasMandatoryDocs));
    }

    // --- API FETCHING ---
    function populateDiseaseDropdown() {
        var apiUrl = '/FindClaims.aspx?action=GetCriticalIllnessBenefits&json={"xml":{}}';
        var dropdowns = $('.disease-dropdown');
        return $.get(apiUrl, function (data) {
            dropdowns.empty().append('<option value="">-- Select a Disease --</option>');
            if (data && Array.isArray(data)) {
                $.each(data, function (index, item) {
                    dropdowns.append($('<option>', { value: item.id, text: `${item.disease_name_nepali} (${item.disease_name_english})` }));
                });
            }
        }).fail(function () {
            dropdowns.empty().append('<option value="">-- Error loading diseases --</option>');
        });
    }

    // --- UPDATED DOCUMENT FETCHING ---
    function fetchDocumentTypes() {
        var apiUrl = '/FindClaims.aspx?action=GetCriticalIllnessDocumentTypes&json={"xml":{}}';
        return $.get(apiUrl, function (data) {
            let optionsAdd = '<option value="">-- Select Document Type --</option>';
            let optionsRenew = '<option value="">-- Select Document Type --</option>';

            if (data && Array.isArray(data)) {
                $.each(data, function (index, item) {
                    // Build Full List for Add Tab
                    optionsAdd += `<option value="${item.id}">${item.type_np} (${item.type_en})</option>`;

                    // Build Restricted List for Renew Tab (Only show ID 1)
                    if (item.id == '1') {
                        optionsRenew += `<option value="${item.id}">${item.type_np} (${item.type_en})</option>`;
                    }
                });
            }

            documentTypeOptionsHtml_Add = optionsAdd;
            documentTypeOptionsHtml_Renew = optionsRenew;

        }).fail(function () {
            // Fallback Logic
            let fallbackAdd = '<option value="">-- Select Document Type --</option>';
            let fallbackRenew = '<option value="">-- Select Document Type --</option>';

            DOCUMENT_TYPES_HARDCODED.forEach((type, index) => {
                fallbackAdd += `<option value="${type}">${type}</option>`;
                // Assuming first item in hardcoded array is ID 1
                if (index === 0) fallbackRenew += `<option value="${type}">${type}</option>`;
            });

            documentTypeOptionsHtml_Add = fallbackAdd;
            documentTypeOptionsHtml_Renew = fallbackRenew;
        });
    }

    // --- UPDATED ROW ADDITION LOGIC ---
    function addDocumentRow(suffix) {
        $('#fileError' + suffix).text('');
        const tbodyId = '#documentListBody' + suffix;
        const newRowId = `doc-row-${Date.now()}`;

        // Decide which dropdown HTML to use based on the tab
        let dropdownHtml = (suffix === "_renew") ? documentTypeOptionsHtml_Renew : documentTypeOptionsHtml_Add;

        const newRowHtml = `
            <tr id="${newRowId}" class="document-entry-row">
                <td><select class="doc-type-select1" data-suffix="${suffix}">${dropdownHtml}</select></td>
                <td><input type="file" class="doc-file-input" style="width: 100%;"></td>
                <td style="text-align: right;"><button type="button" class="btn-remove-doc" data-row-id="${newRowId}" data-suffix="${suffix}">Remove</button></td>
            </tr>`;
        $(tbodyId).append(newRowHtml);
    }

    function sendPolicyDataToServer(chfId, disease, documents, suffix) {
        var requestData = { "xml": { "CHFID": chfId, "Disease": disease, "Documents": { "Document": documents } } };
        var apiAction = (suffix === "_renew") ? "SeriousIllnessApi3" : "SeriousIllnessApi3";

        $('#lblStatus' + suffix).css('color', 'orange').text('Processing...');

        $.ajax({
            url: "/FindClaims.aspx?action=" + apiAction,
            type: "POST",
            data: { json: JSON.stringify(requestData) },
            success: function (response) {
                if (response && response.length > 0 && response[0].Message) {
                    $('#lblStatus' + suffix).css('color', response[0].Message.includes('successfully') ? 'green' : 'blue').text(response[0].Message);
                    if (response[0].Message.includes('successfully')) {
                        $('#btnCancel' + suffix).click();
                        fetchPolicyList(1);
                    }
                } else {
                    $('#lblStatus' + suffix).css('color', 'red').text('An unknown error occurred.');
                }
            },
            error: function (xhr) { $('#lblStatus' + suffix).css('color', 'red').text('Error: ' + xhr.responseText); }
        });
    }

    function sendRenewPolicyDataToServer(chfId, disease, documents) {
        var requestData = { "xml": { "CHFID": chfId, "Disease": disease, "Documents": { "Document": documents } } };
        var suffix = "_renew";
        $('#lblStatus_renew').css('color', 'orange').text('Processing Renewal...');

        $.ajax({
            url: "/FindClaims.aspx?action=SeriousIllnessRenewApi",
            type: "POST",
            data: { json: JSON.stringify(requestData) },
            success: function (response) {
                if (response && response.length > 0 && response[0].Message) {
                    $('#lblStatus_renew').css('color', response[0].Message.includes('successfully') ? 'green' : 'blue').text(response[0].Message);
                    if (response[0].Message.includes('successfully')) {
                        $('#btnCancel_renew').click();
                        fetchPolicyList(1);
                    }
                } else {
                    $('#lblStatus_renew').css('color', 'red').text('Unknown server response., Please check if Critical Policy is active, cannot add if policy is active');
                }
            },
            error: function (xhr) { $('#lblStatus_renew').css('color', 'red').text('Error: ' + xhr.responseText); }
        });
    }


    function checkEligibilityStatus(chfId, suffix) {
        if (!chfId) {
            $('#lblStatus' + suffix).css('color', 'red').text('Please enter Insurance No. (CHFID) first.');
            return;
        }
        var requestData = { "xml": { "CHFID": chfId } };
        var encodedJson = encodeURIComponent(JSON.stringify(requestData));
        var apiUrl = `/FindClaims.aspx?action=PolicyInquiryApi&json=${encodedJson}`;
        $('#lblStatus' + suffix).css('color', 'orange').text('Checking eligibility...');

        $.get(apiUrl, function (response) {
            $('#lblStatus' + suffix).text('');
            if (response && response.length > 0) {
                displayEligibilityInfo(response[0], suffix);
            } else {
                formState[suffix].isEligible = false;
                updateAddPolicyButtonState(suffix);
                $('#lblStatus' + suffix).css('color', 'red').text('No eligibility information found.');
            }
        }).fail(function (xhr) {
            formState[suffix].isEligible = false;
            updateAddPolicyButtonState(suffix);
            $('#lblStatus' + suffix).css('color', 'red').text('Error checking eligibility.');
        });
    }

    function displayEligibilityInfo(data, suffix) {
        var isExpired = isDateExpired(data.ExpiryDate);
        var isInactive = data.Status === 'निष्कृय';

        var eligible = !isExpired && !isInactive;

        formState[suffix].isEligible = eligible;
        updateAddPolicyButtonState(suffix);

        var statusText = isInactive ? 'Expired/Inactive' : '';
        var expiryText = isExpired ? ' EXPIRED' : ' Valid';

        var content = `
            <div class="eligibility-info" style="line-height: 1.8;">
                <div class="info-row"><span class="info-label">CHFID:</span><span>${data.CHFID || 'N/A'}</span></div>
                <div class="info-row"><span class="info-label">Insuree Name:</span><span>${data.InsureeName || 'N/A'}</span></div>
                <div class="info-row"><span class="info-label">Expiry Date:</span><span class="${isExpired ? 'status-expired1' : 'status-active1'}">${data.ExpiryDate || 'N/A'}${expiryText}</span></div>
                <div class="info-row"><span class="info-label">Status:</span><span class="${isInactive ? 'status-expired1' : 'status-active1'}">${data.Status || 'N/A'} (${statusText})</span></div>
            </div>`;

        if (!eligible) {
            content += `<div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;"><b>Cannot proceed:</b> Insurance is inactive or expired.</div>`;
        } else {
            content += `<div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;"><b>Eligible.</b></div>`;
        }
        $('#eligibilityContent').html(content);
        $('#eligibilityModal').show();
    }

    function openBase64InNewTab(base64Data, mimeType) {
        try {
            const byteCharacters = atob(base64Data);
            const byteNumbers = new Array(byteCharacters.length);
            for (let i = 0; i < byteCharacters.length; i++) byteNumbers[i] = byteCharacters.charCodeAt(i);
            const byteArray = new Uint8Array(byteNumbers);
            const blob = new Blob([byteArray], { type: mimeType || 'application/octet-stream' });
            const blobUrl = URL.createObjectURL(blob);
            window.open(blobUrl, '_blank');
        } catch (error) { console.error(error); alert('Could not display document.'); }
    }

    function fetchAndShowDocument(documentId, element) {
        const originalHtml = element.innerHTML;
        element.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading...';
        element.style.pointerEvents = 'none';
        const jsonParam = `{"xml":{"DocumentID":"${documentId}"}}`;
        const apiUrl = `/FindClaims.aspx?action=SeriousIllnessGetDocumentByID&json=${encodeURIComponent(jsonParam)}`;
        $.ajax({
            url: apiUrl, type: 'GET', dataType: 'json',
            success: function (response) {
                if (response && response.length > 0 && response[0].DocumentDataB64) {
                    openBase64InNewTab(response[0].DocumentDataB64, response[0].MimeType);
                } else { alert('Document not found.'); }
            },
            error: function () { alert('Error fetching document.'); },
            complete: function () { element.innerHTML = originalHtml; element.style.pointerEvents = 'auto'; }
        });
    }

    // --- SEARCH & LIST ---
    function renderInitialSearchPanel() {
        const container = $('#policyListContainer');
        const diseaseOptionsHtml = $('#selectDisease').html().replace('<option value="">-- Select a Disease --</option>', '<option value="">All Diseases</option>');
        container.html(`
            <fieldset style="border:none;">
                <legend>Policy Holders List</legend>
                <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-bottom:20px;">
                    <div><label style="font-weight:bold;">CHFID:</label><input type="text" id="txtSearchChfid_list" placeholder="Enter CHFID..." style="padding:3px; border:1px solid #ccc; border-radius:4px;" /></div>
                    <div><label style="font-weight:bold;">Disease:</label><select id="ddlDisease_list" style="padding:0px; border:1px solid #ccc; border-radius:4px; width:200px;">${diseaseOptionsHtml}</select></div>
                    <div style="margin-top:20px;">
                        <button type="button" id="btnSearch_list" class="button btn-primary">Search</button>
                        <button type="button" id="btnClear_list" class="button btn-cancel">Clear</button>
                    </div>
                </div>
                <div style="text-align: center; padding: 40px; color: #666;">
                    <i class="fa fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                    <p>Click <strong>Search</strong> to view policy holders</p>
                </div>
            </fieldset>`);
    }

    function renderPolicyList(meta, policies, searchChfid = '', searchDiseaseId = '') {
        const container = $('#policyListContainer');
        let tableRowsHtml = '';
        if (!policies || policies.length === 0) {
            tableRowsHtml = '<tr><td colspan="7" style="text-align:center;padding:20px;">No policies found.</td></tr>';
        } else {
            policies.forEach(policy => {
                let docLinksHtml = 'No documents';
                if (policy.DocumentsJSON && Array.isArray(policy.DocumentsJSON)) {
                    docLinksHtml = policy.DocumentsJSON.map(doc => `
                        <div style="margin-bottom: 4px; white-space: nowrap;">
                            <a href="#" onclick="fetchAndShowDocument('${doc.DocID}', this); return false;" style="color:#0056b3;">
                            <i class="fa fa-file-alt"></i> ${escapeHtml(doc.FileName)}</a>
                        </div>`).join('');
                }
                tableRowsHtml += `<tr><td>${escapeHtml(policy.CHFID)}</td><td>${escapeHtml(policy.FullName)}</td><td>${policy.PolicyID}</td><td>${escapeHtml(policy.StartDate)}</td><td>${escapeHtml(policy.ExpiryDate)}</td><td>${escapeHtml(policy.ProductName)}</td><td>${docLinksHtml}</td></tr>`;
            });
        }

        let paginationHtml = '';
        if (meta.TotalPages > 1) {
            paginationHtml += (meta.PageNumber > 1) ? `<a class="page-link" data-page="${meta.PageNumber - 1}">« Prev</a>` : `<span class="page-link disabled">« Prev</span>`;
            for (let i = 1; i <= meta.TotalPages; i++) {
                paginationHtml += (i == meta.PageNumber) ? `<span class="page-link active">${i}</span>` : `<a class="page-link" data-page="${i}">${i}</a>`;
            }
            paginationHtml += (meta.PageNumber < meta.TotalPages) ? `<a class="page-link" data-page="${meta.PageNumber + 1}">Next »</a>` : `<span class="page-link disabled">Next »</span>`;
        }

        const diseaseOptionsHtml = $('#selectDisease').html().replace('<option value="">-- Select a Disease --</option>', '<option value="">All Diseases</option>').replace(`value="${searchDiseaseId}"`, `value="${searchDiseaseId}" selected`);

        container.html(`
            <fieldset style="border:none;">
                <legend>Policy Holders List</legend>
                <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-bottom:15px;">
                    <div><label style="font-weight:bold;">CHFID:</label><input type="text" id="txtSearchChfid_list" value="${escapeHtml(searchChfid)}" style="padding:3px; border:1px solid #ccc; border-radius:4px;" /></div>
                    <div><label style="font-weight:bold;">Disease:</label><select id="ddlDisease_list" style="padding:0px; border:1px solid #ccc; border-radius:4px; width:200px;">${diseaseOptionsHtml}</select></div>
                    <div style="margin-top:20px;">
                        <button type="button" id="btnSearch_list" class="button btn-primary">Search</button>
                        <button type="button" id="btnClear_list" class="button btn-cancel">Clear</button>
                    </div>
                </div>
                <div style="margin-bottom: 10px; color: #666; font-size: 14px;">Total Records: <b>${meta.TotalRecords}</b> | Page <b>${meta.PageNumber}</b> of <b>${meta.TotalPages || 1}</b></div>
                <table class="results-table"><thead><tr><th>CHFID</th><th>Name</th><th>Policy ID</th><th>Start Date</th><th>Expiry Date</th><th>Product Name</th><th>Documents</th></tr></thead><tbody>${tableRowsHtml}</tbody></table>
                <div class="pagination">${paginationHtml}</div>
            </fieldset>`);
    }

    function fetchPolicyList(page = 1) {
        var searchChfid = $('#txtSearchChfid_list').val() || '';
        var diseaseId = $('#ddlDisease_list').val() || '';
        $('#policyListContainer').html('<div style="text-align:center; padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>');

        var xmlData = { search: escapeHtml(searchChfid), diseaseId: escapeHtml(diseaseId), page: escapeHtml(page) };
        var apiUrl = `/FindClaims.aspx?action=SeriousIllnessAPIList2&json=${encodeURIComponent(JSON.stringify({ xml: xmlData }))}`;

        $.get(apiUrl, function (response) {
            let metaData = { TotalRecords: 0, TotalPages: 1, PageNumber: 1 };
            let policies = [];
            let fullJsonString = "";
            try {
                if (response && Array.isArray(response) && response.length > 0) {
                    response.forEach(item => { const key = Object.keys(item)[0]; if (item[key]) fullJsonString += item[key]; });
                }
                if (fullJsonString) {
                    const data = JSON.parse(fullJsonString);
                    if (data.Meta) metaData = JSON.parse(data.Meta);
                    if (data.Policies) policies = data.Policies;
                }
            } catch (e) { console.error(e); }
            renderPolicyList(metaData, policies, searchChfid, diseaseId);
        }).fail(function () { $('#policyListContainer').html('<div style="color:red;text-align:center;padding:20px;">Error loading list.</div>'); });
    }

    // --- DOCUMENT READY ---
    $(document).ready(function () {
        if (loggedInUserName) $('#welcomeMessage').text('Welcome, ' + loggedInUserName);

        $('button').not('[type="submit"]').attr('type', 'button');

        Promise.all([populateDiseaseDropdown(), fetchDocumentTypes()]).then(() => { renderInitialSearchPanel(); });

        // 1. Delegated Events
        $(document).on('input', '.input-chfid', function () {
            const suffix = $(this).data('suffix');
            formState[suffix].isEligible = false;
            updateAddPolicyButtonState(suffix);
        });

        $(document).on('click', '.btn-check', function (e) {
            e.preventDefault();
            const suffix = $(this).data('suffix');
            checkEligibilityStatus($('#txtInsuranceNo' + suffix).val().trim(), suffix);
        });

        $(document).on('click', '.btn-add-row', function () {
            const suffix = $(this).data('suffix');
            addDocumentRow(suffix);
            updateAddPolicyButtonState(suffix);
        });

        $(document).on('click', '.btn-remove-doc', function () {
            const rowId = $(this).data('row-id');
            const suffix = $(this).data('suffix');
            $('#' + rowId).remove();
            updateAddPolicyButtonState(suffix);
        });

        $(document).on('change', '.doc-type-select1', function () {
            updateAddPolicyButtonState($(this).data('suffix'));
        });

        // 2. Main Actions
        $(document).on('click', '.action-btn', function (e) {
            e.preventDefault();
            const suffix = $(this).data('suffix'); // "" or "_renew"
            $('#fileError' + suffix).text('');

            var chfId = $('#txtInsuranceNo' + suffix).val().trim();
            var selectedDisease = $('#selectDisease' + suffix).val(); // Might be undefined for renew if hidden

            // VALIDATION ADJUSTMENT:
            // If 'Renew', we might not need disease, or it's hidden.
            // But if your backend requires it for Renew (even if reusing old), logic needs to be here.
            // Assuming Renew relies on documents mainly as per request.
            // If Renew keeps same disease, user might not need to select.
            // However, strict validation:
            if (suffix === "") {
                if (!chfId || !selectedDisease) {
                    $('#lblStatus' + suffix).css('color', 'red').text('Insurance No. and a selected disease are required.');
                    return;
                }
            } else {
                // Renew specific validation
                if (!chfId) {
                    $('#lblStatus' + suffix).css('color', 'red').text('Insurance No. is required.');
                    return;
                }
            }

            var actionName = (suffix === "") ? "Create new policy" : "Renew policy";
            if (!confirm(actionName + ' for CHFID: ' + chfId + '?')) return;

            // File Reading Logic
            var fileReadPromises = [];
            var hasValidationError = false;
            const container = suffix === "" ? "#tab-add" : "#tab-renew";

            $(container + ' .document-entry-row').each(function (index, row) {
                var fileInput = $(row).find('.doc-file-input')[0];
                var docTypeId = $(row).find('.doc-type-select1').val();

                if (fileInput.files.length === 0) {
                    $('#fileError' + suffix).text('Error: Please select a file for every document row.');
                    hasValidationError = true; return false;
                }

                var file = fileInput.files[0];
                let promise = new Promise((resolve, reject) => {
                    var reader = new FileReader();
                    reader.onload = function (event) {
                        resolve({ DocumentData: event.target.result.split(',')[1], FileName: file.name, MimeType: file.type, DocumentTypeID: docTypeId });
                    };
                    reader.onerror = () => reject('Error reading file: ' + file.name);
                    reader.readAsDataURL(file);
                });
                fileReadPromises.push(promise);
            });

            if (hasValidationError) return;

            Promise.all(fileReadPromises)
                .then(documents => {
                    if (suffix === "_renew") {
                        sendRenewPolicyDataToServer(chfId, selectedDisease, documents);
                    } else {
                        sendPolicyDataToServer(chfId, selectedDisease, documents);
                    }
                })
                .catch(error => { $('#lblStatus' + suffix).css('color', 'red').text(error); });
        });

        // 3. Cancel
        $(document).on('click', '.cancel-btn', function (e) {
            e.preventDefault();
            const suffix = $(this).data('suffix');
            $('#txtInsuranceNo' + suffix + ', #selectDisease' + suffix).val('');
            $('#documentListBody' + suffix).empty();
            $('#fileError' + suffix + ', #lblStatus' + suffix).text('');
            formState[suffix].isEligible = false;
            updateAddPolicyButtonState(suffix);
        });

        // 4. Common
        $('.close').click(function () { $('#eligibilityModal').hide(); });
        $(window).click(function (event) { if ($(event.target).is('#eligibilityModal')) $('#eligibilityModal').hide(); });

        // 5. List Search Events
        const listContainer = $('#policyListContainer');
        listContainer.on('click', '#btnSearch_list', () => fetchPolicyList(1));
        listContainer.on('click', '#btnClear_list', () => { listContainer.find('#txtSearchChfid_list, #ddlDisease_list').val(''); fetchPolicyList(1); });
        listContainer.on('keypress', '#txtSearchChfid_list', e => { if (e.which === 13) { e.preventDefault(); fetchPolicyList(1); } });
        listContainer.on('click', '.page-link:not(.disabled):not(.active)', function (e) { e.preventDefault(); fetchPolicyList($(this).data('page')); });
    });
</script>
</asp:Content>