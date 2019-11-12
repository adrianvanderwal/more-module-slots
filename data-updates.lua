local more_module_slots_defines = require('defines')

if settings.startup[more_module_slots_defines.names.settings.extra_modules].value then
    require('prototypes.modules')
end

-- blacklist deep mines as POC

if mods["DeepMine"] then mms.blacklist["deep-mine-beacon"] = true