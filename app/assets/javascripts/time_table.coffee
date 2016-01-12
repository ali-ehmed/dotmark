window.getCurrentTeacherAllocationsForTimeTable = ->
	$("#myAllocations").modal
		keyboard: false,
		show: true,
		backdrop: 'static'

window.openTimeScheduleCell = (elem) ->
	$url = $(elem).data("url")
	$.ajax
    type: "Get"
    url: $url
    beforeSend: ->
    	# $(".loader").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
    error: (response) ->
      swal 'oops', 'Something went wrong'

$(document).on 'page:change', ->
	$('table.teacher_allocations').DataTable
	  responsive: true
	  bSort: true
	  bFilter: true
	  'iDisplayLength': 7
	  ajax: $('table.table.teacher_allocations').data('source')
	  'columns': [
	    { 'data': 'course' }
	    { 'data': 'course_type' }
	    { 'data': 'section' }
	    { 'data': 'batch' }
	    { 'data': 'semester' }
	    { 'data': 'sent_date' }
	  ]