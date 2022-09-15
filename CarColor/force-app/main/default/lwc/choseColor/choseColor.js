import { LightningElement } from 'lwc';
const BASE_URL = 'https://sfdc-demo.s3-us-west-1.amazonaws.com/ecars';
const COLORS = ['red','green','blue','white']

export default class ChoseColor extends LightningElement {
    colors = COLORS
    selectedColor = this.colors[2]
    get selectdImage(){
        return `${BASE_URL}/car_${this.selectedColor}.jpg`
    }
    showRed(event){
        this.selectedColor = 'red'
    }
    showGreen(event){
        this.selectedColor = 'green'
    }
    showBlue(event){
        this.selectedColor = 'blue'
    }
    showWhite(event){
        this.selectedColor = 'white'
    }
    
}