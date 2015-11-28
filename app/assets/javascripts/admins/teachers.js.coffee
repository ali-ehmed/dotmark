$(document).on "page:change", ->
	$('#form_teacher_dob').datepicker(
    format: 'yyyy-M-dd'
    orientation: 'bottom left'
    startDate: '-30y'
    endDate: '+2d'
    useCurrent: true
  ).on 'changeDate', (e) ->
    $(this).datepicker 'hide'

  $('#form_teacher_joining_date').datepicker(
    format: 'yyyy-M-dd'
    orientation: 'bottom left'
    startDate: '-30y'
    endDate: '+2d'
    useCurrent: true
  ).on 'changeDate', (e) ->
    $(this).datepicker 'hide'