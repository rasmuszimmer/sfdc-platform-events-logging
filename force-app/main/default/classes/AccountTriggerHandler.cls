public with sharing class AccountTriggerHandler {
    public static void handleAfterInsert(List<Account> newAccounts) {

        List<Contact> contactsToInsert = new List<Contact>();

        for (Account a : newAccounts) {
            contactsToInsert.add(new Contact(AccountId = a.Id, LastName = a.Name));
        }

        Logger.logTrace('Inserting contacts: ' + JSON.serialize(contactsToInsert));

        insert contactsToInsert;

        Logger.logTrace('Contacts inserted.');

        Logger.logTrace('Testing exception');
        try {
            String s;
            s.trim();
        } catch (Exception ex) {
           Logger.logException(ex);
        }

        test.testLog();
    }
}
