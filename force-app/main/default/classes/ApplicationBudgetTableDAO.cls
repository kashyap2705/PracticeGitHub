public class ApplicationBudgetTableDAO {

    private Application_Budget_Table__c applicationBudgetTable;
    private List<Application_Budget_Table__c> applicationBudgetTableList;

    public List<Application_Budget_Table__c> getApplicationAccountFacilitiesByApplicationId (Id appId) {

        applicationBudgetTableList = [
            SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
                PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
                USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
                Pro_Dev_Item__c, Other_Item__c, Id, Name
            FROM Application_Budget_Table__c
            WHERE IB_Application_Lookup__c = :appId
        ];

        return applicationBudgetTableList;
    }
}