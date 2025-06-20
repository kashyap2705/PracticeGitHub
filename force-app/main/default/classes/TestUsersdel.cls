public class TestUsersdel
{

@Future
public static void delusers()
{

Map<String, String> m = new Map<String, String>();
    m.put('*Basim Test', 'Deactivated Users - Level 1');
    m.put('Answers Global', 'Customer Service - Level 2');
    m.put('Call For Papers', 'Deactivated Users - Level 1');
    m.put('Cases Access Only', 'Deactivated Users - Level 1');
    m.put('Comms Manager Global', 'Deactivated Users - Level 1');
    m.put('Comms User Global', 'Deactivated Users - Level 1');
    m.put('Customer Community Advanced OLD', 'Customer Community Advanced');
    m.put('Customer Community Basic OLD', 'Customer Community Basic');
    m.put('Deactivated Users', 'Deactivated Users - Level 1');
    m.put('Educator Customer Portal AP', 'Customer Community Basic');
    m.put('Educator Customer Portal User', 'Customer Community Basic');
    m.put('Employee Apps', 'Community Management - Level 1');
    m.put('ERD management', 'Deactivated Users - Level 1');
    m.put('Finance AEM', 'Finance - Level 2');
    m.put('Finance Americas', 'Finance - Level 2');
    m.put('Finance AP', 'Finance - Level 2');
    m.put('Global PD', 'PD Development - Level 2');
    m.put('Global PD Provider', 'Deactivated Users - Level 1');
    m.put('Head of School Approver', 'Deactivated Users - Level 1');
    m.put('IBA IBEN New', 'IBEN - Level 2');
    m.put('IBA Professional Development', 'Deactivated Users - Level 1');
    m.put('IBAEM IBEN New', 'IBEN - Level 2');
    m.put('IBAEM Professional Development', 'Deactivated Users - Level 1');
    m.put('IBAP IBEN New', 'IBEN - Level 2');
    m.put('IBAP Professional Development', 'Deactivated Users - Level 1');
    m.put('Integration Connector', 'Deactivated Users - Level 1');
    m.put('Knowledge', 'Deactivated Users - Level 1');
    m.put('Online PD AEM', 'Online PD - Level 2');
    m.put('Online PD Global', 'Online PD - Level 2');
    m.put('PD AEM', 'PD Delivery AEM - Level 2');
    m.put('PD Americas', 'PD Delivery Americas - Level 2');
    m.put('PD AP', 'PD Delivery AP - Level 2');
    m.put('Product Management Global', 'Deactivated Users - Level 1');
    m.put('PYP Development', 'Deactivated Users - Level 1');
    m.put('Read Only AEM', 'School Services - Level 1');
    m.put('Read Only Americas', 'Deactivated Users - Level 1');
    m.put('Read Only AP', 'Deactivated Users - Level 1');
    m.put('Read Only CC', 'Reporting - Level 1');
    m.put('Rec & Dev AEM', 'Recognition & Development - Level 2');
    m.put('Rec & Dev Americas', 'Recognition & Development - Level 2');
    m.put('Rec & Dev AP', 'Recognition & Development - Level 2');
    m.put('Regional Administrator AEM', 'School Services - Level 3');
    m.put('Regional Administrator Americas LA', 'School Services - Level 3');
    m.put('Regional Administrator Americas NA', 'School Services - Level 3');
    m.put('Regional Administrator AP', 'School Services - Level 3');
    m.put('School Community User', 'SCU + Advanced');
    m.put('School Community User OLD', 'SCU + Advanced');
    m.put('School Services AEM', 'School Services - Level 2');
    m.put('School Services AEM Ops', 'School Services - Level 3');
    m.put('School Services Americas', 'School Services - Level 2');
    m.put('School Services Americas w L1', 'School Services - Level 2');
    m.put('School Services AP', 'School Services - Level 2');
    m.put('School Services Global', 'School Services - Level 2');
    m.put('SCU + Advanced OLD', 'SCU + Advanced');
    m.put('SCU + Basic OLD', 'SCU + Basic');
    m.put('Senior Administrator Americas LA', 'School Services - Level 3');
    m.put('Service Administrator', 'Customer Service - Level 3');
    m.put('Service Agent', 'Customer Service - Level 2');
    m.put('System Admin Read Only', 'Security & Compliance - Level 4');
    m.put('System Administrator Communities', 'Deactivated Users - Level 1');
    m.put('System Administrator Non Expiring', 'System Integration - Level 3');
    m.put('System Administrator Read Only', 'Reporting - Level 1');
    m.put('System Administrator View Encrypted Data', 'Deactivated Users - Level 1');
    m.put('System Integration Read Only', 'System Integration - Level 1');
    m.put('System Integration Read Write', 'System Integration - Level 3');
    m.put('Test License Change', 'Deactivated Users - Level 1');
    
    for (String str : m.keySet())
    {
        list<user> us = [select id,Profile.name from user where  Profile.name=:str];
        profile p = [select id,name from profile where name=: m.get(str)];
        
        for (user u : us)
        {
            u.ProfileId=p.id;
        }
        //update us;
    
    }

}



}