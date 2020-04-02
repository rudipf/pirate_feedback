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

slot.put_into("default", [[		<script>
		function checkInput1(startdatum) {
			var textInput = document.getElementById(startdatum).value;	
			document.links.surveylink.href+="&startdate="+textInput
			}
		</script>
		<label for="startdatum">Startdatum: <input type="date" id="startdatum" name="startdatum" onchange="checkInput1('startdatum');"></label></p> 
]])


slot.put_into("default", [[             <script>
                function checkInput(startini) {
                        var textInput = document.getElementById(startini).value;
                        document.links.surveylink.href+="&startini="+textInput
                        }
                </script>
                <label for="startini">Startini: <input type="integer" id="startini" name="startini" onchange="checkInput('startini');"></label></p>
]])

 
 ui.tag{tag="li", content =function()
   ui.link{
     text = _"Survey",
     module ="admin",
     view = "survey.xml",
     attr={name="surveylink"},
     params ={ 
         area= config.survey_area,
         policy=config.survey_policy,
         maxitems=config.survey_maxitems,
         winner=config.survey_winner
         }
      }
  end }
 

end }
