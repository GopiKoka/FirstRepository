/**
 *  Queueable class : Its used to send data from MedicalTeam to CommercialTeam with couple of objects
 *  Objects : Its Dynamic class used to send Sobject data
 *  prerequisite : 
 *  - Create Fieldset for Sobject
 *  - Create Unique_Id__c,Sent_to_CommercialTeam__c on Sobject to integrate
 *  - Call CommercialTeamDataProcess Queueable class when needed (Example : Check AccountHandler class how to call)
 *  - Create NamedCredentials to integrate
 */
public class CommercialTeamDataProcess implements Queueable, Database.AllowsCallouts {
    private List<String> externalIds = new List<String>();
    private string objectName;
    private list<Sobject> sendSobjectToMT = new list<Sobject>();
    public CommercialTeamDataProcess(set<String> externalId,String objectName){
        this.externalIds.addAll(externalId);
        this.objectName = objectName;
    }
    public void execute(QueueableContext context) {
        if(!externalIds.isEmpty()){
            sendInformationToCT();
        }
    }
    
    /*
        - Input : Integrate/Send sobject information to other environment
        - Output : Updating reponse from other environment
    */
    private void sendInformationToCT(){
        try{
            String dynamicSOQL = 'SELECT id ';
            for(Schema.FieldSetMember fld :readFieldSet(this.objectName+'FieldSet',this.objectName)) {
                dynamicSOQL += ', ' + fld.getFieldPath();
            }
            dynamicSOQL += ' FROM '+this.objectName+' WHERE Unique_Id__c IN : externalIds';
            List<SObject> sObj = Database.query(dynamicSOQL);
            HTTPResponse response = sendSobjectDatatoCT(sObj);
            for(Sobject obj:sObj){
                obj.put('Sent_to_CommercialTeam__c',response.getBody());
            }
            update sObj;
        }catch(Exception e){
            ExceptionHandling.handleException(this.objectName,e);
        }
    }
    
    /*
        - Input : Sobject FieldSetName and Sobject
        - Output : Return all fields added in fieldset
    */
    private List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }  
    
    /*
    - To send Sobject data from MedicalTeam to CommercialTeam
    - Named Credentials as endpoint
    */
    private HTTPResponse sendSobjectDatatoCT(List<Sobject> rBody){
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:CommercialTeamLogin/services/apexrest/salesorg/'+objectName);  
        req.setHeader('content-type', 'application/json');
        req.setBody(JSON.serialize(rBody));
        Http http = new Http();
        HTTPResponse response = http.send(req);
        return response;
    }
}