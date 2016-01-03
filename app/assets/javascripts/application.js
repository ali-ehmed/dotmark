// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//= require bootstrap-notify

//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

//= require jquery.minicolors
//= require jquery.minicolors.simple_form

//= require bootstrap-wizard


//= require typeahead

//= require moment
//= require bootstrap-datetimepicker

//= require jquery-ui/datepicker

//= require admin-theme
//= require turbolinks
//= require bootstrap-sprockets
//= require jasny-bootstrap.min
//= require sweet-alert

//= require jquery.purr
//= require best_in_place
//= require best_in_place.jquery-ui
//= require best_in_place.purr

//= require_tree .



$(document).ready(function(){
	$(".alert-message").addClass("in");

	/* swap open/close side menu icons */
	$('[data-toggle=collapse]').click(function(){
	  	// toggle icon
	  	$(this).find("i").toggleClass("glyphicon-chevron-right glyphicon-chevron-down");
	});

	// Defaults
	$.notifyDefaults({
		allow_dismiss: true,
		z_index: 10000,
		offset: {
			y: 50,
			x: 33
		},
		placement: {
			from: "top",
			align: "right"
		}
	});

	// $.notify({
	// 	// options
	// 	icon: 'glyphicon glyphicon-warning-sign',
	// 	title: 'Bootstrap notify',
	// 	message: 'Turning standard Bootstrap alerts into "notify" like notifications',
	// 	url: 'https://github.com/mouse0270/bootstrap-notify',
	// 	target: '_blank'
	// },{
	// 	// settings
	// 	element: 'body',
	// 	position: null,
	// 	type: "info",
	// 	allow_dismiss: true,
	// 	newest_on_top: false,
	// 	showProgressbar: false,
	// 	placement: {
	// 		from: "top",
	// 		align: "right"
	// 	},
	// 	offset: 20,
	// 	spacing: 10,
	// 	z_index: 1031,
	// 	delay: 5000,
	// 	timer: 1000,
	// 	url_target: '_blank',
	// 	mouse_over: null,
	// 	animate: {
	// 		enter: 'animated fadeInDown',
	// 		exit: 'animated fadeOutUp'
	// 	},
	// 	onShow: null,
	// 	onShown: null,
	// 	onClose: null,
	// 	onClosed: null,
	// 	icon_type: 'class',
	// 	template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
	// 		'<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
	// 		'<span data-notify="icon"></span> ' +
	// 		'<span data-notify="title">{1}</span> ' +
	// 		'<span data-notify="message">{2}</span>' +
	// 		'<div class="progress" data-notify="progressbar">' +
	// 			'<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
	// 		'</div>' +
	// 		'<a href="{3}" target="{4}" data-notify="url"></a>' +
	// 	'</div>' 
	// });

	
});