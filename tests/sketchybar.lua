-- Load the config with a fake SketchyBar API. Never send commands to the live bar.
local items = {}
local scripts = {}
local bar
local config_started = false
local config_finished = false
local event_loop_started = false
local counter = 0
local sbar = {}

function sbar.add(kind, name, properties, bracket_properties)
  if kind == "bracket" and type(name) == "string" then
    properties = bracket_properties
  elseif type(name) ~= "string" then
    properties = properties or (type(name) == "table" and name) or {}
    counter = counter + 1
    name = kind .. ".test." .. counter
  end
  local item = { properties = properties or {}, subscriptions = {} }
  function item:set(values)
    for key, value in pairs(values) do
      self.properties[key] = value
    end
  end
  function item:subscribe(events, callback)
    if type(events) == "string" then events = { events } end
    for _, event in ipairs(events) do
      self.subscriptions[event] = callback
    end
  end
  item.name = name
  items[name] = item
  return item
end

function sbar.exec(command, callback)
  scripts[#scripts + 1] = command
  if callback then
    if command == "aerospace list-workspaces --all" then
      callback("A\nB\n")
    elseif command:match("aerospace list%-windows") then
      callback("Safari\nZed\n")
    else
      error("Unexpected command in config test: " .. command)
    end
  end
end

function sbar.bar(properties) bar = properties end
function sbar.default() end
function sbar.begin_config() config_started = true end
function sbar.end_config() config_finished = true end
function sbar.event_loop() event_loop_started = true end
function sbar.animate(_, _, callback) callback() end

package.preload.sketchybar = function() return sbar end
os.execute = function() error("Config must not build or execute helpers at startup") end

require "helpers"
require "init"

assert(config_started and config_finished and event_loop_started)
assert(bar.height == 40 and bar.margin == 12 and bar.corner_radius == 12)
assert(items["space.A"] and items["space.B"])
assert(items["space.A"].properties.label.font == "sketchybar-app-font-bg:Regular:12.0")
assert(items["space.A"].properties.click_script == "aerospace workspace A")
assert(items["menu.1"].properties.click_script == "$CONFIG_DIR/helpers/menus/bin/menus -s 1")
assert(items["menu.padding"].properties.background.drawing == false)
assert(items["widgets"] and items["widgets"].properties.background.drawing == true)
assert(not items["widget.padding"], "A spacer here lands between the spaces indicator and workspace 1")
assert(items["widgets.volume"] and items["widgets.wifi"] and items["widgets.battery"])
assert(not items["widgets.messages"], "Keep the Messages widget disabled")

local space = items["space.A"]
space.subscriptions.aerospace_workspace_change({ FOCUSED_WORKSPACE = "A" })
assert(space.properties.icon.highlight and space.properties.label:match(":safari:"))
assert(space.properties.label:match(":zed:"))
assert(require("helpers.default_font").text == "SF Pro")
assert(require("helpers.default_font").numbers == "SF Mono")

local found_network_provider = false
for _, script in ipairs(scripts) do
  if script:find("$CONFIG_DIR/helpers/event_providers/network_load/bin/network_load", 1, true) then
    found_network_provider = true
  end
end
assert(found_network_provider)
print("SketchyBar config test passed (no live commands)")
