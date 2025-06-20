public class InstituteSearchTabComponentController {
    public static string phone{get;set;}
    
    public static string acId;
    public static string rolId;
    public String citySelected{get; set;}
    public static string emailId{get;set;}
    public static boolean error {get; set;}
    
    private void getPageIds()
    {
        acId = apexpages.currentpage().getparameters().get('AccountId');
        rolId=apexpages.currentpage().getparameters().get('roleId');
        emailId=apexpages.currentpage().getparameters().get('emailId');
        
    }
    public List<SelectOption> getcitynames()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('--None--','--None--'));
        List<IB_Country_Segmentation__c>CountrySegmentationList=[SELECT Name,Country_Code__c FROM IB_Country_Segmentation__c WHERE Country_Code__c!=NUll Order By Name ASC ];
        for (Integer j=0;j<CountrySegmentationList.size();j++)
        {
            options.add(new SelectOption(CountrySegmentationList[j].Country_Code__c,CountrySegmentationList[j].Country_Code__c ));
            
        }
        
        return options;
        
    }
    public pageReference createPhone() {
        pageReference pg;
        error=false;
        try
        {
            getPageIds();
            pg= new PageReference ('/ibportal/InstituteApplyForRole');
            
            if(citySelected!='--None--' && phone!=Null &&phone.length()>6 &&phone.length()<=15 && Phone.isNumeric())
            {
                String []str=citySelected.split('\\(');
                
                String []strFinal=str[1].split('\\)');
                
                
                String FinalPh='';
                String countCode=strFinal[0];
                FinalPh=FinalPh+'+';
                for(Integer x=1;x<countCode.length();x++)
                {
                    if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57))
                    {
                        
                        FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
                    }
                }
                
                String PhoneNumber='';
                
                
                String strPh=phone;
                Boolean check=false;
                for(Integer x=0;x<strPh.length();x++)
                {
                    if(strPh.charAt(x)!=48)
                    {
                        check=true;
                    }
                    if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) && check==true )
                    {
                        
                        PhoneNumber=PhoneNumber+String.valueOf((strPh.charAt(x)-48));
                    }
                    
                    
                    
                }
                
                
                
                FinalPh=FinalPh+PhoneNumber;
                
                phone=FinalPh;
                
                
                System.debug('ERRORPhone'+phone);
                
                
                
                pg.getParameters().put('AccountId',acId);
                pg.getParameters().put('roleId',rolId);
                pg.getParameters().put('emailId',emailId);
                pg.getParameters().put('phoneId',phone);
             /*   
                List<User> u=[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
                Contact_information__c ci=new Contact_information__c();
                ci.Phone__c=phone;
                ci.Recordtypeid=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId();
                ci.IB_Contact__c=u[0].contactId;
                insert ci;*/
                
                
                pg.setRedirect(true);
                
                
            }
            else
            {
                pg.getParameters().put('AccountId',acId);
                pg.getParameters().put('roleId',rolId);
                pg.getParameters().put('emailId',emailId);        
                pg.getParameters().put('errorId','InvalidPhone');
                
                error=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Phone Format'));
                
            }
        }
        catch(exception e)
        {
            System.debug('ERROR');
            System.debug(e);
            
        }
        
        return pg;
        
        
        
    }
    
    public  pageReference CancelPhone() {
        getPageIds();
        pageReference pg;
        pg= new PageReference ('/ibportal/InstituteApplyForRole');
        pg.getParameters().put('AccountId',acId);
        pg.getParameters().put('roleId',rolId);
        pg.getParameters().put('emailId',emailId);
        pg.setRedirect(true);
        return pg;
    }
    
    
}