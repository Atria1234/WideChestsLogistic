require('init')

-- Register chest in base mod
MergingChests.create_mergeable_chest_setting(MergingChestsLogistic.chest_names.passive_provider, {  default_value = 'none' })
MergingChests.create_mergeable_chest_setting(MergingChestsLogistic.chest_names.active_provider, { default_value = 'none' })
MergingChests.create_mergeable_chest_setting(MergingChestsLogistic.chest_names.storage, {  default_value = 'none' })
MergingChests.create_mergeable_chest_setting(MergingChestsLogistic.chest_names.buffer, { default_value = 'none' })
MergingChests.create_mergeable_chest_setting(MergingChestsLogistic.chest_names.requester, { default_value = 'none' })

data:extend(
{
	{
		name = MergingChestsLogistic.copy_requests_setting_name,
		type = "string-setting",
		setting_type = "runtime-per-user",
		allowed_values = {
			'copy',
			'split-count',
			'split-requests'
		},
		default_value = 'copy'
	}
})
