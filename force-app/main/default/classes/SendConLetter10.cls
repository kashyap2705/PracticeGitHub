public class SendConLetter10 implements Process.Plugin{

    public static final String COORD_NAME = 'coordName';
    public static final String SCHOOL_NAME = 'schoolName';
    public static final String PROG_NAME = 'programmeName';
    public static final String CON_NAME = 'consultantName';
    public static final String CON_EMAIL = 'consultantEmail';
    public static final String THE_YEAR = 'theYear';
    public static final String THE_DATE = 'theDate';
    public static final String SIGNATURE = 'signature';
    public static final String LANG = 'lang';
    public static final String TO_ADDRESS = 'to';
    public static final String ORG_WIDE_EMAIL = 'orgWideEmailId';
    public static final String CONTACT_ID = 'conId';
    public static final String IB_EVENT_ID = 'ibEventId';
    public static final String CP = 'cp';
    public static final String HOS_EMAIL = 'hosEmail';
    public static final String CP_PHASE = 'cpPhase';
    public static final String START_DATE = 'startDate';

    public static final String ENGLISH = 'english';
    public static final String FRENCH = 'french';
    public static final String SPANISH = 'spanish';
    public static final String PHASE_ONE = 'Phase 1';

    private static Map<String, Pagereference> pagesByLang = new Map<String,Pagereference>{
        ENGLISH => Page.Consultancy_Letter_10_EN,
        FRENCH => Page.Consultancy_Letter_10_FR,
        SPANISH => Page.Consultancy_Letter_10_SP
    };
    private static Map<String, Pagereference> pagesByLang_CP1 = new Map<String,Pagereference>{
        ENGLISH => Page.Consultancy_Letter_10_EN_CP,
        FRENCH => Page.Consultancy_Letter_10_FR_CP,
        SPANISH => Page.Consultancy_Letter_10_SP_CP
    };
    private static Map<String, String> subjectsByLang = new Map<String,String>{
        ENGLISH => 'Notification of Assigned IB Consultant',
        FRENCH => 'Notification – Un consultant vous a été attribué par l’IB',
        SPANISH => 'Notificación: asignación de un asesor del IB'
    };
    public Process.PluginResult invoke(Process.PluginRequest request) {

        Letter10 tmp = new Letter10();

        tmp.coordName = (String)request.inputParameters.get(COORD_NAME);
        tmp.schoolName = (String)request.inputParameters.get(SCHOOL_NAME);
        tmp.progName = (String)request.inputParameters.get(PROG_NAME);
        tmp.conName = (String)request.inputParameters.get(CON_NAME);
        tmp.conEmail = (String)request.inputParameters.get(CON_EMAIL);
        tmp.year = (String)request.inputParameters.get(THE_YEAR);
        tmp.signature1 = (String)request.inputParameters.get(SIGNATURE);
        tmp.theDate = (String)request.inputParameters.get(THE_DATE);
        tmp.toAddress = (String)request.inputParameters.get(TO_ADDRESS);
        tmp.orgWideEmail = (String)request.inputParameters.get(ORG_WIDE_EMAIL);
        tmp.conId = (String)request.inputParameters.get(CONTACT_ID);
        tmp.lang = (String)request.inputParameters.get(LANG);
        tmp.ibEventId = (String)request.inputParameters.get(IB_EVENT_ID);
        tmp.hosEmail = (String)request.inputParameters.get(HOS_EMAIL);
        tmp.cpPhase = (String)request.inputParameters.get(CP_PHASE);
        tmp.startDate = (String)request.inputParameters.get(START_DATE);

        tmp.progName = localizeProgName(tmp.lang.toLowerCase(), tmp.progName);

        sendEmail(JSON.serialize(tmp));

        return new Process.PluginResult(new Map<String,Object>());
    }
    public Process.PluginDescribeResult describe() {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();

        result.description = 'Used to send Consultancy Letter 10';

        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(IB_EVENT_ID, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(COORD_NAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(SCHOOL_NAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(PROG_NAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(CON_NAME, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(CON_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(THE_YEAR, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(LANG, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(THE_DATE, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(TO_ADDRESS, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(ORG_WIDE_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(CONTACT_ID, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(HOS_EMAIL, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(CP_PHASE, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(START_DATE, Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter(SIGNATURE, Process.PluginDescribeResult.ParameterType.STRING, true)
        };

        return result;
    }
    @future(callout=true)
    @testVisible
    private static void sendEmail(String serializedLetterData){

        try{

            Letter10 request = (Letter10)JSON.deserialize(serializedLetterData, Letter10.class);

            String lowerLang = request.lang.toLowerCase();
            String language = request.lang;
            String cpPhase = request.cpPhase;

            if(!pagesByLang.containsKey(lowerLang) || !subjectsByLang.containsKey(lowerLang) || !pagesByLang_CP1.containsKey(lowerLang)){
                throw new unsupportedException(language + ' is not a supported language.');
            }

            String emailSubject = subjectsByLang.get(lowerLang);

            Pagereference content;

            if(request.progName.toLowerCase() == CP && cpPhase == PHASE_ONE){
                content = pagesByLang_CP1.get(lowerLang);
            }
            else{
                content = pagesByLang.get(lowerLang);
            }

            content.getParameters().put(COORD_NAME, request.coordName);
            content.getParameters().put(SCHOOL_NAME,request.schoolName);
            content.getParameters().put(PROG_NAME,request.progName);
            content.getParameters().put(CON_NAME,request.conName);
            content.getParameters().put(CON_EMAIL,request.conEmail);
            content.getParameters().put(THE_YEAR,request.year);
            content.getParameters().put(SIGNATURE,request.signature1);
            content.getParameters().put(THE_DATE,request.theDate);
            content.getParameters().put(TO_ADDRESS,request.toAddress);
            content.getParameters().put(ORG_WIDE_EMAIL,request.orgWideEmail);
            content.getParameters().put(CONTACT_ID,request.conId);
            content.getParameters().put(START_DATE,request.startDate);
            content.getParameters().put(HOS_EMAIL,request.hosEmail);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new List<String> {
                request.toAddress
            });

            email.setCCAddresses(new List<String> {
                request.conEmail,
                request.hosEmail
            });

            email.setOrgWideEmailAddressId(request.orgWideEmail);
            email.setTargetObjectId(request.conId);
            email.setSubject(emailSubject);

            if(System.Test.isRunningTest()){
                email.setplaintextBody('');
                email.setHTMLBody('');
            }
            else{
                email.setplaintextBody(content.getContent().toString());
                email.setHTMLBody(content.getContent().toString());
            }

            List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                new List<Messaging.Email> {
                    email
                }
            );
        }
        catch(Exception e){
            handleError(e, serializedLetterData);
        }
    }
    public static void handleError(Exception e, String s){

        Letter10 request = (Letter10)JSON.deserialize(s, Letter10.class);

        List<Campaign> ibEvent = [
            SELECT  Id, OwnerId, Name
            FROM    Campaign
            WHERE   Id = :request.ibEventId
        ];


        insert new Task(
            ActivityDate = System.Date.today().addDays(7),
            Priority = 'High',
            Description = 'The email sent to the Programme Coordinator and assigned consultant failed to send despite the IB Event status being set to "Staffed".  The error message is \"'+e.getMessage()+'\"',
            Subject = 'Failed Email - Assigned Consultant',
            WhatId = ibEvent[0].Id,
            OwnerId = ibEvent[0].OwnerId,
            Type = 'Other'
        );
    }
    @testVisible
    private static String localizeProgName(String lang2, String progName_en){

        String localizedProgName;
        Boolean isLang = false;
        Boolean isProgName = false;

        if(lang2 == ENGLISH){

            isLang = true;

            if(progName_en == 'MYP'){
                localizedProgName = 'MYP';
            }
            else if(progName_en == 'PYP'){
                localizedProgName = 'PYP';
            }
            else if(progName_en == 'DP'){
                localizedProgName = 'DP';
            }
            else if(progName_en == 'CP'){
                localizedProgName = 'CP';
            }
        }
        else if(lang2 == FRENCH){

            isLang = true;

            if(progName_en == 'MYP'){
                localizedProgName = 'PEI';
            }
            else if(progName_en == 'PYP'){
                localizedProgName = 'PP';
            }
            else if(progName_en == 'DP'){
                localizedProgName = 'PD';
            }
            else if(progName_en == 'CP'){
                localizedProgName = 'POP';
            }
        }
        else if(lang2 == SPANISH){

            isLang = true;

            if(progName_en == 'MYP'){
                localizedProgName = 'PAI';
            }
            else if(progName_en == 'PYP'){
                localizedProgName = 'PEP';
            }
            else if(progName_en == 'DP'){
                localizedProgName = 'PD';
            }
            else if(progName_en == 'CP'){
                localizedProgName = 'POP';
            }
        }

        if(!isLang){
            throw new UnsupportedException('Language not supported: ' + lang2);
        }
        else if(String.isBlank(localizedProgName)){
            throw new UnsupportedException('Programme not supported: ' + progName_en);
        }

        return localizedProgName;
    }

    public class UnsupportedException extends Exception{}
}