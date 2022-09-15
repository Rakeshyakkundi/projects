public with sharing class OpportunityData {
    @AuraEnabled
    public static List<Opportunity> getOpportunities(Id AccId){
        List<Opportunity> records = [SELECT Id, Name, Amount, StageName, AccountId FROM Opportunity WHERE AccountId=:AccId];
        return records;
    }
}
