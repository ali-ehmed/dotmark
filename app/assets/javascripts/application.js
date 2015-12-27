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
//= require jquery.turbolinks
//= require jquery_ujs

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
});