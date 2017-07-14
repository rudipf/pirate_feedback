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

if config.display_area_stats then 

local stats =db:query("Select member_id, del from get_top_delegatees("..area.id..")","list")

ui.heading{tag=4, content="Top Delegierte"}
ui.container{  
class="member_list",
content=function()


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

end}

slot.put('<br style="clear:both;"><br>')
end

if config.display_similar_voters then

ui.heading{ tag=4, content="Mitglieder, die wie ich abgestimmt haben"}

local dele=db:query("select delegate from get_delegation_recommendation ("..app.session.member_id..","..area.id..")" )

for i,del in ipairs(dele) do

local id =Member:by_id(del[1])
ui.container{
execute.view{
 module = "member",
 view   = "_show_thumb",
 params = { member = id }
}
}
end

end

