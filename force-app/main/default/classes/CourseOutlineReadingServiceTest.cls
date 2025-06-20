@isTest
private class CourseOutlineReadingServiceTest {

     @isTest
     static void testCourseOutlineReadingServiceMethod1() {
         IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog; 
        
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        insert aa; 
         
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;    
        insert cor;
         
        CourseOutlineReadingService.setReadingId(cor.Id); 
        CourseOutlineReadingService.getCourseOutlineReadingById();
     }
    @isTest
     static void testCourseOutlineReadingServiceMethod2() {
        IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog; 
         
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id; 
        insert aa; 

        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;    
        insert cor;

         
        CourseOutlineReadingService.readings = new List<Course_Outline_Reading__c>{cor}; 
        CourseOutlineReadingService.setSubjectId(aa.Id);
        CourseOutlineReadingService.setProgrammeId(prog.Id); 
        CourseOutlineReadingService.getCourseOutlineReadingBySubject();
     }
    @isTest
     static void testCourseOutlineReadingServiceMethod3() {
         IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog; 
        
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        insert aa; 
         
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;    
        insert cor;
         
        CourseOutlineReadingService.setProgrammeId(prog.Id); 
        CourseOutlineReadingService.getCourseOutlinesReadingsByProgramme();
     }
    
    @isTest
     static void testCourseOutlineReadingServiceMethod4() {
        IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog; 
        IB_Programme__c prog2 = PimsTestUtil.createProgramme();
        insert prog2;
         
        IB_Subject__c sub = new IB_Subject__c();
        sub.IB_Programme__c = prog2.id; 
        insert sub; 

        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        aa.Type__c = 'Course outline'; 
        insert aa; 
        IB_Application_Attachment__c aa2 = new IB_Application_Attachment__c(); 
        aa2.IB_Programme__c = prog2.Id;
        aa2.Type__c = 'Course outline'; 
        aa2.IB_Subject__c = sub.id; 
        insert aa2;  
        
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;    
        insert cor;
         
        CourseOutlineReadingService.createCourseOutlineReadings(new Set<Id>{prog.Id, prog2.Id}); 
     }
}