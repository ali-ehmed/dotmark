window.getBatchid = (elem, batch_id) ->
	$(elem).attr("data-id", $.trim(batch_id))
	$("#batch_id_param").val("#{batch_id}")

getStudents = ->
	$("#search_students_form").on "submit", (e) ->
		e.preventDefault()
		$form = $(this)
		batch_id = $("#batch_id_param").val()
		$form_data = $form.serialize()
		$path = $(this).attr("action")
		$method = $(this).attr("method")
		$submit_btn = $form.find("input[type='submit']")
		$.ajax
	    type: $method
	    data: $form_data
	    url: $path
	    beforeSend: ->
	    	$submit_btn.replaceWith("<button id=\"searching_btn\" class=\"btn btn-danger\" disabled=true>Searching..<i class=\"fa fa-spinner fa-spin\"></i></button>")
	    	$('ul.students_search_index').find("li.active a").append(" ")
	    success: (data) ->
	      console.log 'Status: Ok'
	      $('#searching_btn').replaceWith($submit_btn)
	      return
      error: (data) ->
      	swal("Oops", "Something went wrong")

$(document).on "page:change", ->
	# getStudents()

	$('ul.students_search_index a').on "click", ->
		$(this).tab('show')

	$('ul.students_search_index').find("li:first-child").addClass("active")
	$('div.students_search_index').find("div:first-child").addClass("active")

	$('div.students_search_index').find("div.tab-pane").each ->
		if $(this).hasClass("active")
			batch_id = $(this).data("batch-id")
			$("#batch_id_param").val(batch_id)
		else
			$(this).find("div").empty()
			return
