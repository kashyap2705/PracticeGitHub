import { LightningElement } from 'lwc';

export default class SecondchildComp extends LightningElement {

    renderedCallback()    {  
        console.log('This is From child component rendered callback'); 
     }
}