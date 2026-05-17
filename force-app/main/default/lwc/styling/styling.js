import { LightningElement } from 'lwc';

export default class Styling extends LightningElement {
    buttonHovered= false;
    iconHovered = false;
    renderedCallback(){

        if(!this.buttonHovered){
            let style =document.createElement('style');
            let button = this.template.querySelector('lightning-button');
            style.innerHTML = `
                .slds-button:hover{
                background-color: black;
                color: white;
            }`
            button.appendChild(style)
            this.buttonHovered = true;
        }
        if(!this.iconHovered){
            let style =document.createElement('style');
            let icon = this.template.querySelector('lightning-icon.hover');
            style.innerHTML = `
                .slds-icon:hover{
                background-color: black;
                color: white;
            }`
            icon.appendChild(style)
            this.iconHovered = true;
        }
    }
    handleClick() {
        // Handle button click event
       console.log(this.template.querySelector('c-child-component').publicMethod());
    }
    handleChildEvent(event){
        console.log(event.detail);
    }
}