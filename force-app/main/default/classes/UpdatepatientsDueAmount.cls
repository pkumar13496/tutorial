public class UpdatepatientsDueAmount {
    
    public static void UpdatepatientsDueAmount1()
    {
        List<Bill__c> billist = [select id,Patient__c,Doctor_Charge__c,Room_Charge__c,Lab_Charge__c from Bill__c where bill_status__c ='Paid'];
        set<Id> patientid=new set<Id>();
        Decimal DoctorCharge;
        
        for(Bill__c bill :billist){
           DoctorCharge=bill.Doctor_Charge__c +bill.Lab_Charge__c+bill.Room_Charge__c;
           patientid.add(bill.Patient__c);
           
            System.debug('DoctorCharge:'+ DoctorCharge);                        
        
        }
        
        List<Patient__c> patlist = [Select id,name,Due_Amount__c from Patient__c where Id =:patientid];
        
        for(Patient__c ptt:patlist)
        {
            ptt.Due_Amount__c=integer.valueOf(DoctorCharge);
        }
        
        update patlist;
        
    }

}