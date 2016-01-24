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
    $(document).on 'submit', 'form#scheduleForm', (e) ->
      e.preventDefault()
      console.log 'Booking Now'
      $form = $(this)


      params = [ $form.serializeArray()[0].name ]
      $.each $form.serializeArray(), (index) ->
        param = undefined
        param = $(this)
        if index > 0
          params.push param[0].name
        return

      console.log params

      if jQuery.inArray('section_id', params) == -1
        error = true
      else if jQuery.inArray('classroom_id', params) == -1
        error = true


      if error == true
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: 'Please select the required entities to book a classroom.'
        }, type: 'danger'
        return false

      $form_data = $form.serializeArray()

      course_id = document.getElementById('course_id').dataset.course_id
      console.log course_id

      $form_data.push {
        name: 'course_id'
        value: course_id
      }

      $.post($form.attr('action'), $form_data, (data) ->
        console.log 'Booked'

        $("#scheduleTeacherTimeModal").modal('hide')

        ).done(->
          console.log('Done')
        ).fail ->
          swal 'Something went wrong'
          return

}

window.returnSectionCourse = (elem) ->
  $this = $(elem)
  course_id = $this.closest("li").data('for-course-id')
  document.getElementById('course_id').dataset.course_id = course_id

window.removeReservedRoom = (parameters) ->
  console.log parameters
  swal {
    title: 'Are you sure you want to remove?'
    text: 'You Reserved room will be dismissed.'
    type: 'warning'
    showCancelButton: true
    confirmButtonColor: '#DD6B55'
    confirmButtonText: 'Yes'
    closeOnConfirm: true
  }, ->
    $.ajax
      type: "Delete"
      url: "/dissmiss_reserved_room"
      data: parameters
      dataType: "json"
      beforeSend: ->
        swal
          title: "<span class=\"fa fa-spinner fa-spin fa-3x\"></span>"
          text: "<h2>Removing</h2>"
          html: true
          showConfirmButton: false
      success: (response) ->
        expire_date = new Date
        expire_date.setMinutes expire_date.getMinutes() + 1

        window.current_account = response.current_domain
        $.cookie('current_account', response.current_domain, { expires: 1, path: response.current_domain })
        $.cookie('dismissed_reserved_seat', 'present', { expires: expire_date, path: current_account })

        setTimeout (->
          location.reload()
        ), 1000

      error: (response) ->
        swal 'oops', 'Something went wrong'
    return

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

#  Seat Dismiss Message
  if $.cookie('dismissed_reserved_seat')
    $.notify {
      icon: 'glyphicon glyphicon-ok'
      title: ''
      message: 'Your reserved seat has been removed.'
    }, type: 'success'

    setTimeout (->
      $.removeCookie 'dismissed_reserved_seat', path: $.cookie('current_account')
    ), 1000