console.log("success")

$("#admin_timetable").hide().html("<%= escape_javascript(render partial: 'administrations/time_table/generated_time_table').html_safe %>").fadeIn(300);

$('html, body').animate({
    scrollTop: $("#admin_timetable").offset().top - 50
}, 2000);

$('[data-toggle="popover"]').popover()