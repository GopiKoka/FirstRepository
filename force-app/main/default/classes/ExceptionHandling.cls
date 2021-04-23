Public Class ExceptionHandling {
    Public static void handleException(String objectName,Exception e){
        ExceptionHandling__c eh = new ExceptionHandling__c();
        eh.Error_Message__c = e.getMessage();
        eh.ObjectName__c = objectName;
        insert eh;
    }
}