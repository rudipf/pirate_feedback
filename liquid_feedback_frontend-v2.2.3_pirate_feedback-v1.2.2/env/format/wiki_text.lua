function format.wiki_text(wiki_text, formatting_engine)
  local formatting_engine = formatting_engine or "rocketwiki"
  wiki_text =string.gsub(wiki_text, "ä", "{ae}")
  wiki_text =string.gsub(wiki_text, "Ä", "{Ae}")
  wiki_text =string.gsub(wiki_text, "ü", "{ue}")
  wiki_text =string.gsub(wiki_text, "Ü", "{Ue}")
  wiki_text =string.gsub(wiki_text, "ö", "{oe}")
  wiki_text =string.gsub(wiki_text, "Ö", "{Oe}")
  wiki_text =string.gsub(wiki_text, "ß", "{ss}")
  wiki_text =string.gsub(wiki_text, "§", "Paragraph ")
  wiki_text =string.gsub(wiki_text, "„", [["]] )
  wiki_text =string.gsub(wiki_text, "“", [["]] )
  wiki_text =string.gsub(wiki_text, "–", "-" )
  wiki_text =string.gsub(wiki_text, "€", "{\Eur}" )
   

  
  local html, errmsg, exitcode = assert(
    extos.pfilter(wiki_text, config.formatting_engine_executeables[formatting_engine])
  )
  if exitcode > 0 then
    error("Wiki parser process returned with error code " .. tostring(exitcode) .. errmsg .. string.sub(wiki_text,1,10))
  elseif exitcode < 0 then
    error("Wiki parser process was terminated by signal " .. tostring(-exitcode))
  end
  return html
end
