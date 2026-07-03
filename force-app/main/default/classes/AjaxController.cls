/**
 * Controller for AJAX-based counter updates.
 */
public with sharing class AjaxController {
    public Integer count = 0;

    /**
     * Returns the current counter value.
     *
     * @return the current count
     */
    public Integer getCount() {

        return count;
    }

    /**
     * Increment the counter value.
     *
     * @return null to stay on the same page
     */
    public PageReference incrementCounter() {
        count++;
        return null; // Return null to stay on the same page
    }

}