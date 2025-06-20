({
    doInit: function (component, event, helper) {
        component.get("v.recordId");
        var action = component.get('c.getCase');
        action.setParams({
            "recordID": component.get('v.recordId')
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                component.set('v.showEditChatter', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    handleChanged: function (component, message, helper) {
        var CaseStatus = message._params.CaseStatus;
        if (CaseStatus === "Withdrawn") {
            component.set('v.showEditChatter', false);
        } else if (CaseStatus === "Open") {
            component.set('v.showEditChatter', true);
        }
    }
})