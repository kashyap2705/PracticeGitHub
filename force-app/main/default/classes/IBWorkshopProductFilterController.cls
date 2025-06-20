public with sharing class IBWorkshopProductFilterController {

	public String programme = 'All';
	public String category = 'All';
	public String language = 'All';
	public Date availableFrom; 
	public Date availableTo; 

	// used for pagincation
	private Integer counter = 0;
	private Integer listSize = 10;
	public Integer totalSize;

	// this is a hack to get the DatePicker JS on the VF page
	public IB_Workshop_Products__c dateHack { get; set; }

	public IBWorkshopProductFilterController() {
		
	}

	public List<IB_Workshop_Products__c> getWorkshopProducts() {

    	String soql = 
    		'SELECT Id, Name, Available_From__c, Available_To__c, Delivery_Mode__c, IB_Category__c, IB_Programme__c, ' + 
    			'IB_Region__c, Language_of_Delivery__c, IB_Workshop_Title_ENG__c, IB_Workshop_Detail__c ' +
    		'FROM IB_Workshop_Products__c ';

    	soql += 'WHERE (Available_From__c > :availableFrom OR Available_From__c = NULL) AND (Available_To__c < :availableTo OR Available_To__c = NULL) ';

    	if (programme != 'All') {
    		soql += 'AND IB_Programme__c = :programme ';
    	}

    	if (category != 'All') {
    		soql += 'AND IB_Category__c = :category ';
    	}

    	if (language != 'All') {
    		soql += 'AND Language_of_Delivery__c = :language ';
    	}

        List<Profile> profile = [
            SELECT Id, Name 
            FROM Profile 
            WHERE Id = :userinfo.getProfileId() 
            LIMIT 1
        ];
        String profileName = profile[0].Name;

        // external pd providers should not see online or blended workshops, all other should
        if (profileName == 'External PD Provider') {
            soql += 'AND Delivery_Mode__c NOT IN (\'Online\', \'Blended\') ';
        }

    	List<IB_Workshop_Products__c> workshopProducts = Database.query(soql);
    	totalSize = workshopProducts.size();

    	soql += 'LIMIT :listSize OFFSET :counter';
    	workshopProducts = Database.query(soql);

    	return workshopProducts;

    }

	public PageReference filter() {
		counter = 0;
        return null;
    }

    public PageReference beginning() { //user clicked beginning
		counter = 0;
		return null;
	}

	public PageReference previous() { //user clicked previous button
		counter -= listSize;
		return null;
	}

	public PageReference next() { //user clicked next button
		counter += listSize;
		return null;
	}

	public PageReference end() { 
		counter = totalSize - math.mod(totalSize, listSize);
		return null;
	}

    public String getProgramme() {
        return programme;
    }
            
    public void setProgramme(String programme) {
        this.programme = programme;
    }

    public String getCategory() {
        return category;
    }
            
    public void setCategory(String category) {
        this.category = category;
    }

    public String getLanguage() {
        return language;
    }
            
    public void setLanguage(String language) {
        this.language = language;
    }

    public Date getAvailableFrom() {
        return availableFrom;
    }
            
    public void setAvailableFrom(Date availableFrom) {
        this.availableFrom = availableFrom;
    }

    public Date getAvailableTo() {
        return availableTo;
    }
            
    public void setAvailableTo(Date availableTo) {
        this.availableTo = availableTo;
    }
     
	private static list<SelectOption> getPicklistValues(String objectAPI, String fieldAPI) {
      list<SelectOption> optionsToReturn = new list<SelectOption>{};
      String[] types = new String[]{objectAPI};
      Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
      for(Schema.DescribeSobjectResult res : results) {
         for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldAPI).getDescribe().getPicklistValues()) {
            if (entry.isActive()) {
                optionsToReturn.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
         }
      }
      return optionsToReturn;
   }
    
    public List<SelectOption> getProgrammeItems() {
		List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('All','All'));
         options.addAll(getPicklistValues('IB_Workshop_Titles__c','Programme__c'));
       
        return options;

    }

    public List<SelectOption> getCategoryItems() {

        List<IB_Workshop_Products__c> wpList = [SELECT IB_Category__c FROM IB_Workshop_Products__c];
        Set<String> wpSet = new Set<String>();
        List<SelectOption> options = new List<SelectOption>();

        for (IB_Workshop_Products__c x : wpList) {
            wpSet.add(x.IB_Category__c);
        }

        options.add(new SelectOption('All','All'));
        for (String y : wpSet) {
            if (y != null) {
            	options.add(new SelectOption(y,y));
            }
        }

        return options;

    }

    public List<SelectOption> getLanguageItems() {

        List<IB_Workshop_Products__c> wpList = [SELECT Language_of_Delivery__c FROM IB_Workshop_Products__c];
        Set<String> wpSet = new Set<String>();
        List<SelectOption> options = new List<SelectOption>();

        for (IB_Workshop_Products__c x : wpList) {
            wpSet.add(x.Language_of_Delivery__c);
        }

        options.add(new SelectOption('All','All'));
        for (String y : wpSet) {
            if (y != null) {
            	options.add(new SelectOption(y,y));
            }
        }

        return options;

    }

	public Boolean getDisablePrevious() { 
		if (counter > 0) {
			return false; 
		}
		else { 
			return true;
		}
	}

	public Boolean getDisableNext() { 
		if (counter + listSize < totalSize) {
			return false; 
		}
		else {
			return true;
		}
	}

	public Integer getTotal_size() {
		return totalSize;
	}

	public Integer getPageNumber() {
		return counter/listSize + 1;
	}

	public Integer getTotalPages() {
		if (math.mod(totalSize, listSize) > 0) {
			return totalSize/listSize + 1;
		} 
		else {
			return (totalSize/listSize);
		}
	}

}