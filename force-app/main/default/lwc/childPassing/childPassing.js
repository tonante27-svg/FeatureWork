import { LightningElement,api } from 'lwc';

export default class ChildPassing extends LightningElement {

    @api name;
    @api job = { title: '', type: '' };
    @api street;
    @api city;
    @api province;
}