global with sharing class ACHReturnPaymentDynamicProcessor{
    // Read ACH lock box file and find out payments to be reversed
    protected Set<String> loanNamesForNSF = new Set<String>();
    private List<loan__Loan_Payment_Transaction__c> paymentsToBeReversed;
    private List<loan__Loan_Account__c> loanAccsForNSF;
    public Boolean outOfOrderReversal;

    global ACHReturnPaymentDynamicProcessor(List<loan__Loan_Payment_Transaction__c> paymentsToBeReversed,List<loan__Loan_Account__c> loanAccsForNSF){
        this.paymentsToBeReversed = paymentsToBeReversed;
        this.loanAccsForNSF = loanAccsForNSF;
        this.outOfOrderReversal = false;

        if(paymentsToBeReversed == null) {
            paymentsToBeReversed = new List<loan__Loan_Payment_Transaction__c>();
        }

        if(loanAccsForNSF == null) {
            loanAccsForNSF = new List<loan__Loan_Account__c>();
        }
    }

    global void processACHReturns(){
            reversePayments();
            processNSF();
    }


    global void reversePayments(){
        List<loan__Repayment_Transaction_Adjustment__c> reversalTxnList = new List<loan__Repayment_Transaction_Adjustment__c>();
        for(loan__Loan_Payment_Transaction__c payment : paymentsToBeReversed){
            if(!outOfOrderReversal) {
                loan__Repayment_Transaction_Adjustment__c reversalTxn = new loan__Repayment_Transaction_Adjustment__c();
                reversalTxn.loan__Loan_Payment_Transaction__c = payment.Id;
                if(payment.loan__Out_of_Order_Payment__c != null 
                   && payment.loan__Out_of_Order_Status__c == 'Old') {
                    reversalTxn.loan__Loan_Payment_Transaction__c = payment.loan__Out_of_Order_Payment__c;
                }else{
                     reversalTxn.loan__Loan_Payment_Transaction__c = payment.Id;   
                }
                reversalTxn.loan__Reason_Code__c = payment.loan__Reversal_Reason__c;
                reversalTxnList.add(reversalTxn);
            }
        }
            
        if(reversalTxnList != null && reversalTxnList.size() > 0) {
            secureDML.insertRecords(reversalTxnList);
        }

       /* Set<ID> reversalTxnIds = new Set<ID>();
        for(loan__Repayment_Transaction_Adjustment__c reversalTxnTemp:reversalTxnList) {
            reversalTxnIds.add(reversalTxnTemp.Id);
        }

        List<loan__Repayment_Transaction_Adjustment__c> approvedTransactionList = (List<loan__Repayment_Transaction_Adjustment__c>)Database.query(loan.ProcessJobQueryUtil2.getRepaymentTxnAdjQuery(reversalTxnIds,false,false,null)); 
        //Approved Txns. This is required if approval process is setup for Reversal txn
        loan.BulkRepaymentAdjustmentAction approvedRepaymentAdjAction = new loan.BulkRepaymentAdjustmentAction(approvedTransactionList);
        approvedRepaymentAdjAction.postRepaymentsAdjusment();*/
    }

    //loanNamesForNSF Set is to be populated
    global void processNSF(){
        Date currentSystemDate = BatchUtils.getRootBranch().loan__Current_System_Date__c;
        NSFDynamicChargeCreator nsfCreator = new NSFDynamicChargeCreator(loanAccsForNSF,new Set<String>{'NSF Fees'},currentSystemDate);
        nsfCreator.chargeLoans();
        nsfCreator.commitToDb();
    }
}