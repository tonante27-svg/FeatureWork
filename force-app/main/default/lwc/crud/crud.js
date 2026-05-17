import { LightningElement, wire } from 'lwc';
import { createRecord ,updateRecord,getRecord,deleteRecord} from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import LASTNAME_FIELD from '@salesforce/schema/Lead.LastName';

export default class Crud extends LightningElement {
    strLastName;
    strCompany;
    strLeadId;
    recordUpdate;
    strNewName;
    companyChangedHandler(event){
        this.strCompany = event.target.value;
    }
    nameChangedHandler(event){
        this.strLastName = event.target.value;
        console.log('Last Name' + this.strLastName);
    }

    submitRecord(){
        console.log('Last Name' + this.strLastName);
        console.log('Company' + this.strCompany);
        const
        fields = {
            LastName :this.strLastName,
                Company : this.strCompany
        }
        alert(fields);
        createRecord({apiName : 'Lead', fields}).then(result =>
            {
            console.log('Record created successfully' + result.id);
            this.strLeadId = result.id;
            }).catch(error =>{
                console.error('Error creating record' + JSON.stringify(error));
            })

    }
    //Read leads with the retRecord
    @wire(getRecord, {layoutType: 'Full', recordId : '$strLeadId'})
    getRecordHandler(data,error){
        console.log('getRecord', data);
        if(data){
            this.recordUpdate =  data.fields;
        }
        if(error){
            console.error('Error retrieving record' + JSON.stringify(error));
        }
    }

    idChangeHandler(event){
        this.strLeadId = event.target.value;
        console.log('Id' + this.strLeadId);
    }
    newNameHandler(event){
        this.strLastName = event.target.value;
        console.log('New Last Name' + this.strLastName);
    }
    submitUpdate() {
    // 1. Always declare variables (const or let)
    const fields = {};
    
    // 2. Map your fields correctly
    fields[ID_FIELD.fieldApiName] = this.strLeadId;
    fields[LASTNAME_FIELD.fieldApiName] = this.strLastName;

    // 3. updateRecord expects an object with a 'fields' property
    // We wrap 'fields' into a single object called 'recordInput'
    const recordInput = { fields };

    // 4. Pass that object directly to the wire adapter
       updateRecord(recordInput).then(() => {
            alert('Lead updated successfully!');
        })
        .catch(error => {
            console.error('Error updating record:', error);
        });
    }

    //delete record using the deleteRecord fucntion
    submitDelete(){
        deleteRecord(this.strLeadId).then(() => {
            alert('Lead deleted successfully!');
            this.strLeadId = null; // Clear the ID after deletion
        })
        .catch(error => {
            console.error('Error deleting record:', error);
        });
    }
    
}