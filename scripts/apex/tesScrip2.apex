Map<String,Schema.SObjectType> m = Schema.getGlobalDescribe();
//Schema.SObjectType s = m.get('Opportunity');
Schema.SObjectType s = Opportunity.getSObjectType();
System.debug('< Object Opp > ' +s);
Schema.DescribeSObjectResult sdsr =  s.getDescribe();
System.debug('< Object Describe > ' +sdsr);
Map<String,Schema.SObjectField> field = sdsr.fields.getMap();
List<String> lstRequiredFields = new List<String>();
for(String f : field.keySet()){
    Schema.DescribeFieldResult describeField = field.get(f).getDescribe();
    if(describeField.isCreateable() || !describeField.isNillable() || !describeField.isDefaultedOnCreate()){
        lstRequiredFields.add(f);
    }
}
System.debug('Required fields or the object ' +lstRequiredFields);