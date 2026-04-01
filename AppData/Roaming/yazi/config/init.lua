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

-- 剪贴板持久化
-- require("session"):setup {
-- 	sync_yanked = true,
-- }

-- 显示边框
-- border
-- require("full-border"):setup()

-- Yatline
-- require("yatline"):setup({
-- 	section_separator = { open = "", close = "" },
-- 	part_separator = { open = "", close = "" },
-- 	inverse_separator = { open = "", close = "" },

-- 	style_a = {
-- 		fg = "black",
-- 		bg_mode = {
-- 			normal = "#a89984",
-- 			select = "#d79921",
-- 			un_set = "#d65d0e"
-- 		}
-- 	},
-- 	style_b = { bg = "#665c54", fg = "#ebdbb2" },
-- 	style_c = { bg = "#3c3836", fg = "#a89984" },

-- 	permissions_t_fg = "green",
-- 	permissions_r_fg = "yellow",
-- 	permissions_w_fg = "red",
-- 	permissions_x_fg = "cyan",
-- 	permissions_s_fg = "darkgray",

-- 	tab_width = 20,
-- 	tab_use_inverse = false,

-- 	selected = { icon = "󰻭", fg = "yellow" },
-- 	copied = { icon = "", fg = "green" },
-- 	cut = { icon = "", fg = "red" },

-- 	total = { icon = "󰮍", fg = "yellow" },
-- 	succ = { icon = "", fg = "green" },
-- 	fail = { icon = "", fg = "red" },
-- 	found = { icon = "󰮕", fg = "blue" },
-- 	processed = { icon = "󰐍", fg = "green" },

-- 	show_background = true,

-- 	display_header_line = true,
-- 	display_status_line = true,

-- 	header_line = {
-- 		left = {
-- 			section_a = {
-- 			},
-- 			section_b = {
-- 			},
-- 			section_c = {
-- 			}
-- 		},
-- 		right = {
-- 			section_a = {
-- 			},
-- 			section_b = {
-- 			},
-- 			section_c = {
-- 			}
-- 		}
-- 	},
-- 	status_line = {
-- 		left = {
-- 			section_a = {
--         			{type = "string", custom = false, name = "tab_mode"},
-- 			},
-- 			section_b = {
--         			{type = "string", custom = false, name = "hovered_size"},
-- 			},
-- 			section_c = {
--         			{type = "string", custom = false, name = "hovered_name"},
-- 			}
-- 		},
-- 		right = {
-- 			section_a = {
--         			{type = "string", custom = false, name = "cursor_position"},
-- 			},
-- 			section_b = {
--         			{type = "string", custom = false, name = "cursor_percentage"},
-- 			},
-- 			section_c = {
--         			{type = "coloreds", custom = false, name = "permissions"},
-- 			}
-- 		}
-- 	},
-- })

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
require("duckdb"):setup()
