//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require application_layout/jquery.easing.min
//= require application_layout/scrolling-nav
//= require jquery.cookie.js

$(document).ready(function(argument) {
	// To check the cookie from another domain
	if($.cookie("confirm_notice")) {
		$('#confirm_notice_modal').modal('show')

		$('#confirm_notice_modal').on('shown.bs.modal', function () {
			$.removeCookie("confirm_notice", { domain: current_domain });
		})
	}
});
