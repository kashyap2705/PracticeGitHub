/**
 * @description       : Controller class to get the category structure and knowledge articles for home and help topics page
 * @author            : Vikash Kumar
 * @last modified on  : 03-25-2024
 * @last modified by  : Vikash Kumar
 * @last modified by  : Atticus Fernandes on 16-04-2024
 **/
public without sharing class CSM_DescribeDataCategoryGroupStructures {
    private static Map<String,String> categorySpanishMap;
    private static Map<String,String> categoryFrenchMap;
    private static Map<String,String> categoryEnglishMap;
   //private static Map<String,Map<String,KnowledgeDetails>> knowledgeMap;
    private static Map<String,List<String>> categoryKnowledgeMap;
    private static Map<String,List<String>> knowledgeRoleMap;
    private static Map<String,List<String>> knowledgeProgramMap;
    private static Map<String,KnowledgeDetails> knowledgeDetailMap;
	private static Map<String,Set<String>> roleProgramMap;
	private static Map<String,Map<String,List<CategoryProgram>>> roleCategoryLevel1Map;
	private static Map<String,Map<String,List<CategoryProgram>>> roleCategoryLevel2Map;
	/*
	*********************************************************
	@description    : main method to create category structure along with respective knowledge articles
	@param          : Boolean, String, String
	@return         : List<CategoryStructure> 
	********************************************************
	*/
    @AuraEnabled(cacheable=true)
    public static List<CategoryStructure> 
    getDataCategoryGroupStructure(Boolean isGuest,String userID, String userLang){
    
		roleCategoryLevel1Map = new Map<String,Map<String,List<CategoryProgram>>>();
        roleCategoryLevel2Map = new Map<String,Map<String,List<CategoryProgram>>>();
        List<String> roleGroupList; 
        List<String> programList;
        Set<String> roleGroupSet;
        Set<String> programSet;
	    List<CategoryStructure> categoryStructureFinalList = new List<CategoryStructure>();
        roleProgramMap = new Map<String,Set<String>>();
        categorySpanishMap = new Map<String,String>();
        categoryFrenchMap = new Map<String,String>();
        categoryEnglishMap = new Map<String,String>();
        categoryKnowledgeMap = new Map<String,List<String>>();
        knowledgeRoleMap = new Map<String,List<String>>();
        knowledgeProgramMap = new Map<String,List<String>>();
        knowledgeDetailMap = new Map<String,KnowledgeDetails>();
        Set<String> prgSet = new Set<String>{CSM_IboUtil.DP, CSM_IboUtil.CP, CSM_IboUtil.MYP, CSM_IboUtil.PYP}; 
        // Added by Atticus 12-04-2024
    try {
        if(isGuest){
		roleGroupList = new List<String>{CSM_IboUtil.PARENT_Role, CSM_IboUtil.WORKSHOP_Role, CSM_IboUtil.OTHER_Role};
		programList = new List<String>{CSM_IboUtil.DP, CSM_IboUtil.CP, CSM_IboUtil.MYP, CSM_IboUtil.PYP}; 
        }else{
	    List<IB_Role__c> ibRoleList = [SELECT Id,Programme_Selection__c, External_Role_Type__c FROM IB_Role__c where IB_Contact__r.User__r.Id = :userID and Status__c =: CSM_IboUtil.CONFIRMED_STATUS];
            roleGroupSet = new Set<String>();
            programSet = new Set<String>();
            for(IB_Role__c roleObj:ibRoleList){
                roleGroupSet.add(roleObj.External_Role_Type__c);
                // Modified logic by Atticus on 16-04-2024
                if(roleObj.Programme_Selection__c != null && prgSet.contains(roleObj.Programme_Selection__c)){
                    programSet.add(roleObj.Programme_Selection__c);
                    if(!roleProgramMap.containsKey(roleObj.External_Role_Type__c)){
                        Set<String> programmeSet = new Set<String>();
                        programmeSet.add(roleObj.Programme_Selection__c);
                        roleProgramMap.put(roleObj.External_Role_Type__c,programmeSet);
                    }else{ 
                        roleProgramMap.get(roleObj.External_Role_Type__c).add(roleObj.Programme_Selection__c);
                    }
                }else{
                    programSet.addAll(prgSet);
                    if(!roleProgramMap.containsKey(roleObj.External_Role_Type__c)){
                        Set<String> programmeSet = new Set<String>();
                        programmeSet.addAll(prgSet);
                        roleProgramMap.put(roleObj.External_Role_Type__c,programmeSet);
                    }else{ 
                        roleProgramMap.get(roleObj.External_Role_Type__c).addAll(programSet);
                    }
                }
                // End
            }
            roleGroupList = new List<String>(roleGroupSet);
            programList = new List<String>(programSet);
        }
        getCategoryDetails(roleGroupList,programList,isGuest);	
		fetchKnowledgeArticles(userLang);
        if(!roleGroupList.isEmpty()){
            for(String role:roleGroupList){
                System.debug(role);
                System.debug(userLang);
                CategoryStructure catStruct = new CategoryStructure();
                catStruct.roleName = role;
                catStruct.language = userLang;
                List<Categorylevel1Detail> categorylevel1FinalList = new List<Categorylevel1Detail>();
                if(!roleCategoryLevel1Map.isEmpty()){
                    Map<String,List<CategoryProgram>> categorylevel1GroupNameMap = roleCategoryLevel1Map.get(role);
                    Map<String,List<CategoryProgram>> categorylevel2GroupNameMap = roleCategoryLevel2Map.get(role);
                    if(!categorylevel1GroupNameMap.isEmpty()){
                        for(String level1:categorylevel1GroupNameMap.keyset()){
                            Categorylevel1Detail catLevel1Obj = new Categorylevel1Detail();
                            catLevel1Obj.level1CategoryName = getCategoryName(userLang,level1);
                            catLevel1Obj.level1CategoryId = level1;
                            List<Categorylevel2Detail> categorylevel2FinalList = new List<Categorylevel2Detail>();
                            List<String> level1ProgramList = new List<String>();
                            for(CategoryProgram level2:categorylevel1GroupNameMap.get(level1)){
                                Categorylevel2Detail catLevel2Obj = new Categorylevel2Detail();
                                catLevel2Obj.level2CategoryName = getCategoryName(userLang,level2.categoryName);
                                catLevel2Obj.level2CategoryId = level2.categoryName;
                                catLevel2Obj.level2Program = level2.program.split(';');
                                level1ProgramList.addAll(catLevel2Obj.level2Program);
								catLevel2Obj.level2Knowledge = getKnowledge(level2.categoryName,level1, role,catLevel2Obj.level2Program);
                                List<Categorylevel3Detail> categorylevel3FinalList = new List<Categorylevel3Detail>();
                                if(categorylevel2GroupNameMap.containsKey(level2.categoryName)){
                                    for(CategoryProgram level3:categorylevel2GroupNameMap.get(level2.categoryName)){
                                        Categorylevel3Detail catLevel3Obj = new Categorylevel3Detail();
                                        catLevel3Obj.level3CategoryName = getCategoryName(userLang,level3.categoryName);
                                        catLevel3Obj.level3CategoryId = level3.categoryName;
                                        catLevel3Obj.level3Program = level3.program.split(';');
										catLevel3Obj.level3Knowledge = getKnowledge(level3.categoryName,level2.categoryName,role,catLevel3Obj.level3Program);
                                        categorylevel3FinalList.add(catLevel3Obj);
                                    }                     
                                }
                                catLevel2Obj.level2ChildName = categorylevel3FinalList;
                                categorylevel2FinalList.add(catLevel2Obj);
                            }
                            Set<String> level1ProgramSet = new Set<String>(level1ProgramList);
                            catLevel1Obj.level1Program = new List<String>(level1ProgramSet);
                            catLevel1Obj.level1ChildName = categorylevel2FinalList;
							catLevel1Obj.level1Knowledge = getKnowledge(level1,level1,role,catLevel1Obj.level1Program);
                            categorylevel1FinalList.add(catLevel1Obj);                              
                        }
                    }
                }
                catStruct.categoryDetails = categorylevel1FinalList;
                categoryStructureFinalList.add(catStruct);      
            }
                
        }
        system.debug( 'categorylevel1FinalList-->'+ JSON.serialize(categoryStructureFinalList));
        return categoryStructureFinalList;
	}
	catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    } 
	/*
	*********************************************************
	@description    : Method to fetch knowledge articles and category dependencies
	@param          : String
	@return         : Void
	********************************************************
	*/
	private static void fetchKnowledgeArticles(String userLang){

		Map<String,String> articleVersionParentMap = new Map<String,String>();
		for(KnowledgeArticleVersion knowledgeVersion: [SELECT id, KnowledgeArticleId,MasterVersionId,Language  from KnowledgeArticleVersion  where PublishStatus =:CSM_IboUtil.ARTICLE_Publish_Status_ONLINE and Language =:userLang] ){
			articleVersionParentMap.put(knowledgeVersion.MasterVersionId,knowledgeVersion.Id);
		
		}
		Map<Id,knowledge__kav> knowledgeInfoMap  = new Map<Id,knowledge__kav>([SELECT Id,FAQ_Answers_Question__c, Language  FROM knowledge__kav where Language =:userLang and PublishStatus =:CSM_IboUtil.ARTICLE_Publish_Status_ONLINE]);

		
        for(Knowledge__DataCategorySelection knowledgeCategory:[SELECT Id, DataCategoryGroupName, DataCategoryName, Parentid,
                                                                Parent.PublishStatus FROM Knowledge__DataCategorySelection where Parent.PublishStatus =: CSM_IboUtil.ARTICLE_Publish_Status_ONLINE])
        {                      
			
			if(!articleVersionParentMap.isEmpty() && articleVersionParentMap.containsKey(knowledgeCategory.Parentid)){
				String parentId = articleVersionParentMap.get(knowledgeCategory.Parentid);
				if(!knowledgeInfoMap.isEmpty() && knowledgeInfoMap.containsKey(parentId)){
					knowledge__kav knowledgeInfo = knowledgeInfoMap.get(parentId);
					if(!knowledgeDetailMap.containsKey(parentId)){
						KnowledgeDetails knowDetail = new KnowledgeDetails();
						knowDetail.knowledgeId = parentId;
						knowDetail.question = knowledgeInfo.FAQ_Answers_Question__c;
						knowDetail.knowledgeProgram = '';
						knowledgeDetailMap.put(parentId,knowDetail);
					} 
				}
				
				if(knowledgeCategory.DataCategoryGroupName == 'IB_Answers'){
					if(!categoryKnowledgeMap.containsKey(knowledgeCategory.DataCategoryName)){
						List<String> tempknowledgeList = new List<String>();
						tempknowledgeList.add(parentId);
						categoryKnowledgeMap.put(knowledgeCategory.DataCategoryName,tempknowledgeList);
					}else{
						categoryKnowledgeMap.get(knowledgeCategory.DataCategoryName).add(parentId);
					}
				}
				if(knowledgeCategory.DataCategoryGroupName == 'IB_Programmes'){
					if(!knowledgeProgramMap.containsKey(parentId)){
						List<String> tempCategoryList = new List<String>();
						tempCategoryList.add(knowledgeCategory.DataCategoryName);
						knowledgeProgramMap.put(parentId,tempCategoryList);
					}else{
						knowledgeProgramMap.get(parentId).add(knowledgeCategory.DataCategoryName);
					}
				}
				if(knowledgeCategory.DataCategoryGroupName == 'IB_Roles'){
					if(!knowledgeRoleMap.containsKey(parentId)){
						List<String> tempCategoryList = new List<String>();
						tempCategoryList.add(knowledgeCategory.DataCategoryName);
						knowledgeRoleMap.put(parentId,tempCategoryList);
					}else{
						knowledgeRoleMap.get(parentId).add(knowledgeCategory.DataCategoryName);
					}
				}
			}
        }
	}
	/*
	*********************************************************
	@description    : Method to fetch all category mapping
	@param          : List<String>,List<String>,Boolean
	@return         : Void
	********************************************************
	*/
	private static void getCategoryDetails(List<String> roleGroupList,List<String> programList,Boolean isGuest ){
        String programAsString = '(\'' + String.join(programList, '\', \'') + '\')';
		roleCategoryLevel1Map = new Map<String,Map<String,List<CategoryProgram>>>();
		roleCategoryLevel2Map = new Map<String,Map<String,List<CategoryProgram>>>();
        List<Category1_2_Mapping__c> tempcat1_2MappingList = new List<Category1_2_Mapping__c>();    
        List<Category2_3_Mapping__c> tempcat2_3MappingList = new List<Category2_3_Mapping__c>();
        List<Category1_2_Mapping__c> cat1_2MappingList = new List<Category1_2_Mapping__c>();    
        List<Category2_3_Mapping__c> cat2_3MappingList = new List<Category2_3_Mapping__c>();
        String queryStr;
		queryStr = 'select id,Category2__r.Label__c,Category2__r.name,Category2__r.French_Name__c,Category2__r.Spanish_Name__c,Category1__r.name,' +
            'Category1__r.French_Name__c,Category1__r.Label__c,Category1__r.Spanish_Name__c,toLabel(IB_Programme__c),IB_Roles__c '  +
            'FROM Category1_2_Mapping__c ' +
            'WHERE IB_Roles__c IN:roleGroupList ' + 'and IB_Programme__c INCLUDES' + programAsString;
        tempcat1_2MappingList = Database.query(queryStr);
        
        queryStr = 'select id,Category2__r.Label__c,Category2__r.name,Category2__r.French_Name__c,Category2__r.Spanish_Name__c,'+
            'toLabel(IB_Programme__c),IB_Roles__c,Category3__r.Label__c, Category3__r.name,Category3__r.French_Name__c,Category3__r.Spanish_Name__c '+ 
            'FROM Category2_3_Mapping__c ' +
            'WHERE IB_Roles__c IN:roleGroupList ' + 'and IB_Programme__c INCLUDES' + programAsString;
        cat2_3MappingList = Database.query(queryStr);
        if(!tempcat1_2MappingList.isEmpty()){
			if(isGuest){
				cat1_2MappingList = tempcat1_2MappingList;
			}else{
				for(Category1_2_Mapping__c cat1_2:tempcat1_2MappingList){ 
					List<String> programmeList = cat1_2.IB_Programme__c.split(';');
					for(String prgm:programmeList){
						String prgmValue = CSM_IboUtil.programMap.get(prgm);
						if(roleProgramMap.get(cat1_2.IB_Roles__c).contains(prgmValue)){
							cat1_2MappingList.add(cat1_2);
						}
					}
				}
			}
        }
        if(!roleGroupList.isEmpty()){
            for(String role:roleGroupList){
                Map<String,List<CategoryProgram>> categorylevel1GroupNameMap = new Map<String,List<CategoryProgram>>();
                if(!cat1_2MappingList.isEmpty()){                   
                    for(Category1_2_Mapping__c cat1_2:cat1_2MappingList){
                        if(cat1_2.IB_Roles__c == role){
                            if(!categoryFrenchMap.containsKey(cat1_2.Category1__r.Name)){
                                categoryFrenchMap.put(cat1_2.Category1__r.Name,cat1_2.Category1__r.French_Name__c);
                            }
                            if(!categoryFrenchMap.containsKey(cat1_2.Category2__r.Name)){
                                categoryFrenchMap.put(cat1_2.Category2__r.Name,cat1_2.Category2__r.French_Name__c);
                            }
                            if(!categorySpanishMap.containsKey(cat1_2.Category1__r.Name)){
                                categorySpanishMap.put(cat1_2.Category1__r.Name,cat1_2.Category1__r.Spanish_Name__c);
                            }
                            if(!categorySpanishMap.containsKey(cat1_2.Category2__r.Name)){
                                categorySpanishMap.put(cat1_2.Category2__r.Name,cat1_2.Category2__r.Spanish_Name__c);
                            }
                            if(!categoryEnglishMap.containsKey(cat1_2.Category1__r.Name)){
                                categoryEnglishMap.put(cat1_2.Category1__r.Name,cat1_2.Category1__r.Label__c);
                            }
                            if(!categoryEnglishMap.containsKey(cat1_2.Category2__r.Name)){
                                categoryEnglishMap.put(cat1_2.Category2__r.Name,cat1_2.Category2__r.Label__c);
                            }

                            if(!categorylevel1GroupNameMap.containsKey(cat1_2.Category1__r.Name)){
                                List<CategoryProgram> tempCat2List = new List<CategoryProgram>();
                                CategoryProgram catPro = new CategoryProgram();
                                catPro.categoryName = cat1_2.Category2__r.Name;
                                catPro.program = cat1_2.IB_Programme__c;
                                tempCat2List.add(catPro);
                                categorylevel1GroupNameMap.put(cat1_2.Category1__r.Name,tempCat2List);
                            }else{
                                CategoryProgram catPro = new CategoryProgram();
                                catPro.categoryName = cat1_2.Category2__r.Name;
                                catPro.program = cat1_2.IB_Programme__c;                
                                categorylevel1GroupNameMap.get(cat1_2.Category1__r.Name).add(catPro);
                            }
                        }
                    }
                }
                Map<String,List<CategoryProgram>> categorylevel2GroupNameMap = new Map<String,List<CategoryProgram>>(); 
                if(!cat2_3MappingList.isEmpty()){               
                    for(Category2_3_Mapping__c cat2_3:cat2_3MappingList){
                        if(cat2_3.IB_Roles__c == role){
                            if(!categoryFrenchMap.containsKey(cat2_3.Category3__r.Name)){
                                categoryFrenchMap.put(cat2_3.Category3__r.Name,cat2_3.Category3__r.French_Name__c);
                            }
                            if(!categorySpanishMap.containsKey(cat2_3.Category3__r.Name)){
                                categorySpanishMap.put(cat2_3.Category3__r.Name,cat2_3.Category3__r.Spanish_Name__c);
                            }
                            if(!categoryEnglishMap.containsKey(cat2_3.Category3__r.Name)){
                                categoryEnglishMap.put(cat2_3.Category3__r.Name,cat2_3.Category3__r.Label__c);
                            }
                            if(!categorylevel2GroupNameMap.containsKey(cat2_3.Category2__r.Name)){
                                List<CategoryProgram> tempCat3List = new List<CategoryProgram>();
                                CategoryProgram catPro = new CategoryProgram();
                                catPro.categoryName = cat2_3.Category3__r.Name;
                                catPro.program = cat2_3.IB_Programme__c;
                                tempCat3List.add(catPro);
                                categorylevel2GroupNameMap.put(cat2_3.Category2__r.Name,tempCat3List);
                            }else{
                                CategoryProgram catPro = new CategoryProgram();
                                catPro.categoryName = cat2_3.Category3__r.Name;
                                catPro.program = cat2_3.IB_Programme__c;                
                                categorylevel2GroupNameMap.get(cat2_3.Category2__r.Name).add(catPro);
                            }
                        }
                    }
                }
                roleCategoryLevel1Map.put(role,categorylevel1GroupNameMap);
                roleCategoryLevel2Map.put(role,categorylevel2GroupNameMap);
            }
        }
	}
    /*
	*********************************************************
	@description    : Method to get category name on basis of user language
	@param          : String,String
	@return         : String
	********************************************************
	*/
    private static String getCategoryName(String language,String categoryName){
        if(language == 'es'){
            return categorySpanishMap.get(categoryName);
        }else if(language == 'fr'){
            return categoryFrenchMap.get(categoryName);
        }else{
            return categoryEnglishMap.get(categoryName);
        }
    }
    /*
	*********************************************************
	@description    : Method to fetch knowledge on basis of category name, roles and program
	@param          : List<String>,List<String>,Boolean
	@return         : List<KnowledgeDetails>
	********************************************************
	*/
    private static List<KnowledgeDetails> getKnowledge(String categoryName,String parentCategoryName,String roleName,List<String> programName){
        List<String> selectedKnowledgeList = new List<String>();
        List<KnowledgeDetails> returnKnowledgeDetails = new List<KnowledgeDetails>();
	List<String> parentKnowledgeList = new List<String>();
	if(parentCategoryName != ' '){
		parentKnowledgeList = categoryKnowledgeMap.get(parentCategoryName);
	}		
        if(!categoryKnowledgeMap.isEmpty() && categoryKnowledgeMap.containsKey(categoryName)){
            for(String knowledgeId:categoryKnowledgeMap.get(categoryName)){
                for(String program:programName){
                    if(knowledgeProgramMap.containsKey(knowledgeId) && knowledgeRoleMap.containsKey(knowledgeId)){
                        if(knowledgeProgramMap.get(knowledgeId).contains(program) && knowledgeRoleMap.get(knowledgeId).contains(roleName)){
                            if(parentKnowledgeList != null){
                                if(!knowledgeDetailMap.isEmpty() && knowledgeDetailMap.containsKey(knowledgeId) && parentKnowledgeList.contains(knowledgeId)){
                                    KnowledgeDetails knowDetails = new KnowledgeDetails();
                                    knowDetails = knowledgeDetailMap.get(knowledgeId);
                                    if(knowDetails.knowledgeProgram != null){
                                        if(!knowDetails.knowledgeProgram.split(' ').contains(program))
                                        knowDetails.knowledgeProgram += program + ' ';  
                                    }   
                                    returnKnowledgeDetails.add(knowDetails);
                                }
                            }
                        }
                    }
                }
            }
        }
        return returnKnowledgeDetails;      
    }
    
    public class CategoryStructure{
        @AuraEnabled public string language ;
        @AuraEnabled public String roleName;
        @AuraEnabled public List<Categorylevel1Detail> categoryDetails;         
    }

    public class Categorylevel1Detail{
        @AuraEnabled public String level1CategoryId;
        @AuraEnabled public String level1CategoryName;
        @AuraEnabled public List<String> level1Program;
        @AuraEnabled public List<KnowledgeDetails> level1Knowledge;
        @AuraEnabled public List<Categorylevel2Detail> level1ChildName;     
    }
    public class Categorylevel2Detail{
        @AuraEnabled public String level2CategoryId;
        @AuraEnabled public String level2CategoryName;
        @AuraEnabled public List<String> level2Program;
        @AuraEnabled public List<KnowledgeDetails> level2Knowledge;
        @AuraEnabled public List<Categorylevel3Detail> level2ChildName;     
    }
    public class Categorylevel3Detail{
        @AuraEnabled public String level3CategoryId;
        @AuraEnabled public String level3CategoryName;
        @AuraEnabled public List<String> level3Program;
        @AuraEnabled public List<KnowledgeDetails> level3Knowledge;   
    }
    
    public class CategoryProgram{
        @AuraEnabled public String program;
        @AuraEnabled public String categoryName;
    }
    
    public class KnowledgeDetails{
        @AuraEnabled public String knowledgeId;
        @AuraEnabled public String question;
        @AuraEnabled public String knowledgeProgram;
    }
    
    
}