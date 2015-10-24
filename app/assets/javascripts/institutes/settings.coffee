$(document).on "page:change", ->
	$(".admin-settings-list-group").find('a[href="' + this.location.pathname + '"]').addClass('active-list');
