public class LoopsTests {
    
    public static Map<String, List<String>> GetEmails1(Set<Id> accountIds) {

        Map<String, List<String>> emailsMap = new Map<String, List<String>>();

        List<Contact> contacts = [SELECT Id, Email, Account.Name FROM Contact WHERE AccountId IN :accountIds];

        Integer startTime = Limits.getCpuTime();

        for (Contact cnt : contacts) {
            if (!emailsMap.containsKey(cnt.Account.Name)) {
                emailsMap.put(cnt.Account.Name, new List<String>());
            }
            emailsMap.get(cnt.Account.Name).add(cnt.Email);
        }

        Integer endTime = Limits.getCpuTime();

        System.debug(endTime - startTime);

        return emailsMap;
    }

    public static Map<String, List<String>> GetEmails2(Set<Id> accountIds) {

        Map<String, List<String>> emailsMap = new Map<String, List<String>>();

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        List<Contact> contacts = [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN :accountIds];

        Integer startTime = Limits.getCpuTime();

        for (Account acc : accounts) {
            List<String> emails = new List<String>();
            for (Contact cnt : contacts) {
                if (acc.Id == cnt.AccountId) {
                    emails.add(cnt.Email);
                }
            }
            emailsMap.put(acc.Name, emails);
        }

        Integer endTime = Limits.getCpuTime();

        System.debug(endTime - startTime);

        return emailsMap;
    }

    public static Map<String, List<String>> GetEmails3(Set<Id> accountIds) {

        Map<String, List<String>> emailsMap = new Map<String, List<String>>();

        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Email FROM Contacts) 
                                    FROM Account WHERE Id IN :accountIds];
        
        Integer startTime = Limits.getCpuTime();

        for (Account acc : accounts) {
            List<String> emails = new List<String>();
            for (Contact cnt : acc.Contacts) {
                emails.add(cnt.Email);
            }
            emailsMap.put(acc.Name, emails);
        }

        Integer endTime = Limits.getCpuTime();

        System.debug(endTime - startTime);

        return emailsMap;
    }
}
