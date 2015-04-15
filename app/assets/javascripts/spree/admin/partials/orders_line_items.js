$(document).ready(function(){

    $('body').on('change', '.fabrication_state_select', _.debounce(function() {
        $(this).closest('form').trigger('submit');
    }, 500));

    $('form.fabrication_state_form').on("ajax:success", function(e, data, status, xhr) {
        console.dir(data);
    }).on("ajax:error", function(e, data, status, xhr) {
        alert("A problem occurred saving, please see JS console");
        console.dir(data);
        console.dir(status);
        console.dir(xhr);
    });

});