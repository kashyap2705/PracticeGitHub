@isTest
private class AssignmentCtrlTest {
    
    @isTest
    static void assignmentCtrlTestMethod()
    {
        AssignmentsCtrl obj = new AssignmentsCtrl();
        obj.assignments=NULL;
        obj.test = 'foo';
        obj.getAssignments();
        obj.getTest();
    }

}