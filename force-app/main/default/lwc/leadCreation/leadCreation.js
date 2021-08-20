import { LightningElement,track,api } from 'lwc';

export default class LeadCreation extends LightningElement {
    @api leadGreeting;

    labels = {
        firstName: 'First Name',
        lastName: 'Last Name'
       
    };

    apiNames = {
       // lead: LEAD_OBJECT.objectApiName,
        //id: ID_FIELD.fieldApiName,
        firstName: 'firstName',//FIRST_NAME.fieldApiName,
        lastName: 'lastName'//LAST_NAME.fieldApiName,
        
    };

    @track config = {}
    async onValueChange(event) {
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
        console.log('config**'+JSON.stringify(this.config));
        console.log('query selector ***'+JSON.stringify(this.template.querySelector(`lightning-input[data-field-name=${'Test'}]`).required));
        console.log('query selector ***'+JSON.stringify(this.template.querySelector(`lightning-input[data-field-name=Test]`).required));

        if(event.target.name == 'newLead')
        {
            console.log('this.getInputField(this.apiNames.lastName).required'+this.getInputField(this.apiNames.lastName).required);
        this.getInputField(this.apiNames.lastName).required = !this.getInputField(this.apiNames.lastName).required;
        
       
        }
        
    }

    getInputField(fieldName) {
        console.log('fieldName***'+fieldName);
        
        console.log('return***'+JSON.stringify(this.template.querySelector(`lightning-input[data-field-name=${fieldName}]`)));
       
        return this.template.querySelector(`lightning-input[data-field-name=${fieldName}], lightning-combobox[data-field-name=${fieldName}]`);
    }

    

}