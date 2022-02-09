public class QueryInForStatement {
    
    public static Map<Id, Decimal> Test1() {

        Integer startTime = Limits.getCpuTime();
        DateTime startTime2 = DateTime.now();

        Map<Id, Decimal> totalsMap = new Map<Id, Decimal>();

        for (Child_Object__c child : [SELECT Id, Amount__c, Parent_Object__c FROM Child_Object__c]) {
            if (child.Parent_Object__c != null && child.Amount__c != null) {
                if (totalsMap.containsKey(child.Parent_Object__c)) {
                    totalsMap.put(child.Parent_Object__c, totalsMap.get(child.Parent_Object__c) + child.Amount__c);
                } else {
                    totalsMap.put(child.Parent_Object__c, child.Amount__c);
                    System.debug('Heap Size 1: ' + Limits.getHeapSize());
                }
            }
        }
        
        Integer endTime = Limits.getCpuTime();
        DateTime endTime2 = DateTime.now();
        System.debug('CPU Time: ' + (endTime - startTime));
        System.debug('Real Time: ' + (endTime2.getTime() - startTime2.getTime()));
        System.debug('Heap Size: ' + Limits.getHeapSize());

        return totalsMap;
    }

    public static Map<Id, Decimal> Test2() {

        Integer startTime = Limits.getCpuTime();
        DateTime startTime2 = DateTime.now();

        Map<Id, Decimal> totalsMap = new Map<Id, Decimal>();

        List<Child_Object__c> children = [SELECT Id, Amount__c, Parent_Object__c FROM Child_Object__c];

        for (Child_Object__c child : children) {
            if (child.Parent_Object__c != null && child.Amount__c != null) {
                if (totalsMap.containsKey(child.Parent_Object__c)) {
                    totalsMap.put(child.Parent_Object__c, totalsMap.get(child.Parent_Object__c) + child.Amount__c);
                } else {
                    totalsMap.put(child.Parent_Object__c, child.Amount__c);
                    System.debug('Heap Size 1: ' + Limits.getHeapSize());
                }
            }
        }
        
        Integer endTime = Limits.getCpuTime();
        DateTime endTime2 = DateTime.now();
        System.debug('CPU Time: ' + (endTime - startTime));
        System.debug('Real Time: ' + (endTime2.getTime() - startTime2.getTime()));
        System.debug('Heap Size: ' + Limits.getHeapSize());

        return totalsMap;
    }
}
