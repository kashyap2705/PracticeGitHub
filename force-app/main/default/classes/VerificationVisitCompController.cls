public class VerificationVisitCompController {

    public ID Camp; 
    public integer TMA{get;set;}
    
    public My_staffing_event__c TL{get;set;}
    public My_staffing_event__c TM1{get;set;}
    public My_staffing_event__c TM2{get;set;}
    public String TM2Name{get;set;}
    

public ID getCamp(){ 
TL=null;
TM1=null;
TM2 = null;
TMA = 0;  
    return Camp; }    

public void setCamp(ID s){
            Camp = s;
            TL=null;
TM1=null;
TM2 = null;
TMA = 0;  
setAtts();
           
}
Public void setAtts()
{
    system.debug('test');
    list <My_staffing_event__c> TLs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Leader' AND Application_Status__c ='Confirmed' Limit 1];
    list <My_staffing_event__c> TMs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Member' AND Application_Status__c ='Confirmed' Limit 2];
    if(TLs.size()>0 && TMs.size()>0  )
    for(integer i=0;i< TMs.size();i++)
    {
        if(i==0)    
        {
            TL = TLs[i];
            TM1 = TMs[i];
        }
        else
        {
            TMA = 1;
            Tm2 = Tms[i];
            Tm2Name=' and '+Tms[i].IB_Contact__r.name;
        }
    }
    else
    {
    campaign campn= [select id,name from campaign where id=:Camp limit 1];
    system.debug('add error');
    campn.addError('Required field.');
    
    }
    
    
    
}    
    
}