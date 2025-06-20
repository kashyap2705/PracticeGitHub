({
    fireCaseDeflectionSignal : function(component) {    
       
        var evt = $A.get("e.lightningcommunity:deflectionSignal");
        evt.setParams({
            sourceType: "caseCreateDeflectionModal",            
            destination: component.get("v.deflectionEntityId"),
            payload: {
                deflectionAnswer: component.get("v.deflectionAnswer")
                
            },
            shouldSubmitSourceTypeSignals: true
        });      
        evt.fire();
    }
})