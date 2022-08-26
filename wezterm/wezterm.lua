local os = require 'os';
local wezterm = require 'wezterm';
local act = wezterm.action

local GIT_BASH = "C:\\Program Files\\Git\\bin\\bash.exe"

local launch_menu = {}

table.insert(launch_menu, {
    label = "Git Bash",
    args = {GIT_BASH, "-l"},
})
table.insert(launch_menu, {
    label = "PowerShell",
    args = {"pwsh.exe"},
})
table.insert(launch_menu, {
    label = "cmd",
    args = {"cmd.exe"},
})

local edit_settings = wezterm.action_callback(function(window, pane)
    local pinfo = pane:get_foreground_process_info()
    -- print(pinfo)
    if pinfo.name == "wslhost.exe" then
        local edit_command = {"bash", "-c", "vi \"$(wslpath '" .. wezterm.config_file .. "')\""}
        window:perform_action(act.SpawnCommandInNewTab{
            args = edit_command
        }, pane)
    else
        wezterm.background_child_process{"code.cmd", wezterm.config_file}
    end
end)

local open_help = wezterm.action_callback(function()
    local browser = os.getenv("LOCALAPPDATA") .. "\\Google\\Chrome\\Application\\chrome.exe"
    wezterm.background_child_process{browser, "https://wezfurlong.org/wezterm/index.html"}
end)

local keys = {
    {key="v", mods="CTRL", action=act.PasteFrom("Clipboard")},
    {key="=", mods="SHIFT|ALT", action=act.SplitVertical{domain="CurrentPaneDomain"}},
    {key="|", mods="SHIFT|ALT", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="[", mods="CTRL", action=act.ActivateCopyMode},
    {key=",", mods="CTRL", action=edit_settings},
    {key="P", mods="CTRL", action=act.ShowLauncher},
    {key="H", mods="CTRL", action=open_help},
}

local mouse_bindings = {
    {event={Down={streak=1, button="Right"}}, mods="NONE", action=act.PasteFrom("Clipboard")},
}

return {
    -- Program
    default_prog = {GIT_BASH, "-l"},
    -- default_prog = {"pwsh.exe"},
    launch_menu = launch_menu,

    -- Appearance
    initial_cols = 110,
    initial_rows = 30,
    line_height = 1.1,
    color_scheme = "Dracula",
    window_background_opacity = 0.9,

    -- Font
    font_size = 12,
    -- font = wezterm.font("HackGenNerd Console"),
    font = wezterm.font("PlemolJP Console NF"),
    -- treat_east_asian_ambiguous_width_as_wide = true,

    -- Keys
    keys = keys,
    mouse_bindings = mouse_bindings,
}
