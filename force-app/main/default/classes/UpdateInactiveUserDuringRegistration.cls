public without sharing class UpdateInactiveUserDuringRegistration implements Queueable { 
    public ID userID ;
    public String Email ;
    public UpdateInactiveUserDuringRegistration(ID userID, String Email){
        this.userID = userID ;  
        this.Email  = Email;
    }
    
    
    public void execute(QueueableContext context) {
          
        User  isPortalUser =  [ SELECT isActive,ID ,Email, isPortalEnabled from user where ID = : userID  ];
        if(isPortalUser != NULL)
        {
            isPortalUser.IsActive = TRUE;
            isPortalUser.Email =Email;
            isPortalUser.UserName =Email;
            system.debug('The is updated Portal User' + isPortalUser);    
            update isPortalUser;
            
            System.resetPassword(isPortalUser.ID,true);
            system.debug('The is updated Portal User' + isPortalUser);    
            update isPortalUser;
        }
    }
}