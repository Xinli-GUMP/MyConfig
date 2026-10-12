-- mime-ext
require("mime-ext.local"):setup({
	-- Expand the existing filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
	},

	-- Expand the existing extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		ps1 = "text/ps1",
	},

	-- If the mime-type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime` plugin, which uses `file(1)`
	fallback_file1 = true,
})
--
-- starship.yazi
-- require("starship"):setup()

-- 剪贴板持久化
-- require("session"):setup {
-- 	sync_yanked = true,
-- }

-- 显示边框
-- border
-- require("full-border"):setup()

-- custom-shell
require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})

-- require("relative-motions"):setup({ show_numbers="relative", show_motion = true })

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- DuckDB plugin configuration
-- require("duckdb"):setup()
