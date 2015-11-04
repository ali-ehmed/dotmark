$admissions = 
  init: ->
    ### Initializing Methods ###
    $admissions.setupNewAdmission()
    $admissions.cancelAdmission()
    $admissions.autoCompleteGuardians()
    $admissions.searchGuardians()
    $admissions.generateUsername()
    return

  ### Setup Admission Form ###
  setupNewAdmission: ->
    $('#new-admission').on "click", (e) ->
      e.preventDefault()
      $this = $(this)
      $form = $this.closest('.modal').find("form")
      $.ajax
        type: $form.attr("method")
        url: $form.attr("action")
        cache: false
        data: $form.serialize()
        success: (response, xhr) ->
          console.log(response)
          if response.status == 'error'
            swal
              title: "Couldn't enroll admission"
              text: response.errors
              type: 'error'
              html: true
            false
          else
            $form.find(":input").val('')
            window.location.href = response.redirect_url

        beforeSend: ->
          $(".student-title").find("i").css("visibility", "hidden")
        error: (response) ->
          swal 'oops', 'Something went wrong'
      return false

  cancelAdmission: ->
  	$("#cancel-admission").on "click", ->
  		$("#batch_sections .form-group").empty()
  		$(this).closest('.modal').find("form :input").val ''

  searchGuardians: ->
    $("#search_guardian").on "click", (e) ->
      e.preventDefault()
      $elem = $(this)
      $path = "/get_parent/#{$elem.data("parent-id")}"
      
      search_query = $("#query")
      parent_validator = $('#parent_search_validator')
      
      if search_query.val() == ""
        $('.choose_guardians').fadeIn 500
        $('.searched_guardians').hide()

        if parent_validator.hasClass('hidden_name') then parent_validator.show() else ''
        search_query.addClass 'parent_search_validator'
      else
        console.log search_query.val()
        parent_validator.hide()
        search_query.removeClass 'parent_search_validator'

        if $elem.data("parent-id") == ""
          swal "Sorry", "There is no such Parent available", "error"
          return
        else
          $.ajax
            type: 'GET'
            data: { parent_id: $elem.data("parent-id") }
            url: $path
            success: (data) ->
              console.log 'Status: Ok'
              # $admissions.checkSelectedDependencyRelation()
              return

  generateUsername: ->
    username = document.getElementById('student_username')
    email = document.getElementById('student_email')
    if document.contains(username)
      username.onfocus = ->
        this.value = email.value.split("@")[0]

  autoCompleteGuardians: ->
    $('input#query').typeahead 
      source: (query, process) ->
        $.ajax
          url: '/autocomplete_guardians_search'
          data: query
          dataType: "json"
          beforeSend: ->
            $("input#query").closest(".input-group").find(".query-loader").html("<i class=\"fa fa-spinner fa-spin\"></i>")
            return
          complete: ->
            return
          success: (result) ->
            $("input#query").closest(".input-group").find(".query-loader").html("<i class=\"fa fa-bars\"></i>")
            resultList = result.map((item) ->
              aItem = 
                id: item.id
                name: item.name
              JSON.stringify aItem
            )
            process(resultList)
        return

      matcher: (obj) ->
        item = JSON.parse(obj)
        ~item.name.toLowerCase().indexOf(@query.toLowerCase())
      sorter: (items) ->
        `var item`
        beginswith = []
        caseSensitive = []
        caseInsensitive = []
        item = undefined
        while aItem = items.shift()
          item = JSON.parse(aItem)
          if !item.name.toLowerCase().indexOf(@query.toLowerCase())
            beginswith.push JSON.stringify(item)
          else if ~item.name.indexOf(@query)
            caseSensitive.push JSON.stringify(item)
          else
            caseInsensitive.push JSON.stringify(item)
        beginswith.concat caseSensitive, caseInsensitive
      highlighter: (obj) ->
        item = JSON.parse(obj)
        query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
        item.name.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
          '<strong>' + match + '</strong>'
      updater: (obj) ->
        item = JSON.parse(obj)
        # Getting Parent Id
        $("#search_guardian").attr("data-parent-id", item.id)

        $('#IdControl').attr 'value', item.id
        item.name

$(document).on 'page:change', ->
  $admissions.init()
  
  $("#form_student_dob").datetimepicker
    format: 'YYYY-MM-DD'


        

