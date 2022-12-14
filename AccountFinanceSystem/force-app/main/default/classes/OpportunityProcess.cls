public class OpportunityProcess {
    
    public static Integer getDuration(Date startDate,Date endDate){
        return startDate.monthsBetween(endDate);
    }
    public static void insertOpportunityExtension(List<Opportunity> opportunityTrigger){
        Opportunity opportunityObject = [Select Id,Name,Amount,StartDate__c, EndDate__c from Opportunity Where Id IN :opportunityTrigger ];
        
        Decimal slotAmount;
        if(opportunityObject.Amount == null){slotAmount = 0;}
        else{slotAmount = opportunityObject.Amount / getDuration(opportunityObject.StartDate__c,opportunityObject.EndDate__c);}
        List<OpportunityExtension__c> objectInsert = new List<OpportunityExtension__c>();
        
        for(Integer i=0;i<getDuration(opportunityObject.StartDate__c,opportunityObject.EndDate__c);i++){
			  objectInsert.add(new OpportunityExtension__c(Amount__c=slotAmount,StartDate__c=opportunityObject.StartDate__c.addMonths(i),Date__c=opportunityObject.StartDate__c.addMonths(i),EndDate__c=opportunityObject.StartDate__c.addMonths(i+1),Opportunity__c=opportunityObject.Id,Name=opportunityObject.Name+'_Slot_'+i));	
        }   
        insert objectInsert; 
        
        System.debug('Insert Opp:'+opportunityObject);
    }
     public static void deleteOpportunityExtension(List<Opportunity> oldOpportunities,List<Opportunity> newOpportunities){
         try{
       	Opportunity opportunityData = [Select Id,Name,Amount,StartDate__c, EndDate__c from Opportunity Where Id IN :oldOpportunities ];
        Decimal slotAmount;
        if(opportunityData.Amount == null){slotAmount = 0;}
        else{slotAmount = opportunityData.Amount / getDuration(opportunityData.StartDate__c,opportunityData.EndDate__c);}
        Integer numOfExtension = getDuration(opportunityData.StartDate__c,opportunityData.EndDate__c);
          List<OpportunityExtension__c> opportunityExtensionDetele = new List<OpportunityExtension__c>();
         for(Integer i=0;i<numOfExtension;i++){
             String keyName = opportunityData.Name+'_Slot_'+i;
             OpportunityExtension__c oppExtensionAddList = [SELECT Id,Name,Opportunity__c,Amount__c,Date__c from OpportunityExtension__c WHERE Opportunity__c  IN :oldOpportunities AND Amount__c=:slotAmount AND Date__c>=:opportunityData.StartDate__c AND Date__c<=:opportunityData.EndDate__c AND Name=:keyName ];
         	 opportunityExtensionDetele.add(oppExtensionAddList);
             //System.debug('Hi this is objnew to delete :'+objnew);
         }
        delete(opportunityExtensionDetele);
       	//System.debug('Hi this is opportunityData old one'+opportunityData);
        //System.debug('Old :'+oldOpportunities);
        //System.debug('New :'+newOpportunities);
        }catch(Exception e){
            System.debug('Error :'+e);
        }
    }
    
}