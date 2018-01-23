/**
 * Created by cbarbour on 1/17/18.
 */

@IsTest
private class ResourceAbsenceTriggerHandlerTest {

    // Test data
    static ResourceAbsence testBreak;
    static ResourceAbsence testNonAvailability;
    final static String BREAK_RECORD_TYPE = RecordTypeUtility.getRecordTypeMapForObject('ResourceAbsence').get('Break');
    final static String NON_AVAIL_RECORD_TYPE = RecordTypeUtility.getRecordTypeMapForObject('ResourceAbsence').get('Non_Availability');
    static ServiceResource testResource;
    static User testUser;
    static List<ResourceAbsence> newAbsenceList;


    private static void prepTestData() {

        createTestResource();

        // Initialize or clear the list of resource absences
        if (newAbsenceList == null) {
            newAbsenceList = new List<ResourceAbsence>();
        }
        else {
            newAbsenceList.clear();
        }

    }

    private static void createTestResource() {
        createTestUser();

        testResource = new ServiceResource(IsActive = true,
                Name = 'Tester Copperpot',
                RelatedRecordId = testUser.Id,
                ResourceType = 'T'
        );

        insert testResource;

    }


    private static void createTestUser() {
        // Setup test data
        // This code runs as the system user
        String randomInt = String.valueOf(Crypto.getRandomInteger());
        String testUserName = 'standarduser_' + randomInt + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        testUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = testUserName);

        insert testUser;

    }


    static testMethod void testNewBreakWithCountryData() {
        prepTestData();

        testBreak = new ResourceAbsence(RecordTypeId = BREAK_RECORD_TYPE,
                ResourceId = testResource.Id,
                Country = 'United States',
                CountryCode = 'US'
        );

        newAbsenceList.add(testBreak);

        Test.startTest();

        ResourceAbsenceTriggerHandler triggerHandler = new ResourceAbsenceTriggerHandler();
        triggerHandler.executeBeforeInsertFunctions(newAbsenceList);

        System.assertEquals('', newAbsenceList[0].Country);
        System.assertEquals('', newAbsenceList[0].CountryCode);

        Test.stopTest();

    }

    static testMethod void testNewBreakWithoutCountryData() {
        prepTestData();

        testBreak = new ResourceAbsence(RecordTypeId = BREAK_RECORD_TYPE,
                ResourceId = testResource.Id,
                Country = '',
                CountryCode = ''
        );

        newAbsenceList.add(testBreak);

        Test.startTest();

        ResourceAbsenceTriggerHandler triggerHandler = new ResourceAbsenceTriggerHandler();
        triggerHandler.executeBeforeInsertFunctions(newAbsenceList);

        System.assertEquals('', newAbsenceList[0].Country);
        System.assertEquals('', newAbsenceList[0].CountryCode);

        Test.stopTest();

    }

    static testMethod void testNewNonAvailability() {
        prepTestData();

        testNonAvailability = new ResourceAbsence(RecordTypeId = NON_AVAIL_RECORD_TYPE,
                ResourceId = testResource.Id,
                Country = 'United States',
                CountryCode = 'US'
        );

        newAbsenceList.add(testNonAvailability);

        Test.startTest();

        ResourceAbsenceTriggerHandler triggerHandler = new ResourceAbsenceTriggerHandler();
        triggerHandler.executeBeforeInsertFunctions(newAbsenceList);

        System.assertEquals('United States', newAbsenceList[0].Country);
        System.assertEquals('US', newAbsenceList[0].CountryCode);

        Test.stopTest();

    }


}