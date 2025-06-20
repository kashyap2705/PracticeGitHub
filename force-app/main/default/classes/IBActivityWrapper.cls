global class IBActivityWrapper implements Comparable{
	
  public IBActivity myActivity;
  
  public IBActivityWrapper(IBActivity activity) {
    myActivity = activity;
  }
  
  global Integer compareTo(Object compareTo) {

    IBActivityWrapper compareToMyActivity = (IBActivityWrapper)compareTo;
    
    Integer returnValue = 0;
    if (myActivity.StartDate > compareToMyActivity.myActivity.StartDate) {
      returnValue = 1;
    }
    else if (myActivity.StartDate < compareToMyActivity.myActivity.StartDate) {
      returnValue = -1;
    }
    
    return returnValue;     
  }
}