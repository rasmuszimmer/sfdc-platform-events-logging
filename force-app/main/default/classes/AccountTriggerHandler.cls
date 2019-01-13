public with sharing class AccountTriggerHandler {
    public static void handleAfterInsert(List<Account> newAccounts) {

        List<Contact> contactsToInsert = new List<Contact>();

        for (Account a : newAccounts) {
            contactsToInsert.add(new Contact(AccountId = a.Id, LastName = 'TestName'));
        }

        Logger.logTrace('Inserting contacts: \r\n ' + JSON.serializePretty(contactsToInsert));

        insert contactsToInsert;
    }
}
