window.getCoursesAndSections = () ->
	$teacher_id = $(".teacher_ID").val()
	$batch_id = $(".batch_ID").val()
	unless $batch_id == ""
		_params = {
			teacher_id: $teacher_id,
			batch_id: $batch_id
		}
		$url = "/institutes/course_allocations/#{$batch_id}/courses_and_sections.js"
		$.ajax
	    type: "Get"
	    url: $url
	    data: _params
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
          swal
            title: 'Couldn\'t Allocate'
            text: response.msg
            type: 'error'
            html: true

          $('.allocation_errors').css("text-align", "center") # if this Class is added in success
          wrapperAllocationCss($('.allocation_details_list')) # custom css if status is "Error"
        else
          swal
            title: 'Allocation Details'
            text: '<ul class="allocation_details_list" style="margin-left: 125px;"> <li><strong>Teacher:</strong> ' + response.teacher_name + '</li> <li><strong>' + pluralize(response.sections, 'Section') + ': </strong>' + $.map(response.sections, (n) ->
              n
            ) + '</li> <li><strong>Course: </strong>' + response.course + '</li> </ul>'
            type: 'success'
            html: true
          # Adds Extra Class and Serve
          $('.allocation_details_list').closest("p").addClass("allocation_errors")
          $('.allocation_errors').css("text-align", "left")
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
	}, (isConfirm) ->
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

wrapperAllocationCss = (elem) ->
	elem.css("text-align", "left")
	elem.css("margin", "0 auto")
	elem.css("width", "80%")
	elem.css("padding-left", "64px")
	elem.find("li").css("margin-bottom", "7px")
	elem.find("li span").css("font-weight", "bold")
	elem.find("li span").css("text-align", "center")
	elem.find("li span").closest("li").css("list-style-type", "none")

$(document).on "page:change", ->
	allocateTeachers()

	$(".course_allocation").select2
	  placeholder: "---Choose Semester---",
		allowClear: true

	$(".teacher_allocation").select2
	  placeholder: "---Choose Teacher---",
		allowClear: true

