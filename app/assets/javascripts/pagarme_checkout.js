$(document).ready(function() {
  var button = $('#pay-button');

  if (sessionStorage.message) {
    addFlash(sessionStorage.message);
    sessionStorage.removeItem('message');
  }

  button.click(function() {
      // INICIAR A INSTÂNCIA DO CHECKOUT
      // declarando um callback de sucesso
      var encryptionKey = $('#pay-button').data('pagarme-enc-key');
      var checkout = new PagarMeCheckout.Checkout({"encryption_key": encryptionKey, success: function(data) {
        sessionStorage.message="Pagamento realizado com sucesso.";
        location.reload();
        //Tratar aqui as ações de callback do checkout, como exibição de mensagem ou envio de token para captura da transação
      }});

      var _paymentInformation = $("[data-payment-information]");
      var _paymentId = $("[data-payment-id]").data("payment-id");
      var _postbackUrl = "https://teste.aiesec.org.br/api/v1/pagarme/postback/" + _paymentId;
  
      // DEFINIR AS OPÇÕES
      // e abrir o modal
      // É necessário passar os valores boolean em "var params" como string
      var params = {
        "amount":_paymentInformation.find("[data-value]").data("value"),
        "buttonText":"Pagar",
        "customerData":"true",
        "paymentMethods":"boleto,credit_card",
        "maxInstallments":10,
        "uiColor":"#bababa",
        "postbackUrl": _postbackUrl,
        "createToken":"true",
        "interestRate":2.99,
        "freeInstallments":6,
        "defaultInstallment":1,
        "headerText":_paymentInformation.find("[data-opportunity-name]").data("opportunity-name")
      };
      checkout.open(params);
  });
  function addFlash(message) {
    $("#messages").append('<div class="alert alert-success">'+message+'</div>');
  }
});
