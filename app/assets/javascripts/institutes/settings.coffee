class window.Institute
  setupEntity: (entity_name, elem, {type, action, params} = {}) ->
    $elem = $(elem)
    $elem.on "click", (e) ->
    	e.preventDefault()
	    $form = $elem.closest('form')
	    console.log  entity_name

	    $http_type = if type then type else $form.attr("method")
	    $url = if action then action else $form.attr("action")
	    $data = if params then params else $form.serialize()

	    $.ajax
	      type: $http_type
	      url: $url
	      data: $data
	      cache: false
	      success: (response, data) ->
	      	if response.status == 'error'
	          $.notify {
	            icon: 'glyphicon glyphicon-warning-sign'
	            title: '<strong>Couldn\'t save: </strong>'
	            message: "#{response.errors}"
	          }, {
	            type: "danger"
	          }
	          console.log 'Couldn\'t save'
	        else
	          $.notify {
	            icon: 'glyphicon glyphicon-ok'
	            title: '<strong>Created</strong>'
	            message: "#{entity_name}"
	          }, {
	            type: "success"
	          }
	          $elem.closest(".modal").modal 'hide'
	          $form.find(':input').val ''
	      error: (response) ->
	        swal 'oops', 'Something went wrong'
	    false

window.confirmation = (text, elem) ->
	$elem = $(elem)
	url = $elem.data('url')
	swal {
	  title: text
	  type: 'warning'
	  showCancelButton: true
	  confirmButtonColor: '#DD6B55'
	  confirmButtonText: 'Remove'
	  cancelButtonText: 'No'
	  closeOnConfirm: false
	  closeOnCancel: true
	}, (isConfirm) ->
	  if isConfirm
	    $elem.attr "href", url
	    $elem[0].click()
	  else
	    swal 'Cancelled', '', 'error'
	  return

window.cancelForm = (elem) ->
  $form = $(elem).closest('form')
  $form.find(':input').val ''

window.gettingSections = (elem, new_admission_param = false) ->
    $this = $(elem)
    $url = "/institutes/get_sections"
    $.ajax
      type: 'Get'
      url: $url
      data: {batch_id: $this.val(), new_admission: new_admission_param}
      success: (response) ->
        console.log "OK"
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false

window.saveColor = (event) ->
  event.preventDefault()
  $form = $(event.target)
  $id = $form.data("object-id")
  return swal "Empty Color", "", "error" if $form.find("input.color_picker").val() == ""
  $.ajax
    type: 'PUT'
    url: $form.attr("action")
    data: $form.serialize()
    dataType: "json"
    success: (response) ->
      console.log response
      $("span#object_color_span_#{$id}").css "background-color", response.color
      $("span#object_color_span_#{$id}").find('a').hide()
      # $("li#section_color_#{$id} span").first().css "background-color", response.color
      # $("li#section_color_#{$id} span").first().empty()
      $("#edit-color_#{$id}").modal 'hide'
    error: (response) ->
      swal 'oops', 'Something went wrong'
  false

$(document).on 'page:change', ->
  get_curr_url_for_institutes = "/#{@location.pathname.split("/")[1]}/#{@location.pathname.split("/")[2]}"
  get_curr_url_for_settings = "#{@location.pathname}"
  $.each $('.settings-list-group').find('a'), ->
  	$curr_elem_href = $(@).attr("href")
  	if get_curr_url_for_institutes == $curr_elem_href or $curr_elem_href.indexOf(get_curr_url_for_settings) >= 0 or get_curr_url_for_settings == $curr_elem_href
  		$(this).addClass 'active-list'
  		false
  $('.color_picker').minicolors theme: 'bootstrap'

	

	


	


