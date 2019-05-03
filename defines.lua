-- Here are the values that are shared across different files.
local more_module_slots_defines = {}

-- Mod ID.
more_module_slots_defines.mod_id = 'more-module-slots'
-- Prefix of the names.
more_module_slots_defines.name_prefix = more_module_slots_defines.mod_id .. '_'

-- Names.
more_module_slots_defines.names = {}
-- Setting names.
more_module_slots_defines.names.settings = {
    multiplicative_module_slots = more_module_slots_defines.name_prefix .. 'multiplicative-module-slots',
    factor = more_module_slots_defines.name_prefix .. 'factor',
    add_to_nonmoduled_entities = more_module_slots_defines.name_prefix .. 'add-to-nonmoduled-entities',
    assembling_machine = more_module_slots_defines.name_prefix .. 'assembling-machine',
    furnace = more_module_slots_defines.name_prefix .. 'furnace',
    mining_drill = more_module_slots_defines.name_prefix .. 'mining-drill',
    rocket_silo = more_module_slots_defines.name_prefix .. 'rocket-silo',
    beacon = more_module_slots_defines.name_prefix .. 'beacon',
    lab = more_module_slots_defines.name_prefix .. 'lab'
}

return more_module_slots_defines
