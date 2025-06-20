@isTest
private class ActionPlanTest {
    
    @isTest 
    static void testActionPlanService() {
        
        IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog;
        
        Standards_Practices__c sp1 = PimsTestUtil.createStandardPractice('Standard A: Philosophy', 'Practice Test 1', true, false, true, false, '1');
        insert sp1;
        Standards_Practices__c sp2 = PimsTestUtil.createStandardPractice('Standard A: Philosophy', 'Practice Test 2', false, true, false, true, '2');
        insert sp2;
        Standards_Practices__c sp3 = PimsTestUtil.createStandardPractice('Standard A: Philosophy', 'Practice Test 3', true, true, true, true, '3');
        insert sp3;
        Standards_Practices__c sp4 = PimsTestUtil.createStandardPractice('Standard A: Philosophy', 'Practice Test 4', false, false, false, false, '4');
        insert sp4;
        
        IB_Action_Plan__c ap1 = PimsTestUtil.createActionPlan(prog.Id, sp1.Id, 'status');
        insert ap1;
        IB_Action_Plan__c ap2 = PimsTestUtil.createActionPlan(prog.Id, sp2.Id, 'status');
        insert ap2;
        IB_Action_Plan__c ap3 = PimsTestUtil.createActionPlan(prog.Id, sp3.Id, 'status');
        insert ap3;
        IB_Action_Plan__c ap4 = PimsTestUtil.createActionPlan(prog.Id, sp4.Id, 'status');
        insert ap4;
        
        try {
            ActionPlanService.getActionPlanByProgramme();
        } catch (Exception e) { }
        try {
            ActionPlanService.getActionPlanItem();
        } catch (Exception e) { }
        
        ActionPlanService.setProgrammeId(prog.Id);
        List<IB_Action_Plan__c> apList = ActionPlanService.getActionPlanByProgramme();
        
        ActionPlanService.setItemId(ap1.Id);
        IB_Action_Plan__c apItem = ActionPlanService.getActionPlanItem();
        
        ActionPlanService.getStandardOptions();
        ActionPlanService.getStatusOptions();
        
        ActionPlanService.setStandard('Standard A: Philosophy');
        ActionPlanService.setStatus('All');
        ActionPlanService.setStage('All');
        ActionPlanService.setApType('All');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('Required');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('In Progress');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setStage('Candidacy');
        ActionPlanService.setApType('All');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('Required');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('In Progress');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setStage('Authorization');
        ActionPlanService.setApType('All');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('Required');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
        ActionPlanService.setApType('In Progress');
        ActionPlanService.getFilteredActionPlan();
        ActionPlanService.isFilteredPlanCached = false;
        
    }

}