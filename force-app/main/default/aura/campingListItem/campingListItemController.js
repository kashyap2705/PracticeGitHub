({
	doinit : function(component, event, helper) {
		alert('Inside Child Component');
	},
    packItem : function(component, event, helper) {
         var a = component.get("v.item",true);
        a.Packed__c = true;
        component.set("v.item",a);
        var btnClicked = event.getSource();
        btnClicked.set("v.disabled",true);
		
	}
})