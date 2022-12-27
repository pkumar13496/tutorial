public class AddNewPartyCtrl {
@AuraEnabled
    public static string addNewParty(String accid,String partyType,string loanid){
   string msg='';
  
        system.debug('in creation of party');
        try{
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId ].Name ;
            if(profileName=='Branch Standard Platform User FUSION'||profileName=='Branch Manager Standard Platform User FUSION' ){
              return 'You cannot add new party from CL Contract.';  
            }
            list<contact> lstcon=[select id from Contact where AccountID=:accid ];
       clcommon__Party__c newparty=new clcommon__Party__c();
         newparty.clcommon__Account__c=accid;
         newparty.clcommon__Type__c=partyType;
         newparty.CL_Contract__c=loanid;
            if(!lstcon.isEmpty()){
             newparty.clcommon__Contact__c= lstcon[0].id;  
            }
          SecureDML.insertRecords(newparty);
            system.debug('inserted party');
            msg='Party is inserted successfully.';
              return msg;
        }        
      
        catch(Exception e){
          msg=e.getMessage();
            return msg;
        }
    }
   

}