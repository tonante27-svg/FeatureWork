import { LightningElement } from 'lwc';
import { NavigationMixin } from'lightning/navigation';
export default class NavigationMixinExample extends NavigationMixin(LightningElement) {

    // go to the Account home page
    goToAccountHome(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Account',
                actionName:'home'
            }
        });
    } 
    goToContactListView() { // go to a specified Contact list view
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent' // Id of the list view's filter
            }
        });
    }
    createOpportunityRecord() { // navigate to the New Opportunity record page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'
            }
        });
    }
    

}