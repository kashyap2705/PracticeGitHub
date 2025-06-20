public class FutureHelper {
	
	public static boolean allowFuture = true;

	public static void stopFuture(){
		allowFuture = false;
	}

	public static boolean canIRun(){
		return allowFuture;
	}		
	
}