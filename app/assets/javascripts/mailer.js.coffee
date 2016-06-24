class window.Mailer
	@send_for_approval: (params, url) ->
    $.ajax
      type: 'Get'
      url: url
      data: params
      dataType: 'json'
      success: (response) ->
        if response.status == 'ok'
          $('table.allocations_table_for_' + params['batch_id']).DataTable().ajax.url('/institutes/course_allocations/' + params['batch_id'] + '/get_allocations.json').load()
          AlertNotification.notify("success", "", response.msg)
      error: (response) ->
        swal 'oops', 'Something went wrong'