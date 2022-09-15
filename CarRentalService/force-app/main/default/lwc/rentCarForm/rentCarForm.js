import { LightningElement,track } from 'lwc';
import carRecord from '@salesforce/apex/insertCarRecord.carRecord';

export default class RentCarForm extends LightningElement {
    @track carDisplayList = [];
    @track owner="";
    @track rent="";
    @track carModel = "";
    handleOwnerChange(event){
        this.owner = event.target.value
    }
    handleRentChange(event){
        this.rent = event.target.value
    }
    handleModelChange(event){
        this.carModel = event.target.value
    }
    saveCar(event) {
        carRecord({OwnerName:this.owner,rent:this.rent,carModel:this.carModel})
        .then((result) => {
            this.carDisplayList = result;
            this.owner="";
            this.rent="";
            this.carModel="";
        }) 
        
    }
}