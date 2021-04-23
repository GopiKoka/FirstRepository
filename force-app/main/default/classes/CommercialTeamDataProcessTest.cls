/**
 *  Test class : Test class for CommercialTeamData
 *  TBD :  Test class need to improve to pass data into commom method for reuse the code 
 */
@isTest
public class CommercialTeamDataProcessTest {

    /*
    Datasetup : To perform DML operations needed
    */
    
    @testSetup static void setup() {
        Account acc = new Account(Name = 'Phisician Name',Unique_ID__c='1234');
        insert acc;
        
        
        Product2 prod2 = new Product2(Name = 'Amoxicillin',Unique_ID__c='1234');
        insert prod2;
        
    }
    
    /*Start : Account data process to commercialteam with valid and invalid data*/
    @isTest
    static void validAccDataToProcess(){
        test.startTest();
            Test.setMock(HttpCalloutMock.class, new VertoPharmaMockTestData('Successfully sent to medical team'));
            List<Account> acc = [SELECT id FROM Account];
            for(Account a:acc){
                a.Process_to_CT__c = TRUE;
            }
            update acc;
        test.stoptest();
        Account expectedAcc = [SELECT id,Sent_to_CommercialTeam__c FROM Account WHERE id=:acc[0].id];
        system.assertEquals('Successfully sent to medical team',expectedAcc.Sent_to_CommercialTeam__c);
    }
    
    
    @isTest
    static void invalidAccDataToProcess(){
        test.startTest();
            List<Account> acc = [SELECT id FROM Account];
            for(Account a:acc){
                a.Process_to_CT__c = TRUE;
            }
            update acc;
        test.stoptest();
        Account expectedAcc = [SELECT id,Sent_to_CommercialTeam__c FROM Account WHERE id=:acc[0].id];
        system.assertEquals(null,expectedAcc.Sent_to_CommercialTeam__c);
    }
    /*End : Account data process to commercialteam with valid and invalid data*/
    
    
    /*Start : Product2 data process to commercialteam with valid and invalid data*/
    @isTest
    static void validProd2DataToProcess(){
        test.startTest();
            Test.setMock(HttpCalloutMock.class, new VertoPharmaMockTestData('Successfully sent to medical team'));
            List<Product2> prod = [SELECT id FROM Product2];
            for(Product2 p:prod){
                p.FDA_Approved__c = TRUE;
            }
            update prod;
        test.stoptest();
        Product2 expectedProd = [SELECT id,Sent_to_CommercialTeam__c FROM Product2 WHERE id=:prod[0].id];
        system.assertEquals('Successfully sent to medical team',expectedProd.Sent_to_CommercialTeam__c);
    }
    
    @isTest
    static void invalidProd2DataToProcess(){
        test.startTest();
            List<Product2> prod = [SELECT id FROM Product2];
            for(Product2 p:prod){
                p.FDA_Approved__c = TRUE;
            }
            update prod;
        test.stoptest();
        Product2 expectedProd = [SELECT id,Sent_to_CommercialTeam__c FROM Product2 WHERE id=:prod[0].id];
        system.assertEquals(null,expectedProd.Sent_to_CommercialTeam__c);
    }
    
    /*End: Product2 data process to commercialteam with valid and invalid data*/
    
}