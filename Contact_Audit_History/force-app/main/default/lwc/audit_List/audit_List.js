import { LightningElement, wire, track } from 'lwc';
import getaudits from '@salesforce/apex/auditHistory.getaudits'
import AuditSearch from '@salesforce/apex/auditHistory.AuditSearch'
const COLUMNS = [
    {label: 'Contact', fieldName: 'Contact__c'},
    {label: 'User', fieldName: 'User__c'},
    {label: 'Old value', fieldName: 'Field_with_Old_Value__c'},
    {label: 'New value', fieldName: 'Field_with_New_Value__c'},
    {label: 'DML Type', fieldName: 'DML_Type__c'},
    {label: 'TimeStamp', fieldName: 'Audit_Timestamp__c'}
]
export default class Audit_List extends LightningElement {
    auditData
    columns = COLUMNS
    @wire(getaudits)
    auditsHandler({data, error}){
        if(data){
            console.log(data)
            this.auditData = data
        }
        if(error){
            console.error(error)
        }
    }
    userName='Enter User Name here';
    @track listSingle=[];
    
    @wire(AuditSearch,{name :'$userName'})
    singleDetail({error,data}){
        if(data){
            this.listSingle =data;
        }
        else if(error){

        }

    }
    handelKeyChange(event){
        this.userName = event.target.value;
    }
    reset(){
        this.auditData = {};
    }
}