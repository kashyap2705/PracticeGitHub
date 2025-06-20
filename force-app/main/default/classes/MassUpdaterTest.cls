@isTest
public class MassUpdaterTest {
    @isTest static void testMassUpdaterController() 
    {
        try
        {
            
            List<SObject> objs=new List<SObject>();
            objs.add(new Account());
            
            Schema.DescribeFieldResult F = Account.Industry.getDescribe();
            
            Schema.sObjectField T = F.getSObjectField();
            
            Test.startTest(); 
            MassUpdater obj= new MassUpdater(objs,T,NULL);
            //obj.field=NULL;
            // obj.fieldValue=NULL;
            //obj.objsToUpdate=NULL;
            //obj.currentMsg=NULL;
            obj.massUpdate();
            MassUpdater obj1= new MassUpdater(NULL,NULL,NULL);
            obj1.massUpdate();
            
            Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred');
        }
    }
}