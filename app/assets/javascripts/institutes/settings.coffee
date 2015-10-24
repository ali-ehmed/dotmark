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

$(document).on 'page:change', ->
  $('.admin-settings-list-group').find('a[href="' + @location.pathname + '"]').addClass 'active-list'
  
  jQuery('.best_in_place').best_in_place()
  
  jQuery('.best_in_place').unbind().on 'ajax:error', ->
    $('.purr').prepend '<span class=\'glyphicon glyphicon-exclamation-sign\'></span> '
  return