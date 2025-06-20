public class MyAssignmentsComponentController{
	
	public IBActivity assignment {get; set;}
	public Boolean hasUpcomingAssignments {get; set;}
	public String activityCssClass;
	
  public MyAssignmentsComponentController() {
  	assignment = null;
	}
	
	
	public Boolean getSameMonths(){
		Integer startMonth = assignment.StartDate.month();
		Integer endMonth = assignment.EndDate.month();
		
		if(startMonth == endMonth){
			return true;
		}
		
		return false;
	}
	
	
	public String getActivityCssClass(){
		activityCssClass = 'activity';
		
		if(assignment.ApplicationStatus.toLowerCase().contains('pending') || assignment.ApplicationStatus.toLowerCase().contains('under approval')){
			return activityCssClass + ' pending';  //orange
		}
		else if(assignment.ApplicationStatus.toLowerCase().contains('confirmed')){
			return activityCssClass + ' confirmed';  //green
		}
		else if(assignment.ApplicationStatus.toLowerCase().contains('invited')){
			return activityCssClass + ' invited';  //blue
		}
		else{
			//do nothing
		}
		return activityCssClass; //default dark grey
	}


}