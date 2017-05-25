local initiative = Initiative:by_id(param.get_id())

ui.title(_"Change discussion URL", initiative.issue.area.unit, initiative.issue.area, initiative.issue, initiative)

ui.actions(function()
  ui.link{
    content = function()
      ui.image{ static = "icons/16/cancel.png" }
      slot.put(_"Cancel")
    end,
    module = "initiative",
    view = "show",
    id = initiative.id
  }
end)

ui.form{
  record = initiative,
  module = "initiative",
  action = "update",
  id = initiative.id,
  attr = { class = "vertical" },
  routing = {
    default = {
      mode = "redirect",
      module = "initiative",
      view = "show",
      id = initiative.id
    }
  },
  content = function()
    ui.field.text{ label = _"Discussion URL",  name = "discussion_url" }
    ui.submit{ text = _"Save" }
  end
}