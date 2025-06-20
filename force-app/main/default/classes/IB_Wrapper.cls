global class IB_Wrapper {
    
    public String eventAt;
    public String eventName;
    public String processReference;
    public String schoolCode;
    public String[] programmeCodes;
    public List<TriggerEventNames> triggerEventNames;    
    
    global class TriggerEventNames {
        public String triggerName;
        public String IBConciergeDate;
        public String DPEvaluationOutcome;
        public String CPEvaluationOutcome;
        public String MYPEvaluationOutcome;
        public String PYPEvaluationOutcome;
        public String Category;
        public String CPCategory;
        public String MYPCategory;
        public String PYPCategory;
        public String MTBARemarks; 
        public String sectionName;
        public Boolean isLEAssigned;
        public Map<String, String>  sectionStatuses;
        
    }
    
    
    
    
    public static IB_Wrapper parse(String json) {
		return (IB_Wrapper) System.JSON.deserialize(json, IB_Wrapper.class);
	}
    
    
}