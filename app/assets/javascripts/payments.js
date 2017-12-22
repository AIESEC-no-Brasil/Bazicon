//= require forms.js
//= require pagarme_checkout.js

$().ready(function() {
  $("#payment_value").maskMoney({prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: false});
});
