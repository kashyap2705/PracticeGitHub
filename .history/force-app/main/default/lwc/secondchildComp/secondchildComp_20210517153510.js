import { LightningElement } from 'lwc';

export default class secondchildComp extends LightningElement {

    renderedCallback()    {  
        console.log('This is From child component rendered callback'); 
     }
}