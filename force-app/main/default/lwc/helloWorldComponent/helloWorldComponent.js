import { LightningElement,api } from 'lwc';

export default class HelloWorldComponent extends LightningElement {

    Greeting= 'hiii';
    config={};
    //@api greeting2='';

    onValueChange(event)
    {

        if(event.target.name= 'drugApiName')
        {
            this.Greeting= event.target.value;
        }
        this.config[event.target.name] = ((type) => {
            switch (type) {
                case 'file':
                    {this.fileName= event.target.files[0].name;
                        return event.target.files[0];
                    }
                case 'checkbox':return event.target.checked;
                default:return event.target.value;
            }
        })(event.target.type);

        console.log('config***'+ JSON.stringify(this.config));
        //this.greeting2 = this.Greeting;
    }

    

    
}