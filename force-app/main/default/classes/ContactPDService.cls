public class ContactPDService {

     public static List<Contact_Professional_Development__c> proDevByRole = null;
     public static List<Contact_Professional_Development__c> proDevByRoleList = null;
     public static List<Contact_Professional_Development__c> proDevBySubject = null;

     public static Boolean isPdByRoleCached = false;
     public static Boolean isPdBySubjectCached = false;
     public static Boolean isPdByRoleListCached = false;

     public static Id roleId = null;
     public static Id subjectId = null;
     public static List<Id> roleList = null;

     public static List<Contact_Professional_Development__c> getSProfessionalDevelopmentBySubjectId() {

          if (!isPdBySubjectCached) {

               if (subjectId == null) {
               	throw new CustomValidationException('The value for subjectId cannot be null.');
               }

               ContactPDDAO dao = ContactPDDAO.getInstance();
               proDevBySubject = dao.getProDevBySubjectId(subjectId);
               isPdBySubjectCached = true;
		}
		return proDevBySubject;
     }

     public static List<Contact_Professional_Development__c> getSProfessionalDevelopmentByRoleId() {

          if (!isPdByRoleCached) {

			if (roleId == null) {
				throw new CustomValidationException('The value for roleId cannot be null.');
			}

               ContactPDDAO dao = ContactPDDAO.getInstance();
               proDevByRole = dao.getProDevByRoleId(roleId);
               isPdByRoleCached = true;
		}
		return proDevByRole;
     }

     public static List<Contact_Professional_Development__c> getProfessionalDevelopmentByRoleList() {

          if (!isPdByRoleListCached) {

			if (roleList == null) {
                    throw new CustomValidationException('The value for roleList cannot be null.');
			}

               ContactPDDAO dao = ContactPDDAO.getInstance();
               proDevByRoleList = dao.getProDevByRoleList(roleList);
               isPdByRoleListCached = true;
		}
          return proDevByRoleList;
     }

     public static void setRoleId(Id rolId) {
          roleId = rolId;
	}

     public static void setRoleList(List<Id> rolList) {
          roleList = rolList;
	}

     public static void setSubjectId(Id subId) {
          subjectId = subId;
     }
}