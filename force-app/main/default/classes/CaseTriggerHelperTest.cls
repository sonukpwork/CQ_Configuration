@isTest
public class CaseTriggerHelperTest {
    @isTest
    public static void positive1(){
        List<Case> newCaseList = new List<Case>();
        //List<Case> updateCases = new List<Case>();
        
        for(Integer i=0; i<5; i++){
            newCaseList.add(new Case(Subject='Test'+i,Description='Description'+i,Type='Problem',origin='Phone',Status='New'));
        }
        
        insert newCaseList;
        
        System.assertEquals(5,newCaseList.size());
        
        SQX_Nonconformance__c nc = [Select id,QMS_Reference_Number__c from SQX_Nonconformance__c WHERE QMS_Reference_Number__c =: newCaseList[0].CaseNumber LIMIT 1];
        
        System.assertEquals(newCaseList[0].CaseNumber, nc.QMS_Reference_Number__c);
        
    }
    
    @isTest
    public static void positive2(){
        List<Case> newCaseList = new List<Case>();
        List<Case> updateCases = new List<Case>();
        
        for(Integer i=0; i<5; i++){
            newCaseList.add(new Case(Subject='Test'+i,Description='Description'+i,Type='Mechanical',origin='Phone',Status='New'));
        }
        
        insert newCaseList;
        
        for(Case c: newCaseList){
            c.Type = 'Problem';
            updateCases.add(c);
        }
        
        update updateCases;
        
        System.assertEquals(5,updateCases.size());
        
    }
    
    @isTest
    public static void Negetive1(){
        SQX_Nonconformance__c sn = new SQX_Nonconformance__c(Priority__c = 'Medium',Title__c = 'Test',Description__c = 'Test',QMS_Reference_Number__c = '1234');
        insert sn;
        
        Case cs = new Case(Subject='Test',Description='Description',Type='Mechanical',origin='Phone',Status='New',SQX_Nonconformance__c=sn.id);
        insert cs;
        
        cs.Type = 'Problem';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(cs, false);
        Test.stopTest();
        
        System.assert(sr.getErrors().size() == 1);
        
        
    }
    
}