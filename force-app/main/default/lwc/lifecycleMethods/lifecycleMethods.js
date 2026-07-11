import { LightningElement } from 'lwc';
import htmltemplate from './htmltemplate.html';
import lifecycleMethods from './lifecycleMethods.html';
export default class LifecycleMethods extends LightningElement {
    renderDefault = false;
    error = false;
    // Mounting phase
    /* This should be fine too*/ 
    constructor(){
        super();
        console.log('constructor called');
    }
    connectedCallback(){
        console.log('connectedCallback called');
    }
    renderedCallback(){
        console.log('renderedCallback called');
        if(this.error){
       console.log('Error occurred, throwing error to test error boundaries');
       throw new Error('Test error from renderedCallback');    
        }
    }

    //Unmounting Phase
     disconnectedCallback(){
        console.log('disconnectedCallback called');
    }

    /* /Error Phase
     errorCallback(error, stack){
        console.log('errorCallback called with error: ', error, ' and stack: ', stack);
    } */
    render(){
        return this.renderDefault ? htmltemplate : lifecycleMethods;
    }

    handleClick(){
        this.renderDefault = !this.renderDefault;
    }

    causeError(){
        this.error = true;
        // This will cause an error in the template since we're trying to access a property on an undefined object
        this.error = true;
        console.log(this.error);
    }
}