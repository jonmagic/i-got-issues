$(".js-bucket-list").sortable({
  connectWith: ".js-bucket-list"
  update: (event, ui) ->
    if this == ui.item.parent()[0]
      window.target    = $(event.target)
      bucket_id = target.data("bucket-id")
      position  = ui.item.index()

      console.log bucket_id, position

      $.ajax
        type: "POST"
        url: ui.item.data("prioritized-issue-path")
        dataType: "json"
        data: { prioritized_issue: { bucket_id: bucket_id, row_order_position: position } }
}).disableSelection();
