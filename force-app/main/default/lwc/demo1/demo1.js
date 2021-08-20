import { LightningElement } from 'lwc';

export default class Demo1 extends LightningElement {

    Greeting='welcome to night session';
    //console.log('Greeting***'+Greeting);
    fname='';
    lname='';
    result='';
    showMsg = false;
    onValueChange(event)
    {
        //alert('hiii**');
        
        this.Greeting= event.target.value;
        this.fname=event.target.value;
        if(event.target.name === "drugApiName")
        {
            this.fname=event.target.value;

        }
        if(event.target.name === "drugApiName1")
        {
            this.lname=event.target.value;

        }

        console.log('this.fname'+this.fname);
        console.log('this.lname'+this.lname);
        this.result= this.fname + this.lname;

        if(this.fname == 'test')
        {
            this.showMsg= true;
        }




    }

    
}

