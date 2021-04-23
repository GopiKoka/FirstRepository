public class CaseHandler implements TriggerInterface{
    
    set<String> externalIds = new set<String>();
    // Default Constructor used by the factory
    public CaseHandler(){
    }
    /* bulkBefore is called once prior to the iterative execution of BEFORE trigger actions (e.g. beforeInsert, beforeUpdate, beforeDelete).
     * Use this method run SOQL queries and to cache all bulk data into maps/lists.
     */
    public void bulkBefore(){
        // Cached data for both beforeInsert and beforeUpdate
        if(Trigger.isUpdate){
            List<Case> caseList = (List<Case>)Trigger.new;
            Map<id,Case> caseNewObj = (Map<id,Case>)Trigger.newMap;
            Map<id,Case> caseOldObj = (Map<id,Case>)Trigger.oldMap;
            for(Case caseObj:caseList){
                 if ((caseOldObj.get(caseObj.Id).Response__c != 
                                 caseNewObj.get(caseObj.Id).Response__c)){
                     caseObj.Answered_to_Physician__c = TRUE;
                     externalIds.add(caseObj.Unique_Id__c);
                 }
            }
        }
    }

    /* bulkAfter is called once prior to the iterative execution of AFTER trigger actions (e.g. afterInsert, afterUpdate, afterDelete).
     * Use this method run SOQL queries and to cache all bulk data into maps/lists.
     */
    public void bulkAfter(){
        
    }

    /* beforeInsert iteratively processes each record in the Before Insert trigger event. This method should be used
     * to handle field updates. No queries or DML operations should be performed here.
     */
    public void beforeInsert(SObject so){
        Case prodObj = (Case)so;
    }

    /* beforeUpdate iteratively processes each record in the Before Update trigger event. This method should be used
     * to handle field updates. No queries or DML operations should be performed here.
     */
    public void beforeUpdate(SObject oldSo, SObject so){
        
    }

    /* beforeDelete iteratively processes each record in the Before Delete trigger event. This method should be used
     * to perform any validation that cannot be done via Profiles / Field Level Security before a record is deleted.
     * No queries or DML operations should be performed here.
     */
    public void beforeDelete(SObject oldSo){
    }

    /* afterInsert iteratively processes each record in the After Insert trigger event. This method should be used
     * to perform any validation that cannot be done via OOTB validation rules, process related records,
     * or flag records for call outs. No queries or DML operations should be performed here.
     */
    public void afterInsert(SObject so){
        // Cast the SObject to Account sObjectType; Store RecordTypeId to more efficiently reference
        Case caseObj = (Case)so;
      }

    /* afterUpdate iteratively processes each record in the After Update trigger event. This method should be used
     * to perform any validation that cannot be done via OOTB validation rules and prepare related records for processing
     * or flag records for call outs in andFinally. No queries or DML operations should be performed here.
     */
    public void afterUpdate(SObject oldSo, SObject so){
        Case CaseObj = (Case)so;
    }

    /* afterDelete iteratively processes each record in the After Delete trigger event. This method should be used
     * to perform any validation that cannot be done via OOTB validation rules and prepare related records for processing
     * or flag records for call outs in andFinally. No queries or DML operations should be performed here.
     */
    public void afterDelete(SObject oldSo){
    }

    /* andFinally is called once after the BEFORE trigger events and once after the AFTER trigger events. This method should be used to
     * create/update/delete related records or actually make callouts.
     */
    public void andFinally(){
        //finally we do the DML/do bulk operations here
        if(!externalIds.isEmpty()){
            System.enqueueJob(new CommercialTeamDataProcess(externalIds,'Case'));
        }
    }
}