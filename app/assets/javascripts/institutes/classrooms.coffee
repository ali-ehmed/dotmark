setupClassroom = ->
  $setup_classroom = new Institute
  $setup_classroom.setupEntity("Classroom", $('#classroom_save'))

$(document).on "page:change", ->
  setupClassroom()

  $(".classrooms_table").DataTable
    responsive: true
    "dom": '<"pull-left"f><"pull-right"l>tip'
