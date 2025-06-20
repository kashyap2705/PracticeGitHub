public with sharing class MyActivitiesComponentController {

	public static IBActivity assignment {get; set;}
    public static IBActivity event {get; set;}// added by kashyap as a part of phase 3 754
	public String activityCssClass;
	public String LinkColor {get;set;}
	
  public MyActivitiesComponentController() {
      
      system.debug('assignment on MyActivitiesComponentController***'+assignment);
  	  assignment = null;
      event= null;// added by kashyap as a part of phase 3 754
	}
	

	public String getActivityCssClass(){
		activityCssClass = 'activity';
		
		if(assignment.ApplicationStatus == null){
			return activityCssClass;
		}
		else if(assignment.ApplicationStatus.toLowerCase().contains('pending') || 
				assignment.ApplicationStatus.toLowerCase().contains('under approval') || 
				assignment.ApplicationStatus.toLowerCase().contains('sélection en attente') || 
				assignment.ApplicationStatus.toLowerCase().contains('pendiente de seleccionar') || 
				assignment.ApplicationStatus.toLowerCase().contains('en attente dapprobation') || 
				assignment.ApplicationStatus.toLowerCase().contains('en proceso de aprobación')
			){
			return activityCssClass + ' pending';  //orange
		}
		else if(assignment.ApplicationStatus.toLowerCase().contains('confirmed') ||
				assignment.ApplicationStatus.toLowerCase().contains('confirmé') ||
				assignment.ApplicationStatus.toLowerCase().contains('confirmado')
			){
			return activityCssClass + ' confirmed';  //green
		}
		else if(assignment.ApplicationStatus.toLowerCase().contains('invited') ||
				assignment.ApplicationStatus.toLowerCase().contains('invité') ||
				assignment.ApplicationStatus.toLowerCase().contains('invitado') 
			){
			return activityCssClass + ' invited';  //blue
		}
		else{
			//do nothing
		}
		return activityCssClass; //default dark grey
	}


	public Boolean getIsAssignment(){
		return IBActivity.isAssignment(assignment);
	}  
	
	public Boolean getIsMyAssignment(){
		return IBActivity.isMyAssignment(assignment);
	}

	public Boolean getIsEditMyCurrentAssignment(){
		return IBActivity.isEditMyCurrentAssignment(assignment);
	}
	
	public Boolean getIsTraining(){
		return IBActivity.isTraining(assignment);
	}
    
    	public Boolean getIsCase(){
		return IBActivity.isCase(assignment);
	}

	public Boolean getIsMyTraining(){
		return IBActivity.isMyTraining(assignment);
	}
	
	public Boolean getIsEditMyCurrentTraining(){
		return IBActivity.isEditMyCurrentTraining(assignment);
	}
	
	public Boolean getHasEventCity(){
		return IBActivity.hasEventCity(assignment);
	}
	
	public Boolean getHasEventRegion(){
		return IBActivity.hasEventRegion(assignment);
	}
	
	public Boolean getSameMonths(){
		return IBActivity.hasSameMonths(assignment);
	}
		
	public Boolean getNotSingleDay(){
		return IBActivity.isNotSingleDay(assignment);
	}
	
	public static PageReference editAssignment(){
    String url = '/Exception';
    url = '/MyAssignmentDetails?id=' + assignment.EventId + '&action=EDIT';
    PageReference view = new PageReference (url);
    view.setRedirect(true);        
    return view;
  }

	public static PageReference editTraining(){
		System.debug('calling editTraining().');
    //String url = '/Exception';
    String url = '/MyTrainingDetails?id=' + assignment.EventId + '&action=EDIT';
    System.debug('url is ' + url);
    PageReference view = new PageReference(url);
    view.setRedirect(true);
    return view;
  }

}