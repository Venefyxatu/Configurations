-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("shifty")
require("rssmenu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
theme_path = "/home/venefyxatu/.awesome/themes/sky/theme.lua"
-- theme_path = "/usr/share/awesome/themes/zenburn/theme.lua"
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
pure_terminal = "urxvt"
terminal = pure_terminal .. " -e tmux"
terminal_cmd = pure_terminal .. " -e screen"
named_terminal = pure_terminal .. " -e tmux new-session -s "
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal_cmd .. " -R editing " .. editor 

editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -c " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
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
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}



clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "s",      function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)



-- {{{ Shifty

-- tag presets
-- see http://awesome.naquadah.org/wiki/Shifty

shifty.config.tags = {
   ["recording"] = { position = 1, layout = awful.layout.suit.floating      },
   ["social"] = { position = 2, layout = awful.layout.suit.floating, nopopup = true },
   ["term"] = { exclusive = true, position = 3, layout = awful.layout.suit.tile.bottom, icon = "/home/venefyxatu/icons/term.png", mwfact = 0.75},
   ["www"] = { exclusive = true, position = 4, spawn = "opera10", nopopup = true, layout=awful.layout.suit.max, icon = "/home/venefyxatu/icons/world.png" },
   ["work"] = { position = 5, leave_kills = true, icon = "/home/venefyxatu/icons/bug.png" },
   ["dashboard"] = { layout = awful.layout.suit.max, nopopup = true, position = 6 },
   ["design"] = { layout = awful.layout.suit.floating, mwfact = 0.18, icon="/usr/share/pixmaps/gnome-gimp.png", nopopup = true },
   ["development"] = { layout = awful.layout.suit.max, nopopup = true, icon = "/home/venefyxatu/icons/bug.png" },
   ["rdesktop"] = { layout = awful.layout.suit.floating, exclusive = true, max_clients = 1,                    },
   ["sys"] = { layout = awful.layout.suit.fair.horizontal, exclusive = true,                },
   ["music"] = { layout = awful.layout.suit.tile, nopopup = false, icon = "/home/venefyxatu/icons/notes.png" },
   ["vmachines"] = { layout = awful.layout.suit.max, nopopup = true,                   },
   ["office"] = {layout = awful.layout.suit.max, icon = "/home/venefyxatu/icons/notepad.png", nopopup = true }
}

shifty.config.apps = {
        { match = {"htop", ".*dzen.*"                        }, tag = "sys"                           },
        { match = {".*TweetDeck.*"                           }, tag = "dashboard"                     },
        { match = {".*mutt.*", "offlineimap", ".*Skype.*", ".*Buddy List.*"    }, tag = "social",                       },
        { match = {".*VirtualBox.*"                          }, tag = "vmachines", nopopup = true     },
        { match = {".*XVidCap.*", "avidemux.*"               }, tag = "recording", nopopup = true     },
        { match = {".*Opera.*", "Firefox.*"                  }, tag = "www", nopopup = true           },
        { match = {".*Terminator", "xterm", 'urxvt'          }, tag = "term", nopopup = false         },
        { match = {"Gimp", "^dia$", "Layers, Channels", "Toolbox", "GNU Image" }, tag = "design", nopopup = true        },
        { match = {"gimp-image-window"                       }, slave = true,                         },
        { match = {"gqview"                                  }, tag = { "graph", "gqview" }           },
        { match = {".*OpenOffice.*", "Document Viewer", ".*gedit" }, tag = "office"                        },
        { match = {"Eclipse", "Workspace Launcher", "Giggle", "pgAdmin", "MySQL Query.*" }, tag = "development", nopopup = true   },
        { match = {"rdesktop", "Xnest"                       }, tag = "rdesktop"                          },
        { match = {"herrie", "alsamixer", "Picard"           }, tag = "music", nopopup = false        },
        { match = {"MPlayer", "xmag", 
                                                             }, float = true,                         },
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
  run = function(tag) 
    local stitle = "Shifty Created: "
    stitle = stitle .. (awful.tag.getproperty(tag,"position") or shifty.tag2index(mouse.screen,tag))
    stitle = stitle .. " : "..tag.name
    stitle = stitle .. " on screen " .. mouse.screen
    naughty.notify({ text = stitle, screen = mouse.screen })
  end,
}

shifty.config.match_screen_dependent = true

shifty.config.clientkeys = clientkeys

shifty.init()

-- }}}
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

