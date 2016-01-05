parameters = ->
	$teacher_id = $(".teacher_ID").val()
	$batch_id = $(".batch_ID").val()
	_params = {
		teacher_id: $teacher_id,
		batch_id: $batch_id
	}

	_params
window.getAllCoursesAndSections = () ->
	_params = parameters()
	unless _params['batch_id'] == ""
		$url = "/institutes/course_allocations/#{_params['batch_id']}/courses_and_sections.js"
		$.ajax
	    type: "Get"
	    url: $url
	    data: _params
	    beforeSend: ->
	    	$(".loader").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
	    error: (response) ->
	      swal 'oops', 'Something went wrong'

window.getSectionsByCourse = (elem) ->
	_params = parameters()
	_params["only_sections"] = true
	_params["course_id"] = elem.value
	$url = "/institutes/course_allocations/#{_params['batch_id']}/courses_and_sections.js"
	$.ajax
    type: "Get"
    url: $url
    data: _params
    beforeSend: ->
    	$(".loader_1").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
    error: (response) ->
      swal 'oops', 'Something went wrong'

allocateTeachers = ->
  $('#allocate_btn').on 'click', (e) ->
    $form = undefined
    e.preventDefault()
    $form = $(this).closest('form')
    $.ajax
      type: $form.attr('method')
      url: $form.attr('action')
      data: $form.serialize()
      dataType: 'json'
      success: (response) ->
        if response.status == 'error'
          $.notify {
            icon: 'glyphicon glyphicon-warning-sign'
            title: '<strong>Couldn\'t Allocate: </strong>'
            message: "#{response.msg}"
          }, {
            type: "danger",
            allow_dismiss: true,
            z_index: 10000
          }
        else
          $.notify {
            icon: 'glyphicon glyphicon-ok'
            title: '<strong>Allocation Details: </strong>'
            message: '<ul><li><strong>Teacher:</strong> ' + response.teacher_name + '</li> <li><strong>' + pluralize(response.sections, 'Section') + ': </strong>' + $.map(response.sections, (n) ->
              n
            ) + '</li> <li><strong>Course: </strong>' + response.course + '</li></ul>'
          }, {
            type: "success",
            allow_dismiss: true,
            z_index: 10000
          }
          $('table.allocations_table_for_' + response.batch_id).DataTable().ajax.url('/institutes/course_allocations/' + response.batch_id + '/get_allocations.json').load()
      error: (response) ->
        swal 'oops', 'Something went wrong'

window.removeAllocations = (elem) ->
	$this = $(elem)
	swal {
	  title: "Remove #{$this.data('batch-name')}'s Allocations"
	  type: 'warning'
	  showCancelButton: true
	  confirmButtonColor: '#DD6B55'
	  confirmButtonText: 'Remove'
	  cancelButtonText: 'No'
	  closeOnConfirm: false
	  closeOnCancel: true
	}, ->
		$.ajax
	    type: "Delete"
	    url: $this.data("url")
	    data: {batch_id: $this.data("batch-id")}
	    dataType: 'json'
	    success: (response) ->
	      swal 'Removed', ''
	      $('table.allocations_table_for_' + $this.data("batch-id")).DataTable().ajax.url('/institutes/course_allocations/' + $this.data("batch-id") + '/get_allocations.json').load()
	    error: (response) ->
	      swal 'oops', 'Something went wrong'

window.removeTeacherAlloactions = () ->
	_params = parameters
	swal {
	  title: "Remove All Allocations"
	  type: 'warning'
	  showCancelButton: true
	  confirmButtonColor: '#DD6B55'
	  confirmButtonText: 'Remove'
	  cancelButtonText: 'No'
	  closeOnConfirm: false
	  closeOnCancel: true
	}, ->
		$.ajax
	    type: "Delete"
	    url: "/institutes/course_allocations/_params['teacher_id']/remove_teacher_allocations.json"
	    data: _params
	    dataType: 'json'
	    success: (response) ->
	    	$.notify {
          icon: 'glyphicon glyphicon-ok'
          title: '<strong>Allocation Details: </strong>'
          message: "<ul><li><strong>#{response.teacher_name}'s</strong> allocations have been removed.</li></ul>"
        }, {
          type: "danger"
        }
	      $('table.allocations_table_for_' + _params["batch-id"]).DataTable().ajax.url('/institutes/course_allocations/' + _params["batch-id"] + '/get_allocations.json').load()
	    error: (response) ->
	      swal 'oops', 'Something went wrong'
# wrapperAllocationCss = (elem) ->
# 	elem.css("text-align", "left")
# 	elem.css("margin", "0 auto")
# 	elem.css("width", "80%")
# 	elem.css("padding-left", "64px")
# 	elem.find("li").css("margin-bottom", "7px")
# 	elem.find("li span").css("font-weight", "bold")
# 	elem.find("li span").css("text-align", "center")
# 	elem.find("li span").closest("li").css("list-style-type", "none")

$(document).on "page:change", ->
	allocateTeachers()

	$(".course_allocation").select2
	  placeholder: "---Choose Semester---",
		allowClear: true

	$(".teacher_allocation").select2
	  placeholder: "---Choose Teacher---",
		allowClear: true

