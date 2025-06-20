/*******************************************************************************************
* @Name     Logger
* @Author   Ranjith Kondabathini    
* @Date     05/16/2023    
* @Group        
* @Description  Generic logging framework that persists across DML reversions
 * by publishing a Platform Event
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         Generic logging framework that persists across DML reversions
 * by publishing a Platform Event
*******************************************************************************************/
public with sharing class Logger {
    /**
     * @description private instance of this log class that backs the
     * singleton get() method.
     */
    private static Logger currentInstance;
    /**
     * @descritption variables to store logger values
     */
    final static string METADATADEBUG = 'Debug';
    /**
     * @descritption variables to store logger values
     */
    final static string METADATAINFO = 'Info';
    /**
     * @descritption variables to store logger values
     */
    final static string METADATAWARN = 'Warn';
    /**
     * @descritption variables to store logger values
     */
    final static string METADATAERROR = 'Error';
    /**
     * @description to get custom metadata records
     */ 
    list<LoggerSetting__mdt> mdts = (list<LoggerSetting__mdt>) new CustomMetadataHandler().getCustomMetadataRecords('global');
     

    /**
     * @description private list of LogMessage objects to be published in the
     * future
     */
    private final List<LogMessage> buffer;

    /**
     * @description establishes the buffer, if one doesn't yet exist
     * private, to ensure we can't directly construct this class. Use the
     * Singleton, Luke.
     */
    private Logger() {
        buffer = new List<LogMessage>();
    }

    /**
     * @description Singleton pattern `get` method.
     * @return     `Log`
     */
    public static Logger get() {
        if (currentInstance == null) {
            currentInstance = new Logger();
        }
        return currentInstance;
    }
    
    /**
     * @description Add a message to the buffer without publishing it.
     * Assumes a null severity
     * @param messageToLog  The LogMessage to add to the buffer.
     */
    public Logger add(LogMessage msg) {
        buffer.add(msg);
        return this;
    }

    /**
     * @description Add a message to the buffer without publishing it.
     * Assumes a null severity
     * @param messageToLog  The string message to add to the buffer.
     */
    public Logger add(String messageToLog) {
        return this.add(messageToLog, null);
    }

    /**
     * @description Add a message to the buffer without publishing it.
     * @param messageToLog The string message to add to the buffer.
     * @param severity     LogSeverity enum
     */
    public Logger add(String messageToLog, LogSeverity severity) {
        final LogMessage msg = new LogMessage(messageToLog);
        msg.severity = severity == null ? LogSeverity.DEBUG : severity;
        
        buffer.add(msg);
        return this;
    }
    
      /**
     * @description Add a message to the buffer without publishing it.
     * @param messageToLog The string message to add to the buffer.
     * @param severity     LogSeverity enum
     * @param location 
     */
    public Logger add(String messageToLog,String location,LogSeverity severity,String RecordId) {
        final LogMessage msg = new LogMessage(messageToLog , location , RecordId);
        msg.severity = severity == null ? LogSeverity.DEBUG : severity;

        buffer.add(msg);
        return this;
    }

    /**
     * @description Add an formated exception message to the buffer without
     * publishing it. Assumes a null Severity 
     * @param exceptionToLog Exception to format and log
     */
    public Logger add(Exception exceptionToLog) {
        return this.add(exceptionToLog, null);
    }

    /**
     * @description Add an formated exception message to the buffer without
     * publishing it.
     * @param exceptionToLog Exception to format and log
     * @param severity       LogSeverity enum
     */
    public Logger add(Exception exceptionToLog, LogSeverity severity) {
        final  LogMessage msg = new LogMessage(exceptionToLog);
        msg.severity = severity == null ? LogSeverity.ERROR : severity;
        buffer.add(msg);
        return this;
    }
    

    /**
     * @description Publish any messages currently in the buffer based on Event log level value
     * any new ones.
     */
    public Logger publish() {
        final List<SObject> rawLogs = new List<SObject>();
        

        for (LogMessage msg : this.buffer) { 
            final Boolean isLogEnabled = !mdts.isEmpty() && (msg.severity == null ||
            mdts[0].Enable_Log_Events_from_Level__c == METADATADEBUG || (
            mdts[0].Enable_Log_Events_from_Level__c == METADATAINFO && LogSeverity.DEBUG != msg.severity) || (
            mdts[0].Enable_Log_Events_from_Level__c == METADATAWARN && LogSeverity.DEBUG != msg.severity && LogSeverity.INFO != msg.severity) || (
            mdts[0].Enable_Log_Events_from_Level__c == METADATAERROR && LogSeverity.ERROR == msg.severity ));
            
            if(isLogEnabled) {
                rawLogs.add(msg.toEvent()); 
            }   
        }

        if(!rawLogs.isEmpty()) {
            EventBus.publish(rawLogs);
        }
        this.buffer.clear();

        return this;
    }

    /**
     * @description Auto-format exception details, add it to the log buffer,
     * and then publish the current buffer. Use the equivelent add
     * method if you intend to add multiple messages rapidly to minimize DML
     * usage.
     * @param exceptionToLog exception to format and log
     */
    public Logger publish(Exception exceptionToLog) {
        this.buffer.add(new LogMessage(exceptionToLog));
        return this.publish();
    }

    /**
     * @description Auto-format a custom log message string, add it to the log
     * buffer, and then publish the current buffer. Use the equivelent add
     * method if you intend to add multiple messages rapidly to minimize DML
     * usage.
     * @param messageToLog String to log
     */
    public Logger publish(String messageToLog) {
        this.buffer.add(new LogMessage(messageToLog));
        return this.publish();
    }
}