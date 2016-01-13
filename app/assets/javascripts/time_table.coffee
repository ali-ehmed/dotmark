window.getCurrentTeacherAllocationsForTimeTable = ->
	$("#myAllocations").modal
		keyboard: false,
		show: true,
		backdrop: 'static'

window.openTimeScheduleCell = (elem) ->
	$url = $(elem).data("url")
	$slot_id = $(elem).closest('td').data('time-slot-id')
	$.ajax
    type: "Get"
    url: $url
    data: { batch_id: current_batch }
    beforeSend: ->
    	# $(".loader-cell-#{$slot_id}").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
    error: (response) ->
      swal 'oops', 'Something went wrong'

window.getTeacherAllocationsByBatch = (elem) ->
	$this = $(elem)
	window.current_batch = $this.val()
	$.ajax
    type: "Get"
    url: "/time_table/#{$this.val()}/teacher_allocations.js"
    beforeSend: ->
    	$(".loader").addClass("text-center").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
    error: (response) ->
      swal 'oops', 'Something went wrong'

getAllocationsOfTeacher = ->
    $input = $('ul.allocations_current_batches li').find("input[type='radio']:checked")
    window.current_batch = $input.val()
    url = "/time_table/#{$input.val()}/teacher_allocations.js"
    $.get url, (response) ->
      return

$(document).on 'page:change', ->

	getAllocationsOfTeacher() if current_teacher() == current_resource #if teacher_signed_in?

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