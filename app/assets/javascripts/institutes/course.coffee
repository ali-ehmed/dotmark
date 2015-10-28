setupCourse = ->
  $('#course_save').on "click", (e) ->
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
          swal 'Course', "created", "success"
          $('#course_modal').modal 'hide'
          $form.find(':input').val ''
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false


$(document).on "page:change", ->
  setupCourse()

  $('.course_color').minicolors theme: 'bootstrap'
