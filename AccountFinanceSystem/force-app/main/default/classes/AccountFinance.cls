public class AccountFinance {
    
    //Target
     public static Map<Integer, Decimal>  getTargetList(Id AccId){
        List<Account_Target__c > accountTarget = [SELECT Date__c, Amount__c  FROM Account_Target__c  WHERE Date__c=THIS_FISCAL_YEAR  AND Account__c=:AccId ORDER BY Date__c ASC];
        
         //mapTarget has Month,Target Value
         Map<Integer, Decimal> mapTarget = new Map<Integer, Decimal>();        
        Decimal valuesTarget;
         // try block will check is the month in Map if yes the total value will be added
         // catch block if month not present it will create key and value 
        for(Integer j=0;j<accountTarget.size();j++){
            try{
                if(mapTarget.get(accountTarget[j].Date__c.month()) != null){
                    valuesTarget =mapTarget.get(accountTarget[j].Date__c.month());
               		mapTarget.put(accountTarget[j].Date__c.month(),valuesTarget+accountTarget[j].Amount__c);
                }else{
                    mapTarget.put(accountTarget[j].Date__c.month(),accountTarget[j].Amount__c);
                }
                
            }catch(Exception e){
               		System.debug('Error'+e.getMessage());
            }
        }  
         return mapTarget;
        
    }
    
    // Pipeline
    public static Map<Integer, Decimal> getPielineList(Id AccId){
        List<OpportunityExtension__c> oppPipeline=[SELECT Id, Amount__c, Opportunity__c, Date__c, Name ,Opportunity__r.stageName  FROM OpportunityExtension__c   WHERE Date__c=THIS_FISCAL_YEAR AND Opportunity__r.StageName !='Won' AND Opportunity__r.StageName !='Lost'  AND Opportunity__r.AccountId =:AccId];
         
        //mapTarget has Month,Opportunity amount
        Map<Integer, Decimal> mapPipeLine = new Map<Integer, Decimal>();
        Decimal valuesAmount;
         // try block will check is the month in Map if yes the total value will be added
         // catch block if month not present it will create key and value 
        for(Integer j=0;j<oppPipeline.size();j++){
            try{
                if(mapPipeLine.get(oppPipeline[j].Date__c.month()) !=null){
                	valuesAmount = mapPipeLine.get(oppPipeline[j].Date__c.month());//oppPipeline[j].Date__c.month() -> returns month 
                	mapPipeLine.put(oppPipeline[j].Date__c.month(),valuesAmount+oppPipeline[j].Amount__c);
                }else{
                    mapPipeLine.put(oppPipeline[j].Date__c.month(),oppPipeline[j].Amount__c);
                }
            }catch(Exception e){
                	System.debug('Error'+e.getMessage());
            }
        }
        return mapPipeLine;
    }
    
    //Target Deviation
    @AuraEnabled
    public static   DTOclass getTargetDeviationList(Id accId){
        Map<Integer,String> monthName = new Map<Integer,String>{
            1 => 'Jan',
                2 => 'Feb',
                3 => 'Mar',
                4 => 'April',
                5 => 'May',
                6 => 'June',
                7 => 'July',
                8 => 'Aug',
                9 => 'Sept',
                10 => 'Oct',
                11 => 'Nov',
                12=> 'Dec'
                };
        Map<Integer,Decimal> TargetMap = getTargetList(AccId); // Has month and Target;
        Map<Integer,Decimal> PipeLineMap = getPielineList(AccId); // Has month and sum of opportunity amount;
    	
   // System.debug('Empty :'+TargetMap.size());
        
	List<Decimal> ListForTarget = new List<Decimal>();
    List<Decimal> ListForPipeline = new List<Decimal>();
    List<String> ListForMonth = new List<String>();
    List<Decimal> ListForTotalDeviation = new List<Decimal>();
        
    List<FinanceAmountWrapData> dataValues = new List<FinanceAmountWrapData>();
        
        
    Decimal totalTarget =0;
    Decimal totalPipeline =0;
    Decimal totalDeviation = 0;
    // Get users fiscal year start month to display data accordingly
	Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;   
    String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
	//String currentFiscalYear ='2022';
        // itterate 12 for 12 months start with fiscal year
        for(Integer i=0;i<12;i++){
            // Append list with target which start of fiscal year month ex:april then 4 initial of ListForTarget is taken from map of target
            // If null append as 0.00 in List of Target
            if(TargetMap.get(FiscalYearStartMonth)==null){
                ListForTarget.add(0.00);
            }else{
                ListForTarget.add(TargetMap.get(FiscalYearStartMonth));
            }
            // Append list of pipeline which start from fiscal year month . If null the append as 0.00
            if(PipeLineMap.get(FiscalYearStartMonth)==null){
                ListForPipeline.add(0.00);
            }else{
                ListForPipeline.add(PipeLineMap.get(FiscalYearStartMonth));
            }
            //Calculate Target Deviation as List of Target and pipeline is appended
            //if the values is not divided by 0 the try block will run . if values is divided by 0 the catch will run 
            try{
                 ListForTotalDeviation.add(Math.rint(((ListForPipeline[i]-ListForTarget[i])/ListForTarget[i] )*100));
            } 
            catch(Exception e){
                ListForTotalDeviation.add(Math.rint(((ListForPipeline[i]-ListForTarget[i])/1)*100));
            }
            ListForMonth.add(monthName.get(FiscalYearStartMonth)+' '+currentFiscalYear);
            // System.debug('Target of '+monthName.get(FiscalYearStartMonth)+'_'+currentFiscalYear+' is : '+ListForTarget[i]+'======= Pipeline '+monthName.get(FiscalYearStartMonth)+'_'+currentFiscalYear+' is : '+ListForPipeline[i]+'======Traget Deviation:'+ListForTotalDeviation[i]);
            //Increase the FiscalYearStartMonth to get value from map of Target and pipeline
            //if FiscalYearStartMonth is 12 then reinitiate with 1 to start from Jan
          	FinanceAmountWrapData data = new FinanceAmountWrapData();
            
            data.month = monthName.get(FiscalYearStartMonth)+' '+currentFiscalYear;
            data.totalAmount = ListForTarget[i];
            data.pipeLineAmount = ListForPipeline[i];
            data.Deviation = ListForTotalDeviation[i];
            
            dataValues.add(data);
            if(FiscalYearStartMonth==12){
                FiscalYearStartMonth=0;
                currentFiscalYear = String.valueof(Integer.valueof(currentFiscalYear)+1);
            }
             FiscalYearStartMonth +=1;
             totalTarget = totalTarget + ListForTarget[i];
             totalPipeline = totalPipeline + ListForPipeline[i];   
             
           }//for end	
        try{
             totalDeviation = (( totalPipeline-totalTarget)*100)/totalTarget;
        }catch(Exception e){
             totalDeviation = (( totalPipeline-totalTarget)*100)/1;
        }
       
         List<Decimal> chartTarget = ListForTarget;
         List<Decimal> chartPipeline =ListForPipeline;
         List<String> chartMonth = ListForMonth;
            
        DTOclass wrap = new DTOclass(totalTarget,totalPipeline,totalDeviation,dataValues,chartTarget,chartPipeline,chartMonth);
        // System.debug(' Final Output '+ JSON.serialize(wrap));
        return wrap;
        
    }//function end
     public class DTOclass {
         @AuraEnabled
        public decimal totalTarget {get; set;}
         @AuraEnabled
        public decimal totalPipeline {get; set;}
         @AuraEnabled
        public decimal totalDeviation{get; set;}
         @AuraEnabled
        public List<FinanceAmountWrapData> dataValues {get; set;}
         @AuraEnabled
        public List<Decimal> chartTarget  {get; set;}
         @AuraEnabled
    	public List<Decimal> chartPipeline  {get; set;}
         @AuraEnabled
    	public List<String> chartMonth  {get; set;}
        
        
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public DTOclass(decimal totalTarget, decimal totalPipeline,decimal totalDeviation,List<FinanceAmountWrapData> dataValues,  List<Decimal> chartTarget, List<Decimal> chartPipeline, List<String> chartMonth ) {
            this.totalTarget = totalTarget;
            this.totalPipeline = totalPipeline;
            this.totalDeviation = totalDeviation;
            this.dataValues = dataValues;
            this.chartTarget =chartTarget;
            this.chartPipeline = chartPipeline;
            this.chartMonth =chartMonth;
        }
    }
    public class FinanceAmountWrapData {
        @AuraEnabled
        public String month {get; set;}
        @AuraEnabled
        public Decimal totalAmount {get; set;}
        @AuraEnabled
        public Decimal pipeLineAmount {get; set;}
        @AuraEnabled
        public decimal Deviation {get; set;}
    }
    public class UpdateTargetDTO {
    @AuraEnabled
    public String month {get; set;}
    @AuraEnabled
    public Decimal amount {get; set;}
	} 
    
    @AuraEnabled
    public static   void saveTargetAmount(String targetData, Id accId){
        List<UpdateTargetDTO> UpdateTarget = (List<UpdateTargetDTO>) JSON.deserialize(targetData,List<UpdateTargetDTO>.class);
         Map<String,Integer> monthNameToInt = new Map<String,Integer>{
            	'Jan' => 1,
                'Feb' => 2,
                'Mar' =>3 ,
                'April' =>4 ,
                'May' => 5,
                'June' =>6 ,
                'July' =>7 ,
                'Aug' =>8 ,
                'Sept' =>9 ,
                'Oct' =>10 ,
                'Nov' =>11 ,
                'Dec' => 12
                };
        for(Integer j=0;j<UpdateTarget.size();j++){
            String recId = UpdateTarget[j].month.split(' ')[2];
            String recYear = UpdateTarget[j].month.split(' ')[1];
            Integer specificMonth = monthNameToInt.get(UpdateTarget[j].month.split(' ')[0]);
            try{
                List<Account_Target__c>  accountTarget = [SELECT Date__c, Amount__c,Name  FROM Account_Target__c  WHERE Date__c=THIS_FISCAL_YEAR   AND Account__c=:recId  AND CALENDAR_MONTH(Date__c)=:specificMonth ORDER BY Date__c ASC];
                
                if(accountTarget.size()==0){
                    Account_Target__c  createTarget = new Account_Target__c();
                    createTarget.Account__c = recId;
                    createTarget.Amount__c = UpdateTarget[j].amount;
                    createTarget.Date__c = Date.newInstance(Integer.valueof(recYear), specificMonth, 1);
                    insert createTarget;
                    //System.debug(' Complete: '+createTarget);
                }else{
                    accountTarget[0].Amount__c = Integer.valueof(UpdateTarget[j].amount);
                	update accountTarget;
                }
            }catch(Exception e){
               System.debug('Error'+e.getMessage());
            }
           // System.debug('Valid Data:'+'Month:'+UpdateTarget[j].month.split(' ')+'Record id:'+recId+'Month :'+specificMonth);
            //System.debug('Valid Data:'+'Amount:'+UpdateTarget[j].amount);
        }
    } 
}