


import { LightningElement, wire, track, api } from 'lwc';
import getEntityDefinitions from '@salesforce/apex/TaskAttachBatchService.getEntityDefinitions';
import getTypeValues from '@salesforce/apex/TaskAttachBatchService.getTypeValues';
import getStatusValues from '@salesforce/apex/TaskAttachBatchService.getStatusValues';
import getPriorityValues from '@salesforce/apex/TaskAttachBatchService.getPriorityValues';
import startBatch from '@salesforce/apex/TaskAttachBatchService.startBatchApexLWC';
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

  

    @wire(getEntityDefinitions)
    wiredObjects({ data, error }) {
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
     this.selectedObject = evt.target.value;

    }

    handleSubject(evt){
     this.taskSubject = evt.target.value;
    }

    handleDate(evt){
        this.taskDate = evt.target.value;
    }

    handleType(evt){
     this.selectedType = evt.target.value;
    }

    handleStatus(evt){
     this.selectedStatus = evt.target.value;
    }

    handlePriority(evt){
     this.selectedPriority = evt.target.value;
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

        startBatch(request)
            .then(() => {
            console.log('Batch started for LWC');
        })
        .catch(error => {
            console.error(error);
        });


    }
}