local area = Area:by_id(param.get_id())

if not area then
  slot.put_into("error", _"The requested area does not exist!")
  return
end

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

slot.select("head", function()
  execute.view{ module = "area", view = "_head", params = { area = area, show_content = true, member = app.session.member } }
end)

local stats =db:query("Select member_id, del from get_top_delegatees("..area.id..")","list")


for i,stat in ipairs(stats) do
-- slot.put_into("error", "x"..stat[1].."y"..stat[2]) 
local id=Member:by_id(stat[1])
ui.container{
execute.view{
 module = "member",
 view   = "_show_thumb",
 params = { member = id }
}
}
end

