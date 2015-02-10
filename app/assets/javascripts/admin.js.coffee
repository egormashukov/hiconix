//= require default
//= require_tree ./libs
//= require_self

$ ->
  $(".js-change-update").find("input, select").change ->
    $(@).closest(".js-change-update").find("form").trigger("submit")

$ ->
  $(".js-autosubmit").change ->
    $(@).closest("form").trigger("submit")

$ ->

  csrf_token = $('meta[name=csrf-token]').attr('content')
  csrf_param = $('meta[name=csrf-param]').attr('content')
  params = []

  if csrf_param != undefined && csrf_token != undefined
    params = csrf_param + "=" + encodeURIComponent(csrf_token)

  $('.js-redactor').redactor(
    imageUpload: "/redactor_rails/pictures?" + params
    imageGetJson: "/redactor_rails/pictures"
    path: "/assets/redactor-rails"
    css: "style.css"
    buttonSource: true
    lang: 'ru'
    plugins: ['table', 'fontcolor']
    buttons: ['html', 'formatting', 'bold', 'italic', 'unorderedlist', 'orderedlist', 'image', 'file', 'link', 'alignment', 'horizontalrule']
  )

  $(".js-textfielded-select").each ->
    el = $(@)
    el.select2(
      width: '100%'
      allowClear: true
      placeholder: 'Выберите или введите своё'
      data: el.data('valuesarray')
      createSearchChoice:  (term, data) -> 
        if ($(data).filter( -> @.text.localeCompare(term == 0) ).length == 0)
          {id:term, text:term}
    )

  $('.post_contact_client').click ->
    action = $(this).data('action')
    $.post '/feedback_requests/' + action, { contact_data: $('#feedback_request_contact_data').val() }, (result) ->
      # show close_request button
      return
    return
