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
    e.preventDefault()
    $form = $(this).closest('form')
    $.ajax
      type: $form.attr('method')
      url: $form.attr('action')
      data: $form.serialize()
      cache: false
      success: (response) ->
        if response.status == 'error'
          $.notify {
            icon: 'glyphicon glyphicon-warning-sign'
            title: '<strong>Allocation Errors Instructions: </strong>'
            message: "#{response.msg}"
          }, {
            type: "danger",
            allow_dismiss: true,
            z_index: 10000
          }
        else
          console.log "Allocated"
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

window.removeTeacherAllocations = (course_id, type) ->
  _params = {}
  _params = parameters()
  _params['course_id'] = course_id
  _params['type'] = type
  swal {
    title: 'Are you sure?'
    type: 'warning'
    showCancelButton: true
    confirmButtonColor: '#DD6B55'
    confirmButtonText: 'Remove'
    cancelButtonText: 'No'
    closeOnConfirm: true
    closeOnCancel: true
  }, ->
    $.ajax
      type: 'Delete'
      url: '/institutes/course_allocations/' + _params['teacher_id'] + '/remove_teacher_allocations.json'
      data: _params
      dataType: 'json'
      success: (response) ->
        if response.status == 'ok'
          $('table.allocations_table_for_' + _params['batch_id']).DataTable().ajax.url('/institutes/course_allocations/' + _params['batch_id'] + '/get_allocations.json').load()
          $.notify {
            icon: 'glyphicon glyphicon-ok'
            title: '<strong>Allocation Details: </strong>'
            message: "<ul><li>#{response.msg}</li></ul>"
          }, type: 'success'

          deactivateAllActiveLists()
        else
          $.notify {
            icon: 'glyphicon glyphicon-warning-sign'
            title: '<strong>Errors: </strong>'
            message: "<ul><li>#{response.msg}</li></ul>"
          }, type: 'danger'
      error: (response) ->
        swal 'oops', 'Something went wrong'

deactivateAllActiveLists = ->
	$("ul[data-type='sections']").find("li").each ->
  	if $(this).hasClass("list-active")
  		$(this).removeClass('list-group-item-primary list-active')
  		$(this).find("span").removeClass("glyphicon-check")
  		$(this).find("span").addClass("glyphicon-unchecked")
  		$(this).find("input[type='checkbox']").removeAttr("checked")
	$("#remove_teacher_allocations").empty()

$(document).on "page:change", ->
	allocateTeachers()

	$(".course_allocation").select2
	  placeholder: "---Choose Semester---",
		allowClear: true

	$(".teacher_allocation").select2
	  placeholder: "---Choose Teacher---",
		allowClear: true

