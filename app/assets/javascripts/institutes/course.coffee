setupCourse = ->
  $setup_course = new Institute
  $setup_course.setupEntity("Classroom", $('#course_save'))

getCoursesBySections = ->
	$("#semester_courses").on "change", ->
		$this = $(this)
		$.ajax
			type: 'GET'
			url: "/institutes/courses/get_course/#{$this.val()}"
			data: {semester_name: $this.val()}
			success: (response) ->
				console.log "Success"
			error: (response) ->
			  swal 'oops', 'Something went wrong'

$(document).on "page:change", ->
  setupCourse()
  getCoursesBySections()

  $('.course_color').minicolors theme: 'bootstrap'
