public class ChildObjectTriggerHandler {
    
    public static void RollupToParent(List<Child_Object__c> newList, Map<Id, Child_Object__c> oldMap) {

        Set<Id> parentIds = new Set<Id>();

        if (newList != null && oldMap == null) {
            for (Child_Object__c newChild : newList) {
                if (newChild.Parent_Object__c != null) {
                    parentIds.add(newChild.Parent_Object__c);
                }
            }
        }
        if (newList == null && oldMap != null) {
            for (Child_Object__c oldChild : oldMap.values()) {
                if (oldChild.Parent_Object__c != null) {
                    parentIds.add(oldChild.Parent_Object__c);
                }
            }
        }
        if (newList != null && oldMap != null) {
            for (Child_Object__c newChild : newList) {
                Child_Object__c oldChild = oldMap.get(newChild.Id);
                if (newChild.Parent_Object__c != null) {
                    parentIds.add(newChild.Parent_Object__c);
                }
                if (oldChild.Parent_Object__c != null) {
                    parentIds.add(oldChild.Parent_Object__c);
                }
            }
        }

        if (parentIds.size() > 0) {
            Database.executeBatch(new RollupsBatch(parentIds), 2000);
        }
    }
}