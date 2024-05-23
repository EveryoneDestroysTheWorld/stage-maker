local ReplicatedStorage = game:GetService("ReplicatedStorage");
local React = require(ReplicatedStorage.Packages.ReactLua.React);

type BuildingToolsSelectorProps = {
  sections: {{
    name: string;
    buttons: {{
      iconImage: string;
      onClick: () -> ();
    }}
  }};
}

local function BuildingToolsSelector(props: BuildingToolsSelectorProps)
  
  local sections = {};
  for sectionName, sectionItems in pairs(props.sections) do
    
    local section = {};
    for _, sectionItem in ipairs(sectionItems) do
      
      table.insert(section, {
        iconImage = sectionItem.iconImage;
      });
      
    end
    sections[sectionName] = section;
    
  end
  
  return React.createElement("CanvasGroup", {
    Name = "Window";
    
  })
  
end

return BuildingToolsSelector;