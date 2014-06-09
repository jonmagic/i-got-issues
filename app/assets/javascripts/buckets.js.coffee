Turbolinks.enableTransitionCache()

makeBucketsSortable = ->
  $(".js-bucket-list").sortable({
    connectWith: ".js-bucket-list"
    update: (event, ui) ->
      if this == ui.item.parent()[0]
        window.target    = $(event.target)
        bucket_id = target.data("bucket-id")
        position  = ui.item.index()

        $.ajax
          type: "POST"
          url: ui.item.data("move-to-bucket-path")
          dataType: "json"
          data: { prioritized_issue: { bucket_id: bucket_id, row_order_position: position } }
  }).disableSelection()

makeIssuesExpandable = ->
  $(document).on "click", ".js-issue-toggle", (e) ->
    e.preventDefault()
    link = $(this)
    issue = $(this).parents(".issue")
    issue.toggleClass("collapsed")

makeIssuesAssignable = ->
  $(document).on "click", ".js-issue-assignee-link", (e) ->
    e.preventDefault()
    link = $(this)
    issue = $(this).parents(".issue")
    issue.toggleClass("assigning")

  $(document).on "change", ".js-issue-assignee-select", (e) ->
    e.preventDefault()
    field = $(this)
    issue = $(this).parents(".issue")
    form  = $(this).parents("form")
    request = $.ajax
      url: form.attr("action")
      type: "PATCH"
      data: { prioritized_issue: { assignee: field.val() } }
      success: (html) ->
        issue.replaceWith(html)

makeIssuesStateable = ->
  $(document).on "change", ".js-issue-state-toggle", (e) ->
    field = $(this)
    issue = $(this).parents(".issue")
    form  = $(this).parents("form")
    state = if field.prop("checked")
      "closed"
    else
      "open"

    request = $.ajax
      url: form.attr("action")
      type: "PATCH"
      data: { prioritized_issue: { state: state } }
      success: (html) ->
        issue.replaceWith(html)

focusIssueImportOnCommand = ->
  $(document).on "keyup", (e) ->
    if $(".js-issue-import-url:focus").length == 0 && e.keyCode == 73
      $(".js-issue-import-url").focus()

$ ->
  makeBucketsSortable()
  makeIssuesExpandable()
  makeIssuesAssignable()
  makeIssuesStateable()
  focusIssueImportOnCommand()

$(document).on "page:load", ->
  makeBucketsSortable()
