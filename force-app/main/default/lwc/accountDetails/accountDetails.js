import { LightningElement } from 'lwc';

export default class AccountDetails extends LightningElement {

    name;
    rating;
    industry;
    phone;

    handleShowDetails(event){
        const accountData = event.detail;
        this.name = accountData.fields.Name.value;
        this.rating = accountData.fields.Rating.value;
        this.industry = accountData.fields.Industry.value;
        this.phone = accountData.fields.Phone.value;
    }
}