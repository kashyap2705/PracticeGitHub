({
    doInit: function (component, event, helper) {      
        
        var urlString = window.location.href;
        var baseUrl = urlString.substring(0, urlString.indexOf("/s"));      
        var homeUrl = baseUrl + "/s/";        
        var helpTopicsUrl = baseUrl + "/s/help-topics";
        var newCaseUrl = baseUrl + "/s/open-case";
        component.set("v.helpTopicsUrl", helpTopicsUrl);
        component.set("v.homeUrl", homeUrl);
        component.set("v.newCaseUrl", newCaseUrl);        
        var selectedCaseStatus = "Open";
        component.set("v.selectedCaseStatus", selectedCaseStatus);
       
          var localeAction = component.get("c.getUserLanguageLocaleKey");
        localeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                var langLocaleKey = response.getReturnValue();                
                 component.set("v.userLanguage", langLocaleKey);
                helper.getTranslations(component, function () {
                    helper.getTranslationsForSpecificKeys(component);
                });
                }                
             else {
                console.log("Error retrieving language locale key");
            }
        });
        $A.enqueueAction(localeAction);
    

        var action = component.get("c.getCaseListViewsByDeveloperNames");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listViewMap", response.getReturnValue());
                var defaultListView = "EC_IB_Answers_Open_Cases";
                component.set("v.selectedListView", defaultListView);
                helper.onPicklistChangeHelper(component);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                var fileName = 'caseListViewAura';
                var MethodName = 'getCaseListViewsByDeveloperNames';
                helper.handleErrors(component, errors, fileName, MethodName);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": component.get("v.errorTranslation"),
                            "message": component.get("v.wentWrongTranslation"),
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
        component.set("v.languageMap", {
            en_US: "American English",
            fr: "French",
            es: "Spanish"
        });
    },
    handleHomeClick: function (component, event, helper) {
        helper.handleUrlNavigation(component.get("v.homeUrl"));
    },
    navigateToHelpTopicsUrl: function (component, event, helper) {
        helper.handleUrlNavigation(component.get("v.helpTopicsUrl"));
    },
    navigateToNewCaseUrl: function (component, event, helper) {
        helper.handleUrlNavigation(component.get("v.newCaseUrl"));
    },
    onCaseStatusPicklistChange: function (component, event, helper) {
        component.set("v.selectedDateFilter", "");
        var selectedCaseStatus = component.get("v.selectedCaseStatus");
        var selectedDateFilter = "EC_IB_Answers_All_Cases";
        component.set("v.selectedDateFilter", selectedDateFilter);
        var selectedListView = 'EC_IB_Answers_' + selectedCaseStatus.replace(/\s+/g, '_') + '_Cases';

        if (!selectedCaseStatus) {
            selectedCaseStatus = "All";
            component.set("v.selectedCaseStatus", selectedCaseStatus);
        }
        component.set("v.selectedListView", selectedListView);
        helper.onPicklistChangeHelper(component);
    },
    onCaseDatePicklistChange: function (component, event, helper) {
        var selectedDateFilter = component.get("v.selectedDateFilter");
        component.set("v.selectedCaseStatus", "");

        if (!selectedDateFilter) {
            selectedDateFilter = "EC_IB_Answers_All_Cases";
            component.set("v.selectedDateFilter", selectedDateFilter);
        }
        var selectedListView = 'EC_IB_Answers_' + selectedDateFilter.replace(/\s+/g, '_') + '_Cases';
        component.set("v.selectedListView", selectedListView);
        helper.onPicklistChangeHelper(component);
    },
    handleChanged: function (component, message, helper) {
        var userLanguage = message._params.userLanguage;        
        component.set("v.userLanguage", userLanguage);
        helper.getTranslationsForSpecificKeys(component);
        helper.onPicklistChangeHelper(component);
    },
    handleMouseOver: function (component,helper) {
        component.set("v.showImage", false);
    },
    handleMouseOut: function (component,helper) {
        component.set("v.showImage", true);
    },
    handleMouseOverOnStatus: function (component,helper) {
        component.set("v.showStatusImage", false);
    },
    handleMouseOutOnStatus: function (component,helper) {
        component.set("v.showStatusImage", true);
    }
});