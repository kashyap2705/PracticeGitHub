@isTest
private class MenuComponentControllerTest {
	
	@isTest
	private static void test(){
		
		MenuComponentController controller = new MenuComponentController();
		
		System.assert(controller.getMenus().size() > 0);
		
		MenuComponentController.MenuItem item = new MenuComponentController.MenuItem(true , 'far_Home', 'siteHomePage');
		
		System.assert('far_Home' == item.getLabel());
		System.assert('siteHomePage' == item.getLink());
		System.assert(item.getSelected());
		
		MenuComponentController.MenuItem defaultItem = controller.getMenus().get(0);
		
		System.assert(defaultItem.hashCode() != item.hashCode());
		System.assert(item.hashCode() == item.hashCode());
		
		System.assert(! defaultItem.equals(item));
		System.assert(! item.equals(defaultItem));
		System.assert(item.equals(item));
		System.assert(! item.equals(new Contact()));
		
	}
}