import { LightningElement } from 'lwc';
import getVehicleRecords from 'salesforce/apex/VehiclesForService'
export default class VehicleService extends LightningElement {

    vehicles;
    error;

    async handleVLoad(){
        try{
            this.vehicles = await getVehicles();
            this.error = undefined;
        }catch(error){
            this.vehicles = undefined;
            this.error = error;
        }
    }

}