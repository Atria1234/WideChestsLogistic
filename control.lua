require('init')

--- @alias chest_merged_event { player_index: number, surface: LuaSurface, split_chests: LuaEntity[], merged_chest: LuaEntity }

local function move_logistic_requests(player_index, from_entities, to_entities)
    local requests = {}
    for _, from in ipairs(from_entities) do
        for i = 1, from.request_slot_count do
            local request = from.get_request_slot(i)
            if request ~= nil then
                requests[request.name] = (requests[request.name] or 0) + request.count
            end
        end
    end

    local split_setting = game.players[player_index].mod_settings[MergingChestsLogistic.copy_requests_setting_name].value

    if split_setting == 'split-requests' then
        local split_amount = table_size(requests) / table_size(to_entities)
        local to_index = 1
        local i = 1
        for name, count in pairs(requests) do
            to_entities[to_index].set_request_slot({name = name, count = count}, to_entities[to_index].request_slot_count + 1)

            if to_index * split_amount <= i then
                to_index = to_index + 1
            end
            i = i + 1
        end
    elseif split_setting == 'split-count' then
        local split_count = table_size(to_entities)
        for request_name, remaining_request_count in pairs(requests) do
            for i, to_entity in ipairs(to_entities) do
                local request_count = math.floor(remaining_request_count / (split_count - i + 1))
                to_entity.set_request_slot({name = request_name, count = request_count}, to_entity.request_slot_count + 1)
                remaining_request_count = remaining_request_count - request_count
            end
        end
    else
        for request_name, request_count in pairs(requests) do
            for _, to_entity in ipairs(to_entities) do
                to_entity.set_request_slot({name = request_name, count = request_count}, to_entity.request_slot_count + 1)
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
