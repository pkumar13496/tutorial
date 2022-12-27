@istest
public class UpdatepatientsDueAmounttest {

    public static testMethod void updatepatientAmount(){
        Doctor__c d = new Doctor__c();
        d.Name ='mukesh';
        insert d;
        
        Patient__c p = new Patient__c();
        p.Name='sohan';
        p.Doctor__c=d.Id;
        p.Status__c='pending';
        insert p;
        
        
        
        
        Bill__c b = new Bill__c();
        b.Doctor_Charge__c =500;
        b.Room_Charge__c =700;
        b.Lab_Charge__c=3000;
        b.bill_status__c='Paid';
        b.Patient__c=p.Id;
        insert b;
        
        Test.startTest();
             UpdatepatientsDueAmount.UpdatepatientsDueAmount1();           
        Test.stopTest();
        
        
        
        }
}