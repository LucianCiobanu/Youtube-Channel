trigger ChildObjectTrigger on Child_Object__c (after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ChildObjectTriggerHandler.RollupToParent(Trigger.new, null);
        }
        if (Trigger.isUpdate) {
            ChildObjectTriggerHandler.RollupToParent(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            ChildObjectTriggerHandler.RollupToParent(null, Trigger.oldMap);
        }
        if (Trigger.isUndelete) {
            ChildObjectTriggerHandler.RollupToParent(Trigger.new, null);
        }
    }
}