function format.interval_text(value, options)

  local options = options or {}

  -- strip microseconds
  local value = value:gsub("%..*", "")

  -- modes with date and time, not only date
  if options.mode == "time_left" or options.mode == "ago" then

    if value:find("days", 1, true) or value:find("year", 1, true) then
      -- strip time
      value = value:gsub("%s*%d%d:%d%d:%d%d$", "")
    else

      local function hours(value)
        if value == 1 then
          return "1 hour"
        else
          return value .. " hours"
        end
      end

      local function minutes(value)
        if value == 1 then
          return "1 minute"
        else
          return value .. " minutes"
        end
      end

      -- time as hours and minutes
      value = value:gsub("(%d%d):(%d%d):%d%d$", function(h, m)
        h = tonumber(h)
        m = tonumber(m)
        if value:find("day", 1, true) or h >= 6 then
          return hours(h)
        elseif h >= 1 then
          return hours(h) .. " " .. minutes(m)
        else
          return minutes(m)
        end
      end)

    end

  end

  if options.mode == "time_left" then
    value = value
      :gsub("minutes", _"minutes [interval time left]")
      :gsub("minute", _"minute [interval time left]")
      :gsub("hours", _"hours [interval time left]")
      :gsub("hour", _"hour [interval time left]")
      :gsub("days", _"days [interval time left]")
      :gsub("day", _"day [interval time left]")
      :gsub("mons", _"months [interval time left]")
      :gsub("mon", _"month [interval time left]")
      :gsub("years", _"years [interval time left]")
      :gsub("year", _"year [interval time left]")
    return _("#{interval_text} left", { interval_text = value })

  elseif options.mode == "ago" then
    value = value
      :gsub("minutes", _"minutes [interval time ago]")
      :gsub("minute", _"minute [interval time ago]")
      :gsub("hours", _"hours [interval time ago]")
      :gsub("hour", _"hour [interval time ago]")
      :gsub("days", _"days [interval ago]")
      :gsub("day", _"day [interval ago]")
      :gsub("mons", _"months [interval ago]")
      :gsub("mon", _"month [interval ago]")
      :gsub("years", _"years [interval ago]")
      :gsub("year", _"year [interval ago]")
    return _("#{interval_text} ago", { interval_text = value })

  elseif options.mode == "expires" then
    if value == "00:00:00" then
      value = _"less than one day [interval expires]"
    else
      value = value
        :gsub("days", _"days [interval expires]")
        :gsub("day", _"day [interval expires]")
        :gsub("mons", _"months [interval expires]")
        :gsub("mon", _"month [interval expires]")
        :gsub("years", _"years [interval expires]")
        :gsub("year", _"year [interval expires]")
    end
    if     options.variant == "warning_one" then
      return _("One of your outgoing delegations expires in #{interval_text}.", { interval_text = value })
    elseif options.variant == "warning_multiple" then
      return _("#{count} of your outgoing delegations expire soon, the first in #{interval_text}.", { count = options.count, interval_text = value })
    else
      return _("expires in #{interval_text}", { interval_text = value })
    end

  elseif options.mode == "expired" then
    if value == "00:00:00" then
      return _("expired today")
    end
    value = value
      :gsub("days", _"days [interval expired]")
      :gsub("day", _"day [interval expired]")
      :gsub("mons", _"months [interval expired]")
      :gsub("mon", _"month [interval expired]")
      :gsub("years", _"years [interval expired]")
      :gsub("year", _"year [interval expired]")
    return _("expired #{interval_text} ago", { interval_text = value })

  else
    value = value:gsub(":00$", "") -- strip seconds if zero
      :gsub("days", _"days [interval]")
      :gsub("day", _"day [interval]")
      :gsub("mons", _"months [interval]")
      :gsub("mon", _"month [interval]")
      :gsub("years", _"years [interval]")
      :gsub("year", _"year [interval]")
    return _("#{interval_text} [interval]", { interval_text = value })

  end
end
