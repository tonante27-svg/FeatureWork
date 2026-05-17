import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal{
    @api colorOptions;
    currentColor = 'none'

    handleChange(event) {
        this.currentColor = event.detail.value;
    }

    handleSubmit() {
        this.close(this.currentColor);
    }

    }