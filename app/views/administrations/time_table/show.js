console.log("success")

$("#admin_timetable").hide().html("<%= escape_javascript(rendering_time_table(@params)).html_safe %>").fadeIn(300);

$('html, body').animate({
    scrollTop: $("#admin_timetable").offset().top - 50
}, 2000);

$('[data-toggle="popover"]').popover()