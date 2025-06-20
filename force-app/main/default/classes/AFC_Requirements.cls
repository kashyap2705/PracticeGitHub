global class AFC_Requirements implements Process.Plugin {

    /*private final String LEGAL_KEY = 'legal';
    private final String NAME_KEY = 'name';
    private final String MISSION_KEY = 'mission';
    private final String CAMPUS_KEY = 'campus';
    private final String COORDINATOR_KEY = 'coordinator';
    private final String BUDGET_KEY = 'budget';
    private final String COMMITMENT_KEY = 'commitment';
    private final String PYP_STRUCTURE_KEY = 'pypStructure';
    private final String MYP_PARTNER_KEY = 'mypPartner';
    private final String MYP_LENGTH_KEY = 'mypLength';
    private final String CP_STUDIES_KEY = 'cpStudies';*/

    global Process.PluginResult invoke(Process.PluginRequest request) {
        String lang,recordID,signature;
        recordID = (String) request.inputParameters.get('IB Programme ID');
        lang = (String) request.inputParameters.get('Language');
        lang = lang.toLowerCase();
        signature = String.valueOf(request.inputParameters.get('Region'));
        
        String outputText = '';
        
        outputText += '<p><table cellspacing="0" cellpadding="10" style="border: 1px solid black;width: 100%;"><tr>';
        outputText += '<th style="text-align: left;border: 1px solid black;">'+System.Label.PIMS_Standard+'</th>';
        outputText += '<th style="text-align: left;border: 1px solid black;">'+System.Label.PIMS_Practice+'</th>';
        outputText += '<th style="text-align: left;border: 1px solid black;">'+System.Label.PIMS_Actions+'</th></tr>';
        
        system.debug('#### recordId : '+recordId);
        
        if (recordId != null && recordId.length() > 0 && recordId.startsWith('a1R')) {
            list<IB_Action_Plan__c> actionPlans = [select id, AP_Standard_Practice__r.Standard__c, AP_Standard_Practice__r.Practice__c, AP_Action_Description__c from IB_Action_Plan__c 
                                                    where programme__c =: recordId and AP_Action_Type__c = 'MTBA' and (AP_Status__c = 'New' or AP_Status__c = 'In Progress')];
            if(actionPlans.size() > 0){
                for(IB_Action_Plan__c ap : actionPlans){
                    outputText += '<tr>';
                    outputText += '<td style="text-align: left;border: 1px solid black;">'+ap.AP_Standard_Practice__r.Standard__c+'</td>';
                    outputText += '<td style="text-align: left;border: 1px solid black;">'+ap.AP_Standard_Practice__r.Practice__c+'</td>';
                    outputText += '<td style="text-align: left;border: 1px solid black;">'+ap.AP_Action_Description__c+'</td>';
                    outputText += '</tr>';
                }
            }else{
                outputText += '<tr>';
                //outputText += '<td colspan="3" style="text-align: left;border: 1px solid black;">'+System.Label.Candidacy_Documentation_No_Action+'</td>';
                if(lang == 'spanish'){
                    outputText += '<td colspan="3" style="text-align: left;border: 1px solid black;">Ninguna prueba pendiente</td>';
                }else if(lang == 'french'){
                    outputText += '<td colspan="3" style="text-align: left;border: 1px solid black;">Aucun élément de preuve en instance</td>';
                }else{
                    outputText += '<td colspan="3" style="text-align: left;border: 1px solid black;">No evidence pending</td>';
                }
                outputText += '</tr>';
            }
        }
        
        outputText += '</table></p>';
        
        system.debug('#### outputText : '+outputText);
        
        // Signature (Added check for language to ensure the correct signature language is pulled in from the custom settings - 6/30/16)
        if((boolean)request.inputParameters.get('Letter 1')){
            if (signature == 'IBAEM' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Director - AEM').signature__c;
            if (signature == 'IBAEM' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Regional Director - AEM-SP').signature__c;
            if (signature == 'IBAEM' && lang == 'french') signature = Flow_Signatures__c.getInstance('Regional Director - AEM-FR').signature__c;
            if (signature == 'IBA' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Director - IBA').signature__c;
            if (signature == 'IBA' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Regional Director - IBA-SP').signature__c;
            if (signature == 'IBA' && lang == 'french') signature = Flow_Signatures__c.getInstance('Regional Director - IBA-FR').signature__c;
            if (signature == 'IBAP' && lang == 'english')signature = Flow_Signatures__c.getInstance('Regional Director - AP').signature__c;
            if (signature == 'IBAP' && lang == 'spanish')signature = Flow_Signatures__c.getInstance('Regional Director - AP-SP').signature__c;
            if (signature == 'IBAP' && lang == 'french')signature = Flow_Signatures__c.getInstance('Regional Director - AP-FR').signature__c;
        }
        else{
            if (signature == 'IBAEM' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - AEM').signature__c;
            if (signature == 'IBAEM' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AEM-SP').signature__c;
            if (signature == 'IBAEM' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AEM-FR').signature__c;
            if (signature == 'IBA' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - IBA').signature__c;
            if (signature == 'IBA' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-IBA-SP').signature__c;
            if (signature == 'IBA' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-IBA-FR').signature__c;
            if (signature == 'IBAP' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - AP').signature__c;
            if (signature == 'IBAP' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AP-SP').signature__c;
            if (signature == 'IBAP' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AP-FR').signature__c;
        }

        Map<String,Object> result = new Map<String,Object>();
        result.put('Result', outputText);
        result.put('Signature', signature);
        return new Process.PluginResult(result);
    }

    /*global Process.PluginResult invoke(Process.PluginRequest request) {

        String lang, legal, name, mission, campus, coordinator, budget, commitment, pypStructure, mypPartner, mypLength, cpStudies, signature;
        String outputText = '';
        lang = (String) request.inputParameters.get('Language');
        lang = lang.toLowerCase();

        Boolean isCP1 = (Boolean)request.inputParameters.get('Is CP Phase 1');

        String consHours = isCP1 ? '10' : '20';

        system.debug('request =====> '+request);

        legal = (String.valueOf(request.inputParameters.get('Legal Entity'))) == 'true' ? LEGAL_KEY : '';
        name = (String.valueOf(request.inputParameters.get('School Name'))) == 'true' ? NAME_KEY : '';
        mission = (String.valueOf(request.inputParameters.get('School Mission & Philosophy'))) == 'true' ? MISSION_KEY : '';
        campus = (String.valueOf(request.inputParameters.get('Multiple Campus'))) == 'true' ? CAMPUS_KEY : '';
        coordinator = (String.valueOf(request.inputParameters.get('Programme Coordinator'))) == 'true' ? COORDINATOR_KEY : '';
        budget = (String.valueOf(request.inputParameters.get('Budget'))) == 'true' ? BUDGET_KEY : '';
        commitment = (String.valueOf(request.inputParameters.get('Commitment to PD'))) == 'true' ? COMMITMENT_KEY : '';
        pypStructure = (String.valueOf(request.inputParameters.get('Structure PYP ONLY'))) == 'true' ? PYP_STRUCTURE_KEY : '';
        mypPartner = (String.valueOf(request.inputParameters.get('Partner Schools MYP ONLY'))) == 'true' ? MYP_PARTNER_KEY : '';
        mypLength = (String.valueOf(request.inputParameters.get('Length of the MYP'))) == 'true' ? MYP_LENGTH_KEY : '';
        cpStudies = (String.valueOf(request.inputParameters.get('Career-related studies CP ONLY'))) == 'true' ? CP_STUDIES_KEY : '';
        signature = String.valueOf(request.inputParameters.get('Region'));

        // Signature (Added check for language to ensure the correct signature language is pulled in from the custom settings - 6/30/16)
        if((boolean)request.inputParameters.get('Letter 1')){
            if (signature == 'IBAEM' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Director - AEM').signature__c;
            if (signature == 'IBAEM' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Regional Director - AEM-SP').signature__c;
            if (signature == 'IBAEM' && lang == 'french') signature = Flow_Signatures__c.getInstance('Regional Director - AEM-FR').signature__c;
            if (signature == 'IBA' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Director - IBA').signature__c;
            if (signature == 'IBA' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Regional Director - IBA-SP').signature__c;
            if (signature == 'IBA' && lang == 'french') signature = Flow_Signatures__c.getInstance('Regional Director - IBA-FR').signature__c;
            if (signature == 'IBAP' && lang == 'english')signature = Flow_Signatures__c.getInstance('Regional Director - AP').signature__c;
            if (signature == 'IBAP' && lang == 'spanish')signature = Flow_Signatures__c.getInstance('Regional Director - AP-SP').signature__c;
            if (signature == 'IBAP' && lang == 'french')signature = Flow_Signatures__c.getInstance('Regional Director - AP-FR').signature__c;
        }
        else{
            if (signature == 'IBAEM' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - AEM').signature__c;
            if (signature == 'IBAEM' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AEM-SP').signature__c;
            if (signature == 'IBAEM' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AEM-FR').signature__c;
            if (signature == 'IBA' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - IBA').signature__c;
            if (signature == 'IBA' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-IBA-SP').signature__c;
            if (signature == 'IBA' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-IBA-FR').signature__c;
            if (signature == 'IBAP' && lang == 'english') signature = Flow_Signatures__c.getInstance('Regional Head of School Services - AP').signature__c;
            if (signature == 'IBAP' && lang == 'spanish') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AP-SP').signature__c;
            if (signature == 'IBAP' && lang == 'french') signature = Flow_Signatures__c.getInstance('Reg Head of School Services-AP-FR').signature__c;
        }

        // Requirments
        Map<String, Map<String, String>> valuesByLang = new Map<String, Map<String, String>>{
            'english'=> new Map<String, String>{
                LEGAL_KEY => 'Legal Entity',
                NAME_KEY => 'School name',
                MISSION_KEY => 'School mission and philosophy',
                CAMPUS_KEY => 'Multiple campus',
                COORDINATOR_KEY => 'Programme coordinator',
                BUDGET_KEY => 'Budget',
                COMMITMENT_KEY => 'Commitment to PD',
                PYP_STRUCTURE_KEY => 'Structure of the programme',
                MYP_PARTNER_KEY => 'Partner schools',
                MYP_LENGTH_KEY => 'Length of the MYP',
                CP_STUDIES_KEY => 'Career-related studies qualifications'
            },
            'spanish'=> new Map<String, String>{
                LEGAL_KEY => 'Entidad legal',
                NAME_KEY => 'Nombre del colegio',
                MISSION_KEY => 'Declaración de principios y filosofía del colegio',
                CAMPUS_KEY => 'Varias sedes',
                COORDINATOR_KEY => 'Coordinador(a) de programa',
                BUDGET_KEY => 'Presupuesto',
                COMMITMENT_KEY => 'Compromiso con el desarrollo professional',
                PYP_STRUCTURE_KEY => 'Estructura',
                MYP_PARTNER_KEY => 'Colegios asociados',
                MYP_LENGTH_KEY => 'Duración del PAI',
                CP_STUDIES_KEY => 'Titulaciones de estudios de formación profesional'
            },
            'french'=> new Map<String, String>{
                LEGAL_KEY => 'Entité legalé',
                NAME_KEY => 'Nom de l’établissement',
                MISSION_KEY => 'Mission et philosophie de l’établissement',
                CAMPUS_KEY => 'Établissements à sites multiples',
                COORDINATOR_KEY => 'Coordonnateur du programme',
                BUDGET_KEY => 'Budget',
                COMMITMENT_KEY => 'Engagement envers le perfectionnement professionnel',
                PYP_STRUCTURE_KEY => 'Structure',
                MYP_PARTNER_KEY => 'Établissements partenaires',
                MYP_LENGTH_KEY => 'Durée du PPCS',
                CP_STUDIES_KEY => 'Formations à orientation professionnelle'
            }
        };

        String before = '<p>';
        String after = '</p>';

        if(!valuesByLang.containsKey(lang)){
            throw new unsupportedException('Language not supported : ' + lang);
        }
        if(valuesByLang.get(lang).containsKey(legal)){
            outputText += before + valuesByLang.get(lang).get(legal) + after;
        }
        if(valuesByLang.get(lang).containsKey(name)){
            outputText += before + valuesByLang.get(lang).get(name) + after;
        }
        if(valuesByLang.get(lang).containsKey(mission)){
            outputText += before + valuesByLang.get(lang).get(mission) + after;
        }
        if(valuesByLang.get(lang).containsKey(campus)){
            outputText += before + valuesByLang.get(lang).get(campus) + after;
        }
        if(valuesByLang.get(lang).containsKey(coordinator)){
            outputText += before + valuesByLang.get(lang).get(coordinator) + after;
        }
        if(valuesByLang.get(lang).containsKey(budget)){
            outputText += before + valuesByLang.get(lang).get(budget) + after;
        }
        if(valuesByLang.get(lang).containsKey(commitment)){
            outputText += before + valuesByLang.get(lang).get(commitment) + after;
        }
        if(valuesByLang.get(lang).containsKey(pypStructure)){
            outputText += before + valuesByLang.get(lang).get(pypStructure) + after;
        }
        if(valuesByLang.get(lang).containsKey(mypPartner)){
            outputText += before + valuesByLang.get(lang).get(mypPartner) + after;
        }
        if(valuesByLang.get(lang).containsKey(mypLength)){
            outputText += before + valuesByLang.get(lang).get(mypLength) + after;
        }
        if(valuesByLang.get(lang).containsKey(cpStudies)){
            outputText += before + valuesByLang.get(lang).get(cpStudies) + after;
        }

        Map<String,Object> result = new Map<String,Object>();
        result.put('Result', outputText);
        result.put('Signature', signature);
        return new Process.PluginResult(result);
    }*/

    global Process.PluginDescribeResult describe() {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.Name = 'AFC_Requirements';
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter('IB Programme ID', Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('Region', Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Letter 1', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Language', 'On supports Spanish, English, French',Process.PluginDescribeResult.ParameterType.STRING, true)
            /*
            new Process.PluginDescribeResult.InputParameter('Region', Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('Legal Entity', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('School Name', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('School Mission & Philosophy', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Multiple Campus', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Programme Coordinator', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Budget', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Commitment to PD', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Is CP Phase 1', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Structure PYP ONLY', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Partner Schools MYP ONLY', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Length of the MYP', Process.PluginDescribeResult.ParameterType.BOOLEAN, true),
            new Process.PluginDescribeResult.InputParameter('Career-related studies CP ONLY', Process.PluginDescribeResult.ParameterType.BOOLEAN, true)*/
        };
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            new Process.PluginDescribeResult.OutputParameter('Result', Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('Signature', Process.PluginDescribeResult.ParameterType.STRING)
        };
        return result;
    }

    public class unsupportedException extends Exception{}
}