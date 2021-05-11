public inherited sharing class Query {
  /* Static Shared Data Memory ~ For Performance */
  private static Map<String, Schema.DescribeSObjectResult> sObjectDescribeCache = new Map<String, Schema.DescribeSObjectResult>();

  @testVisible
  private static Schema.DescribeSObjectResult describeSObject(
    String sObjectName
  ) {
    String objTypeName = sObjectName.toLowerCase();
    Schema.DescribeSObjectResult retVal;
    if (sObjectDescribeCache.get(objTypeName) != null) {
      retVal = sObjectDescribeCache.get(objTypeName);
    } else {
      try {
        Type t = Type.forName(objTypeName);
        if (t == null)
          return null;
        SObject obj = (SObject) t.newInstance();
        retVal = obj.getSObjectType().getDescribe();
        sObjectDescribeCache.put(objTypeName, retVal);
      } catch (Exception e) {
        return null;
      }
    }
    return retVal;
  }
  /* Static Shared Data Memory ~ For Performance */

  /** Testing Mock Implementations */
  /**
   *
   * Query.setMock(new CustomQueryMock()) | Query.setMock(new List<sObject>())
   */
  @testVisible
  private static Boolean isTest = Test.isRunningTest();

  private static List<List<sObject>> queryMockResults = new List<List<sObject>>();

  public static void setMock(List<QueryMock> queries) {
    for (QueryMock q : queries) {
      queryMockResults.add(q.run());
    }
  }

  public static void setMock(QueryMock q) {
    queryMockResults.add(q.run());
  }

  public static void setMock(List<sObject> mockResponse) {
    queryMockResults.add(mockResponse);
  }
  /** Testing Mock Implementations */

  /* Custom Exception */
  public class QueryException extends Exception {
  }

  public static final String QUOTE = '\'';
  public static final String SPACE = ' ';
  public static final String BRACKET_LEFT = '(';
  public static final String BRACKET_RIGHT = ')';
  public static final String EQUALS = '=';
  public static final String NOT_EQUALS = '!=';
  public static final String GREATER_THAN = '>';
  public static final String GREATER_OR_EQUAL = '>=';
  public static final String LESS_THAN = '<';
  public static final String LESS_OR_EQUAL = '<=';
  public static final String IS_LIKE = 'LIKE';
  public static final String IS_IN = 'IN';
  public static final String NOT_IN = 'NOT IN';
  public static final String INCLUDES = 'INCLUDES';
  public static final String EXCLUDES = 'EXCLUDES';

  public Query(Object obj) {
  }

  public Query() {
    Options opts = new Options();
    opts.securityEnforced = true;
    opts.stripInaccessible = false;
    this.options = opts;
  }

  public Query(Boolean securityEnforced) {
    Options opts = new Options();
    opts.securityEnforced = securityEnforced;
    opts.stripInaccessible = false;
    this.options = opts;
  }

  public Query(
    Boolean securityEnforced,
    Boolean stripInaccessible,
    AccessType type
  ) {
    Options opts = new Options();
    opts.securityEnforced = securityEnforced;
    opts.stripInaccessible = false;
    opts.AccessType = type;
    this.options = opts;
  }

  public Query(Options options) {
    this();
    this.options = options;
  }

  public class Options {
    public Boolean securityEnforced { get; set; }
    public Boolean stripInaccessible { get; set; }
    public AccessType AccessType { get; set; }
    public Options() {
    }
    public Options(Boolean secEnforced) {
      this.securityEnforced = secEnforced;
    }
    public Options(Boolean secEnforced, Boolean strip, AccessType type) {
      this.securityEnforced = secEnforced;
      this.stripInaccessible = strip;
      this.AccessType = type;
    }
  }

  public class OrderBy {
    public String fieldName { get; set; }
    public OrderDirection OrderDirection { get; set; }
    public Boolean nullsFirst { get; set; }
  }

  public class Condition {
    public List<Filter> filters { get;set; }
    public String logic { get;set; }
    public Condition() {
      this.filters = new List<Filter>();
      this.logic = 'AND';
    }
    public Condition(List<Filter> filters, String logic) {
      this.filters = filters;
      this.logic = logic;
    }
  }

  public enum OrderDirection {
    ASCENDING,
    DESCENDING
  }

  public class Filter {
    public String fieldName { get; set; }
    public String operator { get; set; }
    public Object value { get; set; }
    public CXFilter cxValue { get; set; }
    public Filter(string fieldName, String operator, Object value) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = value;
    }
    public Filter(string fieldName, String operator, List<Object> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(string fieldName, String operator, List<sObject> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(string fieldName, String operator, Map<Id, sObject> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(string fieldName, String operator, Set<Id> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(string fieldName, String operator, Set<String> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(string fieldName, String operator, Set<Decimal> values) {
      this.fieldName = fieldName;
      this.operator = operator;
      this.value = values;
    }
    public Filter(String fldName, String op, CXFilter cxF) {
      this.fieldName = fldName;
      this.operator = op;
      this.cxValue = cxF;
    }
  }

  public class CXFilter {
    public String sObjectName { get; set; }
    public String fieldName { get; set; }
    public Condition condition { get {
      if (condition == null) condition = new Condition();
      return condition;
    } set; }

    public CXFilter() {
    }
    public CXFilter(String sobjName, String fldName) {
      this.sObjectName = sobjName;
      this.fieldName = fldName;
    }
    public CXFilter(String sobjName, String fldName, Filter filter) {
      this.sObjectName = sobjName;
      this.fieldName = fldName;
      this.condition.filters.add(filter);
    }
    public CXFilter(String sobjName, String fldName, List<Filter> filters) {
      this.sObjectName = sobjName;
      this.fieldName = fldName;
      this.condition.filters = filters;
    }
    public CXFilter(
      String sobjName,
      String fldName,
      List<Filter> filters,
      String fLogic
    ) {
      this.sObjectName = sobjName;
      this.fieldName = fldName;
      this.condition.filters = filters;
      this.condition.logic = fLogic;
    }
  }

  public class SubQuery {
    public List<String> fields { get; set; }
    public String sObjectName { get; set; }
    public Condition condition { get {
      if (condition == null) condition = new Condition();
      return condition;
    } set; }
    public Integer limitRows { get; set; }

    public subQuery(
        String sobjName,
        List<String> fields
    ) {
      this.sObjectName = sobjName;
      this.fields = fields;
    }
    public SubQuery(
      String sobjName,
      List<String> fields,
      List<Filter> filters
    ) {
      this.sObjectName = sobjName;
      this.fields = fields;
      this.condition.filters = filters;
    }
    public SubQuery(
      String sobjName,
      List<String> fields,
      List<Filter> filters,
      String fLogic
    ) {
      this.sObjectName = sobjName;
      this.fields = fields;
      this.condition.filters = filters;
      this.condition.logic = fLogic;
    }
  }

    /* */
    @testVisible
    private Schema.DescribeSObjectResult objectDescribe { get; set; }
    @testVisible
    private String queryTemplate;
    @testVisible
    private String finalQuery;
    @testVisible
    private String debugQuery;
    @testVisible
    private Map<String, String> soqlParts = new Map<String, String>();
    @testVisible
    private SObjectAccessDecision securityDecision;
    /* */

    /* 
      100k query string limit, circumvent too many values in query string and use bind variables.
      Not a scalable solution but the bind variables need to be declared where the query is run
    */
    @testVisible
    private static final Integer BIND_SIZE = 20;
    @testVisible
    private Object bind1;
    @testVisible
    private Object bind2;
    @testVisible
    private Object bind3;
    @testVisible
    private Object bind4;
    @testVisible
    private Object bind5;
    @testVisible
    private Object bind6;
  
    public class Bind {
      public String var { get; set; }
      
      public Bind(String var) {
        this.var= var;
      }
      
      public String getName() {
        if (!this.var?.startsWith(':')){
          return ':' + this.var;
        }
        return this.var;
      }
    }

  /* Classes / Complex Data Structures */
  /* Public Instance member variables */
  public Options options { get;set; }
  public List<String> fields { get;set; }
  public String sObjectName;
  public Condition condition { get {
    if (condition == null) condition = new Condition();
    return condition;
  } set; }
  public List<SubQuery> subQueries { get;set; }
  public String groupBy;
  public OrderBy orderBy;
  public Integer limitRows;
  public Integer offSet;
  /* Public Instance member variables */

  /* JSON Mapping Utils */
  private static Object parseEnum(string enumString, Type enumType) {
    Type cType = Type.forName(String.format('List<{0}>', new List<String>{ enumType.getName() }));
    return ((List<Object>) JSON.deserialize(String.format('["{0}"]', new List<String>{ enumString }), cType))[0];
  }

  private static List<String> convertStringList(List<Object> tmp) {
    List<String> collection = new List<String>();
    for(Object o : tmp) {
      collection.add(String.ValueOf(o));
    }
    return collection;
  }

  private static Map<String, Object> lowerCaseObject(Map<String, Object> obj) {
    Map<String, Object> lCaseObj = new Map<String, Object>();
    for(String s : obj.keySet()) {
      lCaseObj.put(s.toLowerCase(), obj.get(s));
    }
    return lCaseObj;
  }

  private static Condition getConditionFromJSON(Map<String, Object> conditionJSON) {
    Condition con = new Condition();
    conditionJSON = lowerCaseObject(conditionJSON);
    if (conditionJSON.get('filters') != null) {
      for(Object fObj : (List<Object>)conditionJSON.get('filters')) {
        Map<String, Object> fmap = lowerCaseObject((Map<String, Object>)fObj);
        Set<String> fKeyMap = fmap.keySet();
        // if value is cross object
        if (fKeyMap.contains('value') &&
          fmap.get('value') instanceOf Map<String, Object>) {
          con.filters.add(new Filter(
            (String)fMap.get('fieldname'),
            (String)fMap.get('operator'),
            getCXFilterFromJSON((Map<String, Object>)fMap.get('value'))
          ));
        // cross object prop name is cxvalue
        } else if (fKeyMap.contains('cxvalue')) {
          con.filters.add(new Filter(
            (String)fMap.get('fieldname'),
            (String)fMap.get('operator'),
            getCXFilterFromJSON((Map<String, Object>)fMap.get('cxvalue'))
          ));
        // interpret filter expressed as null
        } else {
          con.filters.add(new Filter(
            (String)fMap.get('fieldname'),
            (String)fMap.get('operator'),
            fMap.get('value')
          ));
        }
      }
    }
    if (conditionJSON.get('logic') != null) {
      con.logic = (String)conditionJSON.get('logic');
    }
    return con;
  }

  private static CXFilter getCXFilterFromJSON(Map<String, Object> cxJSON) {
    cxJSON = lowerCaseObject(cxJSON);
    CXFilter crossObjFilter = new CXFilter();
    crossObjFilter.fieldName = (String)cxJSON.get('fieldname');
    crossObjFilter.sObjectName = (String)cxJSON.get('sobjectname');
    crossObjFilter.condition = getConditionFromJSON((Map<String, Object>)cxJSON.get('condition'));
    return crossObjFilter;
  }
  /* JSON Mapping Utils */

  /* JSON Mapping Methods */
  private void mapOptions(Map<String, Object> optsJSON) {
    if (optsJSON == null) return;
    optsJSON = lowerCaseObject(optsJSON);
    this.options.AccessType = (AccessType)parseEnum((String)optsJSON.get('accesstype'), AccessType.class);
    this.options.securityEnforced = (Boolean)optsJSON.get('securityenforced');
    this.options.stripInaccessible = (Boolean)optsJSON.get('stripinaccessible');
  }

  private void mapOrderBy(Map<String, Object> orderJSON) {
    if (orderJSON == null) return;
    orderJSON = lowerCaseObject(orderJSON);
    if (this.orderBy == null) this.orderBy = new OrderBy();
    this.orderBy.fieldName = (String)orderJSON.get('fieldname');
    this.orderBy.OrderDirection = (Query.OrderDirection)parseEnum(
      (String)orderJSON.get('orderdirection'), Query.OrderDirection.class);
  }

  private void mapCondition(Map<String, Object> conditionJSON) {
    Condition con = getConditionFromJSON(conditionJSON);
    this.condition.filters = con.filters;
    if (con.logic != null) {
      this.condition.logic = con.logic;
    }
  }

  private void mapSubQueries(List<Object> subQueryJSON) {
    if (this.subQueries == null) this.subQueries = new List<SubQuery>();
    for(Object subQ : subQueryJSON) {
      Map<String, Object> subQuery = lowerCaseObject((Map<String, Object>)subQ);
      SubQuery sq = new SubQuery(
        (String)subQuery.get('sobjectname'),
        convertStringList((List<Object>)subQuery.get('fields'))
      );
      if (subQuery.get('condition') != null) {
        sq.condition = getConditionFromJSON(
          (Map<String, Object>)subQuery.get('condition')
        );
      }
      if (subQuery.get('limitrows') != null) {
        sq.limitRows = (Integer)subQuery.get('limitrows');
      }
      this.subQueries.add(sq);
    }
  }

  private void mapFromJSON(Map<String, Object> config) {
    for(String s : config.keySet()) {
      String prop = s.toLowerCase();
      if (prop == 'fields') {
        this.fields = convertStringList((List<Object>)config.get(s));
      } else if (prop == 'subqueries') {
        this.mapSubQueries((List<Object>)config.get(s));
      } else if (prop == 'sobjectname') {
        this.sObjectName = (String)config.get(s);
      } else if (prop == 'condition') {
        this.mapCondition((Map<String, Object>)config.get(s));
      } else if (prop == 'options') {
        this.mapOptions((Map<String, Object>)config.get(s));
      } else if (prop == 'groupby') {
        this.groupBy = (String)config.get(s);
      } else if (prop == 'orderBy') {
        this.mapOrderBy((Map<String, Object>)config.get(s));
      } else if (prop == 'limitrows') {
        this.limitRows = (Integer)config.get(s);
      } else if (prop == 'offset') {
        this.offSet = (Integer)config.get(s);
      }
    }
  }

  public Query fromJSON(Map<String, Object> jsonConfig) {
    this.mapFromJSON(jsonConfig);
    return this;
  }

  public Query fromJSON(string jsonString) {
    Map<String, Object> jsonConfig = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
    this.fromJSON(jsonConfig);
    return this;
  }
  /* JSON Mapping Methods */

  private String getOrderBy() {
    String tmp = this.orderBy.fieldName + ' ';
    tmp += this.orderBy.OrderDirection == OrderDirection.ASCENDING
      ? 'ASC'
      : 'DESC';
    if (this.orderBy.nullsFirst == true) {
      tmp += ' NULLS FIRST';
    } else if (this.orderBy.nullsFirst == false) {
      tmp += ' NULLS LAST';
    }
    return tmp;
  }

  /* ======= PRIVATE UTILS Methods ======== */

  private static Boolean dateOrDateTime(String val) {
    Boolean isDateOrDateTime = false;
    try {
      Date.valueOf(val);
      isDateOrDateTime = true;
    } catch(Exception err) {
      isDateOrDateTime = false;
    }
    return isDateOrDateTime;
  }

  private Object setFilterValue(Object o) {
    Object returnVal;
    if (o == null || o == 'null') {
      returnVal = null;
    } else if (o instanceOf String) {
      Boolean isDate = dateOrDateTime((String)o);
      returnVal = isDate ? String.valueOf(o) : QUOTE + String.valueOf(o) + QUOTE;
    } else if (o instanceOf String[]) {
      returnVal = inConditionHelper((List<Object>)o);
    } else if (o instanceOf sObject[]) {
      Map<Id, SObject> sObjMap = new Map<Id, SObject>((List<sObject>)o);
      returnVal = inConditionHelper(new List<Id>(sObjMap.keySet()));
    } else if (o instanceOf Map<Id, sObject>) {
      Map<Id, SObject> sObjMap = (Map<Id,SObject>)o;
      returnVal = inConditionHelper(new List<Id>(sObjMap.keySet()));
    } else if (o instanceOf Object[]) {
      returnVal = inConditionHelper((List<Object>)o);
    } else if (o instanceOf Bind) {
      Bind b = (Bind)o;
      returnVal = b.getName();
    }  else {
      returnVal = o;
    }
    return returnVal;
  }

  /**
   * (1 AND 2) OR 3 => ({0} AND {1}) OR {2}
   */
  private static String prepareTemplate(String template) {
    String[] matchedChunks = new List<String>{};
    String regX = '([0-9]+)';
    Pattern myPattern = Pattern.compile(regX);
    Matcher match = myPattern.matcher(template);
    while (match.find()) {
      String chunk = match.group(1);
      matchedChunks.add(chunk);
    }
    for (string s : matchedChunks) {
      Integer num = Integer.valueOf(s);
      num = num - 1;
      template = template.replace(s, '{' + num + '}');
    }
    return template;
  }

  private static Map<String, String> getChildAPIName(String parentName, String pluralChild) {
    Map<String, String> apiNamePairing = new Map<String, String>();
    DescribeSObjectResult parentRes = describeSObject(parentName);
    for (ChildRelationship cr : parentRes.getChildRelationships()) {
      SObjectType type = cr.getChildSObject();
      DescribeSObjectResult typeRes = type.getDescribe();
      // if passed in 'Contact' or 'Contacts' etc
      if (typeRes.labelplural == pluralChild || typeRes.name == pluralChild) {
        apiNamePairing.put('name', typeRes.name);
        apiNamePairing.put('labelplural', typeRes.labelplural);
        break;
      }
    }
    return apiNamePairing;
  }

  private List<String> getFilterParts(List<Filter> filters, Map<String, SObjectField> fMap) {
    List<String> filterParts = new List<String>();
    for(Filter f : filters) {
      // SObjectField sObjField = fMap.get(f.fieldName);
      // DescribeFieldResult fDesc = sObjField.getDescribe();
      // DisplayType dType = fDesc.getType();
      String part = escape(f.fieldName) + SPACE + escape(f.operator) + SPACE;
      if (f.value != null) {
        part += setFilterValue(f.value);
      } else if (f.cxValue != null) {
        part += buildCrossObjectFilter(f.cxValue);
      } else {
        // assume value is expressed as null
        part += null;
      }
      filterParts.add(part);
    }
    return filterParts;
  }


  private String buildCrossObjectFilter(CXFilter cx) {
    String cxFilterString = '(SELECT {0} FROM {1}';
    Map<String, SObjectField> fMap = describeSObject(cx.sObjectName)
      .fields.getMap();
    if (cx.condition.filters != null && cx.condition.filters.size() > 0) {
      cxFilterString += ' WHERE {2}';
    }
    List<String> cxParts = new List<String>();
    cxParts.add(escape(cx.fieldName));
    cxParts.add(escape(cx.sObjectName));
    if (cx.condition.filters != null) {
      List<String> filterLogicParts = getFilterParts(cx.condition.filters, fMap);
      String filterLogic = escape(cx.condition.logic?.toUpperCase());
      if (filterLogic != 'AND' && filterLogic != 'OR') {
        cxParts.add(
          String.format(prepareTemplate(filterLogic), filterLogicParts)
        );
      } else {
        cxParts.add(String.join(filterLogicParts, SPACE + filterLogic + SPACE));
      }
    }
    cxFilterString += ')';
    return String.format(cxFilterString, cxParts);
  }

  private String buildFilterTemplateLogic() {
    Map<String, SObjectField> fMap = this.objectDescribe.fields.getMap();
    List<String> filterParts = getFilterParts(this.condition.filters, fMap);
    String filterLogic = escape(this.condition.logic?.toUpperCase());
    if (filterLogic != 'AND' && filterLogic != 'OR') {
      // Will interpolate the list of strings w/ the index {0}
      return String.format(prepareTemplate(filterLogic), filterParts);
    } else {
      return String.join(filterParts, SPACE + filterLogic + SPACE);
    }
  }

  private List<String> buildSubQuery() {
    List<String> subQuerys = new List<String>();
    for (SubQuery sq : this.subQueries) {
      Map<String, String> sqObjectPair = getChildAPIName(
        this.sObjectName,
        sq.sObjectName
      );
      Map<String, SObjectField> fMap = describeSObject(sqObjectPair.get('name'))
        .fields.getMap();
      List<String> subQueryParts = new List<String>();
      subQueryParts.add(String.join(getSelectParts(sq.fields), ', '));
      subQueryParts.add(escape(sqObjectPair.get('labelplural')));
      String baseTemplate = '(SELECT {0} FROM {1}';
      if (sq.condition?.filters?.size() > 0) {
        baseTemplate += ' WHERE {2}';
        List<String> filterParts = getFilterParts(sq.condition.filters, fMap);
        String filterLogic = escape(sq.condition.logic?.toUpperCase());
        String filterResult = filterLogic != 'AND' && filterLogic != 'OR'
          ? String.format(prepareTemplate(filterLogic), filterParts)
          : String.join(filterParts, SPACE + filterLogic + SPACE);
        subQueryParts.add(filterResult);
      }
      if (sq.limitRows != null) {
        baseTemplate += ' LIMIT {3}';
        subQueryParts.add(String.valueOf(sq.limitRows));
      }
      baseTemplate += ')';
      String finalSubQueryResult = String.format(baseTemplate, subQueryParts);
      subQuerys.add(finalSubQueryResult);
    }
    return subQuerys;
  }

  /**
   * Build the temp query string w/ {n} snytax to string.format passing in
   * the collection of soql ready strings
   */
  private void interpolateQueryString() {
    Integer idx = 1;
    // select
    String qt = 'SELECT {0}';
    // from
    qt += ' FROM {1}';
    // where
    if (this.condition.filters != null && this.condition.filters.size() > 0) {
      idx++;
      qt += ' WHERE {' + idx + '}';
    }
    // group by
    if (this.groupBy != null) {
      idx++;
      qt += ' GROUP BY {' + idx + '}';
    }
    // Order by
    if (this.orderBy != null) {
      idx++;
      qt += ' ORDER BY {' + idx + '}';
    }
    if (this.options.securityEnforced == true) {
      qt += ' WITH SECURITY_ENFORCED';
    }
    if (this.limitRows != null) {
      idx++;
      qt += ' LIMIT {' + idx + '}';
    }
    if (this.offSet != null) {
      idx++;
      qt += ' OFFSET {' + idx + '}';
    }
    System.debug('QUERY TEMPLATE: ' + qt);
    this.queryTemplate = qt;
  }

  private static String escape(String dirty) {
    return String.escapeSingleQuotes(dirty);
  }

  private static List<String> escapeCollection(List<String> dirty) {
    List<String> newList = new List<String>();
    for(String s : dirty) {
      newList.add(escape(s));
    }
    return newList;
  }

  // remove dupes, remove nulls, escape sql injection, remove subqueries
  private static List<String> getSelectParts(List<String> dirty) {
    Set<String> clean = new Set<String>();
    for(String s : dirty) {
      if (!String.isBlank(s)) clean.add(escape(s));
    }
    return new List<String>(clean);
  }

  private void checkSetup() {
    if (this.sObjectName == null) {
      throw new QueryException('sObjectName is required');
    }
    // if null instantiate collection
    if (this.soqlParts == null)
      this.soqlParts = new Map<String, String>();
    if (this.objectDescribe == null) {
      this.objectDescribe = describeSObject(this.sObjectName);
    }
  }

  private String getSelectParts() {
    List<String> selectParts = new List<String>();
    selectParts.addAll(getSelectParts(this.fields));
    if (this.subQueries?.size() > 0) {
      selectParts.addAll(this.buildSubQuery());
    }
    return String.join(selectParts, ', ');
  }

  private void beforeCompile() {
    this.checkSetup();
    this.soqlParts.put('select', this.getSelectParts());
    this.soqlParts.put('from', escape(this.sObjectName));
    if (condition?.filters != null && condition.filters.size() > 0)
      soqlParts.put('where', this.buildFilterTemplateLogic());
    if (groupBy != null)
      soqlParts.put('group by', escape(this.groupBy));
    if (orderBy != null)
      soqlParts.put('order by', escape(this.getOrderBy()));
    if (limitRows != null)
      soqlParts.put('limit', escape(String.valueOf(this.limitRows)));
    if (offSet != null)
      soqlParts.put('offset', escape(String.valueOf(offSet)));
  }

  private List<String> getParts() {
    List<String> parts = new List<String>();
    parts.add(soqlParts.get('select'));
    parts.add(soqlParts.get('from'));
    if (this.condition?.filters != null && this.condition.filters.size() > 0)
      parts.add(soqlParts.get('where'));
    if (this.groupBy != null)
      parts.add(soqlParts.get('group by'));
    if (this.orderBy != null)
      parts.add(soqlParts.get('order by'));
    if (this.limitRows != null)
      parts.add(soqlParts.get('limit'));
    if (this.offSet != null)
      parts.add(soqlParts.get('offset'));
    return parts;
  }

  private void compileQuery() {
    // convert apex objects to strings
    this.beforeCompile();
    // create SELECT {0} FROM {1}
    this.interpolateQueryString();
    // get list of strings in specified order, then format the final string
    List<String> parts = this.getParts();
    // format the final string
    this.finalQuery = String.format(this.queryTemplate, parts);
    system.debug('FINAL_QUERY: ' + this.finalQuery);
  }

  private String bindVariableHelper(Object passThrough) {
    String bindStringValue = '';
    if (bind1 == null) {
      bind1 = passThrough;
      bindStringValue = ':bind1';
    } else if(bind2 == null) {
      bind2 = passThrough;
      bindStringValue = ':bind2';
    } else if(bind3 == null) {
      bind3 = passThrough;
      bindStringValue = ':bind3';
    } else if(bind4 == null) {
      bind4 = passThrough;
      bindStringValue = ':bind4';
    } else if(bind5 == null) {
      bind5 = passThrough;
      bindStringValue = ':bind5';
    } else if(bind6 == null) {
      bind6 = passThrough;
      bindStringValue = ':bind6';
    }
    return bindStringValue;
  }

  private String inConditionHelper(List<Object> values) {
    // use bind variables
    if (values?.size() > BIND_SIZE) {
      return bindVariableHelper(values);
    }
    if (values instanceOf String[]) {
      values = (List<Object>)escapeCollection((List<String>)values);
    }
    return BRACKET_LEFT +
      QUOTE +
      String.join(values, QUOTE + ', ' + QUOTE) +
      QUOTE +
      BRACKET_RIGHT;
  }

  private String inConditionHelper(List<Decimal> values) {
    if (values?.size() > BIND_SIZE) {
      return bindVariableHelper(values);
    }
    return BRACKET_LEFT + String.join(values, ', ') + BRACKET_RIGHT;
  }

  /* ======= PRIVATE UTILS Methods ======== */

  // ======= Public Chain Methods ======== //

  public Query fields(List<String> fields) {
    if (fields != null && fields.size() > 0) {
      this.fields = fields;
    }
    return this;
  }

  public Query fields(Set<String> fields) {
    if (fields != null && fields.size() > 0) {
      this.fields = new List<String>(fields);
    }
    return this;
  }

  /* (SELECT Id FROM Opportunities WHERE), */
  public Query subQuery(SubQuery subQ) {
    if (this.subQueries == null)
      this.subQueries = new List<SubQuery>();
    this.subQueries.add(subQ);
    return this;
  }

  public Query subQuery(String sObj, List<String> flds) {
    if (this.subQueries == null)
      this.subQueries = new List<SubQuery>();
    this.subQueries.add(new subQuery(sObj, flds, null));
    return this;
  }

  public Query subQuery(String sObj, List<String> flds, List<Filter> filters) {
    if (this.subQueries == null)
      this.subQueries = new List<SubQuery>();
    this.subQueries.add(new subQuery(sObj, flds, filters));
    return this;
  }

  public Query subQuery(
    String sObj,
    List<String> flds,
    List<Filter> filters,
    String filterLogic
  ) {
    if (this.subQueries == null)
      this.subQueries = new List<SubQuery>();
    this.subQueries.add(new subQuery(sObj, flds, filters, filterLogic));
    return this;
  }

  /* FROM */

  /**
   *
   */
  public Query fromSObject(String sObjName) {
    this.sObjectName = sObjName;
    this.objectDescribe = describeSObject(sObjName);
    return this;
  }
  /* FROM */

  /* WHERE */
  public Query whereFilter(
    String fieldName,
    String operator,
    CXFilter cxValue
  ) {
    this.condition.filters.add(new Filter(fieldName, operator, cxValue));
    return this;
  }

  public Query whereFilter(String fieldName, String operator, Object value) {
    this.condition.filters.add(new Filter(fieldName, operator, value));
    return this;
  }

  public Query whereFilter(
    String fieldName,
    String operator,
    List<Object> values
  ) {
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  public Query whereFilter(
    String fieldName,
    String operator,
    Map<Id, sObject> values
  ) {
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  public Query whereFilter(
    String fieldName,
    String operator,
    List<sObject> values
  ) {
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  public Query whereFilter(
    String fieldName,
    String operator,
    Set<String> values
  ) {
    if (this.condition.filters == null) {
      this.condition.filters = new List<Filter>();
    }
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  public Query whereFilter(String fieldName, String operator, Set<Id> values) {
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  public Query whereFilter(
    String fieldName,
    String operator,
    Set<Decimal> values
  ) {
    this.condition.filters.add(new Filter(fieldName, operator, values));
    return this;
  }

  /**
   *
   */
  public Query whereFilter(Filter filter) {
    this.condition.filters.add(filter);
    return this;
  }

  /**
   *
   */
  public Query whereFilters(List<Filter> filters) {
    this.condition.filters.addAll(filters);
    return this;
  }

  public Query whereFilters(List<Filter> filters, String logic) {
    this.condition.logic = logic;
    this.condition.filters.addAll(filters);
    return this;
  }

  /**
   * String of the logic ordering - `(1 AND 2) OR 3`
   */
  public Query whereLogic(String logic) {
    this.condition.logic = logic;
    return this;
  }
  /* WHERE */

  /* ORDER BY */
  /**
   *
   */
  public Query orderBy(String fldAPIName, OrderDirection OrderDirection) {
    this.orderBy = new OrderBy();
    this.orderBy.fieldName = fldAPIName;
    this.orderBy.OrderDirection = OrderDirection;
    return this;
  }

  /**
   *
   */
  public Query orderBy(
    String fldAPIName,
    OrderDirection OrderDirection,
    Boolean nullsFirst
  ) {
    this.orderBy = new OrderBy();
    if (nullsFirst != null) {
      this.orderBy.nullsFirst = nullsFirst;
    }
    this.orderBy.fieldName = fldAPIName;
    this.orderBy.OrderDirection = OrderDirection;
    return this;
  }
  /* ORDER BY */

  /* GROUP BY */
  public Query groupBy(String fieldName) {
    this.groupBy = fieldName;
    return this;
  }

  /* LIMIT */
  public Query limitRows(Integer i) {
    this.limitRows = i;
    return this;
  }
  /* LIMIT */

  public Query offSet(Integer i) {
    this.offSet = i;
    return this;
  }

  public String queryString() {
    try {
      this.compileQuery();
      return this.finalQuery;
    } catch (Exception e) {
      System.debug(
        'Query String Occured: ' +
        e.getCause() +
        ' ' +
        e.getMessage()
      );
      throw new QueryException(
        'Query String Occured: ' +
        e.getCause() +
        ' ' +
        e.getMessage()
      );
    }
  }

  /**
   * Expose SObjectAccessDecision so consumers can have more control and set fields back etc
   */
  public SObjectAccessDecision getSecurityAccessDecision() {
    return this.securityDecision;
  }

  public List<sObject> run() {
    List<sObject> queryResult;
    try {
      this.compileQuery();
      if (isTest == true && queryMockResults.size() > 0) {
        queryResult = (List<sObject>) queryMockResults.remove(0);
      } else if (this.options.stripInaccessible == true) {
        queryResult = Database.query(this.finalQuery);
        if (this.options.stripInaccessible == true) {
          this.securityDecision = Security.stripInaccessible(
            this.options.AccessType,
            queryResult
          );
          queryResult = securityDecision.getRecords();
          System.debug(
            'Removed Field Amount: ' +
            securityDecision.getRemovedFields().keySet()
          );
        }
      } else {
        queryResult = Database.query(this.finalQuery);
      }
    } catch (Exception e) {
      System.debug(
        'Query Run Error Occured: ' +
        e.getCause() +
        ' ' +
        e.getMessage() +
        ' ' +
        e.getLineNumber()
      );
      throw new QueryException(
        'Query Run Error Occured: ' +
        e.getCause() +
        ' ' +
        e.getMessage()
      );
    }
    return queryResult;
  }
  // ======= Public Chain Methods ======== //
}
