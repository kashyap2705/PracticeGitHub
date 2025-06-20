/*******************************************************************************************
* @Name     LogMessage
* @Author   Ranjith Kondabathini    
* @Date     05/16/2023    
* @Group        
* @Description  A class for automatically attaching metadata to log messages
* like Quiddity and RequestID
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         A class for automatically attaching metadata to log messages
* like Quiddity and RequestID
* by publishing a Platform Event
*******************************************************************************************/
public with sharing class LogMessage {
    /*
* @description Used to formate excepiton
*/ 
    private static final String EXCEPTION_STRING = 'Exception: [{0}] {1} \n StackTrace: {2}';
    
    /**
* @description public read only property for the request ID. Privately set.
*/
    public String requestId {
        get {
            if (requestId == null) {
                requestId = Request.getCurrent().getRequestId();
            }
            return requestId;
        }
        private set;
    }
    
    /**
* @description Public read only property for quiddity. Privately set.
*/
    public Quiddity quiddity {
        get {
            if (quiddity == null) {
                quiddity = Request.getCurrent().getQuiddity();
            }
            return quiddity;
        }
        private set;
    }
    /**
* @description public read only property for the curentUserId. Privately set.
*/
    public String userId {
        get {
            if (userId == null) {
                userId = userInfo.getUserId();
            }
            return userId;
        }
        public set;
    }
    /**
* @description public read only property for the currenttime. Privately set.
*/
    public Datetime currenttime {
        get {
            if (currenttime == null) {
                currenttime = System.now();
            }
            return currenttime;
        }
        private set;
    }
    /**
* @description public read only property for the Source. Privately set.
*/
    public String source {
        get {
            if (source == null) {
                source = 'salesforce';
            }
            return source;
        }
        private set;
    }
    /**
* @description public read only property for the Source. Privately set.
*/
    public String orgId {
        get {
            if (orgId == null) {
                orgId = UserInfo.getOrganizationId();
            }
            return orgId;
        }
        private set;
    }
    
    /**
* @description Public message property.
*/
    public String message { get; set; }
    
    /**
* @description Public severity property.
*/
    public LogSeverity severity { get; set; }
    
    /**
* @description Public additionalInfo property.
*/
    public String additionalInfo { get; set; }
    
    /**
* @description converts this object to an event for publishing
* @return      `SObject`
*/
    public GeneralLog__e toEvent() {
        return new GeneralLog__e(
            Message__c = this.message,
            RequestID__c = this.requestId,
            Context__c = this.quiddity?.name(),
            Level__c = this.severity?.name(),
            OrgId__c = this.orgId,
            Source__c = this.source,
            Time__c = this.currenttime,
            UserID__c = this.userId,
            AdditionalInfo__c = this.additionalInfo
        );
    }
    
    /**
* @description   Constructor accepting a message to log.
* Severity is auto set to info
* @param message
*/
    public LogMessage(String message) {
        this.message = message;
        this.severity = LogSeverity.INFO;
    }
    
    /**
* @description Constructor accepting an exception object.
* @param ex
*/
    public LogMessage(Exception excep) {
        this.message = String.format(
            EXCEPTION_STRING,
            new List<String>{
                excep.getTypeName(),
                    excep.getMessage(),
                    excep.getStackTraceString()
                    }
        );
        this.severity = LogSeverity.ERROR;
    } 
    /**
* @description   Constructor accepting a message to log.
* Severity is auto set to info
* @param message
*/
    public LogMessage(String message,String location,String RecordId) {
        this.message = message;
        this.severity = LogSeverity.INFO;
        this.source = location;
        this.additionalInfo = RecordId;
    }
    
}