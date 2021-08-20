import { LightningElement,track,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountService.getAccounts';
export default class SearchWithWire extends LightningElement {
    @track searchKey;
	@track accounts;
	@track error;

	connectedCallback()
	{
		console.log('Inside connected callback**');

	}

	renderedCallback()
	{
		console.log('Inside rendered callback**');
		
	}

	@wire (getAccounts,{strAccountName: '$searchKey'})
	accounts
	/**wiredAccounts({data, error}){
		if(data) {
			this.accounts =data;
			this.error = undefined;
		}else {
			this.accounts =undefined;
			this.error = error;
		}
	}**/

	handleKeyChange(event){
		
		this.searchKey = event.target.value;
		console.log('this.searchKey***'+this.searchKey);
	}
}