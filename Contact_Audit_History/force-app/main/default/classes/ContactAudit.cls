public class ContactAudit {
    public static void insertAuditRecords(Map<Id,Contact> newMap){
        Audit_History__c contactAudits = new Audit_History__c(DML_Type__c='Insert');
        for(Id recordId:newMap.keySet()){
            contactAudits.Contact__c = recordId;
            contactAudits.Audit_Timestamp__c = System.now();
            contactAudits.User__c = UserInfo.getName();
            contactAudits.User_ID__c = UserInfo.getUserId();
            insert ContactAudits;
            break;
        }
        
    }
     public static void deleteAuditRecords(Map<Id,Contact> oldMap){
        Audit_History__c contactAudits = new Audit_History__c(DML_Type__c='Delete');
        for(Id recordId:oldMap.keySet()){
            contactAudits.Contact__c = recordId;
            contactAudits.Audit_Timestamp__c = System.now();
            contactAudits.User__c = UserInfo.getName();
            contactAudits.User_ID__c = UserInfo.getUserId();
            insert ContactAudits;
            break;
        }
        
    }
    public static void createAuditRecords(Map<Id,Contact> oldMap,Map<Id,Contact> newMap){
        List<Audit_History__c> contactAudits = new List<Audit_History__c>();
        Schema.FieldSet fieldsToTrack = Schema.SObjectType.Contact.fieldSets.AuditFieldSet;
        List<String> fieldNames =  new List<String>();
        for(Schema.FieldSetMember field:fieldsToTrack.getFields()){
            fieldNames.add(field.fieldpath);
        }   
        for(Id recordId:newMap.keySet()){
            Map<String,Object> newFields = new Map<String,String>();
            Map<String,Object> oldFields = new Map<String,String>();
            
            if(oldMap!=null){
                Audit_History__c currentAudit = new Audit_History__c();
                for(String fieldName:fieldNames){
                   Object oldValue = oldMap.get(recordId).get(fieldName);
                   Object newValue = newMap.get(recordId).get(fieldName); 
                   if((oldValue==null && newValue!=null) || (oldValue != null && newValue == null) || (oldValue != newValue)){
                        newFields.put(fieldName,newValue);
                        oldFields.put(fieldName,oldValue);}
                        currentAudit.DML_Type__c='Update';
                }
  
                
                currentAudit.Contact__c = recordId;
                currentAudit.Field_with_New_Value__c = newFields.toString();
                currentAudit.Field_with_Old_Value__c = oldFields.toString();
                currentAudit.Audit_Timestamp__c = System.now();
                currentAudit.User__c = UserInfo.getName();
                currentAudit.User_ID__c = UserInfo.getUserId();
                contactAudits.add(currentAudit);
                }
            }
        system.debug('contactAudits'+contactAudits);
        insert contactAudits;
        
    }
}