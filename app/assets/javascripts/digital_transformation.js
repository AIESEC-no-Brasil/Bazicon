//= require forms.js

$().ready(function() {
  $.validator.addMethod("password",function(value,element){
            return this.optional(element) || /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}/.test(value);
        },"Senhas devem conter no mínimo 8 caractéres, letras maiúsculas, minúsculas e números");

  $.validator.addMethod("email",function(value,element){
            return this.optional(element) || /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))/.test(value);
        },"Por favor insira um endereço de email válido");

  var sent = false;
  var settings = {
    labels: {
      finish: "Enviar",
      next: "Próximo",
      previous: "Anterior",
    },

    enableCancelButton: false,
    transitionEffect: 'fade',

    bodyTag: "fieldset",

    onStepChanging: function (event, currentIndex, newIndex) {
      // Always allow going backward even if the current step contains invalid fields!
      if (currentIndex > newIndex) {
        fbq('trackCustom', "backward", {value:newIndex,program:"#{params['programa']}"} );
        return true;
      }
      fbq('trackCustom', "Next"+newIndex, {value:newIndex,program:"#{params['programa']}"});

      var form = $(this);

      // Clean up if user went backward before
      if (currentIndex < newIndex) {
        // To remove error styles
        $(".body:eq(" + newIndex + ") label.error", form).remove();
        $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
      }

      // Disable validation on fields that are disabled or hidden.
      form.validate({
        rules: {
          password: "required password",
          email: "required email"
        },
      }).settings.ignore = ":disabled,:hidden";

      // Start validation; Prevent going forward if false
      return form.valid();
    },

    onFinishing: function (event, currentIndex) {
      var form = $(this);

      // Disable validation on fields that are disabled.
      // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
      form.validate({
        rules: {
          password: "required password",
          email: "required email"
        },
      }).settings.ignore = ":disabled";

      // Start validation; Prevent form submission if false
      return form.valid();
    },

    onFinished: function (event, currentIndex) {
      var form = $(this);

      fbq('trackCustom', "Send", {value:currentIndex,program:"#{params['programa']}"});
      // Submit form input
      if (sent == false) {
        form.submit();
      }
      sent = true;
      $($("ul[aria-label='Pagination'] li")).addClass('disabled');
    }
  };

  $("#form").steps(settings).validate({
        rules: {
          password: "required password",
          email: "required email"
        },
      });

  $("select#study-level-form").change(function() {
    select_text = $(this).find('option:selected').val()
    if (select_text == '4' ||
       select_text == '5' ||
       select_text == '6') {
      $('#university').show('fast','linear');
      $('#university-form').addClass('required');
      $('#course').show('fast','linear');
      $('#course-form').addClass('required');
    }
    else {
      $('#university').hide('fast','linear');
      $('#university-form').removeClass('required');
      $('#course').hide('fast','linear');
      $('#course-form').removeClass('required');
    }
  });


  $('#password').keypress(function (e) {
    var regex = new RegExp("^[a-zA-Z0-9]+$");
    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    if (regex.test(str)) { return true; }

    alert("Sua senha deve conter apenas caractéres alfanuméricos");

    e.preventDefault();
    return false;
  });

  var gCheckboxSquare = $('.green-checkbox');

  gCheckboxSquare.hover(function() {
    $(this).addClass('hover');
  },
  function() {
    $(this).removeClass('hover');
  });

  gCheckboxSquare.on('change', 'input:checkbox', function(event) {
    var aSquare = $(event.delegateTarget);

    aSquare.toggleClass('checked', this.checked);
    aSquare.toggleClass('disabled', this.disabled);
  });

  $("#dob").mask("99/99/9999",{placeholder:"dd/mm/yyyy"});
});
