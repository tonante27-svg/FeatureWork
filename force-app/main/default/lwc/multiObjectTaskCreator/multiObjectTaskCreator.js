


import { LightningElement, wire, track, api } from 'lwc';
import getAllowableObjects from '@salesforce/apex/TaskAttachBatchService.getAllowableObjects';
import getTypeValues from '@salesforce/apex/TaskAttachBatchService.getTypeValues';
import getStatusValues from '@salesforce/apex/TaskAttachBatchService.getStatusValues';
import getPriorityValues from '@salesforce/apex/TaskAttachBatchService.getPriorityValues';
import startBatchApexLWC from '@salesforce/apex/TaskAttachBatchService.startBatchApexLWC';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
export default class MultiObjectTaskCreator extends LightningElement {

   
    @api taskSubject;
    @api taskDate;
    @api selectedObject = '';
    @api selectedType = '';
    @api selectedStatus = '';
    @api selectedPriority='';

    @track objectOptions = [];
    @track statusOptions =[];
    @track typeOptions =[];
    @track priorityOptions=[];

  

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

    @wire(getTypeValues)
    wiredTypes({ data, error }) {
        if (data) {
            this.typeOptions = data;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getStatusValues)
    wiredStatuses({ data, error }) {
        if (data) {
            this.statusOptions = data;
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getPriorityValues)
    wiredPriorities({ data, error }) {
        if (data) {
            this.priorityOptions = data;
        } else if (error) {
            console.error(error);
        }
    }
    handleObjectChange(evt){
     this.selectedObject = evt.detail.value;

    }

    handleSubject(evt){
     this.taskSubject = evt.detail.value;
    }

    handleDate(evt){
        this.taskDate = evt.detail.value;
    }

    handleType(evt){
     this.selectedType = evt.detail.value;
    }

    handleStatus(evt){
     this.selectedStatus = evt.detail.value;
    }

    handlePriority(evt){
     this.selectedPriority = evt.detail.value;
    }

    handleSubmit(){

         const request = {
            objectTypeName: this.selectedObject,
            taskSubject: this.taskSubject,
            taskDate: this.taskDate,
            taskType: this.selectedType,
            taskPriority: this.selectedPriority,
            taskStatus: this.selectedStatus
        };
        //FORCE DEBUGGER PAUSE
        debugger;
        console.log('<< REQUESTED OBJECT NAME >>',request.objectTypeName);
        // 🌟 Clear out any proxies and force a clean object structure
const cleanRequest = JSON.parse(JSON.stringify(request));
        startBatchApexLWC({ request: cleanRequest })
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
    }
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