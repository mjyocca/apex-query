# Apex Query

Build dynamic SOQL queries in Apex/JSON

### Main Objectives

- Build dynamic queries in Apex
- Build dynamic queries in Javascript (that can be deserialized/mapped server side)
- Ability to Mock Queries in Apex Testing
  - Helps with Apex Testing w/ out the need to commiting data to the database
- Security First: CRUD | FLS | SOQL Injection Protection
    - CRUD/FLS ~ `WITH SECURITY_ENFORCED` & `Security.stripInaccessible`

### Current Unsupported Features

- SOSL
- Aggregate
- TYPEOF
- HAVING
- FOR REFERENCE
- FOR VIEW
- FOR UPDATE

### Examples

#### Testing

Can either pass in a `List<SObject>` or a class that extends `QueryMock` class.

```java
@isTest
private class SomeTest {
    private static testMethod testProcess() {
        List<Account> dummy = new List<Account>();
        for(Integer i = 0; i < 10; i++) {
            dummy.add(new Account(Name='Test ' + i));
        }
        Query.setMock(dummy);

        Test.startTest();
            ...// assert test methods
        Test.stopTest();
    }
}
```

#### Options

- `securityEnforced`: Adds `WITH SECURITY_ENFORCED` to the query

  - Default: TRUE

- `stripInaccessible`: Uses the built in stripInaccessible method based on the AccessType defined, after the query has run
  - Default: FALSE
- `flsAccess`: AccessType Enum
  - Default: null

```java
List<sObject> res = new Query(
    new Query.Options(
        false, // securityEnforced
        true, // stripInaccessible
        AccessType.READABLE
    ))
    .fromSObject('Contact')
    .fields(new List<String>{'Id', 'Name'})
    .run();
```

#### Basic

```java
List<sObject> res = new Query()
    .fromSObject('Account')
    .fields(new List<String>{'Id', 'Name'})
    .run();
```

#### IN, NOT IN collection variables

Supports:
- `Map<Id, sObject>`
- `List<sObject>`
- `List<String>`
- `List<Object>`
- `Set<String>`
- `Set<Id>`
- `Set<Decimal>`

```java
List<String> recordIds = new List<String>{'001J000002Yzs4CIAR', '001J000002Yzs4DIAR'};
List<sObject> res = new Query()
    .fromSObject('Account')
    .fields(new Set<String>{'Id', 'Name'})
    .whereFilter('ID', 'IN', recordIds)
    .run();
```

```java
Map<Id, sObject> accts = new Map<Id, sObject>([SELECT ID FROM Account]);
List<sObject> res = new Query()
    .fromSObject('Account')
    .fields(new List<String>{ 'Id', 'Name' })
    .whereFilter('ID', 'IN', accts)
    .limitRows(200)
    .run();
```

#### toString Bind Variable Example

*If your collection variable is longer than 20 items, and wish to get the compiled query string, make sure to make use of the `new Query.bind(':varName')`.

```java
Map<Id, sObject> accts = new Map<Id, sObject>([SELECT ID FROM Account]);
// variable name declared here
Set<Id> acctIds = accts.keySet();
Query q = new Query()
    .fromSObject('Account')
    .fields(new List<String>{ 'Id', 'Name' })
    // is passed in here
    .whereFilter('ID', 'IN', new Query.bind(':acctIds'))
    .limitRows(200);
    for(Account sobj : Database.query(q.queryString())) {
    // processing here
    }
}
```


#### SubQuery

```java
List<sObject> res = new Query()
    .fromSObject('Account')
    .fields(new List<String>{'Id', 'Name'})
    .subQuery(
        'Opportunities',
        new List<String>{'Id', 'StageName'},
        null
    )
    .limitRows(200)
    .run();
```

#### Cross Object Query

```java
// opts
Query.Options opts = new Query.Options(
    false,
    true,
    AccessType.READABLE
    );
// cross object filters
List<Query.Filter> contactFilters = new List<Query.Filter>();
    contactFilters.add(new Query.Filter('LeadSource', '=', 'Purchased List'));
    contactFilters.add(new Query.Filter('DoNotCall', '=', false));

List<sObject> res = new Query(opts)
    .fromSObject('Account')
    .fields(new List<String>{'Id', 'Name'})
    .subQuery('Opportunities', new List<String>{'Id', 'StageName'})
    .whereFilter('ID', 'NOT IN', new Query.CXFilter(
        'Contact',
        'AccountId',
        contactFilters,
        'OR'
    ))
    .run();

// runs
/*
SELECT Id, Name, (SELECT Id, StageName FROM Opportunities)
FROM Account
WHERE ID NOT IN (SELECT AccountId FROM Contact WHERE LeadSource = 'Purchased List' OR DoNotCall = false)
*/
```

#### Javascript

Construct dynamic queries in Javascript,

Object key/prop names are case insensitive. Should lead to less debugging and confusion.

\*.js

```js
const payload = JSON.stringify({
    options: {
        securityEnforced: true,
        stringInaccessible: false,
        AccessType: 'CREATABLE'
    },
    fields: ['Id', 'Name'],
    subQueries: [{
        sObjectName: 'Contacts',
        fields: ['Id', 'Name'],
        condition: {
            filters: [
                { fieldName: 'LeadSource', operator: '=', value: 'Web' },
                { fieldName: 'Name', operator: '=', value: 'Jack Rogers' },
                { fieldName: 'Email', operator: '!=', value: null }
            ],
            logic: '(1 OR 2) AND 3'
        }
    }],
    sObjectName: 'Account',
    condition: {
        filters: [
            {
                fieldName: 'ID',
                operator: 'IN',
                cxValue: {
                    sObjectName: 'Opportunity',
                    fieldName: 'AccountId',
                    condition: {
                        filters: [{
                            fieldName: 'StageName',
                            operator: '=',
                            value: 'Closed Won'
                        }]
                    }
                }
            },
            {
                fieldName: 'ID',
                operator: 'NOT IN',
                cxValue: {
                    sObjectName: 'Contact',
                    fieldName: 'AccountId',
                    condition: {
                        filters: [
                            {
                                fieldName: 'LeadSource',
                                operator: '=',
                                value: 'Purchased List'
                            },
                            {
                                fieldName: 'DoNotCall',
                                operator: '=',
                                value: false
                            }
                        ],
                        logic: 'OR'
                    }
                }
            }
        ],
        logic: 'AND'
    },
    limitRows: 200
});

/**
 *
*/
visualforce.remoting.invokeAction(... , payload, (result, event) => {
    ..
});
```

[ApexController].cls

```java
public class  ApexController {
    @RemoteAction
    public static List<sObject> queryJSON(string jsonStr) {
        /* Pass in json string */
        Query q = new Query().fromJSON(jsonStr);
        /* Can pass in Map<String, Object>
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
        Query q = new Query().fromJSON(jsonMap);
        */
        return q.run();
    }
}
```
