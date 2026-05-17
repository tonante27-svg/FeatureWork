public with sharing class NastyNameOrdering {
    private String firstName;

    public String getName1() {
        if (firstName == null) {
            firstName = 'Sheila';
            return firstName;
        }else{
            return '1';
        }
       
    }
     public String getName2() {
        if (firstName == null) {
            firstName = 'Amanda';
            return firstName;
        }else{
            return '2';
        }
       
    }
     public String getName3() {
        if (firstName == null) {
            firstName = 'Dave';
            return firstName;
        }else{
            return '3';
        }
       
    }
}