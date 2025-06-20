({
    onPicklistChangeHelper: function (component) {

        $A.createComponents([
            ["lightning:listView", {
                "aura:id": "listViewCase",
                "objectApiName": component.get("v.objectInfo"),
                "listName": component.get("v.selectedListView"),
                "rows": 10,
                "showActionBar": false,
                "enableInlineEdit": false,
                "showRowLevelActions": false,
                "showSearchBar": true
            }]
        ], function (newComponents, status, errorMessage) {
            if (status === "SUCCESS") {
                component.set("v.listViewBody", newComponents);
            } else {
               // console.error("Error creating listView component: " + errorMessage);
            }
        });

    },
    handleUrlNavigation: function (url) {
        try {
            
            var navigateEvent = $A.get("e.force:navigateToURL");
            navigateEvent.setParams({
                "url": url
            });
            navigateEvent.fire();
        }
        catch (error) {
            console.error('An error occurred: ' + error.message);
        }
    },
    getTranslations: function (component, callback) {
        var action = component.get("c.getTranslationsMap");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.translationsMap", response.getReturnValue());
                
                console.log('lang--' + component.get("v.userLanguage"));
                if (callback && typeof callback === "function") {
                    callback(); // Call the callback function
                }
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": component.get("v.errorTranslation"),
                            "message":component.get("v.wentWrongTranslation"),
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    getTranslationsForSpecificKeys: function (component, key) {
        var translationKeys = ['home', 'my_cases', 'for_quickhelp_goto_helptopics', 'status_tooltip', 'date_tooltip', 'open_a_new_case', 'Open', 'Closed', 'waiting_external', 'all', 'Withdrawn', 'last_week', 'last_month', 'last_quarter', 'date_place_holder', 'case_filter', 'date_filter', 'all','error','went_wrong'];
        var userLanguage = component.get("v.userLanguage");
        var translationsMap = component.get("v.translationsMap");

        var languageMap = component.get("v.languageMap");
        var standardLanguageCode = languageMap[userLanguage] || userLanguage;

        var translatedValues = {};
        translationKeys.forEach(function (key) {
            if (translationsMap[key] && Object.keys(translationsMap[key]).length > 0) {
                translatedValues[key] = translationsMap[key][standardLanguageCode];
            } else {
                translatedValues[key] = '';
            }
        });     
        
        var caseStatusOptions = [
            { label: translatedValues['Open'] || 'Open', value: 'Open' },
            { label: translatedValues['Closed'] || 'Closed', value: 'Closed' },
            { label: translatedValues['waiting_external'] || 'Waiting external', value: 'Waiting_External' },
            { label: translatedValues['Withdrawn'] || 'Withdrawn', value: 'Withdrawn' },
            { label: translatedValues['all'] || 'All', value: 'All' }
        ];

        
        component.set("v.caseStatusOptions", caseStatusOptions);

var caseDateFilterOptions = [
    { label: translatedValues['last_week'] || 'Last week', value: 'Last_week' },
    { label: translatedValues['last_month'] || 'Last month', value: 'Last_month' },
    { label: translatedValues['last_quarter'] || 'Last quarter', value: 'Last_quarter' },
    { label: translatedValues['all'] || 'All', value: 'All' }
];  
        component.set("v.caseDateFilterOptions", caseDateFilterOptions);
        

        var defaultTranslations = {
            'home': 'Home',
            'my_cases': 'My Cases',
            'for_quickhelp_goto_helptopics': 'For quick help, go to help topics',
            'status_tooltip': 'Status key:<br/> Open = we are working on your request <br/> Closed = your case has been resolved <br/> Withdrawn = you have closed your request<br/> Waiting External = We need more details (from you)',
            'date_tooltip': 'Specify a date range and filter items by last week,<br/> last month, last quarter, or all.',
            'open_a_new_case': 'Open a new case',
            'date_place_holder': 'Specify a date range',
            'date_filter': 'Filter by date range:',
            'case_filter': 'Filter by Status:',
            'all': 'All',
            'Open':'Open',
            'error':'Error',
            'went_wrong':'Something went wrong!'
            // Add more keys and default translations as needed...
        };

        // Set default translations or use translated values
        for (var key in defaultTranslations) {
            var targetAttribute = getTargetAttribute(key);
            if (targetAttribute) {
                if (translatedValues[key] && translatedValues[key] !== null && translatedValues[key] !== '') {
                    component.set(targetAttribute, translatedValues[key]);
                } else {
                    component.set(targetAttribute, defaultTranslations[key]);
                }
            }
        }

        function getTargetAttribute(key) {
            switch (key) {
                case 'home':
                    return "v.homeTranslation";
                case 'my_cases':
                    return "v.myCasesTranslation";
                case 'for_quickhelp_goto_helptopics':
                    return "v.quickHelpTranslation";
                case 'status_tooltip':
                    return "v.statusTooltipTranslation";
                case 'date_tooltip':
                    return "v.dateTooltipTranslation";
                case 'open_a_new_case':
                    return "v.openNewCaseTranslation";
                case 'date_place_holder':
                    return "v.datePlaceHolderTranslation";
                case 'date_filter':
                    return "v.dateFilterTranslation";
                case 'case_filter':
                    return "v.statusFilterTranslation";
                case 'Open':
                    return "v.openTranslation";
                case 'all':
                    return "v.allTranslation";
                case 'error':
                    return "v.errorTranslation";
                case 'went_wrong':
                    return "v.wentWrongTranslation";
                
                default:
                    // Handle other keys here if needed...
                    return null;
            }
        }
    },
     handleErrors: function(component, error, fileName, MethodName) {
        var errorBody = '';

        if (!error) return;

        if (error.body) {
            errorBody = 'Error: ' + error.body.message;
            if (error.body.errorCode) {
                errorBody += '\nError Code: ' + error.body.errorCode;
            }
            if (error.errorType) {
                errorBody += '\nError Type: ' + error.errorType;
            }
            if (error.stackTrace) {
                errorBody += '\nStack Trace: ' + error.stackTrace;
            }
        } else {
            errorBody = 'Error: ' + error.name + '\nMessage: ' + error.message;
        }

        if (fileName) {
            errorBody += '\nFile Name: ' + fileName;
        }

        if (MethodName) {
            errorBody += '\nMethod Name: ' + MethodName;
        }

        if (errorBody) {
            var action = component.get("c.logError");
            action.setParams({
                "errorBody": errorBody
            });
            action.setCallback(this, function(response) {

            });
            $A.enqueueAction(action);
        }
    }

   
})