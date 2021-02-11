tool
extends EditorPlugin

const BASE_PATH = "res://addons/SpritesheetDragger/"
const AUTOLOADS_PATH = BASE_PATH + "autoloads/"
const CUSTOM_TYPES_PATH = BASE_PATH + "components/"

const Dock = preload("res://addons/SpritesheetDragger/dock/Dock.tscn")
var dock

var icon:Texture = preload("res://addons/SpritesheetDragger/assets/logo/logo16.png")

const autoloads = {
	"SpritesheetDragger": AUTOLOADS_PATH + "SpritesheetDragger.gd",
}

var custom_types = {}


func _enter_tree():

	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])

	
	for key in custom_types.keys():
		var type = custom_types[key]
		if type:
			add_custom_type(key, type.base, type.script, icon)

	# Add the loaded scene to the docks.
	dock = create_dock()
	add_control_to_bottom_panel(dock, "SpritesheetDragger")


func create_dock():
	var dock = Dock.instance()
	dock.plugin = self
	dock.ei = get_editor_interface()
	return dock


func _exit_tree():
	for key in autoloads.keys():
		remove_autoload_singleton(key)
	for key in custom_types.keys():
		remove_custom_type(key)

	remove_control_from_bottom_panel(dock)
	dock.queue_free()