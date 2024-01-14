require('init')

local function create_segments_data(wide_entity_filename, wide_shadow_filename, high_entity_filename, high_shadow_filename, warehouse_entity_filename, warehouse_shadow_filename, trashdump_tint, hatch_filename)
    return {
        wide_segments = {
            entity = {
                filename = wide_entity_filename,
                top_left = { x = 0, y = 0 },
                top = { x = 64, y = 0 },
                top_right = { x = 128, y = 0 },

                widths = { left = 64, middle = 64, right = 64 },
                heights = {
                    top = 80,
                    middle = 0,
                    bottom = 0
                },
                shift = { x = -0.5, y = -4.5 },
                scale = 0.5,

                center = {
                    filename = hatch_filename,
                    width = 66,
                    height = 32,
                    frame_count = 7
                }
            },
            shadow = {
                filename = wide_shadow_filename,
                top_right = { x = 60, y = 0, shift = { x = 30 } },

                widths = { left = 0, middle = 0, right = 50 },
                heights = {
                    top = 46,
                    middle = 0,
                    bottom = 0
                },
                shift = { x = -4, y = 10 },
                scale = 0.5,
                shadow = true
            }
        },
        high_segments = {
            entity = {
                filename = high_entity_filename,
                top_left = { x = 0, y = 0, shift = { y = -8 } },
                left = { x = 0, y = 80 },
                bottom_left = { x = 0, y = 144 },

                widths = { left = 64, middle = 0, right = 0 },
                heights = {
                    top = 80,
                    middle = 64,
                    bottom = 64
                },
                shift = { x = 0, y = -0.5 },
                scale = 0.5,

                center = {
                    filename = hatch_filename,
                    width = 66,
                    height = 32,
                    shift = { x = -0.5, y = -4 },
                    frame_count = 7
                }
            },
            shadow = {
                filename = high_shadow_filename,
                top_right = { x = 8, y = 0, shift = { y = 6.5 } },
                right = { x = 8, y = 18 },
                bottom_right = { x = 8, y = 45 },

                widths = { left = 0, middle = 0, right = 102 },
                heights = {
                    top = 55,
                    middle = 64,
                    bottom = 55
                },
                shift = { x = 0.75, y = 4 },
                scale = 0.5,
                shadow = true
            }
        },
        warehouse_segments = {
            entity = {
                filename = warehouse_entity_filename,

                top_left = { x = 0, y = 0, shift = { y = 7 } },
                top = { x = 66, y = 0, shift = { y = 7 } },
                top_right = { x = 130, y = 0, shift = { y = 7 } },

                left = { x = 0, y = 75 },
                middle = { x = 66, y = 75 },
                right = { x = 130, y = 75 },

                bottom_left = { x = 0, y = 139 },
                bottom = { x = 66, y = 139 },
                bottom_right = { x = 130, y = 139 },

                center = {
                    filename = hatch_filename,
                    width = 66,
                    height = 32,
                    shift = { y = 3 },
                    frame_count = 7
                },

                widths = { left = 66, middle = 64, right = 66 },
                heights = {
                    top = 50,
                    middle = 64,
                    bottom = 110
                },
                shift = { x = 0, y = -23 },
                scale = 0.5
            },
            shadow = {
                filename = warehouse_shadow_filename,

                top_right = { x = 0, y = 0, shift = { x = 32, y = 7 } },

                right = { x = 0, y = 49, shift = { x = 32 } },

                bottom_right = { x = 0, y = 113, shift = { x = 32 } },

                widths = { right = 120 },
                heights = {
                    top = 50,
                    middle = 64,
                    bottom = 50
                },
                shift = { x = -1, y = 6 },
                scale = 0.5,
                shadow = true
            }
        },
        trashdump_segments = util.merge({
            util.copy(MergingChests.steel_chest_segments.trashdump_segments),
            {
                entity = {
                    center = {
                        filename = hatch_filename,
                        width = 66,
                        height = 32,
                        shift = { x= -16, y = 12 },
                        frame_count = 7,
                        scale = 0.5,
                        tint = {1, 1, 1}
                    },

                    tint = trashdump_tint
                }
            }
        })
    }
end

MergingChestsLogistic.passive_provider_chest_segments = create_segments_data(
    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/wide-chest/passive-provider-wide-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/wide-chest/wide-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/high-chest/passive-provider-high-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/high-chest/high-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/warehouse/warehouse.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/warehouse/warehouse-shadow.png",

    {228, 81, 59},

    "__WideChestsLogistic__/graphics/entity/logistic-chest-passive-provider/passive-provider-hatch-door.png"
)
MergingChestsLogistic.active_provider_chest_segments = create_segments_data(
    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/wide-chest/active-provider-wide-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/wide-chest/wide-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/high-chest/active-provider-high-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/high-chest/high-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/warehouse/warehouse.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/warehouse/warehouse-shadow.png",

    {163, 78, 192},

    "__WideChestsLogistic__/graphics/entity/logistic-chest-active-provider/active-provider-hatch-door.png"
)
MergingChestsLogistic.storage_chest_segments = create_segments_data(
    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/wide-chest/storage-wide-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/wide-chest/wide-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/high-chest/storage-high-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/high-chest/high-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/warehouse/warehouse.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/warehouse/warehouse-shadow.png",

    {201, 164, 64},

    "__WideChestsLogistic__/graphics/entity/logistic-chest-storage/storage-hatch-door.png"
)
MergingChestsLogistic.buffer_chest_segments = create_segments_data(
    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/wide-chest/buffer-wide-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/wide-chest/wide-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/high-chest/buffer-high-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/high-chest/high-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/warehouse/warehouse.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/warehouse/warehouse-shadow.png",

    {73, 185, 86},

    "__WideChestsLogistic__/graphics/entity/logistic-chest-buffer/buffer-hatch-door.png"
)
MergingChestsLogistic.requester_chest_segments = create_segments_data(
    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/wide-chest/requester-wide-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/wide-chest/wide-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/high-chest/requester-high-chest.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/high-chest/high-chest-shadow.png",

    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/warehouse/warehouse.png",
    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/warehouse/warehouse-shadow.png",

    {71, 177, 212},

    "__WideChestsLogistic__/graphics/entity/logistic-chest-requester/requester-hatch-door.png"
)

MergingChests.create_mergeable_chest(
    {
        chest_name = 'logistic-chest-passive-provider',
        logistic_mode = 'passive-provider'
    },
    MergingChestsLogistic.passive_provider_chest_segments
)
MergingChests.create_mergeable_chest(
    {
        chest_name = 'logistic-chest-active-provider',
        logistic_mode = 'active-provider'
    },
    MergingChestsLogistic.active_provider_chest_segments
)
MergingChests.create_mergeable_chest(
    {
        chest_name = 'logistic-chest-storage',
        logistic_mode = 'storage'
    },
    MergingChestsLogistic.storage_chest_segments
)
MergingChests.create_mergeable_chest(
    {
        chest_name = 'logistic-chest-buffer',
        logistic_mode = 'buffer'
    },
    MergingChestsLogistic.buffer_chest_segments
)
MergingChests.create_mergeable_chest(
    {
        chest_name = 'logistic-chest-requester',
        logistic_mode = 'requester'
    },
    MergingChestsLogistic.requester_chest_segments
)
