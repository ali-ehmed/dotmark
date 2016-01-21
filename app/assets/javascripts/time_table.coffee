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

$timetable = {
	getAllocationsOfTeacher: ->
	    $input = $('ul.allocations_current_batches li').find("input[type='radio']:checked")
	    window.current_batch = $input.val()
	    url = "/time_table/#{$input.val()}/teacher_allocations.js"
	    $.get url, (response) ->
	      return

	bookingClassroom: ->
		$(document).on "submit", "form#scheduleForm", (e) ->
			e.preventDefault()
			console.log("Booking Now")

			$form = $(@)

			params = [ $form.serializeArray()[0].name ]

			$.each $form.serializeArray(), (i) ->
			  param = $(this)
			  if i > 0
				  params.push param[0].name
				  return

			console.log params

			if jQuery.inArray('section_id', params) == -1
				error = true
			else if jQuery.inArray('classroom_id', params) == -1
				error = true

			if error is true
			  $.notify {
			    icon: 'glyphicon glyphicon-warning-sign'
			    title: '<strong>Instructions:</strong><br />'
			    message: 'Please select the required entities to book a classroom.'
			  }, type: 'danger'
				
			  return false

			$.post($form.attr('action'), $form.serialize(), (data) ->
			  console.log 'Booked'
			  
			  $("#scheduleTeacherTimeModal").modal('hide')

			  time_slot_id = $("#time_slot_id").val()
			  $("table#time_table tr [data-time-slot-id='#{time_slot_id}']").html("
				  <span class='label' style='cursor: help;background-color: #{data.course.color};'>
				  #{data.course.code}
				  </span>
				")
			  
			).done(->
			).fail ->
			  swal 'Something went wrong'
			  return

}

$(document).on 'page:change', ->

	$timetable.getAllocationsOfTeacher() if current_teacher() == current_resource #if teacher_signed_in?
	$timetable.bookingClassroom()

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