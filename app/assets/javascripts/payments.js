//= require forms.js
//= require pagarme_checkout.js

$().ready(function() {
  gPaymentValue = $("#payment_value");
  gPaymentValue.maskMoney({prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: false});
});

$("[name=commit]").submit(function(){
  var value = $('#payment_value').maskMoney('unmasked')[0];
  $('#payment_value').val(value);
})
