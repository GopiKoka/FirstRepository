public with sharing class Calculator {
    @AuraEnabled
    public static string exampleFunction(){
        try {
            String v1 = 'abc';
            system.debug(v1);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
    
}
