public inherited sharing class TradeController {
    
    @AuraEnabled(cacheable=true)
    public static List<Trade__c> getTrades(){
        List<Trade__c> result = [
            SELECT Sell_Currency__c, Buy_Currency__c, Sell_Amount__c,
            Buy_Amount__c, Rate__c, CreatedDate, Trade_Id__c
            FROM Trade__c
            LIMIT 100
        ];
        
        return result;
    }
    
    public static Boolean isTradeIdExist(String tradeId) {
        List<Trade__c> allTrades = [
            SELECT Trade_Id__c
            FROM Trade__c
            WHERE Trade_Id__c = :tradeId
        ];

        return allTrades.size() != 0;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getRate(String sellCurrency, String buyCurrency){
        Decimal result;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String access_key = '3165542b44791d650f6356c75f809837';
        String requestEndpoint = 'http://data.fixer.io/api/latest';
        
        requestEndpoint += '?access_key=' + access_key;
        requestEndpoint += '&base=EUR';
        requestEndpoint += '&symbols=' + sellCurrency + ',' + buyCurrency;
        System.Debug(requestEndpoint);
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            JSONParser parser = JSON.createParser(response.getBody());
            result = TradeController.getRateFromJSON(parser, sellCurrency, buyCurrency);
        }
        
        return result;
    }   

    private static Decimal getRateFromJSON(JSONParser parser, String sellCurrency, String buyCurrency){
        Decimal sellCurrencyRateInEUR;
        Decimal buyCurrencyRateInEUR;
        while(parser.nextToken() != null){
            System.Debug(parser.getText());
            if(parser.getText() == sellCurrency){
                parser.nextToken();
                sellCurrencyRateInEUR =  parser.getDecimalValue();
            }   
            if(parser.getText() == buyCurrency){
                parser.nextToken();
                buyCurrencyRateInEUR =  parser.getDecimalValue();
            }
        }

        return buyCurrencyRateInEUR / sellCurrencyRateInEUR;
    }
}
