local function find_artisan_file(path)
  local artisan_path = path .. "/artisan"
  
  -- Check if the artisan file exists in the current directory
  local file = io.open(artisan_path, "r")
  if file then
    file:close()
    return artisan_path
  end

  -- If not, go up a directory and search again
  local parent_path = path:match("(.*/)")
  if not parent_path or parent_path == path then
    return nil -- Reached the root directory
  end
  
  return find_artisan_file(parent_path:sub(1, -2)) -- Traverse up
end

local function run_artisan_cmd(...)
  local cwd = vim.fn.getcwd() -- Get current directory
  local artisan_path = find_artisan_file(cwd)

  if artisan_path then
    local args = table.concat({...}, " ")
    local cmd = artisan_path .. " " .. args
    print("Running: " .. cmd)
    
    -- Run the command using vim's terminal or system call
    vim.cmd("split | terminal " .. cmd)
  else
    print("artisan file not found!")
  end
end

-- Example usage: run the artisan command with arguments
local function artisan_cmd(...)
  run_artisan_cmd(...)
end

-- Bind the function to a Neovim command for easy access
vim.api.nvim_create_user_command('Artisan', function(opts)
  artisan_cmd(unpack(opts.fargs))
end, { nargs = '*' })

