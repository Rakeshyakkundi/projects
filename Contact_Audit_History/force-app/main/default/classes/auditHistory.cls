public with sharing class auditHistory{
    @AuraEnabled(cacheable=true)
    public static List<Audit_History__c> getaudits(){
        return [SELECT Contact__c, DML_Type__c, Field_with_New_Value__c, Field_with_Old_Value__c, User__c, Audit_Timestamp__c FROM Audit_History__c];
    }
    @AuraEnabled(cacheable=true)
    public static List<Audit_History__c> AuditSearch(String name){
        List<Audit_History__c> accListDet;
        if(name.length()!=0){
            String keyQuery = '%'+name+'%';
        try {

            accListDet = [SELECT Contact__c, DML_Type__c, Field_with_New_Value__c, Field_with_Old_Value__c, User__c, Audit_Timestamp__c, Id FROM Audit_History__c WHERE User__c Like:keyQuery];
            return accListDet;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        }
        else {
            List<Audit_History__c> acclist = new List<Audit_History__c>() ;
            return  acclist ;
        }
        
    }
    public class ChartClass {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal y {get; set;}
        } 

    @AuraEnabled(cacheable=true)
    public static   List<ChartClass> ChartData(){
        List<ChartClass> dataValues = new List<ChartClass>();
        List<User> UserName = [SELECT Name FROM user];
        Map<String, Integer> Chart = new Map<String, Integer>();
        //System.debug('UserName'+String.valueOf(Username));
        List<AggregateResult> userwiseCount = [SELECT COUNT(ID) cnt, User__c usr FROM Audit_History__c GROUP BY user__c ];
        for(AggregateResult res : userwiseCount){
            ChartClass piedata = new ChartClass();
            piedata.name = String.valueOf(res.get('usr'));
            piedata.y = Integer.valueOf(res.get('cnt'));
            Chart.put(String.valueOf(res.get('usr')),Integer.valueOf(res.get('cnt')));
            //System.debug('UserName '+UserName[i].Name +'Count '+Count[0].get('expr0'));  
            //Integer.valueOf(result[0].get('expr0'));
            dataValues.add(piedata);
            }
            System.debug('Chart'+Chart);
                    return dataValues;
                }

}