//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree

$(".path-link").on("click", function(){
    var numb_id = $(this).attr("id").slice(2);
    var form_id = "#form-".concat(numb_id);
    $(form_id).submit();
});

function buttonSelected(e) {

    var target = e.target;
    current_class = target.getAttribute("class");
    target.setAttribute("class",  current_class ==="btn btn-default select-button" ? "btn btn-danger select-button-selected" :  "btn btn-default select-button");

}



function checkSelectedTag(){


    var selectedElements = document.getElementsByClassName("select-button-selected");
    var idSelectedElements = [];
    for (i = 0; i < selectedElements.length; i++) {
        idSelectedElements[i] = selectedElements[i].getAttribute("value");
    }
    document.getElementById("tags").value = idSelectedElements;

}