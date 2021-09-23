import { LightningElement, api, wire, track } from 'lwc';
import getTemplatesByRecordId from '@salesforce/apex/EnableTrackingController.getTemplatesByRecordId'
import { refreshApex } from '@salesforce/apex';
const DELAY = 300;

export default class MappingBuilderContainer extends LightningElement {

    @api recordId;
    @track elementsData;
    @track error;
    wireElementsResult;
    @wire(getTemplatesByRecordId, {
        recordId: '$recordId'
    }) wiredElements ( result ) {
        this.wireElementsResult = result;
        if(result.data) {
            this.elementsData = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.elementsData = undefined;
        }
    }
    
    handleNewItem(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            refreshApex(this.wireElementsResult);
        }, DELAY);
    }
}