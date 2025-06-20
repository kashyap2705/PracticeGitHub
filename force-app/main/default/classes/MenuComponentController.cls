public with sharing class MenuComponentController {
    private List<MenuItem> menus;
	
	public MenuComponentController() {
		   menus = new List <MenuItem>();
		   menus.add(new MenuItem (true , 'Home','siteHomePage') );
		   //  menus.add(new MenuItem (false , 'Detail','www.yahoo.com') );
		   //  menus.add(new MenuItem (true  , 'Registration','www.google.com') );
		   //  menus.add(new MenuItem (false , 'Contact us','www.yahoo.com') );


	}
	
	public List<MenuItem> getMenus() {
		return menus;
	}
	
	public class MenuItem {
		
		final private String label;
		final private String link;
		final private Boolean selected;
		
		
		public MenuItem (Boolean selected, String label, String link ) {
			//TODO: Should be check for not null.
			this.selected = selected;
			this.label = label;
			this.link = link;
		}
		
		
		public String getLabel () {
			return label;
		}
		
		public String getLink () {
			return link;
		}
		
		public Boolean getSelected () {
			return selected;
		} 
		 
		public Boolean equals(Object obj) {
            
            if (obj instanceof MenuItem) {
            	
                MenuItem menu = (MenuItem)obj;
                
                return ((this.label.equals(menu.label)) && (this.link.equals(menu.link)));
            }
            
            return false;
        }

        public Integer hashCode() {
        	 Integer hash = 7;
             hash = hash * 31 + (this.label == null ? 0 : label.HashCode());
             hash = hash * 31 + (this.link == null ? 0 : link.HashCode());
           return hash;
        }
		
	} 
}