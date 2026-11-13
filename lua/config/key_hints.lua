-- On/off state of the key helpers (which-key popup, precognition, hardtime), kept across restarts.
local M = {}

local defaults = { whichkey = true, precognition = false, hardtime = false }

local labels = { whichkey = "Key hints popup", precognition = "Motion hints", hardtime = "Hardtime" }

M.path = vim.fn.stdpath("state") .. "/key-hints.json"

local state

local function load()
  state = vim.deepcopy(defaults)
  local fd = io.open(M.path, "r")
  if not fd then
    return
  end
  local ok, saved = pcall(vim.json.decode, fd:read("*a"))
  fd:close()
  if ok and type(saved) == "table" then
    for name in pairs(defaults) do
      if type(saved[name]) == "boolean" then
        state[name] = saved[name]
      end
    end
  end
end

function M.get(name)
  if not state then
    load()
  end
  return state[name]
end

function M.set(name, on)
  M.get(name)
  state[name] = on
  vim.fn.mkdir(vim.fs.dirname(M.path), "p")
  local fd = io.open(M.path, "w")
  if fd then
    fd:write(vim.json.encode(state))
    fd:close()
  end
end

-- Flips a helper with snacks' on/off notification. `apply` switches the plugin itself.
function M.toggle(name, apply)
  require("snacks").toggle
    .new({
      id = "key_hints_" .. name,
      name = labels[name],
      get = function()
        return M.get(name)
      end,
      set = function(on)
        M.set(name, on)
        if apply then
          apply(on)
        end
      end,
    })
    :toggle()
end

return M
