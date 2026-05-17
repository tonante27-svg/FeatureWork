import { LightningElement,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';

export default class GetAccount extends LightningElement {

    accountId;
@wire(getRecord,{recordId:'$accountId',fields:[NAME_FIELD,INDUSTRY_FIELD,RATING_FIELD,PHONE_FIELD]})
    account;

    handleAccountIdChange(event){
        this.accountId = event.target.value;
    }
    

   dispatchShowDetailsEvent() {
    // Check if data exists before dispatching
    if (this.account && this.account.data) {
        const showDetailsEvent = new CustomEvent('showdetails', {
            detail: this.account.data
        });
        this.dispatchEvent(showDetailsEvent);
    } else {
        console.error('No account data available to dispatch yet!');
    }
}

}