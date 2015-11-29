window.getRecordAllocation = (elem) ->
	$this = $(elem)
	params = {}
	if $this.data("name") == "semester"
		params["semester_name"] = $this.val()
	else
		params["teacher_id"] = $this.val()
	$.ajax
		type: 'GET'
		url: "/institutes/course_allocations/get_allocation_record"
		data: params
		success: (response) ->
			console.log "Success"
		error: (response) ->
		  swal 'oops', 'Something went wrong'

$(document).on "page:change", ->
	$(".course_allocation").select2
	  placeholder: "---Choose Semester---",
		allowClear: true

	$(".teacher_allocation").select2
	  placeholder: "---Choose Teacher---",
		allowClear: true