/*
*  Name         : BankAccountTriggerHandler
*  Purpose      : Handler for Bank Account Trigger
*  Modified at  : 
***************************************************************************
*/
public class BankAccountTriggerHandler {
    
    private static BankAccountTriggerHandler instance;
    public static BankAccountTriggerHandler getInstance(){
        if (instance == null) 
            instance = new BankAccountTriggerHandler();
        return instance;
    } 

    public void onBeforeInsert(List<loan__Bank_Account__c> newList){
        
        for(loan__Bank_Account__c bankAccRec : newList){
            
            if(bankAccRec.loan__Bank_Account_Number__c != null){
                bankAccRec.Bank_Account_No__c = bankAccRec.loan__Bank_Account_Number__c;
            }
           // checkMandatoryFields(bankAccRec);
           
            }
        }
    
    
    public void onBeforeUpdate(Map<Id,loan__Bank_Account__c> oldMap, Map<Id,loan__Bank_Account__c> newMap){
        
       List<loan__Bank_Account__c> bankAccList       = new List<loan__Bank_Account__c>();
       //List<loan__Bank_Account__c> updateBankAccList = new List<loan__Bank_Account__c>();

        for(loan__Bank_Account__c bankAccRec : newMap.values()){
            if(!'Active'.equalsIgnoreCase(bankAccRec.Bank_Account_Status__c)){
                bankAccList.add(bankAccRec);
            }    
        }    

          /*  if( newMap.get(bankAccRec.Id).loan__Active__c
              && (oldMap.get(bankAccRec.Id).Bank_Account_Status__c != newMap.get(bankAccRec.Id).Bank_Account_Status__c && newMap.get(bankAccRec.Id).Bank_Account_Status__c=='Closed')){
                bankAccList.add(bankAccRec);
            }
            
            if(oldMap.get(bankAccRec.Id).loan__Bank_Account_Number__c != newMap.get(bankAccRec.Id).loan__Bank_Account_Number__c){
                bankAccRec.Bank_Account_No__c = bankAccRec.loan__Bank_Account_Number__c;
                bankAccRec.Changed_Field__c='Bank_Account_No__c';
                bankAccRec.Bank_Account_Old_Value__c = oldMap.get(bankAccRec.Id).loan__Bank_Account_Number__c;
                bankAccRec.Bank_Account_New_Value__c = newMap.get(bankAccRec.Id).loan__Bank_Account_Number__c;
                bankAccRec.Bank_Account_Changed_Date__c = System.today();
                bankAccRec.Bank_Account_Changed_By__c = UserInfo.getUserId();
                
            }
            checkMandatoryFields(bankAccRec);
        }*/

        //Handles the validation if whether the connected ASP's are active
        if(!bankAccList.isEmpty())
            onActiveChange_Validation(bankAccList);
    }
    
    
    public void onActiveChange_Validation(List<loan__Bank_Account__c> bankAccList){
        
       Map<Id,loan__Automated_Payment_Setup__c> automatedPayMap = new Map<Id,loan__Automated_Payment_Setup__c>();
       List<loan__Automated_Payment_Setup__c> automatedPayments = [Select id, loan__Active__c, loan__Bank_Account__c
                                                                    from loan__Automated_Payment_Setup__c
                                                                    where loan__Bank_Account__c in: bankAccList AND loan__Active__c = TRUE ];
        
        if(!automatedPayments.isEmpty()){
            for(loan__Automated_Payment_Setup__c pay : automatedPayments){
                automatedPayMap.put(pay.loan__Bank_Account__c, pay);
            }
            
            for(loan__Bank_Account__c bankAcc : bankAccList){
                if(automatedPayMap.containsKey(bankAcc.Id))
                    bankAcc.Bank_Account_Status__c.addError('Can\'t deactivate the record as there are connected active Automated Payment Setups');
            }
        }
    }
    
    public void onActiveStatusCheck(Map<Id,loan__Bank_Account__c> oldMap, Map<Id,loan__Bank_Account__c> newMap){
         for(loan__Bank_Account__c bankAccRec : newMap.values()){
             if(newMap.get(bankAccRec.Id).Bank_Account_Status__c == 'Active'){
                 bankAccRec.loan__Active__c = true;
             }else{
                 bankAccRec.loan__Active__c = false;
             }
         }
    }
    
    public void onActiveStatusCheck( List<loan__Bank_Account__c> newList){
         for(loan__Bank_Account__c bankAccRec : newList){
             if(bankAccRec.Bank_Account_Status__c == 'Active'){
                 bankAccRec.loan__Active__c = true;
             }else{
                 bankAccRec.loan__Active__c = false;
             }
         }
    }    
}