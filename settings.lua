local more_module_slots_defines = require('defines')
data:extend {
    {
        type = 'bool-setting',
        name = more_module_slots_defines.names.settings.multiplicative_module_slots,
        setting_type = 'startup',
        default_value = false,
        order = 'aa'
    },
    {
        type = 'double-setting',
        name = more_module_slots_defines.names.settings.factor,
        setting_type = 'startup',
        default_value = 2,
        minimum_value = 0,
        order = 'ab'
    },
    {
        type = 'bool-setting',
        name = more_module_slots_defines.names.settings.add_to_nonmoduled_entities,
        setting_type = 'startup',
        default_value = false,
        order = 'aa'
    }
}
