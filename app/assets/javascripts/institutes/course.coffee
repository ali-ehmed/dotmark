setupCourse = ->
  $setup_course = new Institute
  $setup_course.setupEntity("Classroom", $('#course_save'))


$(document).on "page:change", ->
  setupCourse()

  $(".courses_table").DataTable
    responsive: true
    "dom": '<"pull-left"f><"pull-right"l>tip'

  $('.course_color').minicolors theme: 'bootstrap'
