trigger OpportunityTrigger on Opportunity (after insert,before update,after update,after delete) {
    if(Trigger.isInsert){
        OpportunityProcess.insertOpportunityExtension(Trigger.new);
    }
    else if(Trigger.isUpdate){
         if (Trigger.isBefore) {
             OpportunityProcess.deleteOpportunityExtension(Trigger.old,Trigger.new);	
        } else if (Trigger.isAfter) {
            OpportunityProcess.insertOpportunityExtension(Trigger.new);
        } 
    }
    else if (Trigger.isDelete) {
         OpportunityProcess.deleteOpportunityExtension(Trigger.old,Trigger.new);
    }
		
   
}