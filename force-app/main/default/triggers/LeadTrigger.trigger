trigger LeadTrigger on SOBJECT (before insert) {
    If(Trigger.isBefore && Trigger.isInsert) {
        for (Lead lead : Trigger.new) {
            if (lead.Company == null) {
                lead.Company = 'Individual';
            }
        }
    }
}