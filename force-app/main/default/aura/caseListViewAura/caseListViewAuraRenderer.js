({
    // Your renderer method overrides go here
    render: function (component, helper) {
        // Retrieve value from local storage during the render phase
        /* component.messageListener = function (event) {
             if (event.data.type === 'lwcReady') {
                 // LWC is ready, notify it to set the user language
                 window.postMessage({ type: 'auraReady' }, '*');
             } else if (event.data.type === 'localstorageset') {
                 // User language is set by LWC
                 var userLanguage = event.data.detail.userLanguage;
                 console.log('Value received from LWC:', userLanguage);
                 localStorage.setItem('userLanguageAura', userLanguage);
 
                 if (userLanguage !== undefined && userLanguage !== null) {
 
                     component.set("v.userLanguage", userLanguage);
                     component.set("v.isMessageReceived", true);
                     helper.getTranslations(component, function () {
                         helper.getTranslationsForSpecificKeys(component);
                     });
                 } else {
                     console.error('userLanguage is undefined or null.');
                 }
             }
 
 
         };
 
         window.addEventListener('message', component.messageListener);*/
        var userLanguage = localStorage.getItem('userLanguageInAura');
        // alert(userLanguage);
        /* if (userLanguage == null) {
             var languageLocaleKey = $A.get("$Locale.language");
             console.log("User's Language Locale Key: " + languageLocaleKey);
             component.set("v.userLanguage", languageLocaleKey);
         } else {*/
        component.set("v.userLanguage", userLanguage);
        // }
        helper.getTranslations(component, function () {
            helper.getTranslationsForSpecificKeys(component);
        });

        // Call the superclass render method
        var ret = this.superRender();
        return ret;
    },

})