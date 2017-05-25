local draft = Draft:new_selector():add_where{ "id = ?", param.get_id() }:single_object_mode():exec()
local source = param.get("source", atom.boolean)

execute.view{
  module = "draft",
  view = "_head",
  params = {
    draft = draft,
    title = _("Draft created at #{date} #{time}", {
      date = format.date(draft.created),
      time = format.time(draft.created, { hide_seconds = true })
    })
  }
}

ui.actions(function()
  if source then
    ui.link{
      content = _"Rendered",
      module = "draft",
      view = "show",
      id = param.get_id(),
      params = { source = false }
    }
  else
    ui.link{
      content = _"Source",
      module = "draft",
      view = "show",
      id = param.get_id(),
      params = { source = true }
    }
  end
end)

execute.view{
  module = "draft",
  view = "_show",
  params = { draft = draft, source = source }
}
