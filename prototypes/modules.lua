--[[
    Add tier 0 modules
    Set modules to be researched earlier
]]
local module_types = {
    ['speed'] = {
        name = 'speed',
        effect = {
            speed = {bonus = 0.1},
            consumption = {bonus = 0.25}
        }
    },
    ['productivity'] = {
        name = 'productivity',
        effect = {
            productivity = {bonus = 0.02},
            consumption = {bonus = 0.2},
            pollution = {bonus = 0.025},
            speed = {bonus = -0.15}
        }
    },
    ['effectivity'] = {
        name = 'effectivity',
        effect = {
            consumption = {bonus = -0.15}
        }
    }
}

for _, module_type in pairs(module_types) do
    -- get base module

    local module_name = module_type.name
    local module_item = table.deepcopy(data.raw.module[module_name .. '-module'])
    local module_recipe = table.deepcopy(data.raw.recipe[module_name .. '-module'])
    local module_technology = table.deepcopy(data.raw.technology[module_name .. '-module'])

    -- add module-0 to tier 1 recipe
    table.insert(data.raw.recipe[module_name .. '-module'].ingredients, {module_name .. '-module-0', 2})

    -- adjust details for tier 0
    module_item.name = module_name .. '-module-0'
    module_item.icon = '__more-module-slots__/graphics/' .. module_item.name .. '.png'
    module_item.tier = 0
    module_item.order = 'a[speed]-a[speed-module-0]'
    module_item.effect = module_type.effect

    module_recipe.name = module_name .. '-module-0'
    module_recipe.ingredients = {
        {'electronic-circuit', 10},
        {'steel-plate', 1}
    }
    module_recipe.energy_required = 5
    module_recipe.result = module_name .. '-module-0'

    -- technology related
    module_technology.name = module_name .. '-module-0'
    module_technology.prerequisites = {
        'mms-extra-modules'
    }
    module_technology.unit.ingredients = {{'automation-science-pack', 1}}
    module_technology.effects = {
        {
            type = 'unlock-recipe',
            recipe = module_name .. '-module-0'
        }
    }

    data:extend(
        {
            module_item,
            module_recipe,
            module_technology
        }
    )
    -- add technology to modules prerequisites
    table.insert(data.raw.technology.modules.prerequisites, module_technology.name)

    --redo tier 1 modules
    -- rename tier 1 module item
    local tier_1_item = table.deepcopy(data.raw.module[module_name .. '-module'])
    tier_1_item.name = module_name .. '-module-1'
    data.raw.module[module_name .. '-module'] = nil
    -- recipe
    local tier_1_recipe = table.deepcopy(data.raw.recipe[module_name .. '-module'])
    tier_1_recipe.name = module_name .. '-module-1'
    tier_1_recipe.result = module_name .. '-module-1'
    data.raw.recipe[module_name .. '-module'] = nil
    -- technology
    local tier_1_technology = table.deepcopy(data.raw.technology[module_name .. '-module'])
    tier_1_technology.name = module_name .. '-module-1'
    data.raw.technology[module_name .. '-module'] = nil

    data:extend({tier_1_item, tier_1_recipe, tier_1_technology})

    --log(serpent.block(data.raw.module))

    -- replace all tier 1 recipe items
    for _, recipe in pairs(data.raw.recipe) do
        if recipe then
            --recipe = data.raw.recipe[recipe]
            if recipe.ingredients ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.ingredients, i)
                        table.insert(recipe.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
            if recipe.normal ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.normal.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.normal.ingredients, i)
                        table.insert(recipe.normal.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
            if recipe.expensive ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.expensive.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.expensive.ingredients, i)
                        table.insert(recipe.expensive.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
        end
    end
    -- replace technology prerequisites
    for _, technology in pairs(data.raw.technology) do
        if data.raw.technology[technology.name] and data.raw.technology[technology.name].prerequisites then
            for i, prerequisite in ipairs(data.raw.technology[technology.name].prerequisites) do
                log(prerequisite)
                if prerequisite == module_name .. '-module' then
                    table.remove(data.raw.technology[technology.name].prerequisites, i)
                    table.insert(data.raw.technology[technology.name].prerequisites, module_name .. '-module-1')
                end
            end
        end
        if data.raw.technology[technology.name] and data.raw.technology[technology.name].effects then
            for i, effect in ipairs(data.raw.technology[technology.name].effects) do
                if effect.type == 'unlock-recipe' and effect.recipe == module_name .. '-module' then
                    table.remove(data.raw.technology[technology.name].effects, i)
                    table.insert(data.raw.technology[technology.name].effects, {recipe = module_name .. '-module-1', type = 'unlock-recipe'})
                end
            end
        end
    end
end

-- add the overall technology
local module_technology = table.deepcopy(data.raw.technology.modules)
module_technology.name = 'mms-extra-modules'
module_technology.prerequisites = {
    'electronics',
    'steel-processing'
}
module_technology.unit.ingredients = {{'automation-science-pack', 1}}
data:extend(
    {
        module_technology
    }
)

-- add support for module-requester
if mods['module-requestor'] then
    if data.raw.technology['module-requestor'] then
        data.raw.technology['module-requestor'].prerequisites = {'mms-extra-modules', 'construction-robotics'}
    end
end
