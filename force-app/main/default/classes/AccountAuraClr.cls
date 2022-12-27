public class AccountAuraClr
 {
                @AuraEnabled
    public static List<clcommon__Party__c> getAccountRecord(string loanid)
   {
       system.debug('loanId is'+loanid);
       system.debug([select id,clcommon__Account__r.Name,clcommon__Type__r.Name from clcommon__Party__c where CL_Contract__c=:loanid]);
        return new List<clcommon__Party__c>( [select id,clcommon__Account__r.Name,clcommon__Type__r.Name from clcommon__Party__c where CL_Contract__c=:loanid]);
    }
}