require('init')

local infinity = 'inf'

--- @alias chest_merged_event { player_index: number, surface: LuaSurface, split_chests: LuaEntity[], merged_chest: LuaEntity }

local function get_logistic_section(entity)
    local logistic_point = entity.get_requester_point()
    local section = logistic_point.get_section(1)
    if not section then
        return logistic_point.add_section()
    end
    return section
end

local function move_logistic_requests(player_index, from_entities, to_entities)
    -- requests[name] = { min, max }
    local requests = {}
    local trash_not_requested = false
    local request_from_buffers = false

    for _, from in ipairs(from_entities) do
        local logistic_point = from.get_requester_point()
        if logistic_point then
            for _, section in ipairs(logistic_point.sections) do
                for _, request in ipairs(section.filters) do
                    if request.value.comparator == '=' and request.value.quality == 'normal' then
                        requests[request.value.name] = requests[request.value.name] or {}

                        local r = requests[request.value.name]
                        r.min = (r.min or 0) + request.min
                        if request.max == nil then
                            r.max = infinity
                        elseif r.max ~= infinity then
                            r.max = (r.max or 0) + request.max
                        end
                    end
                end
            end

            trash_not_requested = trash_not_requested or logistic_point.trash_not_requested
            request_from_buffers = request_from_buffers or from.request_from_buffers
        end
    end

    local request_list = {}
    for name, request in pairs(requests) do
        table.insert(request_list, {
            name = name,
            min = request.min,
            max = request.max
        })
    end

    for _, to in ipairs(to_entities) do
        local logistic_point = to.get_requester_point()
        if logistic_point then
            logistic_point.trash_not_requested = trash_not_requested
            to.request_from_buffers = request_from_buffers
        end
    end

    if table_size(request_list) == 0 then
        return
    end

    local split_setting = game.players[player_index].mod_settings[MergingChestsLogistic.copy_requests_setting_name].value

    if split_setting == 'split-requests' then
        local split_amount = table_size(request_list) / table_size(to_entities)
        local to_index = 1
        for i, request in ipairs(request_list) do
            local to_section = get_logistic_section(to_entities[to_index])
            to_section.set_slot(to_section.filters_count + 1, {
                value = {
                    name = request.name,
                    comparator = '=',
                    quality = 'normal'
                },
                min = request.min,
                max = request.max ~= infinity and request.max or nil
            })

            if to_index * split_amount <= i then
                to_index = to_index + 1
            end
        end
    elseif split_setting == 'split-count' then
        local split_count = table_size(to_entities)
        for i, to_entity in ipairs(to_entities) do
            local to_section = get_logistic_section(to_entity)
            for slot, request in ipairs(request_list) do
                local min = math.floor(request.min / (split_count - i + 1))
                local max = (request.max ~= infinity) and math.floor(request.max / (split_count - i + 1)) or nil
                to_section.set_slot(slot, {
                    value = {
                        name = request.name,
                        comparator = '=',
                        quality = 'normal'
                    },
                    min = min,
                    max = max
                })
                request.min = request.min - min
                if request.max ~= infinity then
                    request.max = request.max - max
                end
            end
        end
    elseif split_setting == 'copy' then
        for _, to_entity in ipairs(to_entities) do
            local to_section = get_logistic_section(to_entity)
            for slot, request in ipairs(request_list) do
                to_section.set_slot(slot, {
                    value = {
                        name = request.name,
                        comparator = '=',
                        quality = 'normal'
                    },
                    min = request.min,
                    max = (request.max ~= infinity) and request.max or nil
                })
            end
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
