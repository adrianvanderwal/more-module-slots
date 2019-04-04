local more_module_slots_defines = require('defines')

local can_have_modules = {
    'assembling-machine',
    'furnace',
    'mining-drill',
    'rocket-silo',
    'beacon'
}

for _, j in pairs(can_have_modules) do
    for _, k in pairs(data.raw[j]) do
        log(k.name)
        -- check if has module slots
        if k.module_specification then
            -- has module slots, add more
            local num_slots = k.module_specification.module_slots
            local factor = settings.startup[more_module_slots_defines.names.settings.factor].value
            if settings.startup[more_module_slots_defines.names.settings.multiplicative_module_slots].value then
                num_slots = num_slots * factor
            else
                num_slots = num_slots + factor
            end
            data.raw[j][k.name].module_specification.module_slots = num_slots
        else
            -- does not have module slots, check to add
            if settings.startup[more_module_slots_defines.names.settings.add_to_nonmoduled_entities].value then
                local num_slots = settings.startup[more_module_slots_defines.names.settings.factor].value

                local raw = table.deepcopy(data.raw[j][k.name])
                raw.module_specification = {
                    module_slots = num_slots
                }
                raw.allowed_effects = {
                    'consumption',
                    'speed',
                    'productivity',
                    'pollution'
                }
                data:extend(
                    {
                        raw
                    }
                )
            end
        end
    end
end
