trigger TradeTrigger on Trade__c (before insert) {
    if(Trigger.isInsert){
        for(Trade__c trade : Trigger.new){
            while(true){
                String generatedId = 'TR' + CustomGenerator.generateRandomAlphanumericString(7);
                if(TradeController.isTradeIdExist(generatedId)){
                    continue;
                }
                else{
                    trade.Trade_Id__c = generatedId;
                    break;
                }
            }
            
        }
    }
}