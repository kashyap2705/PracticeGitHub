({
    doinitChange : function (component) {
       var recId = component.get('v.recordId');
       var flow = component.find("flowData");
       var inputVariables = [
          { name : "fetchRecordID", type : "String", value: recId},         
        ];

        flow.startFlow("Duplicate_Merge_Finalization", inputVariables);
 
    }
 })