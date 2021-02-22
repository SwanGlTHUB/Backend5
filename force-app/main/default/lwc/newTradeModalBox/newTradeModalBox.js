import { LightningElement, track } from 'lwc';
import getRate from '@salesforce/apex/TradeController.getRate'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const allowedCurrencies = [
    { label: 'USD', value: 'USD' },
    { label: 'RUB', value: 'RUB' },
    { label: 'EUR', value: 'EUR' },
    { label: 'BYN', value: 'BYN' },
    { label: 'PLN', value: 'PLN' }
]

export default class NewTradeModalBox extends LightningElement {
    @track allowedCurrencies = allowedCurrencies
    @track value 
    @track sellCurrency
    @track buyCurrency
    @track sellAmount
    @track createButtonClicked = 0
    @track rate
    @track buyAmount

    closeModal(event){
        this.dispatchEvent(new CustomEvent('close'))
    }

    handleSellCurrencyChange(event){
        this.sellCurrency = event.target.value
    }

    handleBuyCurrencyChange(event){
        this.buyCurrency = event.target.value
    }

    handleSellAmountChange(event){
        this.sellAmount = event.target.value
    }

    createTrade(event){
        if(!this.sellCurrency || !this.buyCurrency || !this.sellAmount){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Not all fields are filled',
                    variant: 'error'
                })
            );
            return
        }

        getRate({sellCurrency: this.sellCurrency, buyCurrency: this.buyCurrency})
        .then((response) => {
            this.rate = response.toFixed(2)
            console.log(this.rate)
            this.buyAmount = (this.rate * this.sellAmount).toFixed(2)
        })
        .catch((error) => {
            console.log(error)
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Something wrong with API. Please try later',
                    variant: 'error'
                })
            );
        })
    }   
}