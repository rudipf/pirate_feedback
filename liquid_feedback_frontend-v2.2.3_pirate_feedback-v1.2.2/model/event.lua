Event = mondelefant.new_class()
Event.table = 'event'

Event:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Draft",
  this_key      = 'draft_id',
  that_key      = 'id',
  ref           = 'draft',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Suggestion",
  this_key      = 'suggestion_id',
  that_key      = 'id',
  ref           = 'suggestion',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Argument",
  this_key      = 'argument_id',
  that_key      = 'id',
  ref           = 'argument',
}

Event:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function Event.object_get:event_name()
  return ({
    issue_state_changed = _"Issue reached next phase",
    initiative_created_in_new_issue = _"New issue",
    initiative_created_in_existing_issue = _"New initiative",
    initiative_revoked = _"Initiative revoked",
    new_draft_created = _"New initiative draft",
    suggestion_created = _"New suggestion",
    argument_created = _"New argument"
  })[self.event]
end

function Event.object_get:state_name()
  return Issue:get_state_name_for_state(self.state)
end

function Event.object:send_notification()

  local members_to_notify = Member:new_selector()
    :join("event_seen_by_member", nil, { "event_seen_by_member.seen_by_member_id = member.id AND event_seen_by_member.id = ?", self.id } )
    :add_where("member.activated NOTNULL AND member.notify_email NOTNULL AND member.locked = FALSE AND member.locked_import = FALSE")
    -- SAFETY FIRST, NEVER send notifications for events more then 3 days in past or future
    :add_where("now() - event_seen_by_member.occurrence BETWEEN '-3 days'::interval AND '3 days'::interval")
    -- do not notify a member about the events caused by the member
    :add_where("event_seen_by_member.member_id ISNULL OR event_seen_by_member.member_id != member.id")
    :exec()

  print ( "Event " .. self.id .. " -> " .. #members_to_notify .. " members" )

  -- generate mail content only once for each language
  local body_cache    = {}
  local subject_cache = {}

  for i, member in ipairs(members_to_notify) do

    local lang = member.lang or config.default_lang or 'en'
    locale.do_with(
      { lang = lang },
      function()

        if not body_cache[lang] or not subject_cache[lang] then

          -- initiative(s)
          local body_initiative = ""
          local initiative
          local draft
          local url_initiative_id = self.initiative_id
          if self.initiative_id then
            -- initiative
            initiative = Initiative:by_id(self.initiative_id)
            -- draft
            if self.draft_id then
              draft = Draft:by_id(self.draft_id)
              body_initiative = body_initiative .. _("i#{id}: #{name}", { id = initiative.id, name = draft.name }) .. "\n\n"
                .. draft.content .. "\n"
            else
              body_initiative = body_initiative .. _("i#{id}: #{name}", { id = initiative.id, name = initiative.name }) .. "\n\n"
            end
          else
            -- initiatives of an issue
            local issue = Issue:by_id(self.issue_id)
            local initiatives = Initiative:new_selector()
              :add_where{ "initiative.issue_id = ?", self.issue_id }
              :add_order_by("initiative.rank, initiative.supporter_count DESC, initiative.satisfied_supporter_count DESC, id")
              :exec()
            local ini_count = 0
            for i, initiative in ipairs(initiatives) do
              ini_count = ini_count + 1
              if ini_count <= 20 then
                -- link to the first initiative
                if ini_count == 1 then
                  url_initiative_id = initiative.id
                end
                if issue.ranks_available then
                  if initiative.eligible then
                    body_initiative = body_initiative .. "*"
                  else
                    body_initiative = body_initiative .. "x"
                  end
                  if initiative.rank then
                    body_initiative = body_initiative .. initiative.rank
                  else
                    body_initiative = body_initiative .. " "
                  end
                  body_initiative = body_initiative .. " "
                end
                body_initiative = body_initiative .. _("i#{id}: #{name}", { id = initiative.id, name = initiative.name }) .. "\n"
              end
            end
            if ini_count > 20 then
              body_initiative = body_initiative .. _("and #{count} more initiatives", { count = ini_count - 20 }) .. "\n"
            end
            body_initiative = body_initiative .. "\n"
          end

          -- url
          local body = request.get_absolute_baseurl()
          if self.suggestion_id then
            body = body .. "suggestion/show/" .. self.suggestion_id .. ".html\n\n"
          elseif self.argument_id then
            body = body .. "argument/show/"   .. self.argument_id   .. ".html\n\n"
          elseif url_initiative_id then
            body = body .. "initiative/show/" .. url_initiative_id  .. ".html\n\n"
          else
            body = body .. "issue/show/"      .. self.issue_id      .. ".html\n\n"
          end

          -- head
          body = body
            .. _("[event mail]      Unit: #{name}", { name = self.issue.area.unit.name }) .. "\n"
            .. _("[event mail]      Area: #{name}", { name = self.issue.area.name }) .. "\n"
            .. _("[event mail]     Issue: #{policy} ##{id}", { policy = self.issue.policy.name, id = self.issue_id }) .. "\n\n"
            .. _("[event mail]     Event: #{event}", { event = self.event_name }) .. "\n"
            .. _("[event mail]     Phase: #{phase}", { phase = self.state_name }) .. "\n\n"

          -- initiative(s)
            .. body_initiative

          -- suggestion
          local suggestion
          if self.suggestion_id then
            suggestion = Suggestion:by_id(self.suggestion_id)
            body = body
              .. _("Suggestion") .. ": " .. suggestion.name .. "\n\n"
              .. suggestion.content .. "\n"
          end

          -- argument
          local argument
          if self.argument_id then
            argument = Argument:by_id(self.argument_id)
            body = body
              .. (argument.side == "pro" and _("Argument pro") or _("Argument contra")) .. ": " .. argument.name .. "\n\n"
              .. argument.content .. "\n"
          end

          -- subject
          local subject = config.mail_subject_prefix .. " "
          if self.event == "issue_state_changed" then
            if     self.state == "discussion" then
              subject = subject .. _("Issue ##{id} reached discussion", { id = self.issue_id })
            elseif self.state == "verification" then
              subject = subject .. _("Issue ##{id} was frozen", { id = self.issue_id })
            elseif self.state == "voting" then
              subject = subject .. _("Voting for issue ##{id} started", { id = self.issue_id })
            elseif self.state == "canceled_revoked_before_accepted" then
              subject = subject .. _("Issue ##{id} was canceled due to revocation", { id = self.issue_id })
            elseif self.state == "canceled_issue_not_accepted" then
              subject = subject .. _("Issue ##{id} was not accepted", { id = self.issue_id })
            elseif self.state == "canceled_after_revocation_during_discussion" then
              subject = subject .. _("Issue ##{id} was canceled due to revocation", { id = self.issue_id })
            elseif self.state == "canceled_after_revocation_during_verification" then
              subject = subject .. _("Issue ##{id} was canceled due to revocation", { id = self.issue_id })
            elseif self.state == "canceled_no_initiative_admitted" then
              subject = subject .. _("Issue ##{id} was canceled because no initiative was admitted", { id = self.issue_id })
            elseif self.state == "finished_without_winner" then
              subject = subject .. _("Issue ##{id} was finished (without winner)", { id = self.issue_id })
            elseif self.state == "finished_with_winner" then
              subject = subject .. _("Issue ##{id} was finished (with winner)", { id = self.issue_id })
            end
          elseif self.event == "initiative_created_in_new_issue" then
            subject = subject .. _("New issue ##{id} and initiative - i#{ini_id}: #{ini_name}", { id = self.issue_id, ini_id = initiative.id, ini_name = initiative.name })
          elseif self.event == "initiative_created_in_existing_issue" then
            subject = subject .. _("New initiative in issue ##{id} - i#{ini_id}: #{ini_name}", { id = self.issue_id, ini_id = initiative.id, ini_name = initiative.name })
          elseif self.event == "initiative_revoked" then
            subject = subject .. _("Initiative revoked - i#{id}: #{name}", { id = initiative.id, name = initiative.name })
          elseif self.event == "new_draft_created" then
            subject = subject .. _("New draft for initiative i#{id} - #{name}", { id = initiative.id, name = draft.name })
          elseif self.event == "suggestion_created" then
            subject = subject .. _("New suggestion for initiative i#{id} - #{suggestion}", { id = initiative.id, suggestion = suggestion.name })
          elseif self.event == "argument_created" then
            subject = subject .. _("New argument for initiative i#{id} - #{argument}", { id = initiative.id, argument = argument.name })
          end

          body_cache[lang]    = body
          subject_cache[lang] = subject

        end

        -- send mail
        local success = net.send_mail{
          envelope_from = config.mail_envelope_from,
          from          = config.mail_from,
          reply_to      = config.mail_reply_to,
          to            = member.notify_email,
          subject       = subject_cache[lang],
          content_type  = "text/plain; charset=UTF-8",
          content       = body_cache[lang]
        }

      end
    )
  end

end

function Event:send_next_notification()

  local notification_sent = NotificationSent:new_selector()
    :optional_object_mode()
    :for_update()
    :exec()

  local last_event_id = 0
  if notification_sent then
    last_event_id = notification_sent.event_id
  end

  local event = Event:new_selector()
    :add_where{ "event.id > ?", last_event_id }
    :add_order_by("event.id")
    :limit(1)
    :optional_object_mode()
    :exec()

  if event then
    if last_event_id == 0 then
      db:query{ "INSERT INTO notification_sent (event_id) VALUES (?)", event.id }
    else
      db:query{ "UPDATE notification_sent SET event_id = ?", event.id }
    end

    event:send_notification()

    return true

  end

end

function Event:send_notifications()

  while true do
    local did_work = Event:send_next_notification()
    if not did_work then
      break
    end
  end

end