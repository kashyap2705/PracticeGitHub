public class PimsApplicationRedirectController {

    
    Public List<IB_Application__c> appList{get;set;}
    
	public PimsApplicationRedirectController() {

	}

	public PageReference init() {
       

		if (ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('id') == '') {

			return new PageReference('/pims/PimsDashboard');

		}
		else {

            String forceType ='';
			 forceType = ApexPages.currentPage().getParameters().get('type');

            
			
            List<IB_Application__c> applications;
            if(!Test.isRunningTest())
            {
                ApplicationService.setProgrammeId(ApexPages.currentPage().getParameters().get('id'));
			 applications = ApplicationService.getApplications();
            }
            else if(Test.isRunningTest())
            {
              applications=appList;  
            }
            

			for (IB_Application__c app : applications) {

				if(!String.isBlank(forceType)){
					if (app.RecordType.Name == 'Application for Authorization' && forceType.equalsIgnoreCase('auth')) {
						return new PageReference('/pims/PimsApplicationForAuthorization?id=' + app.Id);
					}

					if (app.RecordType.Name == 'Application for Candidacy' && forceType.equalsIgnoreCase('can')) {
						return new PageReference('/pims/PimsApplicationForCandidacy?id=' + app.Id);
					}
				}

				else if (app.RecordType.Name == 'Application for Authorization') {
					return new PageReference('/pims/PimsApplicationForAuthorization?id=' + app.Id);
				}

				else if (app.RecordType.Name == 'Application for Candidacy') {
					return new PageReference('/pims/PimsApplicationForCandidacy?id=' + app.Id);
				}
			}
		}

		return new PageReference('/pims/PimsDashboard');
        }
       

    

}