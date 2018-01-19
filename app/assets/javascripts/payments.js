//= require forms.js
//= require pagarme_checkout.js

$().ready(function() {
  gPaymentValue = $("#payment_value");
  gPaymentValue.maskMoney({prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: false});

  $("#copy-btn").on('click', function() {
    console.log('clicked');
    copy_to_clipboard("#payment-url");
  });
});

$("[name=commit]").submit(function(){
  var value = $('#payment_value').maskMoney('unmasked')[0];
  $('#payment_value').val(value);
})

function copy_to_clipboard(element) {
  console.log($(element).val());
  var $temp = $("<input>");
  $("body").append($temp);
  $temp.val($(element).val()).select();
  document.execCommand("copy");
  $temp.remove();
}

