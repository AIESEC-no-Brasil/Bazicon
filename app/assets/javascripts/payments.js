//= require forms.js

$().ready(function() {
  $("#payment_value").maskMoney({prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: false});
});
