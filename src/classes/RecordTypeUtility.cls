/**
 * Created by cbarbour on 1/18/18.
 */

public with sharing class RecordTypeUtility {


    private static Map<String, String> pRecordTypeMap;
    public static Map<String, String> getRecordTypeMapForObject(String sObjectType) {

        if (pRecordTypeMap == null) {
            pRecordTypeMap = new Map<String, String>();
            String queryString = 'SELECT Id, DeveloperName FROM RecordType WHERE IsActive = True AND SobjectType = :sObjectType';
            List<RecordType> recTypeList = database.query(queryString);

            for (RecordType recType : recTypeList) {
                pRecordTypeMap.put(recType.DeveloperName, recType.Id);
            }

        }

        return pRecordTypeMap;
    }

}