setupAcademicSession = ->
  $('#batch_save').click (e) ->
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
          swal 'Academic session', "created", "success"
          $('#session_modal').modal 'hide'
          $form.find(':input').val ''
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false

cancelAcademicSession = ->
  $(".cancel-academic-session").click (e) ->
    $form = $(this).closest('form')
    $form.find(':input').val ''

creatingSections = ->
  $("#create_sections").on "change", ->
    $this = $(this)
    $batch_id = $this.data("batch-id")
    $url = "/institutes/batches/#{$batch_id}/add_sections"
    $.ajax
      type: 'PUT'
      url: $url
      data: {no_of_sections: $this.val()}
      dataType: 'JSON'
      success: (response) ->
        $("td#batch_sections").html(response.sections)
        console.log response.status
        $this.prop 'selectedIndex', 0
      error: (response) ->
        swal 'oops', 'Something went wrong'
    false

ready = ->
  setupAcademicSession()
  cancelAcademicSession()
  creatingSections()
  
  $(".academic_batches p:nth-child(2) input[type='text']").attr('maxlength','0') 
  $(".academic_batches p:last-child input[type='text']").attr('maxlength','0')
    
  # Date picker
  $(".start").datetimepicker
    format: 'YYYY-MM-DD'
    
  $(".end").datetimepicker
    format: 'YYYY-MM-DD'

$(document).ready ready
$(document).on 'page:load', ready