import { LightningElement,wire } from 'lwc';
import {NavigationMixin,CurrentPageReference} from 'lightning/navigation';
export default class NavigationService extends NavigationMixin(LightningElement) {
    // No methods or properties needed for the template
    goToGoogle(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            }
        })
    }
    renderedCallback(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            }
        }).then(url => {
            this.recordPageUrl = url
            console.log('Generated URL',url)
        }).catch(error=>{   
            console.error('Error generating URL',error)
        })
    }
    recordPageUrl

    @wire(CurrentPageReference) 
    thisPage
    
    // You need to use a getter to access the wired property in the template due to Apex
    get thisPageReference(){
        return this.thisPage ? JSON.stringify(this.thisPage,null,2):'' 
    }
}