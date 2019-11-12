local more_module_slots_defines = require('defines')

if settings.startup[more_module_slots_defines.names.settings.extra_modules].value then
    require('prototypes.modules')
end