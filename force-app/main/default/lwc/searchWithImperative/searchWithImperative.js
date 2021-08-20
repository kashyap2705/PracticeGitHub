import { LightningElement,track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountService.getAccounts';
export default class SearchWithImperative extends LightningElement {
    @track accounts;
	@track error;
	handleKeyChange(event){
		constsearchKey = event.target.value;
		getAccounts({ strAccountName: constsearchKey })
		.then(result => {
			this.accounts = result;
			this.error = undefined;
		})
		.catch(error => {
			this.error = error;
			this.accounts = undefined;
		})
	} 
}