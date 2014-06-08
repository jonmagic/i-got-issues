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
          url: ui.item.data("prioritized-issue-path")
          dataType: "json"
          data: { prioritized_issue: { bucket_id: bucket_id, row_order_position: position } }
  }).disableSelection()

makeIssuesExpandable = ->
  $(document).on "click", ".js-issue-toggle", (e) ->
    e.preventDefault()

    link = $(this)
    link.parents(".issue").toggleClass("collapsed")

$ ->
  makeBucketsSortable()
  makeIssuesExpandable()

$(document).on "page:load", ->
  makeBucketsSortable()
