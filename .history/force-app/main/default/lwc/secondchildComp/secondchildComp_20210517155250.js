import { LightningElement } from 'lwc';

export default class secondchildComp extends LightningElement {
    constructor(){
        super();
        console.log('Inside child constructor');
        }
        connectedCallback(){
            console.log('Inside child connected callback');
            }
            renderedCallback()    {  
                console.log('This is From child component rendered callback'); 
             }
    
}