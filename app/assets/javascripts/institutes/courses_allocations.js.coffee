window.getCoursesAllocation = (elem) ->
	$this = $(elem)
	params = {}
	params["batch_id"] = $this.val()
	$.ajax
		type: 'GET'
		url: "/institutes/course_allocations/courses"
		data: params
		success: (response) ->
			console.log "Success"
		error: (response) ->
		  swal 'oops', 'Something went wrong'

allocateTeachers = ->
	$("#allocate_btn").on "click", (e) ->
		e.preventDefault()
		$form = $(this).closest("form")
		$.ajax
			type: $form.attr("method")
			url: $form.attr("action")
			data: $form.serialize()
			dataType: "json"
			success: (response) ->
        if response.status == "error"
          swal
	          title: 'Couldn\'t Allocate'
	          text: response.msg
	          type: 'error'
	          html: true
        else
          swal
	          title: 'Allocation Complete'
	          text: "<strong>#{response.teacher_name}</strong> is allocated for #{pluralize(response.sections, 'Section')} #{$.map response.sections, (n) -> n} for <strong>#{response.course}</strong>"
	          type: 'success'
	          html: true
       error: (response) ->
			  swal 'oops', 'Something went wrong'

$(document).on "page:change", ->
	allocateTeachers()

	$(".course_allocation").select2
	  placeholder: "---Choose Semester---",
		allowClear: true

	$(".teacher_allocation").select2
	  placeholder: "---Choose Teacher---",
		allowClear: true

