/**
 * Simple data class representing a single combobox option.
 */
public class ComboboxOption {
        /**
         * Display label for the combobox option.
         */
        @AuraEnabled public String label {get; set;}

        /**
         * Value of the combobox option to return to the server.
         */
        @AuraEnabled public String value {get; set;}

        /**
         * Constructs a combobox option.
         *
         * @param label The label to display in the UI.
         * @param value The underlying value to send to the server.
         */
        public ComboboxOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
}