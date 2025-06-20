public class PDCatalogService {

    public static List<PD_Catalog__c> catalog = null;
    public static Boolean isCatalogCached = false;

    public static List<PD_Catalog__c> getFullCatalog() {

        if (!isCatalogCached) {

            PDCatalogDAO dao = PDCatalogDao.getInstance();
            catalog = dao.getFullCatalog();
            isCatalogCached = true;

        }

        return catalog;

    }

    public static List<SelectOption> getYearOptions() {

        catalog = getFullCatalog();

        List<SelectOption> options = new List<SelectOption>();
		Set<String> standardSet = new Set<String>();

        for (PD_Catalog__c item : catalog) {
			standardSet.add(item.Year__c);
		}

		for (String standardOption : standardSet) {
			options.add(new SelectOption(standardOption, standardOption));
		}

		return options;

    }

    /*public static List<SelectOption> getStandardOptions() {

		actionPlan = getActionPlanByProgramme();

		List<SelectOption> options = new List<SelectOption>();
		Set<String> standardSet = new Set<String>();

		for (IB_Action_Plan__c item : actionPlan) {
			standardSet.add(item.AP_Standard_Practice__r.Standard__c);
		}

		for (String standardOption : standardSet) {
			options.add(new SelectOption(standardOption, standardOption));
		}

		return options;

	}*/

}