public class CountryDetailController {
    public String selectedCountry { get; set; }
    public String continent { get; set; } // Store result here

    public void fetchData() {
        if(String.isNotBlank(selectedCountry)) {
            // Now that we are in an ACTION method, callouts are allowed!
            List<CountryWrapper> results = CountryCalloutUtility.getCountryByName(selectedCountry);
            
            if (!results.isEmpty()) {
                this.continent = results[0].continents[0];
                
                // You can even perform DML here if you need to save the result
                // Country__c c = [SELECT Id FROM Country__c WHERE Name = :selectedCountry LIMIT 1];
                // c.Continent__c = this.continent;
                // update c;
            }
        }
    }
}