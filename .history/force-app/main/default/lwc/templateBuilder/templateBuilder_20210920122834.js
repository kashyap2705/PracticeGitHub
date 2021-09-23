import {LightningElement, wire, track, api} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import OBJECTAPINAME_FIELD from '@salesforce/schema/Audit_Tracking_sObject__c.API_Name__c';
const fields = [OBJECTAPINAME_FIELD];
const COLS = '2';

export default class TemplateBuilder extends LightningElement {

    @track objectApiName;
    @api recordId;
    @api mappings;
    @track objectInfo;
    @track searchText = '';
    @wire(getObjectInfo, {
        objectApiName: '$objectApiName'
    })
    objectInfo;
    @wire(getRecord, {recordId:'$recordId', fields})
    dataTemplate;

    /* Getter for Map of Fields from Object Schema */
    get mapFields() {
        return this.objectInfo ?
            this.objectInfo.data.fields :
            '';
    }

    /* Getter method find the list of fields from Object Schema */
    get objectFields() {
        let tempFi = [];        
        for (let key in this.mapFields) {
            if (this.mapFields.hasOwnProperty(key) && !this.mapFields[key].calculated 
                && this.mapFields[key].apiName != 'CreatedById' && this.mapFields[key].apiName != 'CreatedDate') {  // && this.mapFields[key].updateable                             
                tempFi.push(this.mapFields[key]);               
            }
        }
        return tempFi;
    }
    /* Filter the object fields based on the search term*/
    get searchResults() {
        var i, txtApiName, txtLabel, txtDataType, txtActive;
        let searchResults = [];
        let searchStr = this.searchText.toUpperCase();
        //if(this.searchText, )
        for (i = 0; i < this.objectFields.length; i++) {            
            txtApiName = this.objectFields[i].apiName.toUpperCase();
            txtLabel = this.objectFields[i].label.toUpperCase();
            txtDataType = this.objectFields[i].dataType.toUpperCase();
            txtActive = this.objectFields[i].e_eat__Active__c;
            if (txtApiName.indexOf(searchStr) > -1 || txtLabel.indexOf(searchStr) > -1 || txtDataType.indexOf(searchStr) > -1) {
                searchResults.push(this.objectFields[i]);
            }
          }
          return searchResults;
    }

    performSearch(event) {
        this.searchText = event.target.value;
    }
    /* Send custom event to parent component on selection of field */
    handleSelection(event) {   
        const dispathEvent = new CustomEvent('itemchange', {
            detail: event.detail
        });      
        this.dispatchEvent(dispathEvent);
    }

    /*Getter method for Object API Name */
    get objApiName() {
        this.objectApiName = getFieldValue(this.dataTemplate.data, OBJECTAPINAME_FIELD);
        return this.objectApiName;
    }

    /*Getter method for title of the Component */
    get title() {
        return 'Available fields for ' + this.objApiName;
    }

    /* Getter method for UI Elements. Returns the map with key value pair */
    get mapElements() {
        let mapOfElements = new Map();
        if(this.mappings) {
            for(let i=0; i < this.mappings.length; i++) {
                mapOfElements.set(this.mappings[i].e_eat__Field_API_Name__c, this.mappings[i]);
                mapOfElements.set(this.mappings[i].e_eat__Active__c, this.mappings[i]);
            }
        }
      return mapOfElements;
    }

    /* Getter method for Style class. Changes dynamically based on COLs value */
    get styleClass() {
        return 'slds-size_1-of-'+COLS;
    }
}