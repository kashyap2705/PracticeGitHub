/**
* @author Hari Krishnan
* @date 07/17/2013
* @description This factory creates the correct dispatcher and dispatches the trigger event(s) to the appropriate
*               event handler(s). The dispatchers are automatically created using the Type API, hence dispatcher
*               registration is not required for each dispatchers.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1. 		Ranjith Kondabathini    25-05-23		Added Bypass Triggering Logic
*******************************************************************************************/
public without sharing class TriggerFactory
{
    /**
    * @author Ranjith Kumar Kondabathini
    * @date 05/25/2023
    * @description: Used to store the bypass settings for the logged-in user
    */
    private static final Process_Automation_Settings__c BYPASS_SETTING = Process_Automation_Settings__c.getInstance();        
    /**
    * @author Hari Krishnan
    * @date 07/17/2013
    * @description Creates the appropriate dispatcher and dispatches the trigger event to the dispatcher's event handler method.
    * @param Schema.sObjectType Object type to process (SObject.sObjectType)
    */
    public static void createTriggerDispatcher(Schema.sObjectType soType) {        
        if(BYPASS_SETTING<>null) {            
            try {                
                final String byPassField = getByPassField(soType); //Get bypass field to user for the object trigger
                if(BYPASS_SETTING.Bypass_All_Triggers__c == true){
                    return;
                }
                else if(BYPASS_SETTING.get(byPassField) == true) {
                    return;
                }
            } catch(SObjectException ex) {
                // If there is no field on custom setting for an object to by pass triggers 
                // for a user, to whom we are bypassing other object triggers/validation rules/flows
                // Code will deliberately run into SObjectException on custom setting as there is no column
                System.debug('Bypass field not found in custom setting  for sobject: ' + soType.getDescribe().getName());
            }            
        }        
        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if (dispatcher == null) {
            throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);
        }            
        execute(dispatcher);
    }

    /**
    * @author Ranjith Kumar Kondabathini
    * @date 05/25/2023
    * @description Retrieves appropriate field name to check for bypassing trigger for an object
    * @param Schema.sObjectType Object type to process (SObject.sObjectType)
    */
    private static String getByPassField(Schema.sObjectType soType)
    {
        final String originalTypeName = soType.getDescribe().getName();
        String byPassFieldName = null;
        if (originalTypeName.toLowerCase().endsWith('__c')) {
            final Integer index = originalTypeName.toLowerCase().indexOf('__c');
            byPassFieldName = 'Bypass_' + originalTypeName.substring(0, index) + '_Trigger__c';
            //This comment is added if the field name length > 50 to use a hardcoded field name
            //Begin
            /*if(byPassFieldName.length()>50 && originalTypeName == 'ObjectAPIName')
                byPassFieldName = 'Bypass_ObjectAPIName_Trigger__c'; //End
            */
        } else {
            byPassFieldName = 'Bypass_' + originalTypeName + '_Trigger__c';
        } 
        return  byPassFieldName;      
    }

    /**
    * @author Hari Krishnan
    * @date 07/17/2013
    * @description Dispatches to the dispatcher's event handlers.
    * @param ITriggerDispatcher A Trigger dispatcher that dispatches to the appropriate handlers
    */
    private static void execute(ITriggerDispatcher dispatcher)
    {
        TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap,
                                    Trigger.isBefore, Trigger.isAfter, Trigger.isDelete,
                                    Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting);
        // Handle before trigger events
        if (Trigger.isBefore) {
            dispatcher.bulkBefore();
            if (Trigger.isDelete)
                dispatcher.beforeDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.beforeInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.beforeUpdate(tp);
        }
        else    // Handle after trigger events
        {
            dispatcher.bulkAfter();
            if (Trigger.isDelete)
                dispatcher.afterDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.afterInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.afterUpdate(tp);
            else if (Trigger.isUndelete)
                dispatcher.afterUnDelete(tp);
        }
        dispatcher.andFinally();
    }

    /**
    * @author Hari Krishnan
    * @date 07/17/2013
    * @description Gets the appropriate dispatcher based on the SObject. It constructs the instance of the dispatcher
    *               dynamically using the Type API. The name of the dispatcher has to follow this format:
    *               <ObjectName>TriggerDispatcher. For e.g. for the Feedback__c object, the dispatcher has to be named
    *               as FeedbackTriggerDispatcher.
    * @param Schema.sObjectType Object type to create the dispatcher
    * @return ITriggerDispatcher A trigger dispatcher  if one exists or null.
    */
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType)
    {
        String originalTypeName = soType.getDescribe().getName();
        String dispatcherTypeName = null;
        if (originalTypeName.toLowerCase().endsWith('__c')) {
            Integer index = originalTypeName.toLowerCase().indexOf('__c');
            dispatcherTypeName = originalTypeName.substring(0, index) + 'TriggerDispatcher';
            //This part is added by Ammara-Plumlogix due to Class Name is greater than 40 error for IB_Verification_Visit_Feedback__c,as part of Satff Aug. US-11546
            //Begin
            if(dispatcherTypeName.length()>23 && originalTypeName == 'IB_Verification_Visit_Feedback__c')
                dispatcherTypeName = 'IB_VVFeedback_TriggerDispatcher'; //End
        }
        else
            dispatcherTypeName = originalTypeName + 'TriggerDispatcher';

        Type obType = Type.forName(dispatcherTypeName);
        ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
        return dispatcher;
    }
}