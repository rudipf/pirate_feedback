ui.title(_"Admin menu")

ui.tag{ tag = "ul", attr = { class = "menu_list" }, content = function()
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Policies",
      module = "admin",
      view = "policy_list",
    }
  end }
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Units",
      module = "admin",
      view = "unit_list",
    }
  end }
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Members",
      module = "admin",
      view = "member_list",
    }
  end }
 ui.tag{tag="li", content =function()
   ui.link{
     text = _"Survey",
     module ="admin",
     view = "survey.xml",
     params ={ 
         area= config.survey_area,
         policy=config.survey_policy,
         winner=config.survey_winner
         }
      }
  end }
 

end }
