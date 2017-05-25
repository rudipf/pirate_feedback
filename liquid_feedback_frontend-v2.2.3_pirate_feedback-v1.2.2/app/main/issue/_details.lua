local issue = param.get("issue", "table")

function bool2str(value)
  if value then
    return _("Yes")
  else
    return _("No")
  end
end

function dtdd(label, value, class)
  ui.tag{ tag = "dt", attr = { class = class or "" }, content = label }
  ui.tag{ tag = "dd", attr = { class = class or "" }, content = value }
end

local policy = issue.policy

ui.container{
  attr = { class = "initiative_head details_issue" },
  content = function()
    ui.container{ attr = { class = "title" }, content = _"Issue Details" }
    ui.container{ attr = { class = "content" }, content = function()

      ui.tag{
        tag = "dl",
        attr = { class = "details_left" },
        content = function()
          -- new
          dtdd( _"Created", format.timestamp(issue.created) )
          if policy.polling then
            dtdd( _"Admission time", _"Implicitly admitted", "duration" )
          else
            dtdd( _"Admission time", format.interval_text(issue.admission_time_text), "duration" )
            if policy.issue_quorum_num then
              dtdd( _"Issue quorum", format.percentage(policy.issue_quorum_num / policy.issue_quorum_den), "quorum" )
              if issue.population then
                dtdd( _"Currently required", math.ceil(issue.population * policy.issue_quorum_num / policy.issue_quorum_den) .. " (" .. _"incl. potential" .. ")", "quorum" )
              end
            end
            if policy.issue_quorum_direct_num then
              dtdd( _"Issue direct quorum", format.percentage(policy.issue_quorum_direct_num / policy.issue_quorum_direct_den), "quorum" )
              if issue.population then
                dtdd( _"Currently required", math.ceil(issue.population * policy.issue_quorum_direct_num / policy.issue_quorum_direct_den) .. " (" .. _"incl. potential" .. ")", "quorum" )
              end
            end
          end
          -- discussion
          if issue.accepted then
            dtdd( _"Accepted", format.timestamp(issue.accepted) )
          end
          dtdd( _"Discussion time", format.interval_text(issue.discussion_time_text), "duration" )
          -- frozen
          if issue.half_frozen then
            dtdd( _"Half frozen", format.timestamp(issue.half_frozen) )
          end
          dtdd( _"Verification time", format.interval_text(issue.verification_time_text), "duration" )
          dtdd( _"Initiative quorum", format.percentage(policy.initiative_quorum_num / policy.initiative_quorum_den), "quorum" )
          if issue.population then
            dtdd( _"Currently required", math.ceil(issue.population * (issue.policy.initiative_quorum_num / issue.policy.initiative_quorum_den)) .. " (" .. _"not incl. potential" .. ")", "quorum" )
          end
          -- voting
          if issue.fully_frozen then
            dtdd( _"Fully frozen", format.timestamp(issue.fully_frozen) )
          end
          dtdd( _"Voting time", format.interval_text(issue.voting_time_text), "duration" )
          -- closed
          if issue.closed then
            dtdd( _"Closed", format.timestamp(issue.closed) )
          end
        end
      }

      ui.tag{
        tag = "dl",
        attr = { class = "details_right" },
        content = function()
          if not issue.delegation then
            dtdd( _"Delegation", _"off" )
          end
          dtdd( _"Population", issue.population )
          dtdd( _"State", issue.state_name )
          if issue.snapshot then
            dtdd( _"Last snapshot", format.timestamp(issue.snapshot) )
          end
        end

      }

      slot.put('<div class="clearfix"></div>')

    end }

  end
}
