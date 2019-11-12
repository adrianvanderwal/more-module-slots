local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local more_module_slots_defines = require('defines')

local can_have_modules = {
    ['assembling-machine'] = settings.startup[more_module_slots_defines.names.settings.assembling_machine].value,
    ['furnace'] = settings.startup[more_module_slots_defines.names.settings.furnace].value,
    ['mining-drill'] = settings.startup[more_module_slots_defines.names.settings.mining_drill].value,
    ['rocket-silo'] = settings.startup[more_module_slots_defines.names.settings.rocket_silo].value,
    ['beacon'] = settings.startup[more_module_slots_defines.names.settings.beacon].value,
    ['lab'] = settings.startup[more_module_slots_defines.names.settings.lab].value
}

local max_slots = 65535

for name, add_more_modules in pairs(can_have_modules) do
    if add_more_modules then
        for _, k in pairs(data.raw[name]) do
            if not starts_with(k.name, 'creative') then
                if k.allowed_effects then
                    log(k.name)

                    -- check if has module slots
                    if k.module_specification then
                        --log(serpent.block(k.module_specification))
                        -- has module slots, add more
                        local num_slots = k.module_specification.module_slots
                        local factor = settings.startup[more_module_slots_defines.names.settings.factor].value
                        if settings.startup[more_module_slots_defines.names.settings.multiplicative_module_slots].value then
                            num_slots = num_slots * factor
                        else
                            num_slots = num_slots + factor
                        end
                        if num_slots > max_slots then 
                            num_slots = max_slots 
                        end
                        data.raw[name][k.name].module_specification.module_slots = num_slots
                    else
                        -- does not have module slots, check to add
                        if settings.startup[more_module_slots_defines.names.settings.add_to_nonmoduled_entities].value then
                            local num_slots = settings.startup[more_module_slots_defines.names.settings.factor].value

                            local raw = table.deepcopy(data.raw[name][k.name])
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
        end
    end
end
