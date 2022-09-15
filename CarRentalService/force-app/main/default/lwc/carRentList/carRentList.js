import { LightningElement,api } from 'lwc';
import carList from '@salesforce/apex/insertCarRecord.carList';
import deleteCarRecord from '@salesforce/apex/insertCarRecord.deleteCarRecord';

export default class CarRentList extends LightningElement {
    @api carList=[];
    connectedCallback() {
        carList()
        .then((data) => {
            this.carList = data;
        })
    }
    deleteItem(event) {
        deleteCarRecord({carId:event.target.name})
        .then((data) => {
            this.carList = data;
        })
    }
}