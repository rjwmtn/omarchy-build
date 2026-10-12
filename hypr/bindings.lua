-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Chrome/Chromium on Wayland often ignores Omarchy's Super+C/V copy-paste
-- because the physically held Super is still in the seat when Ctrl+C/V is
-- injected. Temporarily lift Super, target the Chrome window, then send
-- Ctrl+C/V/X so the browser matches the rest of Omarchy.
-- Note: SUPER+C/V/X were previously the stock universal clipboard binds.

local function window_has_tag(window, tag)
  for _, value in ipairs(window.tags or {}) do
    if value:gsub("%*$", "") == tag then
      return true
    end
  end

  return false
end

local function send_key(mods, key, state, window)
  local args = { mods = mods, key = key, state = state }
  if window then
    args.window = window
  end
  hl.dispatch(hl.dsp.send_key_state(args))
end

local function send_shortcut_once(mods, key, window)
  send_key(mods, key, "down", window)
  hl.timer(function()
    send_key(mods, key, "up", window)
  end, { timeout = 50, type = "oneshot" })
end

local function send_clipboard_to_chrome(mods, key, window)
  -- Drop Super from the synthetic stream so Chrome sees a plain Ctrl chord.
  send_key("", "Super_L", "up", window)
  send_key("", "Super_R", "up", window)
  send_shortcut_once(mods, key, window)
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    local window = hl.get_active_window()
    if not window then
      return
    end

    if window_has_tag(window, "terminal") then
      send_shortcut_once(terminal_mods, terminal_key)
      return
    end

    if window_has_tag(window, "chromium-based-browser") then
      send_clipboard_to_chrome(default_mods, default_key, window)
      return
    end

    send_shortcut_once(default_mods, default_key)
  end
end

hl.unbind("SUPER + C")
hl.unbind("SUPER + V")
hl.unbind("SUPER + X")

o.bind("SUPER + C", "Universal copy", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
o.bind("SUPER + V", "Universal paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
local function universal_cut()
  local window = hl.get_active_window()
  if window and window_has_tag(window, "chromium-based-browser") then
    send_clipboard_to_chrome("CTRL", "X", window)
    return
  end
  send_shortcut_once("CTRL", "X")
end

o.bind("SUPER + X", "Universal cut", universal_cut)

-- Print was "Screenshot" (omarchy-capture-screenshot). That freeze grabs the
-- pointer into the picture on the NVIDIA output. This wrapper hides the
-- pointer only while the freeze frame is taken.
hl.unbind("PRINT")
o.bind("PRINT", "Screenshot", "/home/ryan/.local/bin/omarchy-screenshot-no-cursor")

-- config-sync cherry-pick
o.bind("F3", "Screenshot Region", "omarchy-capture-screenshot region")
o.bind("SUPER + Super_R", "Dictation (Talkify)", "talkify tap", { release = true })
o.bind("XF86LaunchA", "Screenshot Region (Apple top row)", "omarchy-capture-screenshot region")
