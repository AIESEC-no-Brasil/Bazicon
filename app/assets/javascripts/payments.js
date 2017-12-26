//= require forms.js
//= require pagarme_checkout.js

$().ready(function() {
  gPaymentValue = $("#payment_value");
  gPaymentValue.maskMoney({prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: false});
});
