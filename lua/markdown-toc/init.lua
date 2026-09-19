local M = {}

-- Default configuration options
M.config = {
	-- Define which heading levels you want to parse (1 to 6)
	min_level = 1,
	max_level = 6,
}

-- Function to parse the current markdown buffer and extract headings
local function get_markdown_headings()
	local bufnr = vim.api.nvim_get_current_buf()

	-- Ensure the current file is actually a markdown file
	if vim.bo[bufnr].filetype ~= "markdown" then
		vim.notify("Markdown TOC: Current file is not a markdown document", vim.log.levels.WARN)
		return nil
	end

	-- Retrieve all lines from the current active buffer
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local headings = {}

	-- Regex pattern to match markdown headers (from # to ######)
	-- ^(#+) means match one or more '#' at the start of the line
	-- %s+(.+) means match the space followed by the actual title text
	for lnum, line in ipairs(lines) do
		local hashes, title = line:match("^(#+)%s+(.+)$")

		if hashes and title then
			local level = #hashes
			-- Filter headings based on configured minimum and maximum levels
			if level >= M.config.min_level and level <= M.config.max_level then
				-- Store formatting details, text representation, and 1-indexed line number
				table.insert(headings, {
					level = level,
					title = title,
					line_number = lnum,
					-- Indent visually in the picker menu to reflect heading depth hierarchy
					display_text = string.rep("  ", level - 1) .. hashes .. " " .. title,
				})
			end
		end
	end

	return headings
end

-- Function to display headings inside a native interactive picker menu
function M.show_toc()
	local headings = get_markdown_headings()

	-- Exit if no headings were extracted or found
	if not headings or #headings == 0 then
		vim.notify("Markdown TOC: No headings found in this file", vim.log.levels.INFO)
		return
	end

	-- Extract display strings to feed into the ui selection engine
	local display_items = {}
	for _, item in ipairs(headings) do
		table.insert(display_items, item.display_text)
	end

	-- Trigger native core Neovim selection UI (integrates cleanly with Telescope/FZF if installed)
	vim.ui.select(display_items, {
		prompt = "Markdown Table of Contents:",
	}, function(selected_text, index)
		-- Handle completion or selection events
		if not selected_text or not index then
			return
		end

		-- Resolve the metadata matching the selected list index
		local target_heading = headings[index]
		if target_heading then
			-- Jump the cursor precisely to the targeted line number
			-- Note: nvim_win_set_cursor expects 0-indexed column, so column is set to 0
			vim.api.nvim_win_set_cursor(0, { target_heading.line_number, 0 })
			-- Center the screen view around the cursor position for maximum readability
			vim.cmd("normal! zz")
		end
	end)
end

-- Core initialization bootstrap module
function M.setup(opts)
	-- Overwrite and force apply any incoming overrides from user setup parameters
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Bind global user commands to make the functional trigger accessible
	vim.api.nvim_create_user_command("MarkdownTOC", M.show_toc, {})
end

return M
