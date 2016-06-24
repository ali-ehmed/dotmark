$(document).on "page:change", ->
  $("#form_teacher_dob").datetimepicker
    format: 'YYYY-MMM-DD'
    maxDate: false

  $("#form_teacher_joining_date").datetimepicker
    format: 'YYYY-MMM-DD'
    maxDate: false

