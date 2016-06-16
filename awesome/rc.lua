-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local tyrannical = require("tyrannical")
local blind = require("blind")
local config = require("forgotten")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local revelation = require("revelation")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- theme = "/home/erik/.awesome/default/theme.lua"
-- beautiful.init(theme)

config.themeName = "arrow"
config.themePath = awful.util.getdir("config") .. "/blind/" .. config.themeName .. "/"
beautiful.init(config.themePath .. "themeSciFi.lua")

-- This is used later as the default terminal and editor to run.
pure_terminal = "urxvt -name term"
terminal = pure_terminal .. " -e tmux"
named_terminal = pure_terminal .. " -name "
named_session_terminal = terminal .. " new-session -s "

editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- naughty.config.default_preset.screen = screen.count()

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}
--
tyrannical.settings.default_layout =  awful.layout.suit.tile.top
tyrannical.settings.mwfact = 0.75

if screen.count() == 1 then web_screen = 1 else web_screen = {2, 3} end

mytags = {
  {
    name       = "Term",
    exclusive  = true,
    screen     = 2,
    volatile   = true,
    position   = 3,
    class      = {
      "URxvt", "urxvt", "xterm", "gnome-terminal"
    }
  },
  {
    name       = "Social",
    exclusive  = true,
    screen     = math.min(screen.count(), 3),
    volatile   = true,
    position   = 2,
    layout     = awful.layout.suit.tile.left,
    mwfact     = .20,
    class = {
      "URxvt:social", "Pidgin"
    }
  },
  {
    name       = "Web",
    exclusive  = true,
    screen     = web_screen,
    volatile   = true,
    position   = 9,
    layout     = awful.layout.suit.max,
    class = {
      "Firefox"
    }
  },
}

tyrannical.tags = mytags

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({}, s, layouts[1])
    -- tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}


do
    local fbyidx = awful.client.focus.byidx
    awful.client.focus.byidx = function (i)
        fbyidx(i)
        local g = client.focus:geometry()
        g.x = g.x + g.width / 2
        g.y = 10
        mouse.coords(g)
    end
end
-- See https://gist.github.com/3302700
do -- Change focus_relative to put the mouse in a sane place.
    local frel = awful.screen.focus_relative
    awful.screen.focus_relative = function (i)
        frel(i)
        if client.focus and client.focus.screen == mouse.screen then
            local g = client.focus:geometry()
            g.x = g.x + g.width/2
            g.y = 10
            mouse.coords(g)
        end
    end
end


--
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mywwwmenu = { { "opera", "/usr/local/bin/opera" }, 
              { "firefox", "/usr/bin/firefox" },
              { "skype", "skype" }
            }

myofficemenu = {
                   { "OpenOffice.org", "/usr/bin/soffice" },
                   { "Evince", "/usr/bin/evince" },
               }

mysystemmenu = {
                   { "XFE", "/usr/bin/xfe" },
                   { "VirtualBox", "/opt/bin/VirtualBox" },
                   { "lxrandr", "/usr/bin/lxrandr" },
                   { "arandr", "/usr/bin/arandr" },
                }

