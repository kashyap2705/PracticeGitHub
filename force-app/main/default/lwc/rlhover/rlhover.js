import { LightningElement, api, track } from 'lwc';

export default class rlhover extends LightningElement {
    @track ranger;
    @track top = 50;
    @track left = 50;

    @api
    get myranger(){
        return this.ranger;
    }

    set myranger(value) {
        this.ranger = value;
    }

    @api
    get topmargin(){
        return this.top;
    }

    set topmargin(value) {
        this.top = value;
    }

    @api
    get leftmargin(){
        return this.left;
    }

    set leftmargin(value) {
        this.left = value;
    }
}