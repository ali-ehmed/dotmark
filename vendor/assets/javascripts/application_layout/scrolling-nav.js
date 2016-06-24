//jQuery to collapse the navbar on scroll
$(window).scroll(function() {
    if ($(".navbar").offset().top > 50) {
        $(".navbar-fixed-top").addClass("top-nav-collapse");
    } else {
        $(".navbar-fixed-top").removeClass("top-nav-collapse");
    }
});

//jQuery for page scrolling feature - requires jQuery Easing plugin
$(function() {
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        // $('.scroll-nav a.page-scroll').each(function(){
        //     $(this).css("font-size", "14px")
        //     $(this).css("color", "#777")
        // });
        // if(!$anchor.hasClass("navbar-brand")) {
        //     $anchor.css("color", "#000")
        //     $anchor.css("font-size", "22px")
        // }
        
        event.preventDefault();
    });
});
