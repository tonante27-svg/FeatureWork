import { LightningElement, wire, track, api } from 'lwc';
import getAllowableObjects from '@salesforce/apex/RemoveTasksBatchService.getAllowableObjects';
import startBatchApexLWC from '@salesforce/apex/RemoveTasksBatchService.startBatchApexLWC';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class RemoveAllTasksFromObjects extends LightningElement {

    @track objectOptions = []; 
    @api selectedObject = '';

    handleObjectChange(evt){
     this.selectedObject = evt.detail.value;
    }

    @wire(getAllowableObjects)
        wiredObjects({ data, error }) {
            console.log('RAW DATA >>> data:', data);
            //console.log('Received objects:', data.length);
            console.log('TYPE >>>', typeof data);
            console.log('IS ARRAY >>>', Array.isArray(data));
            if (data) {
                this.objectOptions = data;
            } else if (error) {
                 console.error(error);
            }
        }

    handleSubmit(){
        startBatchApexLWC({ objectTypeName: this.selectedObject })
            .then(() => {
            console.log('Batch started for LWC');
            this.showToast('IN BATCH PROCESS','Sucessfully processing your request for tasks on '+this.selectedObject, 'success');
        })
        .catch(error => {
            console.error('Full Error Object:', error); 
            // Dynamically extract the Salesforce error message
            let message = 'Unknown error';
            if (error && error.body && error.body.message) {
                message = error.body.message;
            } else if (error && error.message) {
                message = error.message;
            }
            this.showToast('Error', message, 'error');
        });
    }// Submit
        showToast(title, message, variant) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: variant
                })
            );
        }
        reduceError(error) {
            if (Array.isArray(error.body)) {
                return error.body.map(e => e.message).join(', ');
            } else if (error.body && error.body.message) {
                return error.body.message;
            } else {
                return 'Unknown error occurred';
            }
        }
}



