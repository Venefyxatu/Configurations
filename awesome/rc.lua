-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("shifty")
require("revelation")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- theme = "/usr/share/awesome/themes/sky/theme.lua"
theme = "/home/erik/.awesome/themes/current/theme.lua"
beautiful.init(theme)

-- This is used later as the default terminal and editor to run.
pure_terminal = "urxvt"
terminal = pure_terminal .. " -e tmux"
named_terminal = terminal .. " new-session -s "

editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

naughty.config.default_preset.screen = screen.count()

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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

-- {{{ Shifty

-- tag presets
-- see http://awesome.naquadah.org/wiki/Shifty

shifty.config.tags = {
   ["recording"] = { position = 10, layout = awful.layout.suit.floating      },
   ["2:social"] = { position = 2, layout = awful.layout.suit.tile, nopopup = true, mwfact = 0.30, screen = math.min(screen.count(), 1), spawn = "/usr/bin/skype" },
   ["myterm"] = { layout = awful.layout.suit.max, nopopup = true, init = false },
   ["3:term"] = { exclusive = true, position = 3, layout = awful.layout.suit.tile.bottom, mwfact = 0.75, persist = true, screen = math.max(screen.count(), 1) },
   ["5:vmachines"] = { position = 5, layout = awful.layout.suit.max, nopopup = true,                   },
   ["6:ERP"] = { position = 6, leave_kills = true, layout = awful.layout.suit.max },
   ["7:office"] = { position = 7, layout = awful.layout.suit.max, nopopup = true },
   ["9:www"] = { exclusive = true, position = 9, spawn = "/usr/bin/firefox", nopopup = true, layout=awful.layout.suit.max, persist = true, screen = math.max(screen.count(), 1) },
   ["4:work"] = {position = 4, layout = awful.layout.suit.tile.left, mwfact = 0.70, nopopup = true },
   ["video"] = { layout = awful.layout.suit.fair },
   ["dashboard"] = { layout = awful.layout.suit.max, nopopup = true, position = 20 },
   ["design"] = { layout = awful.layout.suit.floating, mwfact = 0.18, nopopup = true },
   ["development"] = { layout = awful.layout.suit.max },
   ["8:Remote Desktop"] = { layout = awful.layout.suit.floating, exclusive = true, },
   ["sys"] = { layout = awful.layout.suit.fair.horizontal, exclusive = true,                },
   ["music"] = { layout = awful.layout.suit.tile, nopopup = false},
   ["df"] = { layout = awful.layout.suit.max, nopopup = true,                   },
   ["astronomy"] = { layout = awful.layout.suit.max, nopopup = true, },
   ["minecraft"] = { layout = awful.layout.suit.max, nopopup = true, },
}

shifty.config.apps = {
        { match = {"htop", ".*dzen.*", "Xfe.*"               }, tag = "sys"                                                     },
        { match = {".*mplayer.*"                                 }, tag = "video"                                                     },
        { match = {"Conky"                                   }, tag = "dashboard"                                               },
        { match = {".*mutt.*", "offlineimap", ".*Skype.*", ".*Buddy List.*"    }, tag = "2:social",                               },
        { match = {".*VirtualBox.*"                          }, tag = "5:vmachines", nopopup = true                               },
        { match = {".*XVidCap.*", "avidemux.*"               }, tag = "recording", nopopup = true                               },
        { match = {".*Opera.*", ".*Google Chrome.*", ".*Vimperator.*"          }, tag = { "9:www", }, nopopup = true                                     },
        { match = {"Firefox.*", ".*Vimperator.*"             }, tag = { "4:work", "9:www"}, nopopup = true                                     },
        --{ match = {".*Google Chrome.*"                       }, tag = { "4:work", "9:www"}, nopopup = true                                     },
        { match = {".*Terminator"                            }, tag = "myterm", nopopup = false                                 },
        { match = {"xterm", 'urxvt'                          }, tag = { "3:term", "4:work" }, nopopup = false,                    },
        { match = {"Gimp", "^dia$", "Layers, Channels", "Toolbox", "GNU Image" }, tag = "design", nopopup = true                },
        { match = {"gimp-image-window"                       }, slave = true,                                                   },
        { match = {"gqview"                                  }, tag = { "graph", "gqview" }                                     },
        { match = {".*libreoffice.*", ".*OpenOffice.*", "Document Viewer", ".*gedit", "(!Opening).*pdf", "zim", "evince", "XMind" }, tag = "7:office"          },
        { match = {".*wing.*", "Eclipse", "Workspace Launcher", "Giggle", "pgAdmin", "MySQL Query.*", ".*Perforce P4Merge" }, tag = "development" },
        { match = {"rdesktop", "Xnest", "Remmina", class= "remmina" }, tag = "8:Remote Desktop"                                                },
        { match = {"herrie", "alsamixer", "Picard"           }, tag = "music", nopopup = false                                  },
        { match = {"MPlayer", "xmag",                        }, float = true,                                                   },
        { match = {"Dwarf Fortress",                         }, tag = "df", nopopup = true                                      },
        { match = {"^OpenERP.*",                             }, tag = "6:ERP", nopopup = true                                    },
        { match = {"^GPREDICT.*",                            }, tag = "astronomy", nopopup = true                               },
        { match = {"^Minecraft Structure Planner.*",         }, tag = "minecraft", nopopup = true                               },
        { match = { "" }, buttons = {
                             button({ }, 1, function (c) client.focus = c; c:raise() end),
                             button({ modkey }, 1, function (c) awful.mouse.client.move() end),
                             button({ modkey }, 3, function (c) awful.mouse.client.resize() end), }, },
}

shifty.config.defaults = {  
  screen = mouse.screen,
  layout = awful.layout.suit.tile.bottom, 
  ncol = 1, 
  mwfact = 0.60,
  floatBars=false,
  guess_name=true,
  guess_position=true,
}

shifty.config.match_screen_dependent = true

shifty.config.clientkeys = clientkeys


---[[ -- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({}, s, layouts[1])
    -- tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}
--]]


do
    local fbyidx = awful.client.focus.byidx
    awful.client.focus.byidx = function (i)
        fbyidx(i)
        local g = client.focus:geometry()
        g.x = g.x + g.width / 2
        g.y = g.y + g.height / 2
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
            g.y = g.y + g.height/2
            mouse.coords(g)
        end
    end
end


--
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
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

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

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
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
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

mystatusbar = awful.wibox({ position = "bottom", screen = math.max(screen.count(), 1), ontop = false, width = 1, height = 16 })

for s = 1, screen.count() do
    -- Create dummy bar to reserve space for Conky
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == screen.count() and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
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
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey, "Shift"}, "n", shifty.send_next), -- client to next tag
    awful.key({modkey, "Shift"}, "p", shifty.send_prev), -- client to prev tag
    awful.key({modkey, "Control"}, "n", shifty.copy_next), -- client to next tag
    awful.key({modkey, "Control"}, "p", shifty.copy_prev), -- client to prev tag
    awful.key({modkey, "Shift"},
              "o",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
                  awful.screen.focus(s)
              end),
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
    awful.key({modkey}, "a", 
              function()
                awful.prompt.run({ prompt = "New tag name: " },
                mypromptbox[mouse.screen].widget,
                function (s)
                      shifty.add({ name = s, screen = mouse.screen })
                    end,
                    nil)
                  end),
    
    awful.key({modkey, "Shift"}, "r", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

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

    -- Prompt
    awful.key({ modkey },            "F1",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ modkey, "Control" }, "Return",
              function ()
                  awful.prompt.run({ prompt = "Session name: " },
                  mypromptbox[mouse.screen].widget,
                  function (s)
                      awful.util.spawn(named_terminal .. s)
                  end,
                  nil)
              end),

    awful.key({ modkey, "Shift" }, "Return", 
        function () 
            awful.util.spawn(pure_terminal) 
        end),

    awful.key({ modkey }, "F9",
            function ()
                awful.util.spawn_with_shell("exe=`cat /home/erik/.dmenu/menu | dmenu -i -nb '#091030' -nf '#138EA1' -sb '#0C2245' -sf '#03DBFC'` && exec ${exe}")
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

   awful.key({ modkey             }, "F12",    function () awful.util.spawn("i3lock -c 999999") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
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

for i=1,9 do
    globalkeys = awful.util.table.join(
                        globalkeys,
                        awful.key({modkey}, i,
                            function()
                                awful.tag.viewonly(shifty.getpos(i))
                            end))
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
end



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
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { name = ".*- Skype.*Chat" }, properties = {}, callback = awful.client.setslave },
    { rule = { class = "URxvt", tag="4:work" }, properties = { }, callback = awful.titlebar.add },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    if c.name:find("rdesktop") then
        awful.titlebar.add(c, { modkey = modkey })
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

shifty.taglist = mytaglist

shifty.init()

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

os.execute("xrdb -merge ~/.Xresources")
os.execute("runonce.sh conky &")
os.execute("xcompmgr -D 4 -c -C -f -n &")
os.execute("xmodmap ~/.Xmodmap")
-- os.execute("runonce.sh dropbox &")

-- }}}
