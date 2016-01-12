$(document).on 'page:change', ->
	$('.profile_url_btn').on 'click', (e) ->
    e.preventDefault()
    $('#accountModal').modal 'show'