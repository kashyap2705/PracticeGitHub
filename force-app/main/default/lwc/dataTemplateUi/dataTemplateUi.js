/* eslint-disable no-console */
/* eslint-disable no-unused-vars */
import OBJECTAPINAME_FIELD from '@salesforce/schema/Audit_Tracking_sObject__c.API_Name__c';
import { getFieldValue, getRecord, updateRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire, track } from 'lwc';
const fields = [OBJECTAPINAME_FIELD];
const DELAY = 400;

export default class DataTemplateUi extends LightningElement {
    @api recordId;
    @api elements;
    @wire(getRecord, {
        recordId: '$recordId',
        fields
    })
    dataTemplate;
    @track draggable = false;
    @track dragIndex;
    @track hoverIndex;
    @track updateRecords = false;
    _prevStateElements = [];

    get objectName() {
        return getFieldValue(this.dataTemplate.data, OBJECTAPINAME_FIELD);
    }

    handleChange(event) {
        const fields = {};
        let recId = event.target.id;
        fields['Id'] = recId.substring(0, 18);
        //fields['e_eat__Value__c'] = event.target.value;

        const recordInput = {
            fields
        };
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            updateRecord(recordInput)
                .then(() => {
                })
                .catch(error => {

                });
        }, DELAY);
    }

    changeSortMode() {
        this._prevStateElements = this.elements;
        this.draggable = !this.draggable;
    }

    handleSelected(event) {
        let drag = event.detail;
        this.dragIndex = drag;
    }

    handleDropItem(event) {
        let drop = event.detail;
        this.hoverIndex = drop;
        this.moveElements();
    }

    moveElements() {
        let drag = this.dragIndex;
        let hover = this.hoverIndex;        
        let sortedElements = [];
        for (let i = 0; i < this.elements.length; i++) {  
            sortedElements.push(this.elements[i]);  
        }       
        if(sortedElements.length > 0) {            
            let dragItem = sortedElements[drag];
            let slicedOne = sortedElements.splice(drag,1);
            sortedElements.splice(hover, 0, dragItem);
            this.elements = sortedElements;
        }
    }

    handleSave(event) {
        this.updateRecords = true;
       
    }

    handleCancel(event) {
        this.updateRecords = false;
        this.draggable = false;
        this.elements = this._prevStateElements;
    }
    handleUpdateComplete(event) {
        this.draggable = false;
        this.updateRecords = false;
    }
      
}