require('init')

local max_infinity = 4294967295

local function clamp_min(min)
    return math.max(-2147483648, math.min(min, 2147483647))
end

local function clamp_max(max)
    if max == nil or max >= max_infinity then
        return nil
    end
    return math.max(0, max)
end

--- @alias chest_merged_event { player_index: number, surface: LuaSurface, split_chests: LuaEntity[], merged_chest: LuaEntity }

local function get_logistic_section(entity, index)
    local logistic_point = entity.get_requester_point()
    local section = logistic_point.get_section(index)
    if not section then
        return logistic_point.add_section()
    end
    return section
end

local function flatten_request_dictionary(requests)
    local requests_list = {}
    for item_name, quality_requests in pairs(requests or {}) do
        for quality, request in pairs(quality_requests) do
            table.insert(requests_list, {
                name = item_name,
                quality = quality,
                min = clamp_min(request.min),
                max = clamp_max(request.max)
            })
        end
    end

    return requests_list
end

local function split_up_requests(to_entities, requests, enabled, split_setting)
    if split_setting == 'split-requests' then
        local split_amount = table_size(requests) / table_size(to_entities)
        local to_index = 1
        for i, request in ipairs(requests) do
            local to_section = get_logistic_section(to_entities[to_index], enabled and 1 or 2)
            to_section.active = enabled
            to_section.set_slot(to_section.filters_count + 1, {
                value = {
                    name = request.name,
                    comparator = '=',
                    quality = request.quality
                },
                min = request.min,
                max = request.max
            })

            if to_index * split_amount <= i then
                to_index = to_index + 1
            end
        end
    elseif split_setting == 'split-count' then
        local split_count = table_size(to_entities)
        for i, to_entity in ipairs(to_entities) do
            local to_section = get_logistic_section(to_entity, enabled and 1 or 2)
            to_section.active = enabled
            for slot, request in ipairs(requests) do
                local min = math.floor(request.min / (split_count - i + 1))
                local max = (request.max ~= nil) and math.floor(request.max / (split_count - i + 1)) or nil
                to_section.set_slot(slot, {
                    value = {
                        name = request.name,
                        comparator = '=',
                        quality = request.quality
                    },
                    min = min,
                    max = max
                })

                request.min = request.min - min
                if request.max ~= nil then
                    request.max = request.max - max
                end
            end
        end
    elseif split_setting == 'copy' then
        for _, to_entity in ipairs(to_entities) do
            local to_section = get_logistic_section(to_entity, enabled and 1 or 2)
            to_section.active = enabled
            for slot, request in ipairs(requests) do
                to_section.set_slot(slot, {
                    value = {
                        name = request.name,
                        comparator = '=',
                        quality = request.quality
                    },
                    min = request.min,
                    max = request.max
                })
            end
        end
    end
end

local function move_logistic_requests(player_index, from_entities, to_entities)
    local split_setting = game.players[player_index].mod_settings[MergingChestsLogistic.copy_requests_setting_name].value
    local can_preserve_named_groups = table_size(to_entities) == 1 or split_setting == 'copy'

    -- requests[enabled][item_name][quality] = { min, max }
    local requests = {}
    --- request_groups[enabled][group_name] = multiplier
    local request_groups = {}
    local trash_not_requested = false
    local request_from_buffers = false

    for _, from_entity in ipairs(from_entities) do
        local logistic_point = from_entity.get_requester_point()
        if logistic_point then
            for _, section in ipairs(logistic_point.sections) do
                -- Move requests to unnamed groups if source is not named group or mod setting wouldn't allow them to be copied to target chests
                if section.group == '' or not can_preserve_named_groups then
                    for _, request in ipairs(section.filters) do
                        if request.value.comparator == '=' then
                            requests[section.active] = requests[section.active] or {}
                            requests[section.active][request.value.name] = requests[section.active][request.value.name] or {}
                            requests[section.active][request.value.name][request.value.quality] = requests[section.active][request.value.name][request.value.quality] or {}

                            local r = requests[section.active][request.value.name][request.value.quality]
                            r.min = (r.min or 0) + request.min * section.multiplier
                            if request.max == nil then
                                r.max = max_infinity
                            else
                                r.max = (r.max or 0) + request.max * section.multiplier
                            end
                        end
                    end
                else
                    request_groups[section.active] = request_groups[section.active] or {}
                    request_groups[section.active][section.group] = (request_groups[section.active][section.group] or 0) + section.multiplier
                end
            end

            trash_not_requested = trash_not_requested or logistic_point.trash_not_requested
            request_from_buffers = request_from_buffers or from_entity.request_from_buffers
        end
    end

    for _, to_entity in ipairs(to_entities) do
        local logistic_point = to_entity.get_requester_point()
        if logistic_point then
            logistic_point.trash_not_requested = trash_not_requested
            logistic_point.remove_section(1)

            to_entity.request_from_buffers = request_from_buffers
        end
    end

    -- Move enabled requests
    local enabled_request_list = flatten_request_dictionary(requests[true])
    if table_size(enabled_request_list) > 0 then
        split_up_requests(to_entities, enabled_request_list, true, split_setting)
    end

    -- Move disabled requests
    local disabled_request_list = flatten_request_dictionary(requests[false])
    if table_size(disabled_request_list) > 0 then
        split_up_requests(to_entities, disabled_request_list, false, split_setting)
    end

    -- Move named logistic groups
    if can_preserve_named_groups then
        for _, to_entity in ipairs(to_entities) do
            local logistic_point = to_entity.get_requester_point()
            if logistic_point then
                for enabled, request_group_names in pairs(request_groups) do
                    for request_group_name, multiplier in pairs(request_group_names) do
                        local group = logistic_point.add_section(request_group_name)
                        group.active = enabled
                        group.multiplier = multiplier
                    end
                end
            end
        end
    end

    -- Reintroduce first empty logistic section back
    for _, to_entity in ipairs(to_entities) do
        local logistic_point = to_entity.get_requester_point()
        if logistic_point and logistic_point.sections_count == 0 then
            logistic_point.add_section()
        end
    end
end

--- @param event chest_merged_event
local function on_chest_merged(event)
    move_logistic_requests(event.player_index, event.split_chests, { event.merged_chest })
end

--- @param event chest_merged_event
local function on_chest_split(event)
    move_logistic_requests(event.player_index, { event.merged_chest }, event.split_chests)
end

local function on_init_or_load()
    script.on_event(remote.call('MergingChests', 'get_chest_merged_event_name'), on_chest_merged)
    script.on_event(remote.call('MergingChests', 'get_chest_split_event_name'), on_chest_split)
end

script.on_init(on_init_or_load)
script.on_load(on_init_or_load)
