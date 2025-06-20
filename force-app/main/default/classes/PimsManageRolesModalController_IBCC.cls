public with sharing class PimsManageRolesModalController_IBCC {

    // These constants may need to live on a service/DAO class somewhere?
    private static final String PROGRAMME_COORDINATOR = 'Programme Coordinator';
    private static final String HEAD_OF_SCHOOL = 'Head of School';
    private static final String BILLING_CONTACT = 'Billing Contact';
    private static final String EXAM_CONTACT = 'Exam Contact';

    public List<RoleAssignment> contactsByRole {get;set;}
    private Set<String> assignedRoles;
    private String theProgram {get;set;}
    private List<String> allowableRoles;
    private String programmeId;
    private Boolean setterAlreadyRan;


    public PimsManageRolesModalController_IBCC(){

        // Record Type Name of IB_Programme_New__c
        theProgram = 'CP';

        contactsByRole = new List<RoleAssignment>();
        assignedRoles = new Set<String>();

        // List role names that need to be set for this programme
        allowableRoles = new List<String>{
            PROGRAMME_COORDINATOR,
            HEAD_OF_SCHOOL,
            BILLING_CONTACT,
            EXAM_CONTACT
        };

        setterAlreadyRan = false;
    }


    public Account theAccount {
        get;
        set{
            // http://salesforce.stackexchange.com/questions/34819/setter-executes-twice-when-attributes-are-defined-on-components
            if(!setterAlreadyRan){
                setterAlreadyRan = true;
                theAccount = value;
                buildRoles();
            }
        }
    }


    private void buildRoles(){

        // Gets programme Id
        for(IB_Programme__c tmp : [select id from IB_Programme__c where Account__c = :theAccount.Id AND recordType.Name = :theProgram order by CreatedDate DESC]){
            programmeId = tmp.Id;
        }

        List<IB_Role__c> roles = new List<IB_Role__c>([
            SELECT  Id, IB_Role_Name__c, IB_Role_Name_es__c,
                    IB_Role_Name_fr__c, IB_Role__r.Role_Name__c, IB_Contact__c,
                    IB_Programme_New__r.RecordType.Name, IB_Programme_New__c
            FROM    IB_Role__c
            WHERE   IB_Account__c =: theAccount.Id
                AND IB_Role_Name__c IN :allowableRoles
                AND (End_Date__c = null OR End_Date__c > TODAY)
                AND IB_Programme_New__c = :programmeId//IB_Programme_New__r.RecordType.Name =: theProgram
            ORDER BY CreatedDate DESC
        ]);

        for(IB_Role__c tmp : roles){

            // Only need one active assignment for each role in our list.
            // Trigger should handle any data issues regarding duplicate
            // active assignments.
            if(assignedRoles.contains(tmp.IB_Role__r.Role_Name__c)){
                continue;
            }

            assignedRoles.add(tmp.IB_Role__r.Role_Name__c);
            contactsByRole.add(new RoleAssignment(
                tmp,
                theAccount
            ));
        }

        // Get any unassigned roles that are needed for this programme
        List<IB_Role_Repository__c> tmpRoles = [
            SELECT Id, Role_Name__c, Role_Name_es__c, Role_Name_fr__c, Related_Programmes__c
            FROM IB_Role_Repository__c
            WHERE Role_Name__c NOT IN :assignedRoles
                AND Related_Programmes__c includes (:theProgram) // TODO: Account for IBCC
                AND Role_Name__c IN :allowableRoles
            ORDER BY CreatedDate DESC
        ];

        for(IB_Role_Repository__c tmp : tmpRoles){

            RoleAssignment tmpRnC = new RoleAssignment(
                new IB_Role__c(
                    IB_Role__c = tmp.Id,
                    IB_Programme_New__c = programmeId
                ),
                theAccount
            );

            if (UserInfo.getLanguage() == 'es') {
                tmpRnC.roleName = tmp.Role_Name_es__c;
            }
            else if (UserInfo.getLanguage() == 'fr') {
                tmpRnC.roleName = tmp.Role_Name_fr__c;
            }
            else {
                tmpRnC.roleName = tmp.Role_Name__c;
            }

            tmpRnC.conOptions.add(PimsManageRolesModalController_IBCC.getNoneOption());
            tmpRnC.chosenContact = '';
            contactsByRole.add(tmpRnC);
        }

        contactsByRole.sort();
    }


    public PageReference doUpdate(){

        if(contactsByRole.size() > 0){

            List<IB_Role__c> newRoles = new List<IB_Role__c>();

            // If EXAM_CONTACT is being cleared out with no new assignment
            List<IB_Role__c> examRolesToClose = new List<IB_Role__c>();

            for(RoleAssignment tmp : contactsByRole){

                // If EXAM_CONTACT is being cleared out
                if(tmp.isExamContact && String.isBlank(tmp.chosenContact) && String.isNotBlank(tmp.initialChoice)){

                    tmp.chosenContact = tmp.initialChoice;
                    tmp.therole.IB_Contact__c = tmp.initialChoice;

                    examRolesToClose.add(tmp.theRole);
                    continue;
                }

                if((tmp.wasChanged || tmp.isNew) && String.isNotBlank(tmp.chosenContact)){
                    newRoles.add(copyRole(tmp));
                }
            }

            if(!examRolesToClose.isEmpty()){

                for(IB_Role__c tmp : examRolesToClose){
                    tmp.End_Date__c = Date.today();
                }

                update examRolesToClose;
            }

            if(!newRoles.isEmpty()){
                insert newRoles;
            }
        }

        PageReference tmpRef = Page.PimsDashboard;
        tmpRef.setRedirect(true);

        return tmpRef;
    }

    @testVisible
    private IB_Role__c copyRole(RoleAssignment arg){

        IB_Role__c tmpRole = new IB_Role__c(
            IB_Contact__c = arg.chosenContact,
            IB_Role__c = arg.theRole.IB_Role__c != null ? arg.theRole.IB_Role__c : null,
            OwnerId = IBRoleDAO.INSTANCE.getDefaultRoleOwnerId(),
            Status__c = 'Applicant',
            IB_Account__c = arg.theAccount.Id,
            IB_Programme_New__c = arg.theRole.IB_Programme_New__c,
            Programme_Selection__c = theProgram,
            Start_Date__c = Date.today()
        );

        return tmpRole;
    }


    public PageReference doCancel(){

        PageReference tmpRef = Page.PimsDashboard;
        tmpRef.setRedirect(true);
        return tmpRef;
    }


    public class RoleAssignment implements comparable{

        public final String initialChoice{get;set;}
        public String roleName {get;set;}
        public String chosenContact {get;set;}
        public List<SelectOption> conOptions {get;set;}
        public IB_Role__c theRole {get;set;}
        public Account theAccount {get;set;}
        public Boolean isExamContact {get;set;}
        public Boolean isNew {get;set;}
        public Boolean wasChanged {get{return !(chosenContact == initialChoice);}set;}


        public RoleAssignment(IB_Role__c r, Account a){

            theRole = r;
            theAccount = a;
            chosenContact = theRole.IB_Contact__c;
            initialChoice = theRole.IB_Contact__c;
            isExamContact = false;
            conOptions = availableContacts;
            isNew = false;

            if (UserInfo.getLanguage() == 'es') {
                roleName = r.IB_Role_Name_es__c;
            }
            else if (UserInfo.getLanguage() == 'fr') {
                roleName = r.IB_Role_Name_fr__c;
            }
            else {
                roleName = r.IB_Role_Name__c;
            }

            // Allows the Exam Contact Role to have a "None" option
            if(PimsManageRolesModalController_IBCC.EXAM_CONTACT == r.IB_Role__r.Role_Name__c){

                //conOptions.add(PimsManageRolesModalController_IBCC.getNoneOption());
                isExamContact = true;
            }
        }


        public List<SelectOption> availableContacts{
            get{
                if(availableContacts == null){
                    availableContacts = new List<SelectOption>();

                    // TODO: Modify logic to leverage profileService
                    for(Contact tmp : [select Id, FirstName, LastName from Contact where AccountId =: theAccount.Id OR Id = :chosenContact]){
                        availableContacts.add(new SelectOption(
                            tmp.Id,
                            tmp.FirstName + ' ' + tmp.LastName
                        ));
                    }
                }

                return availableContacts;
            }
            set;
        }


        public Integer compareTo(Object compareTo){

            // Sort role name alphabetically
            RoleAssignment compareToEmp = (RoleAssignment)compareTo;
            if (roleName == compareToEmp.roleName) return 0;
            if (roleName > compareToEmp.roleName) return 1;
            return -1;
        }
    }


    // None option is used for EXAM_CONTACT roles as well as when a
    // school is assigning roles for the first time.
    public static SelectOption getNoneOption(){
        return new SelectOption(
            '',
            '--- ' + Label.IBENPortal_shared_None + ' ---'
        );
    }


    public String getUserLanguageKey() {
       return UserInfo.getLanguage();
    }
}