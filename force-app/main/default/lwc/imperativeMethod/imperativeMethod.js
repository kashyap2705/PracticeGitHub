import { LightningElement,track } from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountManager.retrieveAccount';
import userId from '@salesforce/user/Id';
export default class ImperativeMethod extends LightningElement {
    @track accountsList;
    @track showAccounts;
    loggedInUserId= userId ;
    onShowClick(){

        getAllAccounts()
        .then(result => {
                this.accountsList = result;
                this.showAccounts = true;
        })
        .catch(error => {
            console.log('Errorured:- '+error.body.message);
        });
    }
    onHideClick(){
        this.showAccounts = false;
    }
}