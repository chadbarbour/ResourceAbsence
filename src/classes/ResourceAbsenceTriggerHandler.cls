/**
 * Created by cbarbour on 1/17/18.
 */

public with sharing class ResourceAbsenceTriggerHandler {

    private List<ResourceAbsence> newAbsenceList = new List<ResourceAbsence>();
    private List<ResourceAbsence> newBreaksList = new List<ResourceAbsence>();
    final static String BREAK_RECORD_TYPE = RecordTypeUtility.getRecordTypeMapForObject('ResourceAbsence').get('Break');
    final static String NON_AVAIL_RECORD_TYPE = RecordTypeUtility.getRecordTypeMapForObject('ResourceAbsence').get('Non_Availability');

    // Constructor
    public ResourceAbsenceTriggerHandler() {

    }


    //Execute before insert and update functions
    public void executeBeforeInsertFunctions(List<ResourceAbsence> newAbsenceList_input) {

        newAbsenceList = newAbsenceList_input;

        // Identify breaks and load them into a list
        for (ResourceAbsence absence : newAbsenceList) {
            System.debug('==========> RecordTypeId from Absence: ' + absence.RecordTypeId);
            System.debug('==========> RecordTypeId for Break: ' + BREAK_RECORD_TYPE);

            if (absence.RecordTypeId == BREAK_RECORD_TYPE) {
                newBreaksList.add(absence);
            }
        }

        resetAddressInfoForBreaks();

    }

    //For breaks, clear the address info
    private void resetAddressInfoForBreaks() {

        for (ResourceAbsence aBreak : newBreaksList) {

            // Check to see if the Country data is blank. If so, clear it out.
            if (!String.isBlank(aBreak.Country) || !String.isBlank(aBreak.CountryCode)) {
                aBreak.Country = '';
                aBreak.CountryCode = '';
            }


        }


    }

}