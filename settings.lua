require('init')

-- Register chest in base mod
MergingChests.create_mergeable_chest_setting('logistic-chest-passive-provider', {  default_value = 'none' })
MergingChests.create_mergeable_chest_setting('logistic-chest-active-provider', { default_value = 'none' })
MergingChests.create_mergeable_chest_setting('logistic-chest-storage', {  default_value = 'none' })
MergingChests.create_mergeable_chest_setting('logistic-chest-buffer', { default_value = 'none' })
MergingChests.create_mergeable_chest_setting('logistic-chest-requester', { default_value = 'none' })

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
