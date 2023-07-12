/*
 * Class Name: CaseTriggerHelper
 * Description: This apex class create Nonconformance object records when cases created with type as problem.
 * Test Class: CaseTriggerHelperTest
 * Author: Sonu Kashyap
*/
public class CaseTriggerHelper {
    
    public static void createNonconformance(List<Case> caseList, Map<Id,Case> oldCaseMap, String actionType){
        List<SQX_Nonconformance__c> ncList = new List<SQX_Nonconformance__c>();
        Map<String,Case> caseNoMap = new Map<String,Case>();
        
        if(actionType == 'Insert'){
            
            for(Case c: caseList){
                if(c.Type == 'Problem'){
                    ncList.add(new SQX_Nonconformance__c(Priority__c = c.Priority,Title__c = c.Subject,Description__c = c.Description,QMS_Reference_Number__c = c.CaseNumber));
                	caseNoMap.put(c.CaseNumber,c);
                }
            }
            
        } else if(actionType == 'Update'){
            for(Case c: caseList){
                if(c.Type == 'Problem' && oldCaseMap.get(c.id).Type != 'Problem'){
                    if(c.SQX_Nonconformance__c != null){
                    	c.addError('Nonconformance already created on this case.');
                    } else{
                     	ncList.add(new SQX_Nonconformance__c(Priority__c = c.Priority,Title__c = c.Subject,Description__c = c.Description,QMS_Reference_Number__c = c.CaseNumber));
                		caseNoMap.put(c.CaseNumber,c);   
                    }
                }
            }
        }
        
        if(!ncList.isEmpty()){
            insert ncList;
            
            for(SQX_Nonconformance__c nc: ncList){
                caseNoMap.get(nc.QMS_Reference_Number__c).SQX_Nonconformance__c = nc.id;
            }
            
        }
    }
    
    Public Static Boolean checkPermissionSet(String userName, String permissionSetName) {
    	List<PermissionSetAssignment> psas = [ select Id from PermissionSetAssignment where PermissionSetId IN ( select Id from PermissionSet where Name = :permissionSetName) and AssigneeId IN (select Id from User where UserName = :userName ) ];
    	Return psas.size() > 0;
	}
    
}