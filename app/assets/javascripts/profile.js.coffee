class Profile
  constructor: ->
    @teacherTimeTable()

  teacherTimeTable: ->
    $("a[href='#time_table_tab']").on "click", (e) ->
      e.preventDefault()
      unless $("#teacher_time_table").html().length > 0
        $("#teacher_time_table").css("text-align", "center")
        AlertNotification.startLoaderIn $("#teacher_time_table")

        $.get(@dataset.url, (response) ->

          $("#teacher_time_table").html(response)

          col = $("#teacher_time_table").find("table tbody tr:first-child td:first-child")
          col.css("padding-top", "27px")
        ).done(->
          $('[data-toggle="popover"]').popover()
          console.log('Rendered')
        ).fail ->
          swal 'Something went wrong'
          return

$(document).on 'page:change', ->
	new Profile

	$('.profile_url_btn').on 'click', (e) ->
    e.preventDefault()
    $('#accountModal').modal 'show'
    