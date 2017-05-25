local draft = param.get("draft", "table")
local source = param.get("source", atom.boolean)

if source then

  ui.tag{
    tag = "div",
    attr = { class = "diff" },
    content = function()
      local output = encode.html(draft.name)
      output = output:gsub("\n", "\n<br />")
      slot.put(output)
    end
  }

  ui.tag{
    tag = "div",
    attr = { class = "diff" },
    content = function()
      local output = encode.html(draft.content)
      output = output:gsub("\n", "\n<br />")
      slot.put(output)
    end
  }

else

  ui.container{ attr = { class = "initiative_head" }, content = function()

    ui.container{
      attr = { class = "title" },
      content = _("Initiative i#{id}: #{name}", { id = draft.initiative_id, name = draft.name })
    }

    ui.container{
      attr = { class = "draft_content wiki" },
      content = function()
        slot.put(draft:get_content("html"))
      end
    }

  end }

end