developmentmenu =  { 
   { "eclipse", "/opt/eclipse/eclipse" },
}

wwwmenu = {
   { "opera", "opera" },
   { "firefox", "firefox" },
}

toolsmenu = {
    { "terminator", "terminator" },
    { "OpenOffice.org", "soffice" },
    { "evince", "evince" },
}

--myrssmenu = awful.menu({ items = { rssmenu.rssfeedsmenu }, })


mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", pure_terminal },
                                    { "virtualbox", "VirtualBox" },
                                    { "ranger", pure_terminal .. " -e ranger" },
                                    { "development", developmentmenu },
                                    { "browsing", wwwmenu },
                                    { "tools", toolsmenu },
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
mystatusbar = {}
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

for s = 1, screen.count() do
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
    mystatusbar[s] = awful.wibox({ position = "bottom", screen = s})
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
        s == 1 and mysystray or nil,
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "p",      awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",      awful.tag.viewnext       ),
    awful.key({ modkey, "Control" }, "h",      awful.tag.viewnone       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),
    --awful.key({ modkey,           }, "r", function () myrssmenu:show(true)      end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end),
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

    awful.key({ modkey },            "F2",     
        function ()
            awful.prompt.run({ prompt = "SSH: " },
            mypromptbox[mouse.screen].widget,
            function (s)
                awful.util.spawn(pure_terminal .. " -e ssh " .. s)
            end) 
        end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

              ---[[
    awful.key({ modkey, "Control" }, "Return",
              function ()
                  awful.prompt.run({ prompt = "Session name: " },
                  mypromptbox[mouse.screen].widget,
                  function (s)
                      awful.util.spawn(named_terminal .. s)
                  end,
                  nil)
              end),
              --]]

    -- Various

--[[    awful.key({ modkey }, "F9",
        function ()
            awful.util.spawn('PROG=`cat /home/venefyxatu/bin/terminal |dmenu -b -p "terminal:"`; exec ' .. pure_terminal .. ' -e $PROG')
            --awful.util.spawn("cat /home/venefyxatu/bin/terminal |dmenu -b -nb '#0a1535' -nf '#1577d3' -sb '#1577d3' -sf '#0a1535'")
    end),
    --usage: dmenu [-i] [-b] [-fn <font>] [-nb <color>] [-nf <color>]
    --             [-p <prompt>] [-sb <color>] [-sf <color>] [-v]

--]]

---[[
    awful.key({ modkey }, "F10",
        function ()
            awful.util.spawn(pure_terminal .. " -e ssh -D 9876 83.101.87.22")
            awful.util.spawn(terminal)
            awful.util.spawn("opera")
        end),
        --]]
    awful.key({ modkey, "Shift" }, "Return", 
        function () 
            awful.util.spawn(pure_terminal) 
        end),

    awful.key({ modkey }, "F11",
        function ()
            awful.util.spawn("awsetbg -r /home/venefyxatu/rotation_wallpaper")
        end),

    awful.key({ modkey }, "F12",
        function ()
            awful.util.spawn("xscreensaver-command -lock")
        end)

)

-- Set keys
root.keys(globalkeys)
-- }}}

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))


-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     --keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

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

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

os.execute("runonce.sh xscreensaver &")
os.execute("runonce.sh xbindkeys")
os.execute("runonce.sh /home/venefyxatu/bin/dzen/networkmeter.sh &")
os.execute("runonce.sh /home/venefyxatu/bin/dzen/cpumeter.sh &")
os.execute("runonce.sh /home/venefyxatu/bin/dzen/mpstatus.sh &")
os.execute("runonce.sh /home/venefyxatu/bin/dzen/battery.sh &")
