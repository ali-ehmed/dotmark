currentAppActiveLink = (elem) ->
	elem.find("a[href=\"#{@location.pathname}\"]").parent().addClass "app-active-li"

$(document).on 'page:change', ->
  currentAppActiveLink $('.navbar-nav ')