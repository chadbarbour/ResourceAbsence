trigger ResourceAbsenceTrigger on ResourceAbsence (before insert) {

    //ResourceAbsenceTriggerHandler.resetAddressInfoForBreaks(Trigger.new);
    
    ResourceAbsenceTriggerHandler triggerHandler = new ResourceAbsenceTriggerHandler();
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            triggerHandler.executeBeforeInsertFunctions(Trigger.new);
        }
    }

}