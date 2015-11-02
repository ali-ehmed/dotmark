setupAcademicSession = ->
  $setup_session = new Institute
  $setup_session.setupEntity("Academic Session", $('#batch_save'))

window.creatingSections = (elem) ->
  $this = $(elem)
  $batch_id = $this.data("batch-id")
  $url = "/institutes/batches/#{$batch_id}/add_sections"
  $.ajax
    type: 'PUT'
    url: $url
    data: {no_of_sections: $this.val()}
    dataType: 'JSON'
    success: (response) ->
      $("td#batch_sections_#{$batch_id}").html(response.sections)
      console.log response.status
      $this.prop 'selectedIndex', 0
    error: (response) ->
      swal 'oops', 'Something went wrong'
  false

ready = ->
  setupAcademicSession()
  
  $(".academic_batches p:nth-child(2) input[type='text']").attr('maxlength','0') 
  $(".academic_batches p:last-child input[type='text']").attr('maxlength','0')
    
  # Date picker
  $(".start").datetimepicker
    format: 'YYYY-MM-DD'
    
  $(".end").datetimepicker
    format: 'YYYY-MM-DD'


  $(".batches_table").DataTable
    responsive: true
    "dom": '<"pull-left"f><"pull-right"l>tip'

$(document).ready ready
$(document).on 'page:load', ready