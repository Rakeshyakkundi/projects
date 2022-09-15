public with sharing class insertCarRecord {
    @AuraEnabled
    public static List<CarRent__c> carRecord(String OwnerName,Integer rent,String carModel) {
        CarRent__c car =  new CarRent__c(Name=OwnerName,RentAmount__c=rent,CarModel__c=carModel);
        insert car;
        return [SELECT Id, Name, RentAmount__c, CarModel__c FROM CarRent__c order by CreatedDate desc];
    }
    @AuraEnabled
    public static  List<CarRent__c> carList() {
        List<CarRent__c> cars = [SELECT Id, Name, RentAmount__c, CarModel__c FROM CarRent__c order by CreatedDate desc];
        return cars;
    }
    @AuraEnabled
    public static List<CarRent__c> deleteCarRecord(Id carId) {
        CarRent__c car =  [SELECT Id, Name, RentAmount__c, CarModel__c FROM CarRent__c WHERE Id=:carId];
        delete car;
        return [SELECT Id, Name, RentAmount__c, CarModel__c FROM CarRent__c order by CreatedDate desc];
    }
}
