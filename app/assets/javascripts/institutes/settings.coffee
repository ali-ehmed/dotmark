$(document).on 'page:change', ->
  $('.admin-settings-list-group').find('a[href="' + @location.pathname + '"]').addClass 'active-list'
  
  jQuery('.best_in_place').best_in_place()
  
  jQuery('.best_in_place').unbind().on 'ajax:error', ->
    $('.purr').prepend '<span class=\'glyphicon glyphicon-exclamation-sign\'></span> '
  return