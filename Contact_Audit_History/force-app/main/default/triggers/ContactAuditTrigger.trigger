trigger ContactAuditTrigger on Contact (after update, after insert, before delete) {
         if (Trigger.isUpdate) {
             ContactAudit.createAuditRecords(Trigger.oldMap,Trigger.newMap);
          }
         if (Trigger.isInsert) { 
             ContactAudit.insertAuditRecords(Trigger.newMap);
          }
         if (Trigger.isDelete) { 
             ContactAudit.deleteAuditRecords(Trigger.oldMap);
          }
}