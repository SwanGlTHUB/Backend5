import { LightningElement, wire, track } from 'lwc';
import getTrades from '@salesforce/apex/TradeController.getTrades'

export default class TradesList extends LightningElement {
    @track allTrades
    @track tradesResponse
    @track showCreationModal = false

    @wire(getTrades)getAllTrades(response){
        this.tradesResponse = response
        if(response.error){
            console.log(error)
        }
        if(response.data){
            this.prepareTradesForDisplaying(response.data)
        }
    }

    prepareTradesForDisplaying(data){
        let allTrades = []
        data.forEach((item) => {
            let newTrade = {}
            newTrade.BuyAmount = item.Buy_Amount__c
            newTrade.BuyCurrency = item.Buy_Currency__c
            newTrade.SellAmount = item.Sell_Amount__c
            newTrade.SellCurrency = item.Sell_Currency__c
            newTrade.Rate = item.Rate__c
            newTrade.TradeId = item.Trade_Id__c
            newTrade.CreatedDate = item.CreatedDate
            allTrades.push(newTrade)
        })
        this.allTrades = allTrades
    }

    handleNewTradeButton(event){
        this.showCreationModal = true
    }

    handleCloseNewTradeModal(event){
        this.showCreationModal = false
    }
}