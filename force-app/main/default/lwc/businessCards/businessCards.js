import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountCardController.getAccounts';

export default class BusinessCards extends LightningElement {
    @wire(getAccounts) accounts;
}
