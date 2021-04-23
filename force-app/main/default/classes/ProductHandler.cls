public class ProductHandler implements TriggerInterface{
    
    set<String> externalIds = new set<String>();
    // Default Constructor used by the factory
    public ProductHandler(){
    }
    /* bulkBefore is called once prior to the iterative execution of BEFORE trigger actions (e.g. beforeInsert, beforeUpdate, beforeDelete).
     * Use this method run SOQL queries and to cache all bulk data into maps/lists.
     */
    public void bulkBefore(){
        // Cached data for both beforeInsert and beforeUpdate
    }

    /* bulkAfter is called once prior to the iterative execution of AFTER trigger actions (e.g. afterInsert, afterUpdate, afterDelete).
     * Use this method run SOQL queries and to cache all bulk data into maps/lists.
     */
    public void bulkAfter(){
        List<product2> prodList = (List<product2>)Trigger.new;
        Map<id,Product2> prodNewObj = (Map<id,Product2>)Trigger.newMap;
        Map<id,Product2> prodOldObj = (Map<id,Product2>)Trigger.oldMap;
        for(product2 prodObj:prodList){
             if (prodObj.FDA_Approved__c && (prodOldObj.get(prodObj.Id).FDA_Approved__c != 
                                             prodNewObj.get(prodObj.Id).FDA_Approved__c)){
                 externalIds.add(prodObj.Unique_Id__c);
             }
        }
    }

    /* beforeInsert iteratively processes each record in the Before Insert trigger event. This method should be used
     * to handle field updates. No queries or DML operations should be performed here.
     */
    public void beforeInsert(SObject so){
        Product2 prodObj = (Product2)so;
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
        Product2 prodObj = (Product2)so;
      }

    /* afterUpdate iteratively processes each record in the After Update trigger event. This method should be used
     * to perform any validation that cannot be done via OOTB validation rules and prepare related records for processing
     * or flag records for call outs in andFinally. No queries or DML operations should be performed here.
     */
    public void afterUpdate(SObject oldSo, SObject so){
        Product2 prodNewObj = (Product2)so;
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
            System.enqueueJob(new CommercialTeamDataProcess(externalIds,'Product2'));
        }
    }
}