public class ProgrammeService {

	public static IB_Programme__c programme = null;
	public static List<IB_Programme__c> programmes = null;
    public static List<ProgrammeName> programmeNames = null;

	public static Boolean isProgrammeCached = false;
	public static Boolean isProgrammesCached = false;
    public static Boolean isProgrammeNamesCached = false;

	public static Id accountId = null;
	public static Id programmeId = null;

	public static IB_Programme__c getProgramme() {
        
        try
        {

		if (!isProgrammeCached) {

			if (programmeId == null) {
				throw new CustomValidationException('The value for programmeId cannot be null.');
			}

			ProgrammeDAO dao = ProgrammeDAO.getInstance();
			programme = dao.getProgrammeById(programmeId);
			isProgrammeCached = true;

		}

		return programme;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            
            System.debug('this class failed '+x);
            return NULL;
        }

	}

	public static List<IB_Programme__c> getProgrammesByAccount() {
try
{
		if (!isProgrammesCached) {

			if (accountId == null) {
				throw new CustomValidationException('The value for accountId cannot be null.');
			}

			ProgrammeDAO dao = ProgrammeDAO.getInstance();
			programmes = dao.getProgrammesByAccountId(accountId);
			isProgrammesCached = true;

		}

		return programmes;
}
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}

    public static Boolean accountHasProgramme(String prog) {
try
{
        getProgrammesByAccount();

		Boolean has = false;
		RecordType recType = RecordTypeService.getRecordTypeByTypeAndName('IB_Programme__c', prog);

		for (IB_Programme__c p : programmes) {
			if (p.RecordTypeId == RecType.Id) {
				has = true;
			}
		}

		return has;
}
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}

	public static void setProgrammeId(Id progId) {
		programmeId = progId;
	}

	public static void setAccountId(Id accId) {
		accountId = accId;
	}

	public static IB_Application__c getApplication(){
        try
        {

		ApplicationService.setProgrammeId(programmeId);
		IB_Application__c mostRecentApp;

		for(IB_Application__c tmp : ApplicationService.getApplications()){
			//checking for one-off scenarios
			if(mostRecentApp == null || mostRecentApp.CreatedDate < tmp.CreatedDate){
				mostRecentApp = tmp;
			}
		}

		return mostRecentApp;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
	}

	public static Set<String> getAfaStatusByRecType(List<IB_Programme__c> progs){
try
{
		System.debug(LoggingLevel.ERROR, progs.size());

		Set<String> result = new Set<String>();

		List<Id> progIDlist = new List<Id>();

		for(IB_Programme__c tmp : progs){
			System.debug(LoggingLevel.ERROR, 'adding to progIDlist');
			progIDlist.add(tmp.Id);
		}

		System.debug(LoggingLevel.ERROR, 'progIDlist.size() : ' + progIDlist.size());
		ApplicationService.setProgrammeIdList(progIDlist);

		for(IB_Application__c tmp :ApplicationService.getApplicationsByProgrammeIds()){

			if(tmp.RecordType.Name != 'Application for Authorization'){
				continue;
			}

			if(tmp.AFA_Available_to_School__c){
				result.add(
					tmp.Application_Lookup_to_Programme__r.RecordType.Name
				);
			}
		}

		System.debug(LoggingLevel.ERROR, 'result.size() : ' + result.size());

		return result;
    }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
	}

	public static void loadProgrammeNames() {
        try
        {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<ProgrammeName> names = new List<ProgrammeName>();

        for (Schema.SObjectType s : gd.values()) {
            if (s.getDescribe().getName().startsWith('Programme_') && s.getDescribe().isCustomSetting()) {
                sObject sobj = Database.query('SELECT ReferenceId__c, LongNameEN__c, LongNameES__c, LongNameFR__c, ShortNameEN__c, ShortNameES__c, ShortNameFR__c FROM ' + s.getDescribe().getName());
                ProgrammeName pn = new ProgrammeName();
                pn.referenceId = String.valueOf(sobj.get('ReferenceId__c'));
                pn.longNameEN = String.valueOf(sobj.get('LongNameEN__c'));
                pn.longNameES = String.valueOf(sobj.get('LongNameES__c'));
                pn.longNameFR = String.valueOf(sobj.get('LongNameFR__c'));
                pn.shortNameEN = String.valueOf(sobj.get('ShortNameEN__c'));
                pn.shortNameES = String.valueOf(sobj.get('ShortNameES__c'));
                pn.shortNameFR = String.valueOf(sobj.get('ShortNameFR__c'));
                names.add(pn);
            }
        }
        
        programmeNames = names;
        isProgrammeNamesCached = true;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
           
        }
        
    }
    
    public static String getProgrammeShortName(String ref) {
        try
        {
        if (!isProgrammeNamesCached) {
            loadProgrammeNames();
        }
        
        for (ProgrammeName pn : programmeNames) {
            if (pn.referenceId == ref) {
                return pn.shortNameEN;
            }
        }
        
        return null;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static String getProgrammeLongNameTranslated(String ref) {
        try
        {
        if (!isProgrammeNamesCached) {
            loadProgrammeNames();
        }
        
        for (ProgrammeName pn : programmeNames) {
            if (pn.referenceId == ref) {
                if (UserInfo.getLanguage() == 'fr') {
                    return pn.longNameFR;
                } else if (UserInfo.getLanguage() == 'es') {
                    return pn.longNameES;
                } else {
                    return pn.longNameEN;
                }
            }
        }
        
        return null;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static String getProgrammeShortNameTranslated(String ref) {
        try
        {
        if (!isProgrammeNamesCached) {
            loadProgrammeNames();
        }
        
        for (ProgrammeName pn : programmeNames) {
            if (pn.referenceId == ref) {
                if (UserInfo.getLanguage() == 'fr') {
                    return pn.shortNameFR;
                } else if (UserInfo.getLanguage() == 'es') {
                    return pn.shortNameES;
                } else {
                    return pn.shortNameEN;
                }
            }
        }
        
        return null;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static List<ProgrammeName> getProgrammeNames() {
        try
        {
        if (!isProgrammeNamesCached) {
            loadProgrammeNames();
        }
        
        return programmeNames;
            }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public class ProgrammeName {
        
        public String referenceId { get; set; }
        public String longNameEN { get; set; }
        public String longNameES { get; set; }
        public String longNameFR { get; set; }
        public String shortNameEN { get; set; }
        public String shortNameES { get; set; }
        public String shortNameFR { get; set; }
        
    }
  
}