require('init')

--- @alias chest_merged_event { player_index: number, surface: LuaSurface, split_chests: LuaEntity[], merged_chest: LuaEntity }

local function move_logistic_requests(player_index, from_entities, to_entities)
    local requests = {}
    for _, from in ipairs(from_entities) do
        for i = 1, from.request_slot_count do
            local request = entity_from.get_request_slot(i)
            if request ~= nil then
                requests[request.name] = (requests[request.name] or 0) + request.count
            end
        end
    end

    local split_setting = game.players[player_index].mod_settings[MergingChestsLogistic.copy_requests_setting_name].value

    if split_setting == 'split-requests' then
        local to_index = 1
        local count_per_chest = math.floor(table_size(requests) / table_size(to_entities))
        local processed = 0
        for name, count in pairs(requests) do
            to_entities[to_index].set_request_slot({name = name, count = count}, to_entities.request_slot_count + 1)

            processed = processed + 1
            if processes % count_per_chest == 0 then
                to_index = to_index + 1
            end
        end
    else
        local split_count
        if split_setting == 'split-count' then
            split_count = table_size(to_entities)
        else
            split_count = 1
        end

        for _, to in ipairs(to_entities) do
            for name, count in pairs(requests) do
                to.set_request_slot({name = name, count = math.floor(count / split_count)}, to.request_slot_count + 1)
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
