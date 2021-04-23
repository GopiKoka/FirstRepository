import { LightningElement,track } from 'lwc';

export default class Calculator extends LightningElement {
    @track output;
    num1;
    num2;
    add(){
        console.log(this.template.querySelector('.num1').value);
        console.log(this.template.querySelector('.num2').value);
        this.num1 = this.template.querySelector('.num1').value;
        this.num2 = this.template.querySelector('.num2').value;
        this.output = parseInt(this.num2) + parseInt(this.num2); 
    }
}