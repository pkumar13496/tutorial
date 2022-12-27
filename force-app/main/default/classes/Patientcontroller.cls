public class Patientcontroller 
{
 public Patient__c patient{get;set;}
 public Patientcontroller ()
 {
 //Id id=apexpages.currentPage().getParameters().get('ID');
 Patient=[select Id,Name,Doctor__c,Address__c,Status__c,Date_Of_Brith__c,Blood_Group__c,Start_Date__c,Gender__c,
 Mobile__c,Email__c,Chief_Complaint__c,Dental_History__c,Provisional_Diagnosis__c,Finding__c,Medical_History__c,Treatment_Plan__c from Patient__c];
 }
 }