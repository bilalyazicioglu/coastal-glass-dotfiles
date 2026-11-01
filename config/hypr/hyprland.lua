-- Requires an existing HyDE installation with the Hyprland Lua API.
if not hyde then
 local share=os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
 dofile(share .. "/hypr/hyde.lua")
end

-- Personal Coastal Glass settings; HyDE Lua is a required dependency.
hl.monitor({output="",mode="preferred",position="auto",scale=1})
hl.config({input={kb_layout="tr",kb_options="grp:alt_shift_toggle",follow_mouse=1,touchpad={natural_scroll=true,tap_to_click=true,tap_and_drag=true,clickfinger_behavior=true,disable_while_typing=true,scroll_factor=1.0}}, decoration={active_opacity=0.92,inactive_opacity=0.86,rounding=13,blur={enabled=true,size=4,passes=2}}})
-- Reuse the existing notification and authentication services.
hyde.config.start.notifications="true"
hyde.config.start.auth_dialogue="systemctl --user start hyprpolkitagent.service"
hyde.config.app.terminal="ghostty"
hl.bind("SUPER + RETURN",hl.dsp.exec_cmd("ghostty"),{description="Open terminal"})
hl.bind("SUPER + B",hl.dsp.exec_cmd("firefox"),{description="Open browser"})
-- Neon Glass: calm cyan/violet accents and short, soft transitions.
hl.config({general={col={active_border={colors={"rgba(70cbd1dd)","rgba(bda0c9bb)"},angle=45},inactive_border={colors={"rgba(31465599)"},angle=45}}},animations={enabled=true}})
hl.layer_rule({match={namespace="waybar"},blur=true})
hl.curve("neonSoft",{type="bezier",points={{0.16,1},{0.3,1}}})
hl.animation({leaf="windows",enabled=true,speed=4,bezier="neonSoft",style="popin 94%"})
hl.animation({leaf="fade",enabled=true,speed=3,bezier="neonSoft"})
hl.animation({leaf="workspaces",enabled=true,speed=4,bezier="neonSoft",style="slidefade 15%"})
hl.animation({leaf="borderangle",enabled=false,speed=1,bezier="default"})
-- Direct, reliable startup commands, without duplicate session services.
-- Noctalia replaces the HyDE-generated Waybar for the shell UI.
hyde.config.start.bar="true"
hyde.config.start.wallpaper="awww-daemon"
hyde.config.start.idle_daemon="hypridle"
hyde.config.start.blue_light_filter_daemon=""
hyde.config.start.battery_notify=""
hyde.config.start.hyde_config="hyde-shell config.lua"

hl.bind("SUPER + SPACE",hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"),{description="Application launcher"})
hl.bind("SUPER + E",hl.dsp.exec_cmd("dolphin"),{description="File manager"})
hyde.config.start.wallpaper=os.getenv("HOME") .. "/.local/bin/coastal-main-wallpaper"
hyde.config.app.lockscreen="__HOME__/.local/bin/coastal-lock"
hl.bind("SUPER + L",hl.dsp.exec_cmd("__HOME__/.local/bin/coastal-lock"),{description="Lock screen"})

-- Battery notifications use HyDE’s Lua/GIO implementation.
hyde.config.start.battery_notify="hyde-shell batterynotify.lua"

-- Coastal Glass UX: wallpaper-derived palette and a standalone edge-reveal dock.
hl.config({general={gaps_in=5,gaps_out=10,border_size=2,col={active_border={colors={"rgba(83c7c5cc)","rgba(e8b49b88)"},angle=45},inactive_border={colors={"rgba(4c606d88)"},angle=45}}},decoration={rounding=14,active_opacity=1.0,inactive_opacity=0.97,blur={enabled=true,size=4,passes=2}}})
hl.layer_rule({match={namespace="rofi"},blur=true})
hl.on("hyprland.start",function()
 hl.exec_cmd("noctalia -d")
 -- Keep the legacy Super+V cliphist menu receiving new Wayland selections.
 hl.exec_cmd("wl-paste --watch cliphist store")
end)
hl.bind("SUPER + COMMA",hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"),{description="Open status and media panel"})

-- Noctalia surfaces use compositor blur over their translucent materials.
hl.layer_rule({name="noctalia",match={namespace="^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"},no_anim=true,ignore_alpha=0.5,blur=true,blur_popups=true})
hl.layer_rule({match={namespace="swaync-control-center"},blur=true})

-- Use Grimblast directly: the HyDE `screenshot` helper is unavailable here.
hl.bind("Print",hl.dsp.exec_cmd("grimblast copysave screen"),{locked=true,description="[Utilities] Save and copy full screenshot"})
hl.bind("SUPER + P",hl.dsp.exec_cmd("grimblast copysave area"),{locked=true,description="[Utilities] Select screenshot area"})
hl.bind("SUPER + CTRL + P",hl.dsp.exec_cmd("grimblast --freeze copysave area"),{locked=true,description="[Utilities] Freeze and select screenshot area"})
hl.bind("SUPER + ALT + P",hl.dsp.exec_cmd("grimblast copysave output"),{locked=true,description="[Utilities] Screenshot active monitor"})


-- Wallpaper theme colors; geometry and key bindings stay in this file.
dofile(os.getenv("HOME") .. "/.config/hypr/coastal-theme.lua")
