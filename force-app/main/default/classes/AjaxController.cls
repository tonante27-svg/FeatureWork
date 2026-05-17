public with sharing class AjaxController {
    public Integer count = 0;

    public Integer getCount() {

        return count;
    }

    public PageReference incrementCount() {
        count++;
        return null; // Return null to stay on the same page
    }

}