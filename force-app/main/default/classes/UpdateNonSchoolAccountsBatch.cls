global class UpdateNonSchoolAccountsBatch implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        set<id>AccrecTypes=new set<id>();
        //Getting the record types from Schema
     /*   AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'IB_Institute'
            ).getRecordTypeId()
        );*/
        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'Exhibitor_Account'
            ).getRecordTypeId()
        );
        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'External_PD_Provider_Account'
            ).getRecordTypeId()
        );
        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'Governmental_Bodies'
            ).getRecordTypeId()
        );
        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'Groups_of_School'
            ).getRecordTypeId()
        );
        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'School_Districts'
            ).getRecordTypeId()
        );

        AccrecTypes.add(
            Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                'University_Account'
            ).getRecordTypeId()
        );
        
        //Passing the account values to update
        return Database.getQueryLocator(
            [select id,IBIS_id__c,name from account where
                                  Recordtypeid IN:AccrecTypes 
                                   And ibis_id__c = null                    ]
        );
    }
    global void execute(Database.BatchableContext bc,List <Account> NonSchoolAccts) {

        for(Account a:NonSchoolAccts)
        {
            if(MaxNonSchoolCodeValue()<99999){
                a.IBIS_ID__c='N0'+String.valueOf(MaxNonSchoolCodeValue());
            }
            else
            {
                a.IBIS_ID__c='N'+String.valueOf(MaxNonSchoolCodeValue());
                
            }
           
        }
        update NonSchoolAccts;
    }
integer MaxNonSchoolCodeValue()
{
    List<Account> AccMax=[SELECT Ibis_id__c FROM Account where ibis_id__c Like 'N%'order by Ibis_id__c DESC limit 1];
    if(AccMax.size()>0)
    {
       string value= AccMax[0].Ibis_id__c.substring(1, AccMax[0].ibis_id__c.length());
        return Integer.valueOf(value)+1;
    }

    return 50000;
}    
    
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    
    
}