Turbolinks.enableTransitionCache()

makeIssuesSortable = ->
  $(".js-write-access .js-bucket-list").sortable({
    connectWith: ".js-bucket-list"
    over: (event, ui) ->
      $(".bucket-list").removeClass("highlight")
      $(event.target).addClass("highlight")
    stop: (event, ui) ->
      $(".bucket-list").removeClass("highlight")
    update: (event, ui) ->
      if this == ui.item.parent()[0]
        window.target = $(event.target)
        bucket_id = target.data("bucket-id")
        position  = ui.item.index()

        $.ajax
          type: "PATCH"
          url: ui.item.data("move-to-bucket-path")
          dataType: "json"
          data: { prioritized_issue: { bucket_id: bucket_id, row_order_position: position } }
  }).disableSelection()

makeBucketsSortable = ->
  $(".js-write-access .js-buckets").sortable({
    handle: $(".js-bucket-handle")
    update: (event, ui) ->
      window.target = $(event.target)
      position  = ui.item.index()

      $.ajax
        type: "PATCH"
        url: ui.item.data("bucket-path")
        dataType: "json"
        data: { bucket: { row_order_position: position } }
  }).disableSelection()

makeIssuesAssignable = ->
  $(document).on "click", ".js-write-access .js-issue-assignee-link", (e) ->
    e.preventDefault()
    link = $(this)
    issue = $(this).parents(".issue")
    issue.toggleClass("assigning")

  $(document).on "change", ".js-write-access .js-issue-assignee-select", (e) ->
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
    .fail (data) ->
      issue.toggleClass("assigning")


makeIssuesStateable = ->
  $(document).on "change", ".js-write-access .js-issue-state-toggle", (e) ->
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

syncIssues = ->
  $(".js-issue").each (i, element) ->
    issue = $(element)
    syncIssue(issue)

syncIssue = (issue) ->
  request = $.ajax
    url: issue.data("issue-sync-path")
    type: "POST"
    success: (html) ->
      issue.replaceWith(html) if html.length > 0
      issue.data("synced-at", new Date())

makeIssuesSyncOnMouseEnter = ->
  $(document).on "mouseenter", ".js-issue", (e) ->
    issue = $(this)
    synced_at = issue.data("synced-at")

    if synced_at && new Date - synced_at > 20000
      syncIssue(issue)

makeIssuesSyncOnInterval = ->
  # sync issues on load
  syncIssues()
  # sync issues every 1 minute
  setInterval(syncIssues, 60000)

makeIssuesArchivable = ->
  $(document).on "click", ".js-write-access .js-issues-archive", (e) ->
    e.preventDefault()
    button = $(this)
    request = $.ajax
      url: button.attr "href"
      type: "POST"
      success: (html) ->
        $("[name=prioritized_issue\\[state\\]]:checked").closest(".issue").hide()

subscribeToTeamUpdates = ->
  pusher_config     = $("#pusher_config")
  window.channels ||= {}

  if pusher_config.length > 0
    channel_name = pusher_config.data().pusherChannel

    if !window.channels[channel_name]
      window.channels[channel_name] = pusher.subscribe(channel_name)
    else
      window.channels[channel_name].unbind()

    window.channels[channel_name].bind "update", (data) ->
      refreshTeamWhenUpdated(data)

refreshTeamWhenUpdated = (data) ->
  pusher_config  = $("#pusher_config")

  if pusher_config.length > 0
    if data.user_id != pusher_config.data().userId
      if data.team_id == "#{pusher_config.data().teamId}"
        Turbolinks.visit(window.location.href)

$ ->
  makeIssuesSortable()
  makeIssuesAssignable()
  makeIssuesStateable()
  focusIssueImportOnCommand()
  makeBucketsSortable()
  makeIssuesSyncOnInterval()
  makeIssuesSyncOnMouseEnter()
  makeIssuesArchivable()
  subscribeToTeamUpdates()

$(document).on "page:load", ->
  makeIssuesSortable()
  makeBucketsSortable()
  subscribeToTeamUpdates()
