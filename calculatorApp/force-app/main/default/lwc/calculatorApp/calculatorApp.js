import { LightningElement,track } from 'lwc';

export default class CalculatorApp extends LightningElement {
    @track num1;
    @track num2;
    @track result=undefined;
  
    addition() {
      this.result = Number(this.num1) + Number(this.num2);
    }
    subtraction() {
        this.result = Number(this.num1) - Number(this.num2);
    }
    multiplication() {
        this.result = Number(this.num1) * Number(this.num2);
    }  
    division() {
        this.result =  Math.round(Number(this.num1) / Number(this.num2));
    }
    handleChangeNum1(evt) {
      this.num1 = evt.target.value;
    }
    handleChangeNum2(evt) {
      this.num2 = evt.target.value;
    }
}