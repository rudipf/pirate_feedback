local search               = param.get("search")
local search_imported      = param.get("search_imported",      atom.integer)
local search_admin         = param.get("search_admin",         atom.integer)
local search_activated     = param.get("search_activated",     atom.integer)
local search_locked        = param.get("search_locked",        atom.integer)
local search_locked_import = param.get("search_locked_import", atom.integer)
local search_active        = param.get("search_active",        atom.integer)

local order = param.get("order")
local desc  = param.get("desc", atom.integer)
if not order then
  order = "id"
end

ui.title(_"Member list")

ui.actions(function()

  ui.link{
    text = _"Admin menu",
    module = "admin",
    view = "index"
  }
  slot.put(" &middot; ")

  ui.link{
    text = _"Register new member",
    module = "admin",
    view = "member_edit",
    params = {
      search               = search,
      search_imported      = search_imported,
      search_admin         = search_admin,
      search_activated     = search_activated,
      search_locked        = search_locked,
      search_locked_import = search_locked_import,
      search_active        = search_active,
      order                = order,
      desc                 = desc,
      page                 = param.get("page", atom.integer)
    }
  }

end)

ui.form{
  module = "admin",
  view = "member_list",
  -- Form method should be GET, but WebMCP adds some unwanted parameters, so we use POST.
  attr = { class = "member_list_form" },
  content = function()

    ui.field.text{
      label = _"Search:",
      name = "search",
      value = search
    }

    ui.field.select{
      name = "search_imported",
      foreign_records  = {
        {id = 0, name = "---" .. _"Imported" .. "?---"},
        {id = 1, name = _"Imported"},
        {id = 2, name = _"Not imported"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_imported
    }

    ui.field.select{
      name = "search_admin",
      foreign_records  = {
        {id = 0, name = "---" .. _"Admin" .. "?---"},
        {id = 1, name = _"Admin"},
        {id = 2, name = _"Not admin"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_admin
    }

    ui.field.select{
      name = "search_activated",
      foreign_records  = {
        {id = 0, name = "---" .. _"Activated" .. "?---"},
        {id = 1, name = _"Activated"},
        {id = 2, name = _"Not activated"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_activated
    }

    ui.field.select{
      name = "search_locked",
      foreign_records  = {
        {id = 0, name = "---" .. _"Locked" .. "?---"},
        {id = 1, name = _"Locked"},
        {id = 2, name = _"Not locked"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_locked
    }

    ui.field.select{
      name = "search_locked_import",
      foreign_records  = {
        {id = 0, name = "---" .. _"Locked by import" .. "?---"},
        {id = 1, name = _"Locked by import"},
        {id = 2, name = _"Not locked by import"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_locked_import
    }

    ui.field.select{
      name = "search_active",
      foreign_records  = {
        {id = 0, name = "---" .. _"Active" .. "?---"},
        {id = 1, name = _"Active"},
        {id = 2, name = _"Not active"}
      },
      foreign_id = "id",
      foreign_name = "name",
      selected_record  = search_active
    }

    ui.submit{ value = _"Search / Filter" }

    ui.field.hidden{ name = "order", value = order }
    ui.field.hidden{ name = "desc",  value = desc }

  end
}

local members_selector = Member:build_selector{
  admin_search               = search,
  admin_search_imported      = search_imported,
  admin_search_admin         = search_admin,
  admin_search_activated     = search_activated,
  admin_search_locked        = search_locked,
  admin_search_locked_import = search_locked_import,
  admin_search_active        = search_active
}
if desc then
  members_selector:add_order_by(order .. " DESC")
else
  members_selector:add_order_by(order)
end

ui.tag{
  tag = "p",
  content = _("#{count} members found:", { count = members_selector:count() })
}

local params_tpl = {
  search               = search,
  search_imported      = search_imported,
  search_admin         = search_admin,
  search_activated     = search_activated,
  search_locked        = search_locked,
  search_locked_import = search_locked_import,
  search_active        = search_active
}

ui.paginate{
  selector = members_selector,
  per_page = 30,
  content = function()
    ui.list{
      style = "table",
      records = members_selector:exec(),
      attr = { class = "member_list" },
      columns = {
        {
          field_attr = { style = "text-align: right;" },
          name = "id",
          label = function()
            local params = params_tpl
            params['order'] = "id"
            if not desc then
              params['desc'] = 1
            end
            ui.link{
              text = _"Id",
              module = "admin",
              view = "member_list",
              params = params
            }
            if order == "id" then
              if desc then
                slot.put("&uarr;")
              else
                slot.put("&darr;")
              end
            end
          end
        },
        {
          name = "identification",
          label = function()
            local params = params_tpl
            params['order'] = "identification"
            if not desc then
              params['desc'] = 1
            end
            ui.link{
              text = _"Identification",
              module = "admin",
              view = "member_list",
              params = params
            }
            if order == "identification" then
              if desc then
                slot.put("&uarr;")
              else
                slot.put("&darr;")
              end
            end
          end
        },
        {
          label = function()
            local params = params_tpl
            params['order'] = "name"
            if not desc then
              params['desc'] = 1
            end
            ui.link{
              text = _"Screen name",
              module = "admin",
              view = "member_list",
              params = params
            }
            if order == "name" then
              if desc then
                slot.put("&uarr;")
              else
                slot.put("&darr;")
              end
            end
          end,
          content = function(record)
            if (record.name) then
              ui.link{
                text = record.name,
                module = "member",
                view = "show",
                id = record.id
              }
            end
          end
        },
        {
          content = function(record)
            if record.admin then
              ui.field.text{ value = _"Admin" }
            end
          end
        },
        {
          content = function(record)
            if record.locked then
              ui.field.text{ value = _"Locked" }
            end
          end
        },
        {
          content = function(record)
            if record.locked_import then
              ui.field.text{ value = _"Locked by import" }
            end
          end
        },
        {
          content = function(record)
            if not record.activated then
              ui.field.text{ value = _"Not activated" }
            elseif not record.active then
              ui.field.text{ value = _"Inactive" }
            else
              ui.field.text{ value = _"Active" }
            end
          end
        },
        {
          content = function(record)
            ui.link{
              attr = { class = "action" },
              text = _"Edit",
              module = "admin",
              view = "member_edit",
              id = record.id,
              params = {
                search               = search,
                search_imported      = search_imported,
                search_admin         = search_admin,
                search_activated     = search_activated,
                search_locked        = search_locked,
                search_locked_import = search_locked_import,
                search_active        = search_active,
                order                = order,
                desc                 = desc,
                page                 = param.get("page", atom.integer)
              }
            }
          end
        },
        {
         content =function(record)
          ui.link{
             text=_"Data Sheet",
             module="admin",
             view="data_sheet.xml",
             id=record.id
           }
          end
        }

      }
    }
  end
}
