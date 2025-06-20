({
    handleSaveRecord : function(component, event, helper) {
        component.find("AccountRecordCreator").saveRecord($A.getCallback(function(saveResult) {
             if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                  component.set("v.recordSaveError", '');
                // handle component related logic in event handler
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
                component.set("v.recordSaveError", '');
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                component.set("v.recordSaveError", '');
            } else {
                component.set("v.recordSaveError", '');
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    }
})