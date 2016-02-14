window.$timetable = {
  # Time Tables Coffee
  initFunctions: ->
    $timetable.getAllocationsOfTeacher() if resource_account == current_resource_account #if teacher_signed_in?
    $timetable.bookingClassroom()
    $timetable.generateTimeTable()
    $timetable.loadTeacherAllocations()
    $timetable.loadReservedDetail()

  getAllocationsOfTeacher: ->
    $input = $('ul.allocations_current_batches li').find("input[type='radio']:checked")
    window.current_batch = $input.val()
    url = "/room_reservation/#{$input.val()}/teacher_allocations.js"

    $("blockquote.teacher_allocation_for_batch").find("small").html(AlertNotification.startLoaderIn("", "fa-1x"))

    AlertNotification.startLoaderIn(".loader", "fa-3x")

    if $input.val()
      $.get(url, (response) ->
        return
      )
      .done((data)->
        if data.status == "401"
          console.log(data.responseText)
          return
      ).fail((response)->
        console.log(response)
      )

  bookingClassroom: ->
    $('form#scheduleForm').submit (e) ->
      e.preventDefault()
      console.log 'Booking Now'

      $form = $(this)

      params = [$form.serializeArray()[0].name]
      $.each $form.serializeArray(), (index) ->
        param = undefined
        param = $(this)
        if index > 0
          params.push param[0].name
        return

      console.log params

      if jQuery.inArray('section_id', params) == -1
        error = true
      else if jQuery.inArray('classroom_id', params) == -1
        error = true


      if error == true
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: 'Please select the required entities to book a classroom.'
        }, type: 'danger'
        return false

      $form_data = $form.serializeArray()

      course_id = document.getElementById('course_id').dataset.course_id
      console.log course_id

      $form_data.push {
        name: 'course_id'
        value: course_id
      }

      $.ajax
        type: "post"
        url: $form.attr('action')
        data: $form_data
        cache: false
        beforeSend: ->
          $form.find("button[type='submit']").prop("disabled", "disabled")
          $form.find("button[type='submit']").html("Processing... <i class='fa fa-spinner fa-spin fa-1x'></i>")
        success: (response, data) ->
          $("#scheduleTeacherTimeModal").modal('hide')
        error: (response) ->
          swal 'oops', 'Something went wrong'
        complete: ->
          console.log 'Done'
      false

  generateTimeTable: ->
    $("#generate_time_table").on "click", ->
      console.log("Generating")
      $(".book-reserved-detail").popover('destroy')

      section_id = $('input[name="section_id"]:checked').val()
      batch_id = $('input[name="current_batch_id"]:checked').val()

      if section_id == undefined
        $.notify {
          icon: 'glyphicon glyphicon-warning-sign'
          title: '<strong>Instructions:</strong><br />'
          message: 'Please Select Batch and Section'
        }, type: 'danger'
        return false

      params = {
        batch_id: batch_id,
        section_id: section_id
      }
      $("#admin_timetable").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")

      $.get(@dataset.url, params, (response) ->
        if response.status == "empty"
          $.notify {
            icon: 'glyphicon glyphicon-warning-sign'
            title: '<strong>Couldn\'t Generate:</strong><br />'
            message: "#{response.alert}"
          }, type: 'warning'

          $("#admin_timetable").empty()
          return false
      ).done(->
        console.log('Done')
      ).fail ->
        swal 'Something went wrong'
        return

  loadTeacherAllocations: ->
    $('table.teacher_allocations').DataTable
      responsive: true
      bSort: true
      bFilter: true
      'iDisplayLength': 7
      ajax: $('table.table.teacher_allocations').data('source')
      'columns': [
        { 'data': 'course' }
        { 'data': 'course_type' }
        { 'data': 'section' }
        { 'data': 'batch' }
        { 'data': 'semester' }
        { 'data': 'sent_date' }
      ]

  dismissScheduleForm: ->
    $('#scheduleTeacherTimeModal').on 'hidden.bs.modal', ->
      $(".schedule_timings").empty()

  loadReservedDetail: ->
    $marked_cell = $(".book-reserved-detail")
    $marked_cell.attr("data-clicked",  false)

    $is_clicked = $marked_cell.data("clicked")

    $marked_cell.click ->
      if $is_clicked == false
        $(@).attr("data-clicked",  true)
      else
        $(@).attr("data-clicked",  false)

    $marked_cell.mouseleave ->
      if $is_clicked = false
        $(this).popover('destroy')

    $marked_cell.mouseenter ->
      $popover = $(this)
      $behavior = $popover.data("behavior")

      _params = jQuery.parseJSON($behavior)

      section_id = $('input[name="section_id"]:checked').val()
      batch_id = $('input[name="current_batch_id"]:checked').val()

      if section_id
        _params["section_id"] = section_id

      if batch_id
        _params["batch_id"] = batch_id

      console.log _params

      $.get(@dataset.url, _params, (response) ->

        $popover.attr("data-original-title", response.title)
        $popover.attr 'data-content', response.content

      ).done( ->
        $popover.popover('toggle')
      ).fail ->
        swal 'Something went wrong'
        return

  getCurrentTeacherAllocationsForTimeTable: ->
    $("#myAllocations").modal
      keyboard: false,
      show: true,
      backdrop: 'static'

  openTimeScheduleCell: (elem) ->
    $url = $(elem).data("url")
    $slot_id = $(elem).closest('td').data('time-slot-id')
    $.ajax
      type: "Get"
      url: $url
      data: { batch_id: current_batch }
      beforeSend: ->
        # $(".loader-cell-#{$slot_id}").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
      error: (response) ->
        swal 'oops', 'Something went wrong'

  getTeacherAllocationsByBatch: (elem) ->
    $this = $(elem)
    window.current_batch = $this.val()
    $(".book-reserved-detail").popover('destroy')

    $.ajax
      type: "Get"
      url: "/room_reservation/#{$this.val()}/teacher_allocations.js"
      beforeSend: ->
        $(".loader").addClass("text-center").html("<i style=\"text-align:center;\" class=\"fa fa-spinner fa-spin fa-3x\"></i>")
      error: (response) ->
        swal 'oops', 'Something went wrong'

  returnSectionCourse: (elem) ->
    $this = $(elem)
    course_id = $this.closest("li").data('for-course-id')
    document.getElementById('course_id').dataset.course_id = course_id

  removeReservedRoom: (elem) ->
    parameters = jQuery.parseJSON(elem.dataset.params)[0]
    swal {
      title: 'Are you sure you want to remove?'
      text: 'Your Reserved room will be dismissed.'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Yes'
      closeOnConfirm: true
    }, ->
      $.ajax
        type: "Delete"
        url: "/dismiss_reserved_room"
        data: jQuery.parseJSON(parameters)
        dataType: "json"
        beforeSend: ->
          swal
            title: "<span class=\"fa fa-spinner fa-spin fa-3x\"></span>"
            text: "<h2>Removing</h2>"
            html: true
            showConfirmButton: false
        success: (response) ->

          alertDismiss("dismissed_reserved_seat", "present", 1, response)

          setTimeout (->
            location.reload()
          ), 1000

        error: (response) ->
          swal 'oops', 'Something went wrong'
      return
}

$(document).on 'page:change', ->
  $timetable.initFunctions()

#  Seat Dismiss Message
  if $.cookie('dismissed_reserved_seat')
    $.notify {
      icon: 'glyphicon glyphicon-ok'
      title: ''
      message: 'Your reserved seat has been removed.'
    }, type: 'success'

    setTimeout (->
      $.removeCookie 'dismissed_reserved_seat', path: $.cookie('current_account')
    ), 1000