setupClassroom = ->
  $('#classroom_save').on "click", (e) ->
    e.preventDefault()
    $form = $(this).closest('form')
    console.log  $form.serialize()
    $.ajax
      type: 'POST'
      url: $form.attr("action")
      data: $form.serialize()
      cache: false
      success: (response, data) ->
        if response.status == 'error'
          swal
            title: 'Couldn\'t save'
            text: response.errors
            type: 'error'
            html: true
          console.log 'Couldn\'t save'
        else
          swal 'Classroom', "created", "success"
          $('#classroom_modal').modal 'hide'
          $form.find(':input').val ''
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false

cancelClassroom = ->
  $(".cancel-classroom").click (e) ->
    $form = $(this).closest('form')
    $form.find(':input').val ''

$(document).on "page:change", ->
  setupClassroom()
  cancelClassroom()

  $('.classroom_color').minicolors theme: 'bootstrap'
