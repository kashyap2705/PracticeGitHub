import { LightningElement, api, track } from 'lwc';
import { createRecord, deleteRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TEMPLATEMAPPING_OBJECT from '@salesforce/schema/Audit_Tracking_Field__c';
const FIELDSTOSKIP = new Set(['OwnerId']);

export default class FieldTemplate extends LightningElement {
    @api fieldDefination;
    @track selected;
    @api recordId;
    @api fieldDefs;
    @api mappings;
    myValue = new Boolean();
    currentMappingId;

    /*Create Mappings for required fields on Component load*/
    connectedCallback() {
        if (this.fieldCreateable === true && this.hasMapping === false
            && !FIELDSTOSKIP.has(this.fieldDefination.apiName) && this.fieldDefination.dataType !== 'Boolean') {

                /*Skip creation of mappings if atleast one mapping is defined on Data Template*/
            if (this.mappings.size === 0) {
               // this.createMapping();
                const dispathEvent = new CustomEvent('selection', {
                    detail: this.fieldDefination.apiName
                });
                this.dispatchEvent(dispathEvent);
            }

        }
    }

    /*Create/Delete the template mapping based on user selection. */
    handleChange(event) {
        let userInput = event.target.checked;        
        const dispathEvent = new CustomEvent('selection', {
            detail: this.fieldDefination.apiName
        });
        if (userInput === true) {
            this.createMapping();
        }
        if (userInput === false) {
            this.deleteMapping();
        }
        this.dispatchEvent(dispathEvent);
    }

    /*Helper method of creating mapping. */
    createMapping() {
        if (this.activeMapping === true) {
            return;
        } else if (this.hasMapping === true
            && !this.mappings.get(this.fieldDefination.apiName).e_eat__Active__c) {

            const fields = {};
            fields['e_eat__Active__c'] = true;
            fields['Id'] = this.mappings.get(this.fieldDefination.apiName).Id;
            const recordInput = {
                fields
            };
            updateRecord(recordInput)
                .then()
                .catch(

                );
        } else {
            const fields = {};
            fields['e_eat__Field_API_Name__c'] = this.fieldDefination.apiName;
            fields['e_eat__Active__c'] = true;
            fields['Name'] = this.fieldDefination.label;
            fields['e_eat__Audit_Tracking_sObject__c'] = this.recordId;
            const recordInput = {
                apiName: TEMPLATEMAPPING_OBJECT.objectApiName,
                fields
            };
            createRecord(recordInput)
                .then(mapping => {
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record mapping',
                            message: error.body.message,
                            variant: 'error'
                        }),
                    );
                });
        }
    }

    /* getter method to check if there is mapping already available on Data template */
    get hasMapping() {
        return this.mappings.has(this.fieldDefination.apiName);
    }

    get activeMapping() {
        return this.hasMapping && this.mappings.get(this.fieldDefination.apiName).e_eat__Active__c;
    }

    /*Helper method to delete the mapping */
    deleteMapping() {
        if (this.hasMapping) {
            console.log('active '+this.mappings.get(this.fieldDefination.apiName).e_eat__Active__c);
            const fields = {};
            fields['e_eat__Active__c'] = false;
            fields['Id'] = this.mappings.get(this.fieldDefination.apiName).Id;
            const recordInput = {
                fields
            };
            updateRecord(recordInput)
                .then()
                .catch(

                );
        }
    }

    /* Getter method to verify if the field is required on field defination */
    get fieldRequired() {
        return this.fieldDefination.required;
    }

    /* Getter method to verify if the field is creatable on field defination */
    get fieldCreateable() {
        return this.fieldDefination.createable;
    }
}