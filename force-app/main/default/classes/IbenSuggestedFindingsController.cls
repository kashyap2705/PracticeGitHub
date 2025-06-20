public class IbenSuggestedFindingsController {

	@TestVisible public String questionAttr { get; set; }
	@TestVisible public String labelsAttr { get; set; }

	public IbenSuggestedFindingsController() {}

	public List<ConvertedLabel> getLabelList() {

		List<ConvertedLabel> convertedLabels = new List<ConvertedLabel>();
		List<String> labels = new List<String>();
		if(labelsAttr!=null)
		{
			labels = labelsAttr.split('\\|');
		}

		//IbenSuggestedFindingsCounter.counter = 0;

		for (String label : labels) {
			
			ConvertedLabel con = new ConvertedLabel();

			con.htmlVersion = label;

			con.scriptVersion = label;
			con.scriptVersion = con.scriptVersion.replace('\'','\\\'');
			con.scriptVersion = con.scriptVersion.replace('<br />','\\n');
			con.scriptVersion = con.scriptVersion.replace('<br/>','\\n');
			con.scriptVersion = con.scriptVersion.replace('<br>','\\n');

			if(con.scriptVersion.contains('i>') || con.scriptVersion.contains('I>')){
				con.scriptVersion = con.scriptVersion.replace('<I>','<i>');
				con.scriptVersion = con.scriptVersion.replace('</I>','</i>');				
				con.bTag = 0;
				con.eTag = 0;
				con.bTag = con.scriptVersion.indexOf('<i>') + 3;
				con.eTag = con.scriptVersion.indexOf('</i>');
				if(con.eTag > 0 && con.bTag >= 0){

					con.scriptVersion = con.scriptVersion.subString(0, con.bTag) + 
										con.scriptVersion.subString(con.bTag, con.eTag).toUpperCase() +
										con.scriptVersion.subString(con.eTag, con.scriptVersion.length());
				}

				con.scriptVersion = con.scriptVersion.replace('<i>','');
				con.scriptVersion = con.scriptVersion.replace('</i>','');
				con.scriptVersion = con.scriptVersion.replace('<I>','');
				con.scriptVersion = con.scriptVersion.replace('</I>','');

			}

			/* if we need to equal length the suggested findings boxes we may need to use a counter on the component
			if (IbenSuggestedFindingsCounter.counter >= 4) {
				IbenSuggestedFindingsCounter.counter = 1;
			}
			else {
				IbenSuggestedFindingsCounter.counter = IbenSuggestedFindingsCounter.counter + 1;
			}
			con.counter = IbenSuggestedFindingsCounter.counter;
			*/

			convertedLabels.add(con);

		}

		return convertedLabels;

	}
    

	public class ConvertedLabel {
		public String htmlVersion { get; set; }
		public String scriptVersion { get; set; }
		public Integer counter { get; set; }
		public Integer iteration { get; set; }
		public Integer bTag { get; set; }
		public Integer eTag { get; set; }
        

	}

}