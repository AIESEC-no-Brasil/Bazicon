


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