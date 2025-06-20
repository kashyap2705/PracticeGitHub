public class MyTrainingsComponentController {

	public IBActivity training {get; set;}
	
	public void MyTrainingsComponentController(){
		training = new IBActivity();
	} 

	public Boolean getIsMyTraining(){
		return IBActivity.isMyTraining(training);
	}

	public Boolean getIsEligTraining(){
		return IBActivity.isEligibleTraining(training);
	}

	public Boolean getHasEventCity(){
		return IBActivity.hasEventCity(training); 
	}	
	
	public Boolean getHasEventCountry(){ 
		return IBActivity.hasEventCountry(training); 
	}
	
	public Boolean getHasEventRegion(){
		return IBActivity.hasEventRegion(training);
	}
	
	public Boolean getSameMonths(){
		return IBActivity.hasSameMonths(training);
	}
		
	public Boolean getNotSingleDay(){
		return IBActivity.isNotSingleDay(training);
	}


}