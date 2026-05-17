import { LightningElement, wire } from 'lwc';
import { getRecord, getRecordCreateDefaults, getFieldValue,createRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { getListUi } from 'lightning/uiListApi';
import {getNavItems} from 'lightning/uiAppsApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import Id from '@salesforce/user/Id';



export default class WireAdapter extends LightningElement {
    userId = Id;
    accountRecordType;
    @wire(getRecord, { 
        layoutTypes:'Full',
        recordId: '$userId'
    })
    getRecordHandler({data, error }) {
        
       console.log('getRecord: ',data);
        
        if (data) {
             console.log('getFiledValue:', getFieldValue(data,'User.LastName'));
        } 
    }//getRecord
    /**
     * Wire adapter to fetch Account object metadata
     * Retrieves the default record type ID for dependent picklist queries
     * @param {Object} result - Wire adapter result containing data or error
     */
    @wire(getObjectInfo, { objectApiName: 'Account'})
    getObjectInfoHandler(data,error) {
        
        if (data) {
            this.accountRecordType = data.defaultRecordTypeId;
            
        } 
        console.log('getObjectInfo:', data);
    }//getObjectInfo
        /**
     * Wire adapter to fetch default values for Lead record creation
     * Useful for prepopulating form fields with org defaults
     * @param {Object} result - Wire adapter result containing data or error
     */
    @wire(getRecordCreateDefaults, { objectApiName: 'Lead' })
    getRecordCreateDefaultsHandler(data,error) {

        if (data) {
            this.accountRecordType = data.defaultRecordTypeId
            //if (this.isDebugMode()) {
                console.log('getRecordCreateDefaults:', data);
           // }
        } 
    }
        /**
     * Wire adapter to fetch picklist values for a specific field
     * Retrieves Industry field picklist values for the Account object
     * @param {Object} result - Wire adapter result containing data or error
     * @note Reactive to accountRecordType changes
     */
    @wire(getPicklistValues, { 
        recordTypeId: '$accountRecordType',
        fieldApiName: 'Account.Industry'
    })
    getPicklistValuesHandler(data,error) {
  
       
                console.log('getPicklistValues:', data);
  
       
    }
        /**
     * Wire adapter to fetch all picklist values for a record type
     * Retrieves all picklist fields for the Account object
     * @param {Object} result - Wire adapter result containing data or error
     * @note Reactive to accountRecordType changes
     */
    @wire(getPicklistValuesByRecordType, { 
        recordTypeId: '$accountRecordType',
        objectApiName: ACCOUNT_OBJECT
    })
    getPicklistValuesByRecordTypeHandler(data,error) {
       
        
        if (data) {
            this.accountPicklistValues = data.picklistFieldValues;
           
            
           
                console.log('getPicklistValuesByRecordType:', this.accountPicklistValues);
           
        } 
        console.log('getPicklistValuesByRecordType:', data);
    }
    @wire(getListUi, { objectApiName: ACCOUNT_OBJECT })
    getListUiHandler(data,error) {
         console.log('getListUi:',data);
    }
     @wire(getNavItems, { pageSize: 30})
    getNavItemsHandler(data,error) {
        if(data) {
            console.log('getNavItems: ',data);
        }
    }

    strLastName;
    strCompany;
    nameChangeHandler(event){
        this.strLastName = event.target.value;
    }
    companyChangeHandler(event){
        this.strCompany = event.target.value;
    }
    submitRecord(){
        let fields ={
            'LastName': this.strLastName,
            'Company': this.strCompany
        }
        console.log('submitRecord Fields : ', fields);
        createRecord({apiName: 'Lead', fields}).then(response =>{
            console.log('Lead created successfully with id: ', response.id)
        }).catch(error =>{
            console.log('Error creating record: ', JSON.stringify(error));
        });
        
    }

        /**
     * Centralized error handling with user notification
     * @param {string} context - Error context identifier
     * @param {string} message - User-friendly error message
     * @param {Object} error - Error object from wire adapter
     * @private
     */
    handleError(context, message, error) {
        this.errors[context] = error;
        
        // Log detailed error for debugging
        console.error(`${message}:`, this.reduceErrors(error));
        
        // Show user-friendly toast notification
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: `${message}. Please try again or contact your administrator.`,
                variant: 'error',
                mode: 'sticky'
            })
        );
    }
      /**
     * Reduces wire adapter errors to a readable format
     * @param {Object} error - Error object from wire adapter
     * @returns {string} - Formatted error message
     * @private
     */
    reduceErrors(error) {
        if (!error) {
            return 'Unknown error';
        }

        if (Array.isArray(error.body)) {
            return error.body.map(e => e.message).join(', ');
        } else if (error.body && typeof error.body.message === 'string') {
            return error.body.message;
        } else if (typeof error.message === 'string') {
            return error.message;
        }

        return JSON.stringify(error);
    }
       /**
     * Checks if component is in debug mode
     * @returns {boolean} - True if debug logging is enabled
     * @private
     */
    isDebugMode() {
        // Can be controlled via custom setting, custom metadata, or component attribute
        // For now, check if in non-production context
        return window.location.hostname.includes('localhost') || 
               window.location.hostname.includes('sandbox') ||
               window.location.hostname.includes('.scratch.') ||
               window.location.hostname.includes('.dev.');
    }
        /**
     * Computed property indicating overall loading state
     * @returns {boolean} - True if any data is still loading
     */
    get isLoading() {
        return this.isLoadingUser || 
               this.isLoadingAccount || 
               this.isLoadingLead || 
               this.isLoadingPicklists;
    }

    /**
     * Computed property indicating if any errors occurred
     * @returns {boolean} - True if any errors exist
     */
    get hasErrors() {
        return Object.values(this.errors).some(error => error !== null);
    }

    /**
     * Computed property for user display
     * @returns {string} - Formatted user display string
     */
    get userDisplayName() {
        return this.userLastName ? `User: ${this.userLastName}` : 'Loading user...';
    }
}