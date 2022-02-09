public class RollupsBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private Set<Id> parentIds;
    private Map<Id, Decimal> totalsMap;

    public RollupsBatch(Set<Id> parentIds) {
        this.parentIds = parentIds;

        totalsMap = new Map<Id, Decimal>();
        for (Id parentId : parentIds) {
            totalsMap.put(parentId, 0);
        }
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Amount__c, Parent_Object__c FROM Child_Object__c WHERE Parent_Object__c IN :parentIds');
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<Child_Object__c> children = (List<Child_Object__c>)scope;

        for (Child_Object__c child : children) {
            if (child.Amount__c != null) {
                totalsMap.put(child.Parent_Object__c, totalsMap.get(child.Parent_Object__c) + child.Amount__c);
            }
        }
    }

    public void finish(Database.BatchableContext BC) {

        List<Parent_Object__c> parents = [SELECT Id, Total_Amount__c FROM Parent_Object__c WHERE Id IN :totalsMap.keySet()];

        List<Parent_Object__c> toUpdate = new List<Parent_Object__c>();

        for (Parent_Object__c parent : parents) {
            if (parent.Total_Amount__c != totalsMap.get(parent.Id)) {
                parent.Total_Amount__c = totalsMap.get(parent.Id);
                toUpdate.add(parent);
            }
        }

        if (toUpdate.size() > 0) {
            update toUpdate;
        }
    }
}