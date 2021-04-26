public with sharing class Calculator {
    public Integer num1{get;set;}
    public Integer num2{get;set;}
    public Integer output{get;set;}
    
    public string addition(){
        try {
            output = num1 + num2 ; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
    
}