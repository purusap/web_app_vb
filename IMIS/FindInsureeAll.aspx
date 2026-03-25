<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" Title="Insuree Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" runat="Server">

    <!-- 1. LOAD LIBRARIES -->
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <link rel="stylesheet" type="text/css" href="NepaliDate/jquery.calendars.picker.css" /> 
    <script type="text/javascript" src="NepaliDate/jquery.plugin.min.js"></script>
    <script type="text/javascript" src="NepaliDate/jquery.calendars.all.js"></script>
    <script type="text/javascript" src="NepaliDate/jquery.calendars.nepali.js"></script>
    <script type="text/javascript" src="NepaliDate/dateConverter.js"></script>    
    <script type="text/javascript" src="NepaliDate/NepaliCalendarNew.js?c=600689853"></script>

    <style>
        /* UI Styles */
        .search-app { font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; max-width: 1200px; margin: 30px auto; padding: 0 15px; }
        .card { background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; }
        .card-header { background: #f8f9fa; padding: 15px 20px; border-bottom: 1px solid #e0e0e0; font-weight: 600; color: #333; display: flex; align-items: center; gap: 10px; }
        .card-body { padding: 25px; }
        .input-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-bottom: 20px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: #555; margin-bottom: 6px; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; box-sizing: border-box; }
        .action-row { display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid #eee; padding-top: 20px; }
        .btn { padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 8px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-light { background: #f8f9fa; border: 1px solid #ddd; color: #333; }
        .table-container { overflow-x: auto; }
        .result-table { width: 100%; border-collapse: collapse; font-size: 14px; }
        .result-table th { text-align: left; padding: 12px 15px; background: #343a40; color: #fff; }
        .result-table td { padding: 12px 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        [v-cloak] { display: none; }
    </style>

    <div id="app" class="search-app" v-cloak>
        <!-- SEARCH CARD -->
        <div class="card">
            <div class="card-header"><i class="fa fa-users"></i> <span>Insuree Search Criteria</span></div>
            <div class="card-body">
                <div class="input-grid">
                    <div class="form-group"><label>Insurance No (CHFID)</label><input type="text" class="form-control" v-model="form.chfid" @keyup.enter="search"></div>
                    <div class="form-group"><label>Phone Number</label><input type="text" class="form-control" v-model="form.phone" @keyup.enter="search"></div>
                    <div class="form-group"><label>First Name</label><input type="text" class="form-control" v-model="form.firstName" @keyup.enter="search"></div>
                    <div class="form-group"><label>Last Name</label><input type="text" class="form-control" v-model="form.lastName" @keyup.enter="search"></div>
                    <div class="form-group"><label>Date of Birth (BS)</label>
                        <input type="text" id="nepali-datepicker" class="form-control bsDob" v-model="form.bsDob">
                    </div>
                    <div class="form-group"><label>Identification No</label><input type="text" class="form-control" v-model="form.identificationNo" @keyup.enter="search"></div>
                    <div class="form-group"><label>NIN Number</label><input type="text" class="form-control" v-model="form.nin" @keyup.enter="search"></div>
                </div>
                <div class="action-row">
                    <button class="btn btn-light" @click="resetForm" :disabled="loading"><i class="fa fa-eraser"></i> Clear</button>
                    <button class="btn btn-primary" @click="search" :disabled="loading">
                        <span v-if="loading"><i class="fa fa-spinner fa-spin"></i> Searching...</span>
                        <span v-else><i class="fa fa-search"></i> Search</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- RESULTS CARD -->
        <div class="card" v-if="results.length > 0">
            <div class="card-header"><i class="fa fa-list"></i> <span>Search Results ({{ results.length }})</span></div>
            <div class="table-container">
                <table class="result-table">
                    <thead>
                        <tr>
                            <th>CHFID</th>
                            <th>Full Name</th>
                            <th>Gender</th>
                            <th>DOB / Age</th>
                            <th>Phone</th>
                            <th>NIN</th>
                            <th>Location</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in results" :key="index">
                            <td style="font-weight: bold; color: #007bff;">{{ item.CHFID }}</td>
                            <td>{{ item.FirstName }} {{ item.LastName }}</td>
                            <td>{{ item.Gender }}</td>
                            <td>{{ item.FormattedDOB }} <span style="color:#777; font-size:0.9em;">({{ item.Age }} yrs)</span></td>
                            <td>{{ item.Phone || '-' }}</td>
                            <td>{{ item.NIN || '-' }}</td>
                            <td>{{ item.InsureeLocation || '-' }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- NO RESULTS -->
        <div v-if="hasSearched && results.length === 0 && !loading" style="text-align: center; color: #888; padding: 40px;">
            <i class="fa fa-folder-open" style="font-size: 48px; opacity: 0.3; margin-bottom: 15px;"></i>
            <p>No records found.</p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            new Vue({
                el: '#app',
                data: {
                    loading: false,
                    hasSearched: false,
                    form: {
                        chfid: '',
                        phone: '',
                        firstName: '',
                        lastName: '',
                        bsDob: '',
                        dob: '',
                        identificationNo: '',
                        nin: ''
                    },
                    results: []
                },
                watch: {
                    "form.bsDob"(newVal) {
                        if (!newVal) {
                            this.form.dob = "";
                            return;
                        }
                        try {
                            // Using your dateConverter.js / NepaliCalendarNew.js
                            let adDate = dateConverter.bsToAd(newVal); // returns {year, month, day}
                            this.form.dob = `${adDate.year}-${String(adDate.month).padStart(2, '0')}-${String(adDate.day).padStart(2, '0')}`;
                        } catch (e) {
                            console.error("BS→AD conversion error:", e);
                            this.form.dob = "";
                        }
                    }
                },

                mounted() {
                    var self = this;
                    if (window.jQuery) {
                        $("#nepali-datepicker").calendarsPicker({
                            calendar: $.calendars.instance('nepali'),
                            onSelect: function (dateText) {
                                self.form.bsDob = dateText; // update Vue model
                            }
                        });
                    }
                },
                methods: {
                    enDateStr(npDateStr) {
                        if (!npDateStr) {
                            return ''; // Return empty string if npDateStr is falsy
                        }                        // Assuming npDateStr is a Nepali date in the format 'YYYY-MM-DD'
                        const npDateParts = npDateStr.split('-');
                        const nepaliYear = parseInt(npDateParts[0]);
                        const nepaliMonth = parseInt(npDateParts[1]);
                        const nepaliDay = parseInt(npDateParts[2]);

                        // Create a new instance of DateConverter
                        var converter = new DateConverter();

                        // Set Nepali date
                        converter.setNepaliDate(nepaliYear, nepaliMonth, nepaliDay);

                        // Get the English (Gregorian) date
                        const englishYear = converter.getEnglishYear();
                        const englishMonth = converter.getEnglishMonth();
                        const englishDay = converter.getEnglishDate();

                        // Format the date as 'DD/MM/YYYY'
                        const formattedDate = `${englishYear}-${englishMonth < 10 ? '0' + englishMonth : englishMonth}-${englishDay < 10 ? '0' + englishDay : englishDay}`;


                        return formattedDate;
                    },
                    search() {
                        var f = this.form;
                        var hasValue = Object.keys(f).some(k => f[k] && f[k].trim() !== '');
                        if (!hasValue) { alert("Please enter at least one field."); return; }

                        this.loading = true;
                        this.hasSearched = true;
                        this.results = [];

                        var payload = {
                            xml: {
                                CHFID: f.chfid,
                                Phone: f.phone,
                                FirstName: f.firstName,
                                LastName: f.lastName,
                                DOB: this.enDateStr($('.bsDob').val()),
                                IdentificationNo: f.identificationNo,
                                NIN: f.nin
                            }
                        };

                        var apiUrl = '/FindClaims.aspx?action=InsureeSearchFromAll&json=' + encodeURIComponent(JSON.stringify(payload));

                        axios.get(apiUrl)
                            .then(response => {
                                var data = response.data;
                                if (Array.isArray(data)) this.results = data;
                                else if (data && data.result) {
                                    try { this.results = JSON.parse(data.result); } catch { this.results = []; }
                                }
                                else this.results = [];
                            })
                            .catch(error => { console.error(error); alert("Error fetching data."); })
                            .finally(() => { this.loading = false; });
                    },

                    resetForm() {
                        this.form = { chfid: '', phone: '', firstName: '', lastName: '', bsDob: '', dob: '', identificationNo: '', nin: '' };
                        this.results = [];
                        this.hasSearched = false;
                    }
                }
            });
        });
    </script>
</asp:Content>
