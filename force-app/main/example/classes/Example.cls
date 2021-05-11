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
      .whereFilter('ParentId', 'IN', accts)
      .whereLogic('OR')
      .limitRows(200)
      .run();
      system.debug(accts.size());
      system.debug(res.size());
      System.debug(res);
  }

  public static void bindExample()  {
    Map<Id, sObject> accts = new Map<Id, sObject>([SELECT ID FROM Account]);
    Set<Id> acctIds = accts.keySet();
    String q = new Query()
      .fromSObject('Account')
      .fields(new List<String>{ 'Id', 'Name' })
      .whereFilter('ID', 'IN', new Query.Bind(':acctIds'))
      .limitRows(200)
      .queryString();
      for(Account sobj : Database.query(q)) {
        // processing here
      }
  }


  public static void newQuery() {
    List<sObject> q = new Query()
      .fromSObject('Account')
      .fields(new List<String>{'Id', 'Name', 'AnnualRevenue', 'Industry'})
      .run();
  }

}
