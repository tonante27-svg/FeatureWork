import { LightningElement } from 'lwc';

export default class ParentPassing extends LightningElement {

    myName = 'Tonante';
    myJob = { title: 'Developer', type: 'full-time' }
        myAddress = {
            street: '123 Main St',
            city: 'Anytown',
            province: 'AB'
        }
    
}