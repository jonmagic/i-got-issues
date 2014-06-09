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
          url: ui.item.data("move-prioritized-issue-path")
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
    request = $.ajax
      type: "PATCH"
      url: issue.data("prioritized-issue-path")
      data: { prioritized_issue: { assignee: field.val() } }
      success: (html) ->
        issue.replaceWith(html)

$ ->
  makeBucketsSortable()
  makeIssuesExpandable()
  makeIssuesAssignable()

$(document).on "page:load", ->
  makeBucketsSortable()
