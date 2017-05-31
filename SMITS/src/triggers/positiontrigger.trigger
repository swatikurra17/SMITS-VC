trigger positiontrigger on Position__c (before update) {
    Position__c p=new Position__c();
    p.City__c='chandigarh';

}