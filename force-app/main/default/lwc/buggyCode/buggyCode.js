import { LightningElement,wire,track} from 'lwc';
import getContactList from '@salesforce/apex/AccountService.getAccounts';
export default class BuggyCode extends LightningElement {

    //@track contacts;
   // @track error;
   searchKey='';
    @wire(getContactList, { strAccountName: '$searchKey' })
    contacts;
    /**wiredAccounts({data, error}){
		if(data) {
			this.contacts =data;
			this.error = undefined;
		}else {
			this.contacts =undefined;
			this.error = error;
		}**/
	//}
    
    
    handlekeychange(event){
        this.searchKey = event.target.value;
        console.log('this.searchKey'+this.searchKey );
    }
}