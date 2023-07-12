/*
 * Trigger Name: CaseTrigger
 * Description: This Trigger run on Case Object and performs all the dml related logics related to the cases.
 * Author: Sonu Kashyap
*/

trigger CaseTrigger on Case (before insert, before update, after insert, after Update) { 
    if(Trigger.isBefore){
        if(CaseTriggerHelper.checkPermissionSet(UserInfo.getUserName(),'Case_Admin')){
            if(Trigger.IsInsert){
                CaseTriggerHelper.createNonconformance(Trigger.new, Trigger.oldMap, 'Insert');	
            } else if(Trigger.isUpdate){
                CaseTriggerHelper.createNonconformance(Trigger.new, Trigger.oldMap, 'Update');
            }   
        }
    }
    
}