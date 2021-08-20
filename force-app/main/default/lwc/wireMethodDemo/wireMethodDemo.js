import { LightningElement,wire,api } from 'lwc';
//import getAllAccounts from '@salesforce/apex/AccountManager.retrieveAccount'
//1. import the methods getRecord and getFieldValue
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import userId from '@salesforce/user/Id';

//2. Import reference to the object and the fields
import NAME_FIELD from "@salesforce/schema/Account.Name";
import RATING_FIELD from "@salesforce/schema/Account.Rating";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";
const fields = [NAME_FIELD, RATING_FIELD, INDUSTRY_FIELD];
export default class WireMethodDemo extends LightningElement {

    @api recordId;
  
    //3. Wire the output of the out of the box method getRecord to the property account
    @wire(getRecord, {
      recordId: "$recordId",
      fields
    })
    account;  

    loggedInUserId= userId ;
  
    /**renderedCallback() {
      console.log('renderedd call back in wire mthod**'+this.accounts.data);
    }

    @wire (getAllAccounts) accounts;**/
    
    /**get responseReceived()
    {
        if(this.accounts)
        {
            return true;
        }
        else false;

    }**/

    get name() {
        return getFieldValue(this.account.data, NAME_FIELD);
      }
    
      get rating() {
        return getFieldValue(this.account.data, RATING_FIELD);
      }
    
      get industry() {
        return getFieldValue(this.account.data, INDUSTRY_FIELD);
      }
} 