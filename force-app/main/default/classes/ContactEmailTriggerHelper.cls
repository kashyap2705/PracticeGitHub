public class ContactEmailTriggerHelper {

	public static void setProgrammeDefaultRoleEmails(List<ContactEmail__c> emails) {

		List<IB_Programme__c> progs = new List<IB_Programme__c>();

		for (ContactEmail__c email : emails) {

			RoleService.isRolesByContactCached = false;
			RoleService.setContactId(email.Contact__c);
			List<IB_Role__c> roles = RoleService.getRolesByContactId();

			for (IB_Role__c role : roles) {

				if (email.Account__c == role.IB_Account__c && role.IB_Programme_New__c != null) {

					if (role.IB_Role_Name__c == 'Head of School') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Head_of_School_Email__c = email.EmailAddress__c
						);
						progs.add(prog);
					}

					if (role.IB_Role_Name__c == 'Programme Coordinator') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Programme_Coordinator_Email__c = email.EmailAddress__c
						);
						progs.add(prog);
					}

					if (role.IB_Role_Name__c == 'Billing Contact') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Billing_Contact_Email__c = email.EmailAddress__c
						);
						progs.add(prog);
					}

				}

			}

		}
        
        if (!progs.isEmpty()) {
            update progs;
        }

	}
    
    public static void deleteProgrammeDefaultRoleEmails(List<ContactEmail__c> emails) {

		List<IB_Programme__c> progs = new List<IB_Programme__c>();

		for (ContactEmail__c email : emails) {

			RoleService.isRolesByContactCached = false;
			RoleService.setContactId(email.Contact__c);
			List<IB_Role__c> roles = RoleService.getRolesByContactId();

			for (IB_Role__c role : roles) {

				if (email.Account__c == role.IB_Account__c) {

					if (role.IB_Role_Name__c == 'Head of School') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Head_of_School_Email__c = null
						);
						progs.add(prog);
					}

					if (role.IB_Role_Name__c == 'Programme Coordinator') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Programme_Coordinator_Email__c = null
						);
						progs.add(prog);
					}

					if (role.IB_Role_Name__c == 'Billing Contact') {
						IB_Programme__c prog = new IB_Programme__c(
							Id = role.IB_Programme_New__c,
							Billing_Contact_Email__c = null
						);
						progs.add(prog);
					}

				}

			}

		}
        
        if (!progs.isEmpty()) {
            update progs;
        }

	}

}