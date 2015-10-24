gettingSections = ->
  $("#sections_for_batch").on "change", ->
    $this = $(this)
    $url = "/institutes/sections/get_sections"
    $.ajax
      type: 'Get'
      url: $url
      data: {batch_id: $this.val()}
      success: (response) ->
        console.log "OK"
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false

window.saveSection = (elem) ->
  $this = $(elem)
  $id = $this.data("section-id")
  $url = "/institutes/sections/#{$id}"
  $.ajax
    type: 'PUT'
    url: $url
    data: {color: $("#section_color_input_#{$id}").val()}
    success: (response) ->
      if response.status == 'error'
        swal
          title: 'Couldn\'t save'
          text: "Color is blank."
          type: 'error'
          html: true
        console.log 'Couldn\'t save'
      else
        $("li#section_color_#{$id} span").first().css "background-color", response.color
        $("li#section_color_#{$id} span").first().empty()
        $("#edit-section-color_#{$id}").modal 'hide'
    error: (response) ->
      swal 'oops', 'Something went wrong'
  false

$(document).on "page:change", ->
  gettingSections()