myastronomymenu = {
                   { "GPredict", "/usr/bin/gpredict" },
                }

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Astronomy", myastronomymenu },
                                    { "Internet", mywwwmenu },
                                    { "Office", myofficemenu },
                                    { "System", mysystemmenu },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    --[[
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    --]]
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- Create dummy bar to reserve space for Conky
mystatusbar = awful.wibox({ position = "bottom", screen = math.max(screen.count(), 1), ontop = false, width = 1, height = 16 })

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    -- mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "p",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey, "Control" }, "h",      awful.tag.viewnone       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "e", revelation),
    awful.key({modkey, "Shift"}, "m", 
              function()
                  awful.prompt.run({ prompt = "New tag position: " },
                  mypromptbox[mouse.screen].widget,
                  function (s)
                      local t = awful.tag.selected()
                      awful.tag.move(s, t)
                  end,
                  nil)
              end),
    --[[awful.key({ modkey,           }, "#13",
        function () 
            awful.util.spawn_with_shell('scrot') 
        end),

    awful.key({ modkey, "Shift"   }, "#13",
        function () 
            awful.util.spawn_with_shell('scrot -s') 
        end),--]]

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    -- Prompt
    awful.key({ modkey },            "F1",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ modkey, "Control", "Shift" }, "Return",
              function ()
                  awful.prompt.run({ prompt = "Window name: " },
                  mypromptbox[mouse.screen].widget,
                  function (s)
                      awful.util.spawn(named_terminal .. s .. " -e tmuxp load " .. s .. ".yaml")
                  end,
                  nil)
              end),
    awful.key({ modkey, "Control" }, "Return",
              function ()
                  awful.prompt.run({ prompt = "Session name: " },
                  mypromptbox[mouse.screen].widget,
                  function (s)
                      awful.util.spawn(named_session_terminal .. s)
                  end,
                  nil)
              end),

    awful.key({ modkey, "Shift" }, "Return", 
        function () 
            awful.util.spawn(pure_terminal) 
        end),

    awful.key({ modkey }, "F9",
            function ()
                awful.util.spawn_with_shell("exe=`cat /home/erik/.dmenu/menu | dmenu -i -nb '#091030' -nf '#138EA1' -sb '#0C2245' -sf '#03DBFC'` && PATH=$PATH:/home/erik/.screenlayout exec ${exe}")
            end),

    awful.key({ modkey }, "F10",
            function ()
                awful.util.spawn(pure_terminal .. ' -e tmuxinator start tunnel')
                awful.util.spawn(pure_terminal .. ' -e tmuxinator start dacentec')
            end),

    awful.key({modkey}, "v", 
        function ()
            awful.util.spawn_with_shell("/usr/bin/xclip -o -selection clipboard |xclip")
        end),

    awful.key({modkey}, "3", 
        function ()
          awful.tag.viewonly(tyrannical.tags_by_name["Term"], mouse.screen)
        end),
   awful.key({ modkey             }, "F12",    function () awful.util.spawn("i3lock -ti .config/awesome/blind/arrow/wallpaper/nihilusdesigns-d679voj.png") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Control" }, "1",      function (c) awful.client.movetoscreen(c, 1)  end),
    awful.key({ modkey, "Control" }, "2",      function (c) awful.client.movetoscreen(c, 2)  end),
    awful.key({ modkey, "Control" }, "3",      function (c) awful.client.movetoscreen(c, 3)  end),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    -- awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)

)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
--[[
for i=1,9 do
    globalkeys = awful.util.table.join(
                        globalkeys,
                        awful.key({modkey}, i,
                            function()
                                for pos, tag in ipairs(mytags) do
                                  if tag.position == i then
                                    awful.tag.viewonly(tyrannical.tags_by_name[tag.name], mouse.screen)
                                    break
                                  end
                                end
                            end))
                            --]]
                            --[[
    globalkeys = awful.util.table.join(
                        globalkeys,
                        awful.key({modkey, "Control"}, i,
                            function ()
                                local t = shifty.getpos(i)
                                t.selected = not t.selected
                            end))
    globalkeys = awful.util.table.join(globalkeys,
                                awful.key({modkey, "Control", "Shift"}, i,
                function ()
                    if client.focus then
                        awful.client.toggletag(shifty.getpos(i))
                    end
                end))
    -- move clients to other tags
    globalkeys = awful.util.table.join(
                    globalkeys,
                    awful.key({modkey, "Shift"}, i,
                        function ()
                            if client.focus then
                                local t = shifty.getpos(i)
                                awful.client.movetotag(t)
                                awful.tag.viewonly(t)
                            end
                        end))
                        --]]
--end


clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { instance="social" },
      callback = function(c)
        awful.client.property.set(c, "overwrite_class", "urxvt:social")
      end
    },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { name = ".*- Skype.*Chat" }, properties = {}, callback = awful.client.setslave },
    { rule = { class = "Pidgin"}, except = { name = "Buddy List" }, callback = awful.client.setslave },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

os.execute("xrdb -merge ~/.Xresources")
os.execute("/usr/bin/runonce.sh conky &")
os.execute("/usr/bin/runonce.sh nm-applet &")
os.execute("xcompmgr -D 6 -c -C -f -n &")
os.execute("setxkbmap us -variant mac")
os.execute("xmodmap ~/.Xmodmap")
os.execute("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &")
-- os.execute("runonce.sh dropbox &")

-- }}}
