/**
 * Apex class to handle vehicle-related invocable actions.
 */
public with sharing class VehicleAction {
    
    /**
     * Wrapper for invocable input representing a vehicle request.
     */
    public with sharing class VehicleRequest {
        @InvocableVariable(required=true)
        public Id vehicleId;
    }

    /**
     * Wrapper for invocable output representing a vehicle response.
     */
    public with sharing class VehicleResponse {
        @InvocableVariable
        public String statusMessage;
    }

    /**
     * Retrieves the status of a vehicle based on the provided vehicle request.
     * @param vehicleReqs List of vehicle requests containing vehicle IDs
     * @return List of vehicle responses with status messages
     */
    @InvocableMethod
    public static List<VehicleResponse> getStatus(List<VehicleRequest> vehicleReqs) {
        List<VehicleResponse> results = new List<VehicleResponse>();
        for(VehicleRequest req : vehicleReqs){
            VehicleResponse vResp = new VehicleResponse();
            vResp.statusMessage = 'Vehicle found: ' + req.vehicleId;
            results.add(vResp);
        }
        return results;
    }
}