public class PimsPageMessagesController { 

	public Boolean getPageHasErrorMessages() {
   		return ApexPages.hasMessages(ApexPages.Severity.ERROR);
   	}

	public Boolean getPageHasSuccessMessage() {
   		return ApexPages.hasMessages(ApexPages.Severity.CONFIRM);
   	}

}