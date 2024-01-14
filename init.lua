MergingChestsLogistic = MergingChestsLogistic or { }

MergingChestsLogistic.mod_name = 'WideChestsLogistic'

--- @param value string
function MergingChestsLogistic.prefix_with_modname(value)
	return MergingChestsLogistic.mod_name..'_'..value
end

MergingChestsLogistic.copy_requests_setting_name = MergingChestsLogistic.prefix_with_modname('copy-requests-on-split')
