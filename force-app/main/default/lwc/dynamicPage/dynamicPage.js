import { LightningElement,track } from 'lwc';

export default class DynamicPage extends LightningElement {
@track item = {name:'John'};

    changeHandler(event){
        this.item.name = event.target.value;
    }
    handleClick(){
        let h1 = this.template.querySelector('h1').innerText;
        console.log(h1);
    }
}