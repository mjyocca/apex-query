public with sharing class Example {
  @RemoteAction
  public static Object queryJSON(String jsonString) {
    Query q = new Query().fromJSON(jsonString);
    q.run();
    return q;
  }

  public static void example() {
    Map<Id, sObject> accts = new Map<Id, sObject>([SELECT ID FROM Account]);
    List<sObject> res = new Query()
      .fromSObject('Account')
      .fields(new List<String>{ 'Id', 'Name' })
      .whereFilter('ID', 'IN', accts)
      .limitRows(200)
      .run();
  }


  public static void newQuery() {
    List<sObject> q = new Query()
      .fromSObject('Account')
      .fields(new List<String>{'Id', 'Name', 'AnnualRevenue', 'Industry'})
      .run();
  }

}