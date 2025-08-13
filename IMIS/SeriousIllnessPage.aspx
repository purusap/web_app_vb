<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" Title="Critical Illness Policy Management" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" runat="Server">
<style>
    /* All CSS styles are self-contained here */
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background-color: #f4f4f9; color: #333; }
    .divBody { max-width: 1200px; margin: 40px auto; }
    .panel { border: 1px solid #ddd; padding: 20px; margin: 20px 0; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .FormLabel { font-weight: bold; padding-right: 10px; vertical-align: top; padding-top: 10px; }
    .DataEntry input[type="text"], .DataEntry input[type="file"], .DataEntry select, .doc-type-select { width: 250px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    button, .button { padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; text-align: center; }
    #btnAddPolicy { background-color: #007bff; color: white; }
    #btnAddPolicy:disabled { background-color: #6c757d; cursor: not-allowed; opacity: 0.6; }
    #btnCancel { background-color: #6c757d; color: white; }
    #btnCheckEligibility { background-color: #17a2b8; color: white; margin-left: 10px; }
    #btnAddDocumentRow { background-color: #28a745; color: white; }
    .btn-remove-doc { background-color: #dc3545; color: white; padding: 5px 10px; font-size: 12px; }
    legend { font-size: 1.2em; font-weight: bold; color: #0056b3; }
    .results-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .results-table th { background-color: #343a40; color: white; }
    .results-table th, .results-table td { padding: 12px; text-align: left; border: 1px solid #dee2e6; vertical-align: top; }
    .results-table tr:nth-child(even) { background-color: #f8f9fa; }
    .results-table tr:hover { background-color: #e9ecef; }
    .pagination { display: flex; justify-content: center; gap: 5px; flex-wrap: wrap; margin-top: 15px; }
    .page-link { display: inline-block; padding: 8px 12px; text-decoration: none; border: 1px solid #007bff; color: #007bff; border-radius: 4px; cursor: pointer; }
    .page-link.active, .page-link:hover { background-color: #007bff; color: white; }
    .page-link.disabled { color: #6c757d; border-color: #6c757d; cursor: not-allowed; background-color: #f8f9fa; }
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
    .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; border-radius: 8px; width: 80%; max-width: 600px; position: relative; }
    .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
    .eligibility-info .info-row { display: flex; margin: 8px 0; }
    .eligibility-info .info-label { font-weight: bold; min-width: 140px; }
    .status-active { color: #28a745; font-weight: bold; }
    .status-expired { color: #dc3545; font-weight: bold; }
    .eligibility-header { text-align: center; margin-bottom: 20px; color: #0056b3; }
    .document-entry-row td { padding: 4px; }
</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<div class="divBody">
    <div class="panel">
        <fieldset>
            <legend>Create Serious Illness Policy</legend>
            <span id="welcomeMessage"></span>
            <table>
                <tr>
                    <td class="FormLabel" style="vertical-align: middle;">Insurance No (CHFID)</td>
                    <td class="DataEntry">
                        <input type="text" id="txtInsuranceNo" maxlength="50" />
                        <button id="btnCheckEligibility">Check Eligibility Status</button>
                    </td>
                </tr>
                <tr>
                    <td class="FormLabel" style="vertical-align: middle;">Select Disease</td>
                    <td>
                        <select id="selectDisease">
                            <option value="">-- Loading Diseases --</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="FormLabel">Add Documents</td>
                    <td>
                        <table id="documentList" style="width: 100%;">
                            <tbody id="documentListBody"></tbody>
                        </table>
                        <button type="button" id="btnAddDocumentRow" style="margin-top: 10px;">+ Add Document</button>
                        <div id="fileError" style="color: red; font-size: 12px; margin-top: 5px;"></div>
                    </td>
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
        <div class="panel" style="text-align:center; padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading policy list...</div>
    </div>
</div>

<div id="eligibilityModal" class="modal">
    <div class="modal-content">
        <span class="close">×</span>
        <h2 class="eligibility-header">Insurance Eligibility Status</h2>
        <div id="eligibilityContent"></div>
    </div>
</div>

<script type="text/javascript">
    // This server-side code nugget is executed when the page is rendered.
    // It embeds the logged-in username into a JavaScript constant.
    const loggedInUserName = '<%: User.Identity.Name %>';
</script>

<script type="text/javascript">
    // --- GLOBAL CONFIGURATION & CACHING ---
    const DOCUMENT_TYPES_HARDCODED = ["Medical Report", "Citizenship Certificate", "Photo", "Hospital Discharge Summary", "Claim Form", "Other"];
    const MANDATORY_DOC_IDS = ['1', '2', '3'];
    let documentTypeOptionsHtml = '<option value="">-- Loading Types... --</option>';
    let isEligible = false; // Flag to track eligibility status

    // --- UTILITY AND HELPER FUNCTIONS ---
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

    function updateAddPolicyButtonState() {
        // 1. Get all currently selected document type IDs from the UI
        const selectedDocIds = $('.doc-type-select1').map(function () {
            return $(this).val();
        }).get(); // .get() converts jQuery object to a standard array

        // 2. Check if every mandatory ID is included in the list of selected IDs
        const hasAllMandatoryDocs = MANDATORY_DOC_IDS.every(id => selectedDocIds.includes(id));

        // 3. The button is enabled only if the user is eligible AND has selected all mandatory docs.
        $('#btnAddPolicy').prop('disabled', !(isEligible && hasAllMandatoryDocs));
    }

    // --- API FETCHING FUNCTIONS ---
    function populateDiseaseDropdown() {
        var apiUrl = '/FindClaims.aspx?action=GetCriticalIllnessBenefits&json={"xml":{}}';
        var dropdown = $('#selectDisease');
        return $.get(apiUrl, function (data) {
            dropdown.empty().append('<option value="">-- Select a Disease --</option>');
            if (data && Array.isArray(data)) {
                $.each(data, function (index, item) {
                    dropdown.append($('<option>', { value: item.id, text: `${item.disease_name_nepali} (${item.disease_name_english})` }));
                });
            }
        }).fail(function () {
            dropdown.empty().append('<option value="">-- Error loading diseases --</option>');
        });
    }

    function fetchDocumentTypes() {
        var apiUrl = '/FindClaims.aspx?action=GetCriticalIllnessDocumentTypes&json={"xml":{}}';
        return $.get(apiUrl, function (data) {
            let options = '<option value="">-- Select Document Type --</option>';
            if (data && Array.isArray(data)) {
                $.each(data, function (index, item) {
                    options += `<option value="${item.id}">${item.type_np} (${item.type_en})</option>`;
                });
            }
            documentTypeOptionsHtml = options;
        }).fail(function () {
            let fallbackOptions = '<option value="">-- Select Document Type --</option>';
            DOCUMENT_TYPES_HARDCODED.forEach(type => { fallbackOptions += `<option value="${type}">${type}</option>`; });
            documentTypeOptionsHtml = fallbackOptions;
            console.error("Failed to load document types from database. Using fallback list.");
        });
    }

    // --- UI AND BUSINESS LOGIC FUNCTIONS ---
    function addDocumentRow() {
        $('#fileError').text('');
        const newRowId = `doc-row-${Date.now()}`;
        const newRowHtml = `
            <tr id="${newRowId}" class="document-entry-row">
                <td><select class="doc-type-select1">${documentTypeOptionsHtml}</select></td>
                <td><input type="file" class="doc-file-input" style="width: 100%;"></td>
                <td style="text-align: right;"><button type="button" class="btn-remove-doc" data-row-id="${newRowId}">Remove</button></td>
            </tr>`;
        $('#documentListBody').append(newRowHtml);
    }

    function sendPolicyDataToServer(chfId, disease, documents) {
        var requestData = { "xml": { "CHFID": chfId, "Disease": disease, "Documents": { "Document": documents } } };
        $('#lblStatus').css('color', 'orange').text('Processing...');
        $.ajax({
            url: "/FindClaims.aspx?action=SeriousIllnessApi3",
            type: "POST",
            data: { json: JSON.stringify(requestData) },
            success: function (response) {
                if (response && response.length > 0 && response[0].Message) {
                    $('#lblStatus').css('color', response[0].Message.includes('successfully') ? 'green' : 'blue').text(response[0].Message);
                    if (response[0].Message.includes('successfully')) {
                        $('#btnCancel').click();
                        fetchPolicyList(1);
                    }
                } else {
                    $('#lblStatus').css('color', 'red').text('An unknown error occurred. The server response was not in the expected format.');
                }
            },
            error: function (xhr) { $('#lblStatus').css('color', 'red').text('An error occurred: ' + xhr.responseText); }
        });
    }

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
                isEligible = false;
                updateAddPolicyButtonState();
                $('#lblStatus').css('color', 'red').text('No eligibility information found for this CHFID.');
            }
        }).fail(function (xhr) {
            isEligible = false;
            updateAddPolicyButtonState();
            $('#lblStatus').css('color', 'red').text('Error checking eligibility: ' + xhr.responseText);
        });
    }

    function displayEligibilityInfo(data) {
        var isExpired = isDateExpired(data.ExpiryDate);
        var isInactive = data.Status === 'निष्कृय';
        isEligible = !isExpired && !isInactive;
        updateAddPolicyButtonState();
        var statusText = isInactive ? 'Expired/Inactive' : 'Active';
        var expiryText = isExpired ? ' (EXPIRED)' : ' (Valid)';
        var content = `
            <div class="eligibility-info">
                <div class="info-row"><span class="info-label">CHFID:</span><span>${data.CHFID || 'N/A'}</span></div>
                <div class="info-row"><span class="info-label">Insuree Name:</span><span>${data.InsureeName || 'N/A'}</span></div>
                <div class="info-row"><span class="info-label">Expiry Date:</span><span class="${isExpired ? 'status-expired' : 'status-active'}">${data.ExpiryDate || 'N/A'}${expiryText}</span></div>
                <div class="info-row"><span class="info-label">Status:</span><span class="${isInactive ? 'status-expired' : 'status-active'}">${data.Status || 'N/A'} (${statusText})</span></div>
            </div>`;
        if (!isEligible) {
            content += `<div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-top: 15px;"><b>Cannot create policy:</b> Insurance is inactive or expired.</div>`;
        } else {
            content += `<div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-top: 15px;"><b>Eligible for policy creation.</b></div>`;
        }
        $('#eligibilityContent').html(content);
        $('#eligibilityModal').show();
    }

    function viewDocument(base64Data, mimeType) {
        const byteCharacters = atob(base64Data);
        const byteNumbers = new Array(byteCharacters.length);
        for (let i = 0; i < byteCharacters.length; i++) { byteNumbers[i] = byteCharacters.charCodeAt(i); }
        const byteArray = new Uint8Array(byteNumbers);
        const blob = new Blob([byteArray], { type: mimeType || 'application/pdf' });
        const blobUrl = URL.createObjectURL(blob);
        window.open(blobUrl, '_blank');
    }

    function fetchAndShowDocument(documentBase64, element) {
        const originalText = element.innerHTML;
        element.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Loading...';
        element.style.pointerEvents = 'none';

        try {
            // Convert base64 to binary
            const byteCharacters = atob(documentBase64);
            const byteNumbers = new Array(byteCharacters.length);
            for (let i = 0; i < byteCharacters.length; i++) {
                byteNumbers[i] = byteCharacters.charCodeAt(i);
            }
            const byteArray = new Uint8Array(byteNumbers);

            // Create blob and object URL
            const blob = new Blob([byteArray], { type: 'application/pdf' });
            const blobUrl = URL.createObjectURL(blob);

            // Open in a new tab without blank screen issue
            window.open(blobUrl, '_blank');
        } catch (error) {
            alert('Could not load the document: ' + error.message);
        } finally {
            element.innerHTML = originalText;
            element.style.pointerEvents = 'auto';
        }
    }




    // --- POLICY LIST RENDERING AND FETCHING ---
    function renderPolicyList(meta, policies, searchChfid = '', searchDiseaseId = '') {
        const container = $('#policyListContainer');
        let tableRowsHtml = '';
        if (!policies || policies.length === 0) {
            tableRowsHtml = '<tr><td colspan="7" style="text-align:center;padding:20px;">No policies found.</td></tr>';
        } else {
            policies.forEach(policy => {
                let docLinksHtml = 'No documents';
                const documents = policy.DocumentsJSON;
                if (documents && Array.isArray(documents) && documents.length > 0) {
                    docLinksHtml = documents.map(doc => `
        <div style="margin-bottom: 4px; white-space: nowrap;">
            <a href="#"
               onclick="fetchAndShowDocument('${doc.DocumentData}', this, true); return false;"
               style="color:#0056b3;">
               <i class="fa fa-file-alt"></i> ${escapeHtml(doc.FileName)}
            </a>
            <span style="color:#6c757d; font-size:0.9em; margin-left:8px;">
                (${escapeHtml(doc.DocumentType)})
            </span>
        </div>`
                    ).join('');
                }
                tableRowsHtml += `<tr><td>${escapeHtml(policy.CHFID)}</td><td>${escapeHtml(policy.FullName)}</td><td>${policy.PolicyID}</td><td>${escapeHtml(policy.StartDate)}</td><td>${escapeHtml(policy.ExpiryDate)}</td><td>${escapeHtml(policy.ProductName)}</td><td>${docLinksHtml}</td></tr>`;
            });
        }
        let paginationHtml = '';
        if (meta.TotalPages > 1) {
            paginationHtml += (meta.PageNumber > 1) ? `<a href="#" class="page-link" data-page="${meta.PageNumber - 1}">« Prev</a>` : `<span class="page-link disabled">« Prev</span>`;
            for (let i = 1; i <= meta.TotalPages; i++) {
                paginationHtml += (i == meta.PageNumber) ? `<span class="page-link active">${i}</span>` : `<a href="#" class="page-link" data-page="${i}">${i}</a>`;
            }
            paginationHtml += (meta.PageNumber < meta.TotalPages) ? `<a href="#" class="page-link" data-page="${meta.PageNumber + 1}">Next »</a>` : `<span class="page-link disabled">Next »</span>`;
        }
        const diseaseOptionsHtml = $('#selectDisease').html().replace('<option value="">-- Select a Disease --</option>', '<option value="">All Diseases</option>').replace(`value="${searchDiseaseId}"`, `value="${searchDiseaseId}" selected`);
        const finalHtml = `<div class="panel"><fieldset><legend>Policy Holders List</legend><div class="search-area" style="margin-bottom: 15px;"><div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;"><div><label for="txtSearchChfid_list" style="display: block; margin-bottom: 5px; font-weight: bold;">CHFID:</label><input type="text" id="txtSearchChfid_list" placeholder="Enter CHFID..." value="${escapeHtml(searchChfid)}" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 200px;" /></div><div><label for="ddlDisease_list" style="display: block; margin-bottom: 5px; font-weight: bold;">Disease:</label><select id="ddlDisease_list" >${diseaseOptionsHtml}</select></div><div style="margin-top: 25px;"><button type="button" id="btnSearch_list" class="button" style="background-color: #007bff; color: white;">Search</button><button type="button" id="btnClear_list" class="button" style="background-color: #6c757d; color: white; margin-left: 5px;">Clear</button></div></div></div><div style="margin-bottom: 10px; color: #666; font-size: 14px;">Total Records: <b>${meta.TotalRecords}</b> | Page <b>${meta.PageNumber}</b> of <b>${meta.TotalPages || 1}</b></div><table class="results-table"><thead><tr><th>CHFID</th><th>Name</th><th>Policy ID</th><th>Start Date</th><th>Expiry Date</th><th>Product Name</th><th>Documents</th></tr></thead><tbody>${tableRowsHtml}</tbody></table><div class="pagination">${paginationHtml}</div></fieldset></div>`;
        container.html(finalHtml);
    }

    function fetchPolicyList(page = 1) {
        var searchChfid = $('#txtSearchChfid_list').val() || '';
        var diseaseId = $('#ddlDisease_list').val() || '';
        $('#policyListContainer').html('<div class="panel" style="text-align:center; padding: 40px;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>');
        // FIX 1: Properly encode the XML data
        var xmlData = `<xml><search>${escapeHtml(searchChfid)}</search><diseaseId>${diseaseId}</diseaseId><page>${page}</page></xml>`;
        var xmlData = { search: escapeHtml(searchChfid), diseaseId: escapeHtml(diseaseId), page: escapeHtml(page) }; ///var xmlData = JSON.stringify(jsonData);

        // FIX 2: Use proper JSON structure that matches what the stored procedure expects
        var requestData = { "xml": xmlData };

        var apiUrl = `/FindClaims.aspx?action=SeriousIllnessAPIList2&json=${encodeURIComponent(JSON.stringify(requestData))}`;
        $.get(apiUrl, function (response) {
            let metaData = { TotalRecords: 0, TotalPages: 1, PageNumber: 1 };
            let policies = [];
            let fullJsonString = "";
            try {
                if (response && Array.isArray(response) && response.length > 0) {
                    response.forEach(item => {
                        const key = Object.keys(item)[0];
                        if (item[key]) { fullJsonString += item[key]; }
                    });
                }
                if (fullJsonString) {
                    const data = JSON.parse(fullJsonString);
                    if (data && data.Meta && typeof data.Meta === 'string') {
                        metaData = JSON.parse(data.Meta);
                    }
                    if (data && data.Policies) {
                        policies = data.Policies;
                    }
                }
            } catch (e) {
                console.error("Error parsing policy list response:", e);
                console.error("Assembled JSON string that failed to parse:", fullJsonString);
            }
            renderPolicyList(metaData, policies, searchChfid, diseaseId);
        }).fail(function () {
            $('#policyListContainer').html('<div class="panel" style="text-align:center; color:red;"><b>Error:</b> Could not load policy list.</div>');
        });
    }

    // --- DOCUMENT READY (Single, unified block) ---
    $(document).ready(function () {
        // --- INITIAL LOAD ---
        
        if (loggedInUserName) {
            $('#welcomeMessage').text('Welcome, ' + loggedInUserName);
        }
        Promise.all([
            populateDiseaseDropdown(),
            fetchDocumentTypes()
        ]).then(() => {
            fetchPolicyList(1);
        });

        // --- CREATE POLICY EVENT HANDLERS ---
        $('#txtInsuranceNo').on('input', function () {
            isEligible = false;
            updateAddPolicyButtonState();
        });

        $('#btnCheckEligibility').click(function (e) {
            e.preventDefault();
            checkEligibilityStatus($('#txtInsuranceNo').val().trim());
        });

        $('#btnAddDocumentRow').on('click', function () {
            addDocumentRow();
            updateAddPolicyButtonState();
        });

        $('#documentListBody').on('click', '.btn-remove-doc', function () {
            var rowId = $(this).data('row-id');
            $('#' + rowId).remove();
            updateAddPolicyButtonState();
        });

        $('#documentListBody').on('change', '.doc-type-select1', function () {
            updateAddPolicyButtonState();
        });

        $('#btnAddPolicy').click(function (e) {
            e.preventDefault();
            $('#fileError').text('');
            var chfId = $('#txtInsuranceNo').val().trim();
            var selectedDisease = $('#selectDisease').val();
            if (!chfId || !selectedDisease) {
                $('#lblStatus').css('color', 'red').text('Insurance No. and a selected disease are required.');
                return;
            }
            if (!confirm('Create a new policy for CHFID: ' + chfId + '?')) return;
            var fileReadPromises = [];
            var hasValidationError = false;
            $('.document-entry-row').each(function (index, row) {
                var fileInput = $(row).find('.doc-file-input')[0];
                var docTypeId = $(row).find('.doc-type-select1').val(); // Correctly get the ID
                if (fileInput.files.length === 0) {
                    $('#fileError').text('Error: Please select a file for every document row.');
                    hasValidationError = true; return false;
                }
                var file = fileInput.files[0];
                let promise = new Promise((resolve, reject) => {
                    var reader = new FileReader();
                    reader.onload = function (event) {
                        // Send DocumentTypeID to the backend
                        resolve({ DocumentData: event.target.result.split(',')[1], FileName: file.name, MimeType: file.type, DocumentTypeID: docTypeId });
                    };
                    reader.onerror = () => reject('Error reading file: ' + file.name);
                    reader.readAsDataURL(file);
                });
                fileReadPromises.push(promise);
            });
            if (hasValidationError) return;
            Promise.all(fileReadPromises)
                .then(documents => { sendPolicyDataToServer(chfId, selectedDisease, documents); })
                .catch(error => { $('#lblStatus').css('color', 'red').text(error); });
        });

        $('#btnCancel').click(function (e) {
            e.preventDefault();
            $('#txtInsuranceNo, #selectDisease').val('');
            $('#documentListBody').empty();
            $('#fileError, #lblStatus').text('');
            isEligible = false;
            updateAddPolicyButtonState();
        });

        $('.close').click(function () { $('#eligibilityModal').hide(); });
        $(window).click(function (event) { if ($(event.target).is('#eligibilityModal')) $('#eligibilityModal').hide(); });

        // --- POLICY LIST EVENT HANDLERS (Delegated from static parent) ---
        const listContainer = $('#policyListContainer');
        listContainer.on('click', '#btnSearch_list', () => fetchPolicyList(1));
        listContainer.on('click', '#btnClear_list', () => {
            listContainer.find('#txtSearchChfid_list, #ddlDisease_list').val('');
            fetchPolicyList(1);
        });
        listContainer.on('keypress', '#txtSearchChfid_list', e => {
            if (e.key === 'Enter' || e.which === 13) {
                e.preventDefault();
                fetchPolicyList(1);
            }
        });
        // listContainer.on('change', '#ddlDisease_list', () => fetchPolicyList(1)); // This was commented out as requested
        listContainer.on('click', '.page-link:not(.disabled):not(.active)', function (e) {
            e.preventDefault();
            fetchPolicyList($(this).data('page'));
        });
    });
</script>

</asp:Content>