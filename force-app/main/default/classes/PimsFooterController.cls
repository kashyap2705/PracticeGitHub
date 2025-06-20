public with sharing class PimsFooterController {

	public PimsFooterController() {}

	public Integer getCurrentYear() {
		Date today = Date.today();
		return today.year();
	}

}