window.pluralize = (obj_array, text) ->
  if obj_array.length > 1
    "#{text}s"
  else
    "#{text}"
    
currentAppActiveLink = (elem) ->
	elem.find("a[href=\"#{@location.pathname}\"]").parent().addClass "app-active-li"

window.activeTabs = (elem) ->
  setTimeout ->
    $("ul.nav").find("li").each ->
      if $(this).hasClass("active")
        $(this).css("font-weight", "bold")
      else
        $(this).css("font-weight", "normal")
  , 10

$(document).on 'page:change', ->
  activeTabs()

  currentAppActiveLink $('.navbar-nav')
  window.setTimeout (->
    $('.alert-timeout').fadeTo(500, 0).slideUp 500, ->
      $(this).hide()
  ), 5000

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind().on 'ajax:error', ->
    $('.purr').prepend '<span class=\'glyphicon glyphicon-exclamation-sign\'></span> '
    return

  $("span.best_in_place").closest("a").attr("href", "javascript:void(0)")

  # Default Date Settings (Basically for Best in Place)
  $.datepicker.setDefaults 
  	dateFormat: 'yy-mm-dd'
  	changeMonth: 'true'
  	changeYear: "true"
