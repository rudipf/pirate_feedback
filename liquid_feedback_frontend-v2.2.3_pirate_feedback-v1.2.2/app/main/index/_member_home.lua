local member = param.get("member", "table")
local for_member = param.get("for_member", atom.boolean)
local filter_unit = param.get_all_cgi()["filter_unit"] or "my_areas"

-- filter
if not for_member then
  ui.container{ attr = { class = "ui_filter" }, content = function()
    ui.container{ attr = { class = "ui_filter_head" }, content = function()
      ui.link{
        attr = { class = filter_unit == "global" and "active" or nil },
        text = _"All units",
        module = "index", view = "index", params = { filter_unit = "global" }
      }
      slot.put(" ")
      ui.link{
        attr = { class = filter_unit == "my_units" and "ui_tabs_link active" or nil },
        text = _"All areas in my units",
        module = "index", view = "index", params = { filter_unit = "my_units" }
      }
      slot.put(" ")
      ui.link{
        attr = { class = filter_unit == "my_areas" and "ui_tabs_link active" or nil },
        text = _"My areas",
        module = "index", view = "index", params = { filter_unit = "my_areas" }
      }
    end }
  end }
end

-- display units only
if not for_member then
  if filter_unit == "global" then
    execute.view{ module = "unit", view = "_list" }
    return
  end
end

-- display units and areas

local units = Unit:new_selector():add_where("active"):add_order_by("name"):exec()

if member then
  units:load_delegation_info_once_for_member_id(member.id)
end

for i, unit in ipairs(units) do
  if member:has_voting_right_for_unit_id(unit.id) then

    local areas_selector = Area:new_selector()
      :reset_fields()
      :add_field("area.id", nil, { "grouped" })
      :add_field("area.unit_id", nil, { "grouped" })
      :add_field("area.name", nil, { "grouped" })
      :add_field("area.delegation", nil, { "grouped" })
      :add_field("direct_member_count", nil, { "grouped" })
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.accepted ISNULL AND issue.closed ISNULL)", "issues_new_count")
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.accepted NOTNULL AND issue.half_frozen ISNULL AND issue.closed ISNULL)", "issues_discussion_count")
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.half_frozen NOTNULL AND issue.fully_frozen ISNULL AND issue.closed ISNULL)", "issues_frozen_count")
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed ISNULL)", "issues_voting_count")
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed NOTNULL)", "issues_finished_count")
      :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen ISNULL AND issue.closed NOTNULL)", "issues_canceled_count")
      :add_field({ "(SELECT COUNT(*) FROM issue LEFT JOIN direct_voter ON direct_voter.issue_id = issue.id AND direct_voter.member_id = ? WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed ISNULL AND direct_voter.member_id ISNULL)", app.session.member.id }, "issues_to_vote_count")
      :add_where{ "area.unit_id = ?", unit.id }
      :add_where{ "area.active" }
      :add_order_by("area.direct_member_count DESC")
      :add_order_by("area.name")

    if filter_unit == "my_areas" then
      areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
    else
      areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
    end

    local area_count = areas_selector:count()

    local max_area_count = Area:new_selector()
      :add_where{ "area.unit_id = ?", unit.id }
      :add_where{ "area.active" }
      :count()
    local more_area_count = max_area_count - area_count
    local delegated_count = Area:new_selector()
      :reset_fields()
      :add_field("area.id", nil, { "grouped" })
      :add_where{ "area.unit_id = ?", unit.id }
      :add_where{ "area.active" }
      :left_join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id } )
      :add_where{ "membership.member_id ISNULL" }
      :join("delegation", nil, { "delegation.area_id = area.id AND delegation.truster_id = ?", member.id } )
      :add_where{ "delegation.trustee_id NOTNULL" }
      :count()

    ui.container{ attr = { class = "area_list" }, content = function()

      execute.view{ module = "unit", view = "_head", params = { unit = unit, show_content = true, member = member } }

      local areas = areas_selector:exec()
      areas:load_delegation_info_once_for_member_id(member.id)
      for i, area in ipairs(areas) do
        execute.view{
          module = "area",
          view = "_head",
          params = {
            area = area,
            member = member,
            hide_unit = true,
            show_content = true,
            for_listing = true
          }
        }
      end

    end }

    ui.container{ attr = { class = "area", style="margin-top: 1ex; margin-left: 10px;" }, content = function()
      ui.container{ attr = { class = "title" }, content = function()

        local more_area_text
        if area_count > 0 then
          if more_area_count > 0 then
            if more_area_count == 1 then
              more_area_text = _("One more area in this unit")
            else
              more_area_text = _("#{count} more areas in this unit", { count = more_area_count })
            end
          end
        else
          if more_area_count > 0 then
            if more_area_count == 1 then
              if app.session.member_id == member.id then
                more_area_text = _("You are not participating in the only area of the unit.")
              else
                more_area_text = _("Member is not participating in the only area of the unit.")
              end
            else
              if app.session.member_id == member.id then
                more_area_text = _("You are not participating in any of the #{count} areas in this unit.", { count = more_area_count })
              else
                more_area_text = _("Member is not participating in any of the #{count} areas in this unit.", { count = more_area_count })
              end
            end
          end
        end
      
        if more_area_text then
          ui.link{ module = "unit", view = "show", id = unit.id, text = more_area_text }
          if delegated_count > 0 then
            local delegated_text
            if delegated_count == 1 then
              delegated_text = _("One of them has an area delegation set.", { count = delegated_count })
            else
              delegated_text = _("#{count} of them have an area delegation set.", { count = delegated_count })
            end
            slot.put(" &middot; ")
            ui.tag{ content = delegated_text }
          end
        end

      end }
    end }

  end
end


