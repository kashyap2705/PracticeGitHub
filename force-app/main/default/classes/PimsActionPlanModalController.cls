public without sharing class PimsActionPlanModalController extends PimsApplicationControllerHelper { 
    
	//public IB_Action_Plan__c actionItem { get; set; }
	public String practiceFilter { get; set; }
	public String actionType { get; set; }

	public PimsActionPlanModalController() {

		//IB_Programme__c programme = ProgrammeService.getProgramme();
		//actionItem = new IB_Action_Plan__c(Programme__c = programme.Id);

	}
    
    public String getFunctionSafeName() {
        return practiceFilter.replace('-', '_');
    }
    
    public String getProgrammeId() {
        IB_Programme__c programme = ProgrammeService.getProgramme();
        return programme.Id;
    }
	
    @RemoteAction
	public static String create(Id progId, String actionType, String practiceUniqueId, String status, String description) {
        
        IB_Action_Plan__c actionItem = new IB_Action_Plan__c(
            Programme__c = progId,
            AP_Action_Type__c = actionType,
            AP_Status__c = status,
            AP_Action_Description__c = description
        );

        try {
            
            ProgrammeService.setProgrammeId(progId);
            IB_Programme__c programme = ProgrammeService.getProgramme();
            
            String filter = practiceUniqueId;
            if (programme.RecordType.Name == 'PYP') {
                filter = filter + '-PYP';
            }
            if (programme.RecordType.Name == 'MYP') {
                filter = filter + '-MYP';
            }
            if (programme.RecordType.Name == 'Diploma Programme') {
                filter = filter + '-DP';
            }
            if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
                filter = filter + '-CP1';
            }
            if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
                filter = filter + '-CP2';
            }
         
			Standards_Practices__c practice = StandardsPracticesService.getStandardAndPracticeByPracticeIdFilter(filter);

            if (practice == null) {
                practice = StandardsPracticesService.getStandardAndPracticeByPracticeIdFilter(practiceUniqueId);
            }
			actionItem.AP_Standard_Practice__c = practice.Id;

            insert actionItem;
            
            return 'Success';

        }
        catch (Exception ex) {

            return ex.getMessage();

        }

    }

}