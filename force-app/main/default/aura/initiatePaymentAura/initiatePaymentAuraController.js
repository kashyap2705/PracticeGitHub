({
    handleClose : function(component, event, helper) {
        // Dispatch the force:closeQuickAction event to close the modal
        $A.get("e.force:closeQuickAction").fire();
    }
})