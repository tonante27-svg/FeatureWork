import { LightningElement } from 'lwc';
import MyCoolModal from"c/myModal";
export default class MyModalContainer extends LightningElement {
    selectedColor = 'none';
	handleOpenModal() {
		MyCoolModal.open({
			size:'small',
			colorOptions: [               
				{ label:'Red', value:'Red' },  
                { label:'Yellow', value:'Yellow' },            
				{ label:'Green', value:'Green' },               
				{ label:'Blue', value:'Blue' },
           	]       
		}).then(color=> {
		this.selectedColor = color;
       });
   }
   handleClearColor() {
	this.selectedColor = 'none';
   }
}