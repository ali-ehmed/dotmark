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

		# $form_data.push
		#   name: 'revision_date'
		#   value: revision_date_val
		$.ajax
	    type: $method
	    data: $form_data
	    url: $path
	    beforeSend: ->
	    	$('ul.students_search_index').find("li.active a").append(" <i class=\"fa fa-spinner fa-spin\"></i>")
	    success: (data) ->
	      console.log 'Status: Ok'
	      $('ul.students_search_index').find("li.active a i").remove()
	      return
      error: (data) ->
      	swal("Oops", "Something went wrong")

$(document).on "page:change", ->
	getStudents()

	$('ul.students_search_index a').on "click", ->
		$(this).tab('show')

	$('ul.students_search_index').find("li:first-child").addClass("active")
	$('div.students_search_index').find("div:first-child").addClass("active")

	# $('ul.students_search_index').find("li").each ->
	# 	if !$(this).hasClass("active")
	# 		div_id = $(this).find("a").data("target").split("#")[1]
	# 		$("div##{div_id}").empty()

	$('div.students_search_index').find("div.tab-pane").each ->
		if $(this).hasClass("active")
			batch_id = $(this).data("batch-id")
			$("#batch_id_param").val(batch_id)
			return
