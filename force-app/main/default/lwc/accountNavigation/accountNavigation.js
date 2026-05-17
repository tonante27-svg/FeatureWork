import { LightningElement } from 'lwc';

export default class AccountNavigation extends LightningElement {

    goToAccounts(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'home'
            }
        });
    }
}