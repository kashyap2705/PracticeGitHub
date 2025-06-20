({    invoke : function(component, event, helper) {
   // Get the record ID attribute
   var url_value = component.get("v.url");
   
   var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": url_value
    });
    urlEvent.fire();
}})