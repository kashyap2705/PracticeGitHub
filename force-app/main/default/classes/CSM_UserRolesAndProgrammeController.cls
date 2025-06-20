/**
 * @description       : Controller class to get the confirmed user roles and programmes
 * @author            : Charan Kumar
 * @last modified on  : 03-21-2024
 * @last modified by  : Charan Kumar
 * @last modified by  : Atticus Fernandes on 16-04-2024
 **/
public with sharing class CSM_UserRolesAndProgrammeController {
    /**
     * @description : Get the confirmed logged in user roles and programmes
     * @author      : Charan Kumar | 03-21-2024
     * @return      : Map<String, RolesAndProgrammes>
     **/
    @AuraEnabled(cacheable=true)
    public static Map<String, RolesAndProgrammes> getConfirmedRolesMap() {
        List<IB_Role__c> ibRoles;
        Map<String, RolesAndProgrammes> rolesAndProgrammes = new Map<String, RolesAndProgrammes>();
        Set<String> preDefinedProgrammeNames = new Set<String>{'DP','CP','MYP','PYP'}; // Added by Atticus  on 16-04-2024
        try {
            ibRoles = getConfirmedUserRoles();
            for (IB_Role__c ibRole : ibRoles) {
                if (!rolesAndProgrammes.containsKey(ibRole.IB_Role_Name__c)) {
                    RolesAndProgrammes roleAndProgrammes = new RolesAndProgrammes();
                    roleAndProgrammes.role = ibRole;
                    roleAndProgrammes.programmes = new List<String>();
                    roleAndProgrammes.programmesFullName = new List<String>();
                    rolesAndProgrammes.put(ibRole.IB_Role_Name__c, roleAndProgrammes);
                }
                // Modified by Atticus on 16-04-2024 [Start]
                if(ibRole.Programme_Selection__c == null || !preDefinedProgrammeNames.contains(ibRole.Programme_Selection__c)){
                    rolesAndProgrammes.get(ibRole.IB_Role_Name__c).programmes.addAll(preDefinedProgrammeNames);
                    for(String prg : preDefinedProgrammeNames){
                        rolesAndProgrammes.get(ibRole.IB_Role_Name__c).programmesFullName.add(CSM_IboUtil.programmeMap.get(prg));
                    }
                }else{
                    rolesAndProgrammes.get(ibRole.IB_Role_Name__c).programmes.add(ibRole.Programme_Selection__c);
                    rolesAndProgrammes.get(ibRole.IB_Role_Name__c).programmesFullName.add(CSM_IboUtil.programmeMap.get(ibRole.Programme_Selection__c));     
                }
                // End
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return rolesAndProgrammes;
    }

    /**
     * @description : Get the confirmed logged in user roles
     * @author      : Charan Kumar | 03-21-2024
     * @return      : List<IB_Role__c>
     **/
    @AuraEnabled(cacheable=true)
    public static List<IB_Role__c> getConfirmedUserRoles() {
        List<IB_Role__c> ibRoles = new List<IB_Role__c>();
        try {
            Id userId = UserInfo.getUserId();
            ibRoles = [
                SELECT Id, IB_Contact__c, First_Name__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, Programme_Selection__c, Role_Type__c, External_Role_Type__c
                FROM IB_Role__c
                WHERE IB_Contact__r.User__r.Id = :userId AND Status__c = :CSM_IboUtil.CONFIRMED_STATUS
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return ibRoles;
    }

    public class RolesAndProgrammes {
        @AuraEnabled
        public IB_Role__c role;
        @AuraEnabled
        public List<String> programmes;
        @AuraEnabled
        public List<String> programmesFullName;
    }
}