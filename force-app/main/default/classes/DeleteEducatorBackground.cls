public without sharing class DeleteEducatorBackground {

    public DeleteEducatorBackground() {}

    public String backgroundId {get;set;}

    public PageReference deleteBackground(){
        IB_E_Background__c toDelete = new IB_E_Background__c();

        IBEBackgroundDAO ibeDao = IBEBackgroundDAO.INSTANCE;

        toDelete = ibeDao.getIBEBackgroundById(backgroundId);

        if(toDelete.Id != null){
            UserDAO userD = UserDAO.getInstance();

            if (toDelete.IB_Contact__c == userD.getCurrentUser().ContactId){
                delete toDelete;
            }
        }

        PageReference page = null;

        try{
        if(System.Site.getName() == 'IBEN_Central')
            page = new PageReference('/myProfile?selectedTab=experience');
        if(System.Site.getName() == 'ibportal')
            page = new PageReference('/IBPortalEditProfile');
        page.setRedirect(true);
        } catch(Exception e){}
        
        return page;
    }
}