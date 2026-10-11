-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- X post composer (Super+Shift+Alt+X): small centered dialog, not a tiled browser.
-- https://github.com/omacom/omarchy/pull/12613
o.window("^.+-x\\.com__compose_post-.*$", { float = true, center = true, size = { 540, 320 } })

-- Hybrid Intel+NVIDIA: Omarchy's nvidia.lua sets LIBVA_DRIVER_NAME=nvidia
-- whenever a GSP NVIDIA GPU exists. Chrome GL is on the Intel iGPU
-- (renderD129), so NVIDIA VA-API decode flashes Meet and can abort the
-- GPU process. Keep VA-API on Intel. Do not set AQ_DRM_DEVICES.
hl.env("LIBVA_DRIVER_NAME", "iHD")
